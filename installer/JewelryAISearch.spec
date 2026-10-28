import os
from PyInstaller.utils.hooks import collect_all

project_root=os.path.abspath(os.path.join(SPECPATH,".."))
app_script=os.path.join(project_root,"main.py")
if not os.path.isfile(app_script):
    raise SystemExit("Не найден main.py рядом с папкой installer. Распакуйте весь ZIP и повторите сборку.")
icon_ico=os.path.join(project_root,"assets","jewelry-ai-search.ico")
icon_png=os.path.join(project_root,"assets","jewelry-ai-search.png")
if not os.path.isfile(icon_ico) or not os.path.isfile(icon_png):
    raise SystemExit("Не найдена фирменная иконка Jewelry AI Search в папке assets.")

datas=[(icon_ico,"assets"),(icon_png,"assets")]
binaries=[]
hiddenimports=[
    "base64", "collections", "contextlib", "ctypes", "datetime", "difflib",
    "functools", "gzip", "io", "json", "numpy", "open_clip", "platform",
    "queue", "runpy", "sentencepiece", "shlex", "shutil", "sqlite3", "struct",
    "subprocess", "tempfile", "threading", "traceback", "urllib.error",
    "urllib.request", "uuid", "wave", "zstandard", "torch", "torchvision",
    "rhino3dm", "transformers", "PIL", "PIL.Image", "PIL.ImageOps",
    "PIL.ImageTk", "PIL.ImageDraw", "PIL.ImageFont", "PIL.ImageFilter",
    "tkinter", "tkinter.font", "tkinter.ttk", "tkinter.filedialog",
    "tkinter.messagebox", "tkinter.simpledialog", "winreg", "winsound",
]
for package in ("open_clip","torchvision","zstandard","rhino3dm","transformers","tokenizers",
                "sentencepiece","huggingface_hub","safetensors"):
    package_datas,package_binaries,package_hidden=collect_all(package)
    datas+=package_datas
    binaries+=package_binaries
    hiddenimports+=package_hidden

a=Analysis(
    [app_script],
    pathex=[os.path.dirname(app_script)],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=["matplotlib","pandas","jupyter","IPython"],
    noarchive=False,
    optimize=1,
)
pyz=PYZ(a.pure)

exe=EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name="JewelryAISearch",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    icon=icon_ico,
)

coll=COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=False,
    upx_exclude=[],
    name="JewelryAISearch",
)
