@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0.." || goto :failed

echo.
echo Jewelry AI Search 0.98.3: preparing a free Windows installer...
echo.

call :find_python
if errorlevel 1 (
  echo Python 3.11 x64 is required to build the installer.
  where winget >nul 2>&1
  if errorlevel 1 (
    echo Windows Package Manager was not found. Install Python 3.11 x64 manually and run this file again.
    goto :failed
  )
  echo Installing Python 3.11...
  winget install --id Python.Python.3.11 -e --accept-package-agreements --accept-source-agreements
  if errorlevel 1 goto :failed
  call :find_python
  if errorlevel 1 (
    echo Python is not visible to this Windows session. Close this window and run BUILD_INSTALLER.cmd again.
    goto :failed
  )
)

call :find_inno
if errorlevel 1 (
  echo Inno Setup 6 is required to create Setup.exe.
  where winget >nul 2>&1
  if errorlevel 1 (
    echo Windows Package Manager was not found. Install Inno Setup 6 manually and run this file again.
    goto :failed
  )
  echo Installing Inno Setup 6...
  winget install --id JRSoftware.InnoSetup -e --accept-package-agreements --accept-source-agreements
  if errorlevel 1 goto :failed
  call :find_inno
  if errorlevel 1 (
    echo Inno Setup was installed, but ISCC.exe could not be found.
    goto :failed
  )
)

echo Python: "%JAI_BUILD_PYTHON%"
echo Inno Setup: "%JAI_INNO_COMPILER%"
echo The first build downloads large PyTorch dependencies and can take some time.
"%JAI_BUILD_PYTHON%" "%~dp0build_installer.py"
if errorlevel 1 goto :failed
if not exist "%CD%\release\Jewelry_AI_Search_Setup_v0.98.3.exe" (
  echo The expected Setup.exe was not created.
  goto :failed
)

echo.
echo READY: "%CD%\release\Jewelry_AI_Search_Setup_v0.98.3.exe"
echo This EXE is the installer that can be shared.
explorer.exe "%CD%\release" >nul 2>&1
pause
exit /b 0

:find_python
set "JAI_BUILD_PYTHON="
for /f "usebackq delims=" %%P in (`py -3.11 -c "import sys; print(sys.executable)" 2^>nul`) do set "JAI_BUILD_PYTHON=%%P"
if defined JAI_BUILD_PYTHON if exist "%JAI_BUILD_PYTHON%" exit /b 0
if exist "%LOCALAPPDATA%\Programs\Python\Python311\python.exe" set "JAI_BUILD_PYTHON=%LOCALAPPDATA%\Programs\Python\Python311\python.exe"
if not defined JAI_BUILD_PYTHON if exist "%ProgramFiles%\Python311\python.exe" set "JAI_BUILD_PYTHON=%ProgramFiles%\Python311\python.exe"
if defined JAI_BUILD_PYTHON exit /b 0
exit /b 1

:find_inno
set "JAI_INNO_COMPILER="
if exist "%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe" set "JAI_INNO_COMPILER=%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe"
if not defined JAI_INNO_COMPILER if exist "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" set "JAI_INNO_COMPILER=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
if not defined JAI_INNO_COMPILER if exist "%ProgramFiles%\Inno Setup 6\ISCC.exe" set "JAI_INNO_COMPILER=%ProgramFiles%\Inno Setup 6\ISCC.exe"
if defined JAI_INNO_COMPILER exit /b 0
exit /b 1

:failed
echo.
echo Build failed. Check the message shown above.
pause
exit /b 1
