#!/usr/bin/env python3
"""Build the Windows installer with ordinary, visible subprocesses."""

from __future__ import annotations

import os
import struct
import subprocess
import sys
import tempfile
from pathlib import Path


VERSION = "0.98.3"
INSTALLER = Path(__file__).resolve().parent
PROJECT = INSTALLER.parent
ENVIRONMENT = PROJECT / ".build-venv"
BUILD_PYTHON = ENVIRONMENT / "Scripts" / "python.exe"
RELEASE = PROJECT / "release"
OUTPUT = RELEASE / f"Jewelry_AI_Search_Setup_v{VERSION}.exe"
configured_stage = os.environ.get("JAI_BUILD_STAGE_DIR", "").strip()
STAGE = Path(configured_stage).resolve() if configured_stage else Path(
    tempfile.gettempdir()
) / "JAI89"
DIST = STAGE / "d"
WORK = STAGE / "w"


def run(arguments: list[str], description: str) -> None:
    print(f"\n==> {description}", flush=True)
    subprocess.run(arguments, cwd=PROJECT, check=True)


def main() -> int:
    if sys.version_info[:2] != (3, 11) or struct.calcsize("P") != 8:
        raise SystemExit("Для сборки нужен Python 3.11 x64.")
    source = (PROJECT / "main.py").read_text(encoding="utf-8")
    if f'APP_VERSION = "{VERSION}"' not in source:
        raise SystemExit("Версии приложения и установщика не совпадают.")
    for directory in (RELEASE, DIST, WORK):
        directory.mkdir(parents=True, exist_ok=True)
    if not BUILD_PYTHON.is_file():
        run([sys.executable, "-m", "venv", str(ENVIRONMENT)],
            "Создаю отдельное окружение сборки")
    python = str(BUILD_PYTHON)
    run([python, "-m", "pip", "install", "--upgrade", "pip"], "Обновляю pip")
    run([python, "-m", "pip", "install", "-r",
         str(INSTALLER / "requirements-build.txt")], "Устанавливаю зависимости")
    run([python, "-m", "pip", "check"], "Проверяю установленные зависимости")
    run([python, "-c", "import transformers, sentencepiece, open_clip, rhino3dm"],
        "Проверяю визуальный движок")
    run([python, "-m", "py_compile", str(PROJECT / "main.py")],
        "Проверяю код Jewelry AI Search")
    run([python, "-m", "PyInstaller", "--noconfirm", "--clean",
         "--distpath", str(DIST), "--workpath", str(WORK),
         str(INSTALLER / "JewelryAISearch.spec")],
        "Создаю автономную программу Windows")
    application = DIST / "JewelryAISearch"
    if not (application / "JewelryAISearch.exe").is_file():
        raise SystemExit("PyInstaller не создал JewelryAISearch.exe.")
    compiler = os.environ.get("JAI_INNO_COMPILER", "").strip()
    if not compiler or not Path(compiler).is_file():
        raise SystemExit("Не найден Inno Setup 6. Запустите BUILD_INSTALLER.cmd.")
    OUTPUT.unlink(missing_ok=True)
    run([compiler, f"/DAppDistDir={application}",
         str(INSTALLER / "JewelryAISearch.iss")], "Создаю установщик Windows")
    if not OUTPUT.is_file():
        raise SystemExit(f"Inno Setup не создал ожидаемый файл: {OUTPUT}")
    print(f"\nГОТОВО: {OUTPUT}", flush=True)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, subprocess.CalledProcessError) as error:
        raise SystemExit(f"Не удалось собрать установщик: {error}") from error
