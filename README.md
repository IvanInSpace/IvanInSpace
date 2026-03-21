# Twitter/X Photo Downloader

CLI-утилита для скачивания всех фотографий из любого Twitter/X аккаунта — публичного или закрытого (если ты на него подписан).

## Требования

- Python 3.10+
- Аккаунт разработчика Twitter/X

---

## Установка

```bash
pip install -r requirements.txt
cp .env.example .env
# Заполнить .env своими ключами (см. ниже)
```

---

## Получение API-ключей

### Шаг 1 — Создать приложение

1. Зайти на [developer.twitter.com](https://developer.twitter.com/en/portal/dashboard)
2. Нажать **"+ Create Project"** → задать имя → выбрать тип "Personal use"
3. Нажать **"+ Add App"** → задать имя приложению
4. Сохранить появившиеся ключи (**Consumer Key**, **Secret Key**, **Bearer Token**)

### Шаг 2 — Включить Read-доступ

1. Зайти в приложение → вкладка **"Settings"**
2. В разделе **"User authentication settings"** нажать **"Set up"**
3. Выбрать **"Read"** (только чтение)
4. В поле **App Type** выбрать **"Native App"**
5. В поле **Callback URI** вписать любой: `http://localhost`
6. Нажать **"Save"**

> ⚠️ Этот шаг обязателен для получения Access Token. Без него кнопка Generate не появится.

### Шаг 3 — Получить Access Token и Access Token Secret

1. Перейти на вкладку **"Keys and Tokens"**
2. В разделе **"Authentication Tokens"** нажать **"Generate"** рядом с *Access Token and Secret*
3. Сохранить **Access Token** и **Access Token Secret** — они показываются только один раз!

### Итоговый `.env` файл

```env
TWITTER_BEARER_TOKEN=AAAAAAAAAAAA...   # Bearer Token
TWITTER_API_KEY=QqX0ZW2Q...            # Consumer Key
TWITTER_API_SECRET=mFsLfWrb...         # Secret Key
TWITTER_ACCESS_TOKEN=123456789-abc...  # Access Token
TWITTER_ACCESS_TOKEN_SECRET=xyz123...  # Access Token Secret
```

---

## Использование

```bash
# Публичный аккаунт (нужен только Bearer Token)
python twitter_photo_downloader.py NASA

# Закрытый аккаунт (нужны все 5 ключей + ты должен быть подписан)
python twitter_photo_downloader.py private_username

# Свой аккаунт
python twitter_photo_downloader.py мой_логин

# Указать папку для сохранения
python twitter_photo_downloader.py username --output ~/Desktop/photos

# Ограничить количество сканируемых твитов
python twitter_photo_downloader.py username --limit 1000

# Перезаписать уже скачанные файлы
python twitter_photo_downloader.py username --no-skip
```

При запуске скрипт покажет режим аутентификации:
```
Auth mode: OAuth 1.0a (user context) — protected accounts supported
```
или
```
Auth mode: Bearer Token (app-only) — public accounts only
```

---

## Аргументы

| Аргумент | Описание |
|---|---|
| `username` | Имя пользователя (с @ или без) |
| `--output, -o` | Папка для сохранения (по умолчанию: `./downloads`) |
| `--limit, -l` | Максимум твитов для сканирования |
| `--no-skip` | Перескачивать уже существующие файлы |
| `--env, -e` | Путь к .env файлу с ключами |

---

## Структура скачанных файлов

```
downloads/
└── username/
    ├── 2024-01-15_1234567890_photo.jpg
    ├── 2024-01-10_1234567880_image.jpg
    └── ...
```

Имя файла: `ДАТА_ID-ТВИТА_ОРИГИНАЛЬНОЕ-ИМЯ.jpg`

---

## Возможные ошибки

| Ошибка | Причина | Решение |
|---|---|---|
| `TWITTER_BEARER_TOKEN not set` | Не заполнен .env | Заполни Bearer Token в .env |
| `Access denied (403)` | Закрытый аккаунт, нет OAuth | Заполни все 5 ключей в .env |
| `Access denied (403)` | Не подписан на аккаунт | Подпишись на аккаунт со своего профиля |
| `User not found` | Неверный логин | Проверь имя пользователя |
| `No photos found` | У аккаунта нет фото в твитах | Аккаунт не публикует фото |

---

## Лимиты Twitter API

| Тип | Free | Basic ($100/мес) |
|---|---|---|
| Твитов в месяц | 10 000 | 100 000 |
| Rate limit | ~15 запросов / 15 мин | ~15 запросов / 15 мин |

Скрипт автоматически ждёт при достижении rate limit.
