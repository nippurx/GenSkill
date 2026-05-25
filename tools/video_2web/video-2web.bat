@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "TOOL_NAME=video-2web"
set "TOOL_ID=video_2web"
set "TOOL_VERSION=1.0.0"

set "INPUT="
set "OUTPUT="
set "QUALITY=28"
set "MAX_WIDTH="
set "ALL_MODE=0"
set "RECURSIVE=0"
set "DRY_RUN=0"
set "FORCE=0"
set "TARGET_DIR=."

if "%~1"=="" (
    call :help
    exit /b 0
)

:parse_args
if "%~1"=="" goto after_parse

if /I "%~1"=="--help" (
    call :help
    exit /b 0
) else if /I "%~1"=="--version" (
    echo %TOOL_NAME% %TOOL_VERSION%
    exit /b 0
) else if /I "%~1"=="--quality" (
    if "%~2"=="" (
        call :error "MISSING_VALUE" "--quality requires a number." 2
        exit /b 2
    )
    set "QUALITY=%~2"
    shift
) else if /I "%~1"=="--max-width" (
    if "%~2"=="" (
        call :error "MISSING_VALUE" "--max-width requires a number." 2
        exit /b 2
    )
    set "MAX_WIDTH=%~2"
    shift
) else if /I "%~1"=="--output" (
    if "%~2"=="" (
        call :error "MISSING_VALUE" "--output requires a path." 2
        exit /b 2
    )
    set "OUTPUT=%~2"
    shift
) else if /I "%~1"=="--force" (
    set "FORCE=1"
) else if /I "%~1"=="--all" (
    set "ALL_MODE=1"
) else if /I "%~1"=="--recursive" (
    set "RECURSIVE=1"
) else if /I "%~1"=="--dry-run" (
    set "DRY_RUN=1"
) else (
    if "%ALL_MODE%"=="1" (
        set "TARGET_DIR=%~1"
    ) else (
        if defined INPUT (
            call :error "TOO_MANY_INPUTS" "Only one input file is accepted in single-file mode." 2
            exit /b 2
        )
        set "INPUT=%~1"
    )
)

shift
goto parse_args

:after_parse
call :validate_number "%QUALITY%" "--quality"
if errorlevel 1 exit /b 2
if defined MAX_WIDTH (
    call :validate_number "%MAX_WIDTH%" "--max-width"
    if errorlevel 1 exit /b 2
)

where ffmpeg >nul 2>nul
if errorlevel 1 (
    call :error "MISSING_DEPENDENCY" "ffmpeg was not found in PATH. Install FFmpeg and add it to PATH." 2
    exit /b 2
)

if "%ALL_MODE%"=="1" (
    if defined OUTPUT (
        if not exist "%OUTPUT%\" (
            call :error "INVALID_OUTPUT" "In --all mode, --output must be an existing folder." 2
            exit /b 2
        )
    )
    if not exist "%TARGET_DIR%\" (
        call :error "INVALID_FOLDER" "Folder not found: %TARGET_DIR%" 2
        exit /b 2
    )
    set "PROCESSED=0"
    if "%RECURSIVE%"=="1" (
        for /R "%TARGET_DIR%" %%F in (*.mp4 *.mov *.mkv *.avi *.webm) do (
            call :process_file "%%~fF"
            if errorlevel 4 exit /b 4
            if errorlevel 3 exit /b 3
            if errorlevel 2 exit /b 2
            if errorlevel 1 exit /b 1
        )
    ) else (
        for %%E in (mp4 mov mkv avi webm) do (
            for %%F in ("%TARGET_DIR%\*.%%E") do (
                if exist "%%~fF" (
                    call :process_file "%%~fF"
                    if errorlevel 4 exit /b 4
                    if errorlevel 3 exit /b 3
                    if errorlevel 2 exit /b 2
                    if errorlevel 1 exit /b 1
                )
            )
        )
    )
    if "!PROCESSED!"=="0" goto no_inputs
    echo OK: !PROCESSED! video^(s^) processed.
    exit /b 0
)

goto single_mode

:no_inputs
call :error "NO_INPUTS" "No supported videos found." 1
exit /b 1

:single_mode
if not defined INPUT (
    call :error "MISSING_INPUT" "Usage: video-2web.bat video.mp4" 2
    exit /b 2
)
if defined OUTPUT (
    call :require_mp4_output "%OUTPUT%"
    if errorlevel 1 exit /b 2
)
call :process_file "%INPUT%"
exit /b %ERRORLEVEL%

:process_file
set "SRC=%~1"
if not exist "%SRC%" (
    call :error "INPUT_NOT_FOUND" "File not found: %SRC%" 2
    exit /b 2
)

call :is_supported "%SRC%"
if errorlevel 1 (
    call :error "UNSUPPORTED_EXTENSION" "Supported input extensions: .mp4, .mov, .mkv, .avi, .webm" 2
    exit /b 2
)

if "%ALL_MODE%"=="1" (
    if defined OUTPUT (
        set "DEST=%OUTPUT%\%~n1_web.mp4"
    ) else (
        set "DEST=%~dpn1_web.mp4"
    )
) else if defined OUTPUT (
    set "DEST=%OUTPUT%"
) else (
    set "DEST=%~dpn1_web.mp4"
)

if exist "!DEST!" (
    if not "%FORCE%"=="1" (
        call :error "OUTPUT_EXISTS" "Output already exists: !DEST! Use --force to overwrite." 3
        exit /b 3
    )
)

set "VF_ARGS="
if defined MAX_WIDTH set "VF_ARGS=-vf scale='if(gt(iw,!MAX_WIDTH!),!MAX_WIDTH!,iw)':-2"

if "%DRY_RUN%"=="1" (
    echo DRY-RUN: ffmpeg -i "%SRC%" -c:v libx264 -crf !QUALITY! -preset medium !VF_ARGS! -c:a aac -b:a 128k -movflags +faststart -pix_fmt yuv420p "!DEST!"
    set /A PROCESSED+=1
    exit /b 0
)

echo Processing: "%SRC%"
echo Output: "!DEST!"
if defined MAX_WIDTH (
    ffmpeg -y -i "%SRC%" -c:v libx264 -crf !QUALITY! -preset medium -vf "scale='if(gt(iw,!MAX_WIDTH!),!MAX_WIDTH!,iw)':-2" -c:a aac -b:a 128k -movflags +faststart -pix_fmt yuv420p "!DEST!"
) else (
    ffmpeg -y -i "%SRC%" -c:v libx264 -crf !QUALITY! -preset medium -c:a aac -b:a 128k -movflags +faststart -pix_fmt yuv420p "!DEST!"
)
if errorlevel 1 (
    call :error "FFMPEG_FAILED" "FFmpeg failed while processing: %SRC%" 4
    exit /b 4
)
set /A PROCESSED+=1
echo OK: "!DEST!"
exit /b 0

:is_supported
set "EXT=%~x1"
if /I "%EXT%"==".mp4" exit /b 0
if /I "%EXT%"==".mov" exit /b 0
if /I "%EXT%"==".mkv" exit /b 0
if /I "%EXT%"==".avi" exit /b 0
if /I "%EXT%"==".webm" exit /b 0
exit /b 1

:require_mp4_output
if /I "%~x1"==".mp4" exit /b 0
call :error "INVALID_OUTPUT_EXTENSION" "Output path must end in .mp4." 2
exit /b 2

:validate_number
set "NUM=%~1"
set "PARAM=%~2"
if "%NUM%"=="" (
    call :error "INVALID_NUMBER" "%PARAM% requires a positive integer." 2
    exit /b 2
)
for /F "delims=0123456789" %%A in ("%NUM%") do (
    call :error "INVALID_NUMBER" "%PARAM% must be a positive integer." 2
    exit /b 2
)
if %NUM% LEQ 0 (
    call :error "INVALID_NUMBER" "%PARAM% must be greater than 0." 2
    exit /b 2
)
exit /b 0

:help
echo video-2web %TOOL_VERSION%
echo.
echo Optimizes local videos for web using FFmpeg.
echo.
echo Usage:
echo   video-2web.bat video.mp4
echo   video-2web.bat video.mp4 --quality 26
echo   video-2web.bat video.mp4 --max-width 1280
echo   video-2web.bat video.mp4 --output salida_web.mp4
echo   video-2web.bat --all
echo   video-2web.bat --all "C:\Videos" --dry-run
echo.
echo Parameters:
echo   --quality NUMBER     CRF quality value. Lower is better quality/larger file. Default: 28.
echo   --max-width NUMBER   Downscale only if the video is wider than this value.
echo   --output PATH        Output .mp4 path in single mode, or existing folder in --all mode.
echo   --force              Overwrite existing output files.
echo   --all [FOLDER]       Process supported videos in a folder. Defaults to current folder.
echo   --recursive          Include subfolders when using --all.
echo   --dry-run            Show planned FFmpeg commands without writing files.
echo   --version            Show version.
echo   --help               Show this help.
echo.
echo Supported input extensions: .mp4, .mov, .mkv, .avi, .webm
exit /b 0

:error
echo ERROR [%~1]: %~2 1>&2
exit /b %~3
