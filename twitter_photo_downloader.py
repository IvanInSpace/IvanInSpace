#!/usr/bin/env python3
"""
Twitter/X Photo Downloader
Downloads all photos from a Twitter/X account using gallery-dl.
No API keys required — uses your browser session for private accounts.
"""

import sys
import subprocess
import argparse
from pathlib import Path


def check_gallery_dl() -> None:
    """Make sure gallery-dl is installed."""
    try:
        subprocess.run(
            ["gallery-dl", "--version"],
            capture_output=True,
            check=True,
        )
    except FileNotFoundError:
        sys.exit(
            "Error: gallery-dl not installed.\n"
            "Run: pip install gallery-dl"
        )


def download(
    username: str,
    output_dir: Path,
    browser: str | None,
    cookies_file: str | None,
) -> None:
    username = username.lstrip("@")
    url = f"https://twitter.com/{username}/media"
    user_dir = output_dir / username
    user_dir.mkdir(parents=True, exist_ok=True)

    print(f"Downloading photos from @{username}...")
    print(f"Output: {user_dir.resolve()}")

    if browser:
        print(f"Using cookies from: {browser}")
    elif cookies_file:
        print(f"Using cookies file: {cookies_file}")
    else:
        print("No cookies — only public accounts accessible.")

    print()

    cmd = [
        "gallery-dl",
        # Save only photos (skip videos and gifs)
        "--filter", "extension in ('jpg', 'jpeg', 'png', 'webp')",
        # Output directory
        "--destination", str(output_dir),
        # Filename pattern: username/YYYY-MM-DD_tweetID_filename.ext
        "--filename", "{date:%Y-%m-%d}_{tweet_id}_{filename}.{extension}",
        # Subdir per user
        "--directory", username,
    ]

    if browser:
        cmd += ["--cookies-from-browser", browser]
    elif cookies_file:
        cmd += ["--cookies", cookies_file]

    cmd.append(url)

    try:
        result = subprocess.run(cmd)
        if result.returncode == 0:
            print(f"\nDone! Photos saved to: {user_dir.resolve()}")
        else:
            print(f"\nFinished with errors (exit code {result.returncode}).")
    except KeyboardInterrupt:
        print("\nInterrupted by user.")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Download all photos from a Twitter/X account.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Public account (no login needed)
  python twitter_photo_downloader.py NASA

  # Private account — use your Safari session
  python twitter_photo_downloader.py username --browser safari

  # Private account — use your Chrome session
  python twitter_photo_downloader.py username --browser chrome

  # Private account — use your Firefox session
  python twitter_photo_downloader.py username --browser firefox

  # Use exported cookies file
  python twitter_photo_downloader.py username --cookies cookies.txt

  # Save to a specific folder
  python twitter_photo_downloader.py username --browser safari --output ~/Desktop/photos
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
        "--browser", "-b",
        choices=["safari", "chrome", "firefox", "edge", "chromium", "brave"],
        default=None,
        help="Browser to take cookies from (for private accounts)",
    )
    parser.add_argument(
        "--cookies", "-c",
        default=None,
        help="Path to a Netscape-format cookies.txt file",
    )

    args = parser.parse_args()

    check_gallery_dl()

    if args.browser and args.cookies:
        parser.error("Use either --browser or --cookies, not both.")

    download(
        username=args.username,
        output_dir=Path(args.output),
        browser=args.browser,
        cookies_file=args.cookies,
    )


if __name__ == "__main__":
    main()
