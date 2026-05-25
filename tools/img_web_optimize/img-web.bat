@echo off
setlocal

:: ============================================================
:: Tool: img-web
:: ID: img_web_optimize
:: Version: 1.0.0
:: Type: batch
:: Status: experimental
:: Category: images
:: Description:
::   Optimizes local images for web by resizing large images and
::   exporting compressed WebP or JPG copies.
::
:: Usage:
::   img-web.bat imagen.jpg
::   img-web.bat imagen.png --quality 70
::   img-web.bat imagen.jpg --max-size 1600
::   img-web.bat imagen.jpg --format jpg
::   img-web.bat --all
::   img-web.bat --all "C:\imagenes" --output "C:\imagenes_web"
::   img-web.bat --all --dry-run
::
:: Dependencies:
::   Python 3 and Pillow.
::   Install with: pip install pillow
::
:: Safety:
::   Does not delete or modify original images.
::   Does not overwrite outputs unless --force is used.
::   Does not access the network.
:: ============================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_PATH=%SCRIPT_DIR%img_web_optimize.py"

where py >nul 2>nul
if not errorlevel 1 (
    py -3 "%SCRIPT_PATH%" %*
    exit /b %ERRORLEVEL%
)

where python >nul 2>nul
if not errorlevel 1 (
    python "%SCRIPT_PATH%" %*
    exit /b %ERRORLEVEL%
)

echo ERROR [MISSING_DEPENDENCY]: Python 3 was not found in PATH. 1>&2
echo Suggestion: Install Python 3 or add it to PATH. 1>&2
exit /b 2
