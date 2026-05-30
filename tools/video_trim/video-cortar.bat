@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "TOOL_NAME=video-cortar"
set "TOOL_ID=video_trim"
set "TOOL_VERSION=1.0.0"

set "INPUT="
set "OUTPUT="
set "DURATION=00:18:00"
set "FORCE=0"

if "%~1"=="" (
    call :help
    exit /b 0
)

:parse_args
if "%~1"=="" goto after_parse

if /I "%~1"=="--help" (
    call :help
    exit /b 0
) else if /I "%~1"=="-h" (
    call :help
    exit /b 0
) else if /I "%~1"=="/?" (
    call :help
    exit /b 0
) else if /I "%~1"=="--version" (
    echo %TOOL_NAME% %TOOL_VERSION%
    exit /b 0
) else if /I "%~1"=="--duration" (
    if "%~2"=="" (
        call :error "MISSING_VALUE" "--duration requires a HH:MM:SS value." 2
        exit /b 2
    )
    set "DURATION=%~2"
    shift
) else if /I "%~1"=="--output" (
    if "%~2"=="" (
        call :error "MISSING_VALUE" "--output requires a file path." 2
        exit /b 2
    )
    set "OUTPUT=%~2"
    shift
) else if /I "%~1"=="--force" (
    set "FORCE=1"
) else (
    if defined INPUT (
        call :error "TOO_MANY_INPUTS" "Only one input video is accepted." 2
        exit /b 2
    )
    set "INPUT=%~1"
)

shift
goto parse_args

:after_parse
where ffmpeg >nul 2>nul
if errorlevel 1 (
    call :error "MISSING_DEPENDENCY" "ffmpeg was not found in PATH. Install FFmpeg and add it to PATH." 2
    exit /b 2
)

if not defined INPUT (
    call :error "MISSING_INPUT" "Usage: video-cortar.bat video.mp4 [--duration HH:MM:SS]" 2
    exit /b 2
)

if not exist "%INPUT%" (
    call :error "INPUT_NOT_FOUND" "File not found: %INPUT%" 2
    exit /b 2
)

call :is_supported "%INPUT%"
if errorlevel 1 (
    call :error "UNSUPPORTED_EXTENSION" "Supported input extensions: .mp4, .mov, .mkv, .avi, .webm" 2
    exit /b 2
)

call :validate_duration "%DURATION%"
if errorlevel 1 exit /b 2

if defined OUTPUT (
    call :require_mp4_output "%OUTPUT%"
    if errorlevel 1 exit /b 2
    set "DEST=%OUTPUT%"
) else (
    call :duration_label "%DURATION%"
    for %%I in ("%INPUT%") do set "DEST=%%~dpnI_!DURATION_LABEL!.mp4"
)

for %%I in ("%INPUT%") do set "INPUT_FULL=%%~fI"
for %%O in ("!DEST!") do set "DEST_FULL=%%~fO"
if /I "!INPUT_FULL!"=="!DEST_FULL!" (
    call :error "INVALID_OUTPUT" "Output path cannot be the same as the input file." 2
    exit /b 2
)

if exist "!DEST!" (
    if not "%FORCE%"=="1" (
        call :error "OUTPUT_EXISTS" "Output already exists: !DEST! Use --force to overwrite." 3
        exit /b 3
    )
)

echo Processing: "%INPUT%"
echo Duration: %DURATION%
echo Output: "!DEST!"

if "%FORCE%"=="1" (
    ffmpeg -y -i "%INPUT%" -t "%DURATION%" -c copy "!DEST!"
) else (
    ffmpeg -n -i "%INPUT%" -t "%DURATION%" -c copy "!DEST!"
)

if errorlevel 1 (
    call :error "FFMPEG_FAILED" "FFmpeg failed while trimming: %INPUT%" 4
    exit /b 4
)

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

:validate_duration
set "VALUE=%~1"
if not "%VALUE:~2,1%"==":" (
    call :error "INVALID_DURATION" "--duration must use HH:MM:SS format." 2
    exit /b 1
)
if not "%VALUE:~5,1%"==":" (
    call :error "INVALID_DURATION" "--duration must use HH:MM:SS format." 2
    exit /b 1
)
if not "%VALUE:~8,1%"=="" (
    call :error "INVALID_DURATION" "--duration must use HH:MM:SS format." 2
    exit /b 1
)
set "HH=%VALUE:~0,2%"
set "MM=%VALUE:~3,2%"
set "SS=%VALUE:~6,2%"
call :validate_two_digits "%HH%" "hours"
if errorlevel 1 exit /b 1
call :validate_two_digits "%MM%" "minutes"
if errorlevel 1 exit /b 1
call :validate_two_digits "%SS%" "seconds"
if errorlevel 1 exit /b 1
if %MM% GEQ 60 (
    call :error "INVALID_DURATION" "Minutes must be between 00 and 59." 2
    exit /b 1
)
if %SS% GEQ 60 (
    call :error "INVALID_DURATION" "Seconds must be between 00 and 59." 2
    exit /b 1
)
if "%HH%%MM%%SS%"=="000000" (
    call :error "INVALID_DURATION" "Duration must be greater than 00:00:00." 2
    exit /b 1
)
exit /b 0

:validate_two_digits
set "PART=%~1"
set "LABEL=%~2"
if "%PART:~2,1%" neq "" (
    call :error "INVALID_DURATION" "%LABEL% must have exactly two digits." 2
    exit /b 1
)
for /F "delims=0123456789" %%A in ("%PART%") do (
    call :error "INVALID_DURATION" "%LABEL% must contain only digits." 2
    exit /b 1
)
exit /b 0

:duration_label
set "VALUE=%~1"
set "HH=%VALUE:~0,2%"
set "MM=%VALUE:~3,2%"
set "SS=%VALUE:~6,2%"
if "%HH%"=="00" (
    if "%SS%"=="00" (
        set "DURATION_LABEL=%MM%min"
    ) else (
        set "DURATION_LABEL=%MM%m%SS%s"
    )
) else (
    set "DURATION_LABEL=%HH%h%MM%m%SS%s"
)
exit /b 0

:help
echo video-cortar %TOOL_VERSION%
echo.
echo Cuts a local video using FFmpeg stream copy, without re-encoding.
echo.
echo Usage:
echo   video-cortar.bat video.mp4
echo   video-cortar.bat video.mp4 --duration 00:05:00
echo   video-cortar.bat "C:\Videos\mi video.mp4" --output "C:\Videos\corte.mp4"
echo   video-cortar.bat video.mp4 --force
echo.
echo Parameters:
echo   video.mp4              Input video file.
echo   --duration HH:MM:SS    Trim duration. Default: 00:18:00.
echo   --output FILE          Output .mp4 path. Default: input name plus duration suffix.
echo   --force                Overwrite the output file if it already exists.
echo   --version              Show version.
echo   --help, -h, /?         Show this help.
echo.
echo Safety:
echo   Original videos are never deleted or modified.
echo   Existing output files are not overwritten unless --force is used.
exit /b 0

:error
echo ERROR [%~1]: %~2 1>&2
exit /b %~3
