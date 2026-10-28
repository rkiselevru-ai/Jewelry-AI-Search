# 💎 Jewelry AI Search

**Локальный ИИ-каталог и поиск по вашей библиотеке украшений — фото, Rhino (.3dm), Blender (.blend), STL.**

Всё работает офлайн на вашем компьютере: индексация, поиск по смыслу и чат с языковой моделью. Ни один файл вашей библиотеки не уходит в облако.

> 🇬🇧 English summary at the bottom of this page.

---

## Что это

Jewelry AI Search — настольное приложение (Windows/Linux) для ювелиров и мастерских, которое делает вашу личную библиотеку работ *осмысленно доступной для поиска*:

- 📁 **Каталог** — импорт фотографий и 3D-файлов проекта (`.3dm` / Rhino, `.blend` / Blender, `.stl`), роли изображений (3D-фасон, ручной, этюд, комплект…);
- 🔍 **Поиск по смыслу** — находите работы по описанию «золотое кольцо с гравировкой на один камень», а не по именам файлов;
- 💬 **Чат-поиск** — диалог с локальной LLM (через [Ollama](https://ollama.com)): «покажи все подвески, которые мы делали из золота с бриллиантами»;
- 🏷 **Теги и проекты** — ваши ярлыки, списки, сохранённые выборки;
- 🧠 **Обучение на вашей библиотеке** — «Сохрани + обучить похожим»: поиск подстраивается под ваш стиль;
- 🗄 **Бэкапы** — полное резервное копирование (SQL + кэш, ZIP) и восстановление, экспорт ИИ-базы;
- 🌐 **Интерфейс RU / EN**.

Стек: Python, PyTorch + OpenCLIP (векторный поиск), Ollama (локальный LLM), rhino3dm (чтение 3DM).

---

## Быстрый старт (Windows)

1. Скачайте `Jewelry_AI_Search_Setup_v0.98.3.exe` со страницы [Releases](../../releases).
2. Установите и запустите — программа сама скачает нужные модели при первом запуске.
3. Для **чат-поиска** установите [Ollama](https://ollama.com/download) и скачайте любую модель (например `ollama pull qwen2.5`). Без Ollama всё остальное работает.

## Запуск из исходников

```bash
python -m venv .venv
.venv\Scripts\activate          # Linux: source .venv/bin/activate
pip install -r installer/requirements-build.txt   # все зависимости, включая PyInstaller
python main.py
```

> Требуется Python 3.10+. NVIDIA GPU ускоряет индексацию и поиск, но не обязателен.

## Скриншоты

<!-- TODO: вставить 2–3 скриншота из видео/работы программы
![Каталог](screenshots/catalog.png)
![Поиск](screenshots/search.png)
-->

---

## 📺 Видео и статьи

- [Разбор на YouTube — обзор программы](https://www.youtube.com/watch?v=llTMryO0Y10)
- [Демонстрация](https://www.youtube.com/watch?v=oh1G_3MdOhY)
- [Пост в Telegram-канале](https://t.me/RKiselev26/451)

## 📖 Инструкция

Подробная инструкция на русском: [`docs/Jewelry_AI_Search_Instruction_RU.pdf`](docs/Jewelry_AI_Search_Instruction_RU.pdf)

---

## Сборка установщика из исходников

Нужен только если вы хотите собрать `.exe` сами:

```bash
cd installer
pip install -r requirements-dev.txt
BUILD_INSTALLER.cmd
```

Сборка использует PyInstaller + Inno Setup (см. `installer/JewelryAISearch.spec` и `installer/JewelryAISearch.iss`).

---

## Лицензия

**PolyForm Noncommercial 1.0.0** — программа бесплатна, но **нельзя продавать её или строить на ней коммерческий продукт**. Личное использование, мастерские, обучение, некоммерческие организации — полностью разрешены. См. [LICENSE](LICENSE).

---

## 🇬🇧 English (short)

**Jewelry AI Search** is a local-first desktop app (Windows/Linux) for jewelry makers: it indexes your private library of photos and 3D files (Rhino `.3dm`, Blender `.blend`, STL) and lets you find works by *meaning*, not filenames. Includes a chat-based search powered by a local LLM via [Ollama](https://ollama.com), tagging, projects, self-training on your own library ("save + teach similar"), full backups (SQL + cache ZIP) and offline operation — nothing leaves your machine.

- Install: grab the latest `Setup.exe` from [Releases](../../releases), or run from source (`python main.py`).
- Docs: [`docs/Jewelry_AI_Search_Instruction_RU.pdf`](docs/Jewelry_AI_Search_Instruction_RU.pdf) (in Russian).
- License: [PolyForm Noncommercial 1.0.0](LICENSE) — free for personal/non-commercial use, reselling is not permitted.
- Video overview: [YouTube](https://www.youtube.com/watch?v=llTMryO0Y10) · [demo](https://www.youtube.com/watch?v=oh1G_3MdOhY) · [Telegram](https://t.me/RKiselev26/451)
