@echo off
setlocal

:: ============================================================
:: Tool: text-count
:: ID: text_count_words
:: Version: 1.0.0
:: Type: batch
:: Status: experimental
:: Category: text
:: Description:
::   Counts words, characters, and lines from a .txt file or text
::   passed through the command line.
::
:: Usage:
::   text-count.bat archivo.txt
::   text-count.bat archivo.txt --json
::   text-count.bat --text "hola mundo"
::   text-count.bat --all examples
::
:: Inputs:
::   .txt file, folder of .txt files with --all, or direct text with --text.
::
:: Outputs:
::   Counts printed to stdout as text or JSON.
::
:: Parameters:
::   --help       Show help.
::   --text       Count text provided as an argument.
::   --all        Count all .txt files in a folder.
::   --recursive  Include subfolders with --all.
::   --encoding   File encoding. Default: utf-8.
::   --json       Output JSON.
::   --version    Show version.
::
:: Dependencies:
::   Python 3, standard library only.
::
:: Safety:
::   Read-only. Does not delete, modify, or overwrite files.
::   Does not access the network.
::
:: AI Notes:
::   This tool is part of the GenSkill Tool Protocol.
::   It is designed to be understandable by humans and AI agents.
::
:: Author:
::   GenSkill
:: ============================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_PATH=%SCRIPT_DIR%text_count_words.py"

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
