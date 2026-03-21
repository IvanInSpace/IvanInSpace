# Twitter/X Photo Downloader

CLI-утилита для скачивания всех фотографий из любого Twitter/X аккаунта.
**API-ключи не нужны** — использует сессию твоего браузера для закрытых аккаунтов.

## Требования

- Python 3.10+
- Браузер с активной сессией Twitter/X (Safari, Chrome, Firefox)

## Установка

```bash
pip install -r requirements.txt
```

## Использование

```bash
# Публичный аккаунт (без логина)
python twitter_photo_downloader.py NASA

# Свой или закрытый аккаунт — через Safari
python twitter_photo_downloader.py johnmrmitchell --browser safari

# Через Chrome
python twitter_photo_downloader.py username --browser chrome

# Через Firefox
python twitter_photo_downloader.py username --browser firefox

# Указать папку для сохранения
python twitter_photo_downloader.py username --browser safari --output ~/Desktop/photos
```

## Аргументы

| Аргумент | Описание |
|---|---|
| `username` | Имя пользователя (с @ или без) |
| `--browser, -b` | Браузер для получения cookies: `safari`, `chrome`, `firefox`, `edge` |
| `--cookies, -c` | Путь к файлу cookies.txt (альтернатива --browser) |
| `--output, -o` | Папка для сохранения (по умолчанию: `./downloads`) |

## Важно

- Ты должен быть **залогинен в Twitter/X** в указанном браузере
- Для закрытых аккаунтов — должен быть **подписан** на них
- Скачиваются только фото (jpg, png, webp) — видео пропускаются

## Структура скачанных файлов

```
downloads/
└── username/
    ├── 2024-01-15_1234567890_photo.jpg
    ├── 2024-01-10_1234567880_image.png
    └── ...
```
