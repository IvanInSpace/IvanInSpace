#!/usr/bin/env python3
"""
Twitter/X Photo Downloader
Downloads all photos from a Twitter/X account using the Twitter API v2.
"""

import os
import sys
import time
import argparse
import requests
from pathlib import Path
from datetime import datetime

try:
    import tweepy
except ImportError:
    sys.exit("Error: tweepy not installed. Run: pip install -r requirements.txt")

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

try:
    from tqdm import tqdm
    TQDM_AVAILABLE = True
except ImportError:
    TQDM_AVAILABLE = False


def get_client() -> tuple["tweepy.Client", bool]:
    """
    Create a Tweepy client using credentials from environment variables.
    Returns (client, has_user_auth) where has_user_auth indicates OAuth 1.0a
    tokens are available (required for accessing protected/private accounts).
    """
    bearer_token = os.getenv("TWITTER_BEARER_TOKEN")
    api_key = os.getenv("TWITTER_API_KEY")
    api_secret = os.getenv("TWITTER_API_SECRET")
    access_token = os.getenv("TWITTER_ACCESS_TOKEN")
    access_token_secret = os.getenv("TWITTER_ACCESS_TOKEN_SECRET")

    if not bearer_token:
        sys.exit(
            "Error: TWITTER_BEARER_TOKEN not set.\n"
            "Copy .env.example to .env and fill in your credentials.\n"
            "Get them at: https://developer.twitter.com/en/portal/dashboard"
        )

    has_user_auth = all([api_key, api_secret, access_token, access_token_secret])

    if not has_user_auth:
        print(
            "Notice: OAuth tokens not set — only public accounts are accessible.\n"
            "To download from protected accounts, add all 4 OAuth fields to .env.\n"
        )

    client = tweepy.Client(
        bearer_token=bearer_token,
        consumer_key=api_key or None,
        consumer_secret=api_secret or None,
        access_token=access_token or None,
        access_token_secret=access_token_secret or None,
        wait_on_rate_limit=True,
    )
    return client, has_user_auth


def get_user_id(client: tweepy.Client, username: str) -> tuple[str, str]:
    """Resolve a username to a user ID. Returns (user_id, display_name)."""
    username = username.lstrip("@")
    try:
        response = client.get_user(username=username, user_fields=["name"])
    except tweepy.TweepyException as e:
        sys.exit(f"Error looking up user @{username}: {e}")

    if not response.data:
        sys.exit(f"User @{username} not found.")

    return str(response.data.id), response.data.name


def fetch_media_urls(client: tweepy.Client, user_id: str, limit: int | None, user_auth: bool = False) -> list[dict]:
    """
    Fetch all tweet media URLs for a user.
    Returns list of dicts: {url, tweet_id, created_at}
    """
    media_items = []
    pagination_token = None
    fetched = 0
    page_size = 100  # max allowed by API

    print("Fetching tweets...")

    while True:
        remaining = None
        if limit:
            remaining = limit - fetched
            if remaining <= 0:
                break
            page_size = min(100, remaining)

        try:
            response = client.get_users_tweets(
                id=user_id,
                max_results=page_size,
                expansions=["attachments.media_keys"],
                media_fields=["url", "preview_image_url", "type", "width", "height"],
                tweet_fields=["created_at", "attachments"],
                pagination_token=pagination_token,
                # user_auth=True is required to access protected/private accounts.
                # It tells tweepy to sign the request with OAuth 1.0a (your account),
                # so Twitter sees you as a logged-in follower of that account.
                user_auth=user_auth,
            )
        except tweepy.errors.Forbidden as e:
            print(
                f"\nAccess denied (403). The account may be protected.\n"
                f"Make sure all 4 OAuth fields are set in .env and you follow this account.\n"
                f"Details: {e}"
            )
            break
        except tweepy.TweepyException as e:
            print(f"\nAPI error: {e}")
            break

        if not response.data:
            break

        # Build a map of media_key -> media object
        media_map: dict[str, object] = {}
        if response.includes and "media" in response.includes:
            for media in response.includes["media"]:
                media_map[media.media_key] = media

        for tweet in response.data:
            fetched += 1
            if not tweet.attachments:
                continue
            for media_key in tweet.attachments.get("media_keys", []):
                media = media_map.get(media_key)
                if media and media.type == "photo":
                    # Use original quality URL
                    url = media.url
                    if url:
                        # Request the original size
                        if "?" in url:
                            url += "&name=orig"
                        else:
                            url += "?name=orig"
                        media_items.append({
                            "url": url,
                            "tweet_id": tweet.id,
                            "created_at": tweet.created_at,
                        })

        pagination_token = response.meta.get("next_token") if response.meta else None
        if not pagination_token:
            break

        print(f"  Scanned {fetched} tweets, found {len(media_items)} photos so far...")

    return media_items


def download_photo(url: str, dest_path: Path, session: requests.Session) -> bool:
    """Download a single photo. Returns True on success."""
    try:
        response = session.get(url, timeout=30, stream=True)
        response.raise_for_status()
        dest_path.parent.mkdir(parents=True, exist_ok=True)
        with open(dest_path, "wb") as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        return True
    except requests.RequestException as e:
        print(f"\n  Failed to download {url}: {e}")
        return False


def sanitize_filename(name: str) -> str:
    """Remove characters unsafe for filenames."""
    return "".join(c for c in name if c.isalnum() or c in "._- ").strip()


def download_all(
    username: str,
    output_dir: Path,
    limit: int | None,
    skip_existing: bool,
) -> None:
    client, has_user_auth = get_client()

    auth_mode = "OAuth 1.0a (user context) — protected accounts supported" if has_user_auth else "Bearer Token (app-only) — public accounts only"
    print(f"Auth mode: {auth_mode}")

    print(f"Looking up @{username}...")
    user_id, display_name = get_user_id(client, username)
    safe_name = sanitize_filename(username)
    user_dir = output_dir / safe_name
    user_dir.mkdir(parents=True, exist_ok=True)

    print(f"User: {display_name} (@{username})  ID: {user_id}")
    print(f"Output directory: {user_dir.resolve()}")

    media_items = fetch_media_urls(client, user_id, limit, user_auth=has_user_auth)

    if not media_items:
        print("No photos found.")
        return

    print(f"\nFound {len(media_items)} photo(s). Starting download...")

    session = requests.Session()
    session.headers.update({"User-Agent": "TwitterPhotoDownloader/1.0"})

    ok = 0
    skipped = 0
    failed = 0

    iterator = tqdm(media_items, unit="photo") if TQDM_AVAILABLE else media_items

    for item in iterator:
        url: str = item["url"]
        tweet_id = item["tweet_id"]
        created_at: datetime | None = item["created_at"]

        # Build filename: YYYY-MM-DD_tweetID_index.jpg
        date_str = created_at.strftime("%Y-%m-%d") if created_at else "unknown"
        # Extract original filename from URL
        base = url.split("?")[0].split("/")[-1]
        filename = f"{date_str}_{tweet_id}_{base}"
        dest = user_dir / filename

        if skip_existing and dest.exists():
            skipped += 1
            if not TQDM_AVAILABLE:
                print(f"  Skip (exists): {filename}")
            continue

        success = download_photo(url, dest, session)
        if success:
            ok += 1
            if not TQDM_AVAILABLE:
                print(f"  Downloaded: {filename}")
        else:
            failed += 1

    print(f"\nDone! Downloaded: {ok}  Skipped: {skipped}  Failed: {failed}")
    print(f"Photos saved to: {user_dir.resolve()}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Download all photos from a Twitter/X account.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python twitter_photo_downloader.py elonmusk
  python twitter_photo_downloader.py @NASA --output ./downloads
  python twitter_photo_downloader.py username --limit 500
  python twitter_photo_downloader.py username --no-skip
        """,
    )
    parser.add_argument(
        "username",
        help="Twitter/X username (with or without @)",
    )
    parser.add_argument(
        "--output", "-o",
        default="./downloads",
        help="Directory to save photos (default: ./downloads)",
    )
    parser.add_argument(
        "--limit", "-l",
        type=int,
        default=None,
        help="Maximum number of tweets to scan (default: all)",
    )
    parser.add_argument(
        "--no-skip",
        action="store_true",
        help="Re-download photos that already exist",
    )
    parser.add_argument(
        "--env", "-e",
        default=".env",
        help="Path to .env file with credentials (default: .env)",
    )

    args = parser.parse_args()

    # Load custom .env if specified
    if args.env != ".env" and os.path.exists(args.env):
        try:
            from dotenv import load_dotenv
            load_dotenv(args.env, override=True)
        except ImportError:
            pass

    download_all(
        username=args.username,
        output_dir=Path(args.output),
        limit=args.limit,
        skip_existing=not args.no_skip,
    )


if __name__ == "__main__":
    main()
