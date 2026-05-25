# video-2web

`video-2web.bat` optimizes local videos for web using FFmpeg. It creates `.mp4` copies with H.264 video, AAC audio, `faststart`, and the `_web` suffix by default.

The tool preserves the original aspect ratio. By default it also keeps the original resolution. If `--max-width` is used, it only downscales videos that are wider than the requested width.

## Defaults

| Setting | Value |
|---|---|
| Video codec | `libx264` |
| Quality | `CRF 28` |
| Preset | `medium` |
| Audio codec | `aac` |
| Audio bitrate | `128k` |
| Pixel format | `yuv420p` |
| Web optimization | `-movflags +faststart` |
| Output format | `.mp4` |
| Output suffix | `_web` |

## Install FFmpeg

1. Download a Windows build from the official FFmpeg site: <https://ffmpeg.org/download.html>
2. Extract it to a local folder, for example `C:\ffmpeg`.
3. Add the `bin` folder to PATH, for example `C:\ffmpeg\bin`.
4. Open a new terminal and verify:

```bat
ffmpeg -version
```

## Usage

```bat
tools\video_2web\video-2web.bat video.mp4
tools\video_2web\video-2web.bat video.mp4 --quality 26
tools\video_2web\video-2web.bat video.mp4 --max-width 1280
tools\video_2web\video-2web.bat video.mp4 --output salida_web.mp4
tools\video_2web\video-2web.bat --all
tools\video_2web\video-2web.bat --all "C:\Videos"
tools\video_2web\video-2web.bat --all "C:\Videos" --max-width 1280 --quality 28
tools\video_2web\video-2web.bat --all "C:\Videos" --dry-run
tools\video_2web\video-2web.bat --help
```

## Parameters

| Parameter | Description |
|---|---|
| `video.mp4` | Input video for single-file mode. Supports `.mp4`, `.mov`, `.mkv`, `.avi`, `.webm`. |
| `--help` | Show help. |
| `--version` | Show tool version. |
| `--quality NUMBER` | FFmpeg CRF quality value. Lower is higher quality and larger output. Default: `28`. |
| `--max-width NUMBER` | Downscale only if the input video is wider than this value. Aspect ratio is always preserved. |
| `--output RUTA` | Output `.mp4` path in single-file mode, or existing output folder in `--all` mode. |
| `--force` | Overwrite existing output files. |
| `--all [FOLDER]` | Process all supported videos in a folder. Defaults to the current folder. |
| `--recursive` | Include subfolders when using `--all`. |
| `--dry-run` | Show planned FFmpeg commands without writing files. |

## Output

For `video.mp4`, the default output is:

```txt
video_web.mp4
```

For `pelicula.mov`, the default output is:

```txt
pelicula_web.mp4
```

The base FFmpeg command is:

```bat
ffmpeg -i "video.mp4" -c:v libx264 -crf 28 -preset medium -c:a aac -b:a 128k -movflags +faststart -pix_fmt yuv420p "video_web.mp4"
```

When `--max-width 1280` is used, the tool adds a scale filter that keeps the original size unless the video is wider than `1280`.

## Safety

- Does not delete original videos.
- Does not modify original videos.
- Does not overwrite output files unless `--force` is used.
- Supports `--dry-run` for folder and single-file operations.
- Validates that `ffmpeg` is available in PATH.
- Does not access the network.
- Does not use hardcoded absolute paths.
- Handles paths with spaces when they are quoted.

## Test

From the project root, verify help and parsing:

```bat
tools\video_2web\video-2web.bat --help
tools\video_2web\video-2web.bat --version
tools\video_2web\video-2web.bat --all tools\video_2web --dry-run
```

Manual smoke test with a real video:

```bat
tools\video_2web\video-2web.bat "C:\Videos\video.mp4" --dry-run
tools\video_2web\video-2web.bat "C:\Videos\video.mp4"
```

## AI Usage Notes

Use this tool when an AI agent needs deterministic local video compression for web delivery. Do not use it for video editing, downloading remote media, subtitles, thumbnails, or format workflows outside the supported input extensions.
