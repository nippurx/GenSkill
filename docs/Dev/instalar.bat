@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: Tool: crear-estructura-genskill
:: ID: crear_estructura_genskill
:: Version: 1.0.0
:: Type: batch
:: Status: experimental
:: Category: project_setup
:: Description:
::   Crea la estructura inicial de carpetas y archivos maqueta
::   para el proyecto GenSkill.
::
:: Usage:
::   crear-estructura-genskill.bat
::   crear-estructura-genskill.bat GenSkill
::
:: Safety:
::   No borra archivos existentes.
::   No sobrescribe archivos existentes.
:: ============================================================
set "PROJECT_NAME=%~1"

if "%PROJECT_NAME%"=="" set "PROJECT_NAME=GenSkill"

echo.
echo Creando estructura del proyecto: %PROJECT_NAME%
echo.

mkdir "%PROJECT_NAME%" 2>nul

cd "%PROJECT_NAME%"

:: ============================================================
:: Carpetas principales
:: ============================================================

mkdir "genskill" 2>nul
mkdir "genskill\core" 2>nul
mkdir "genskill\models" 2>nul
mkdir "genskill\services" 2>nul
mkdir "genskill\utils" 2>nul

mkdir "skills" 2>nul
mkdir "skills\text_count_words" 2>nul
mkdir "skills\text_count_words\examples" 2>nul
mkdir "skills\text_count_words\examples\input" 2>nul
mkdir "skills\text_count_words\examples\output" 2>nul
mkdir "skills\text_count_words\tests" 2>nul

mkdir "tools" 2>nul
mkdir "tools\img_2web" 2>nul
mkdir "tools\img_2web\examples" 2>nul
mkdir "tools\img_2web\tests" 2>nul

mkdir "workflows" 2>nul

mkdir "workspace" 2>nul
mkdir "workspace\input" 2>nul
mkdir "workspace\output" 2>nul
mkdir "workspace\temp" 2>nul
mkdir "workspace\sandbox" 2>nul

mkdir "data" 2>nul
mkdir "data\logs" 2>nul
mkdir "data\cache" 2>nul
mkdir "data\indexes" 2>nul
mkdir "data\indexes\embeddings" 2>nul
mkdir "data\registry" 2>nul

mkdir "docs" 2>nul

mkdir "hub" 2>nul
mkdir "hub\downloaded" 2>nul

mkdir "tests" 2>nul
mkdir "tests\fixtures" 2>nul

mkdir "scripts" 2>nul

:: ============================================================
:: Archivos raíz
:: ============================================================

call :create_file "README.md" "# GenSkill"
call :create_file "GENSKILL_SPEC.md" "# GenSkill Spec"
call :create_file "ROADMAP.md" "# GenSkill Roadmap"
call :create_file "requirements.txt" "typer+pydantic+pytest"
call :create_file "pyproject.toml" "[project]"
call :create_file ".gitignore" "__pycache__/"

:: ============================================================
:: Paquete Python
:: ============================================================

call :create_file "genskill\__init__.py" ""
call :create_file "genskill\cli.py" ""
call :create_file "genskill\config.py" ""

call :create_file "genskill\core\runner.py" ""
call :create_file "genskill\core\registry.py" ""
call :create_file "genskill\core\search.py" ""
call :create_file "genskill\core\planner.py" ""
call :create_file "genskill\core\validator.py" ""
call :create_file "genskill\core\logger.py" ""
call :create_file "genskill\core\sandbox.py" ""
call :create_file "genskill\core\permissions.py" ""

call :create_file "genskill\models\skill_metadata.py" ""
call :create_file "genskill\models\tool_metadata.py" ""
call :create_file "genskill\models\workflow_metadata.py" ""
call :create_file "genskill\models\run_result.py" ""

call :create_file "genskill\services\skill_service.py" ""
call :create_file "genskill\services\workflow_service.py" ""
call :create_file "genskill\services\log_service.py" ""
call :create_file "genskill\services\hub_service.py" ""

call :create_file "genskill\utils\paths.py" ""
call :create_file "genskill\utils\json_utils.py" ""
call :create_file "genskill\utils\hashing.py" ""

:: ============================================================
:: Primera skill maqueta
:: ============================================================

call :create_file "skills\text_count_words\skill.json" "{"
call :create_file "skills\text_count_words\run.py" ""
call :create_file "skills\text_count_words\README.md" "# text_count_words"
call :create_file "skills\text_count_words\prompt.md" "# AI usage notes"
call :create_file "skills\text_count_words\requirements.txt" ""
call :create_file "skills\text_count_words\tests\test_skill.py" ""

:: ============================================================
:: Primera tool maqueta
:: ============================================================

call :create_file "tools\img_2web\tool.json" "{"
call :create_file "tools\img_2web\README.md" "# img_2web"
call :create_file "tools\img_2web\img-2web.bat" "@echo off"
call :create_file "tools\img_2web\img_2web.py" ""

:: ============================================================
:: Workflows
:: ============================================================

call :create_file "workflows\youtube_thumbnail.json" "{"
call :create_file "workflows\prepare_images_for_web.json" "{"
call :create_file "workflows\audiobook_video_pipeline.json" "{"

:: ============================================================
:: Data
:: ============================================================

call :create_file "data\logs\runs.jsonl" ""
call :create_file "data\logs\errors.jsonl" ""
call :create_file "data\logs\audit.jsonl" ""

call :create_file "data\registry\local_skills.json" "[]"
call :create_file "data\registry\local_tools.json" "[]"
call :create_file "data\registry\workflows.json" "[]"

call :create_file "data\indexes\skills_index.json" "[]"
call :create_file "data\indexes\tools_index.json" "[]"

:: ============================================================
:: Docs
:: ============================================================

call :create_file "docs\ARCHITECTURE.md" "# Architecture"
call :create_file "docs\SKILL_SPEC.md" "# Skill Spec"
call :create_file "docs\TOOL_CREATION_PROTOCOL.md" "# Tool Creation Protocol"
call :create_file "docs\TOOL_JSON_SCHEMA.md" "# Tool JSON Schema"
call :create_file "docs\SKILL_JSON_SCHEMA.md" "# Skill JSON Schema"
call :create_file "docs\WORKFLOW_SPEC.md" "# Workflow Spec"
call :create_file "docs\SECURITY.md" "# Security"
call :create_file "docs\TOOLS_INDEX.md" "# Tools Index"
call :create_file "docs\TOOLS_ENCYCLOPEDIA.md" "# Tools Encyclopedia"
call :create_file "docs\CODEX_PROMPTS.md" "# Codex Prompts"

:: ============================================================
:: Hub futuro
:: ============================================================

call :create_file "hub\README.md" "# GenSkill Hub"
call :create_file "hub\remote_registry_schema.json" "{"
call :create_file "hub\manifest.example.json" "{"

:: ============================================================
:: Tests
:: ============================================================

call :create_file "tests\test_cli.py" ""
call :create_file "tests\test_registry.py" ""
call :create_file "tests\test_runner.py" ""
call :create_file "tests\test_skill_metadata.py" ""
call :create_file "tests\test_tool_metadata.py" ""
call :create_file "tests\test_workflows.py" ""

:: ============================================================
:: Scripts internos
:: ============================================================

call :create_file "scripts\rebuild_indexes.py" ""
call :create_file "scripts\validate_all_skills.py" ""
call :create_file "scripts\validate_all_tools.py" ""
call :create_file "scripts\run_tests.bat" "@echo off"

:: ============================================================
:: Gitkeep para carpetas vacías importantes
:: ============================================================

call :create_file "workspace\input\.gitkeep" ""
call :create_file "workspace\output\.gitkeep" ""
call :create_file "workspace\temp\.gitkeep" ""
call :create_file "workspace\sandbox\.gitkeep" ""
call :create_file "data\cache\.gitkeep" ""
call :create_file "data\indexes\embeddings\.gitkeep" ""
call :create_file "hub\downloaded\.gitkeep" ""
call :create_file "tests\fixtures\.gitkeep" ""

echo.
echo ============================================================
echo Estructura GenSkill creada correctamente.
echo Proyecto: %CD%
echo ============================================================
echo.
echo Siguiente paso recomendado:
echo   cd %PROJECT_NAME%
echo   git init
echo.
exit /b 0

:create_file
set "FILE_PATH=%~1"
set "CONTENT=%~2"

if exist "%FILE_PATH%" (
    echo Ya existe: %FILE_PATH%
) else (
    if "%CONTENT%"=="" (
        type nul > "%FILE_PATH%"
    ) else (
        echo %CONTENT%> "%FILE_PATH%"
    )
    echo Creado: %FILE_PATH%
)

mkdir "docs\skills" 2>nul
mkdir "docs\skills\genskill-tool-protocol" 2>nul
call :create_file "docs\skills\genskill-tool-protocol\SKILL.md" "# GenSkill Tool Protocol"

exit /b 0