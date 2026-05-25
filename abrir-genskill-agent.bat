@echo off
setlocal

cd /d "%~dp0"

echo ==========================================
echo  GenSkill Agent - Codex
echo ==========================================
echo.
echo Carpeta actual:
cd
echo.
echo Iniciando Codex con instrucciones AGENTS.md...
echo.

codex

endlocal
