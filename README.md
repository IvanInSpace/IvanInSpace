# Twitter/X Photo Downloader

CLI-утилита для скачивания всех фотографий из любого публичного аккаунта Twitter/X.

## Требования

- Python 3.10+
- Аккаунт разработчика Twitter/X и приложение с **Bearer Token**

## Установка

```bash
# 1. Клонировать репозиторий
git clone <repo-url>
cd IvanInSpace

# 2. Установить зависимости
pip install -r requirements.txt

# 3. Создать .env файл с токенами
cp .env.example .env
# Отредактировать .env и вставить свои ключи
```

## Получение API-ключей

1. Зайти на [developer.twitter.com](https://developer.twitter.com/en/portal/dashboard)
2. Создать новый проект и приложение
3. В разделе **Keys and Tokens** скопировать:
   - **Bearer Token** — обязательно (для чтения публичных аккаунтов)
   - **API Key / Secret + Access Token / Secret** — опционально (для своего аккаунта с закрытыми твитами)

> **Примечание:** Бесплатный план (Free) Twitter API имеет ограничения. Для скачивания большого количества фото рекомендуется план **Basic** ($100/мес).

## Использование

```bash
# Скачать все фото из публичного аккаунта
python twitter_photo_downloader.py NASA

# С указанием папки для сохранения
python twitter_photo_downloader.py @elonmusk --output ./my_downloads

# Ограничить количество сканируемых твитов
python twitter_photo_downloader.py username --limit 1000

# Использовать другой .env файл
python twitter_photo_downloader.py username --env /path/to/.env

# Перезаписать уже скачанные файлы
python twitter_photo_downloader.py username --no-skip
```

## Аргументы

| Аргумент | Описание |
|---|---|
| `username` | Имя пользователя (с @ или без) |
| `--output, -o` | Папка для сохранения (по умолчанию: `./downloads`) |
| `--limit, -l` | Максимум твитов для сканирования |
| `--no-skip` | Перескачивать уже существующие файлы |
| `--env, -e` | Путь к .env файлу с ключами |

## Структура скачанных файлов

```
downloads/
└── NASA/
    ├── 2024-01-15_1234567890_photo.jpg
    ├── 2024-01-10_1234567880_image.jpg
    └── ...
```

Имя файла: `ДАТА_ID-ТВИТА_ОРИГИНАЛЬНОЕ-ИМЯ.jpg`

## Ограничения Twitter API

| Тип | Лимит |
|---|---|
| Твиты в месяц (Free) | 10 000 чтений |
| Твиты в месяц (Basic) | 100 000 чтений |
| Запросов в 15 мин | ~15 (автоматическое ожидание) |

Скрипт автоматически ждёт при достижении rate limit.
