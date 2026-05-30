# video-cortar

`video-cortar.bat` cuts a local video to a fixed duration using FFmpeg stream copy. It does not re-encode video or audio.

Default command behavior:

```bat
ffmpeg -i "video.mp4" -t "00:18:00" -c copy "video_18min.mp4"
```

## Defaults

| Setting | Value |
|---|---|
| Duration | `00:18:00` |
| FFmpeg mode | `-c copy` |
| Output format | `.mp4` |
| Default output suffix | `_18min` |
| Overwrite existing files | No, unless `--force` is used |

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
tools\video_trim\video-cortar.bat video.mp4
tools\video_trim\video-cortar.bat video.mp4 --duration 00:05:00
tools\video_trim\video-cortar.bat video.mp4 --output video_corte.mp4
tools\video_trim\video-cortar.bat "C:\Videos\mi video.mp4" --output "C:\Videos\mi video_18min.mp4"
tools\video_trim\video-cortar.bat video.mp4 --force
tools\video_trim\video-cortar.bat --help
```

## Parameters

| Parameter | Description |
|---|---|
| `video.mp4` | Input video file. Supports `.mp4`, `.mov`, `.mkv`, `.avi`, `.webm`. |
| `--duration HH:MM:SS` | Trim duration. Default: `00:18:00`. |
| `--output RUTA` | Output `.mp4` path. |
| `--force` | Overwrite the output file if it already exists. |
| `--version` | Show tool version. |
| `--help`, `-h`, `/?` | Show command help. |

## Output

For `video.mp4`, the default output is:

```txt
video_18min.mp4
```

For a custom duration such as `00:05:30`, the default output is:

```txt
video_05m30s.mp4
```

For a custom duration such as `01:30:00`, the default output is:

```txt
video_01h30m00s.mp4
```

## Safety

- Does not delete original videos.
- Does not modify original videos.
- Does not overwrite output files unless `--force` is used.
- Refuses to use the input file itself as output.
- Validates that `ffmpeg` is available in PATH.
- Does not access the network.
- Does not use hardcoded absolute paths.
- Handles paths with spaces when they are quoted.

## Tests

From the project root, verify help and metadata:

```bat
tools\video_trim\video-cortar.bat --help
tools\video_trim\video-cortar.bat --version
python -m json.tool tools\video_trim\tool.json
```

Manual smoke test with a real video:

```bat
tools\video_trim\video-cortar.bat "C:\Videos\video.mp4"
tools\video_trim\video-cortar.bat "C:\Videos\video.mp4" --duration 00:05:00 --output "C:\Videos\video_5min.mp4"
```

Overwrite behavior test:

```bat
tools\video_trim\video-cortar.bat "C:\Videos\video.mp4"
tools\video_trim\video-cortar.bat "C:\Videos\video.mp4"
tools\video_trim\video-cortar.bat "C:\Videos\video.mp4" --force
```

The second command should fail with `OUTPUT_EXISTS`. The third command may overwrite the generated output.

## Limitations

Because this tool uses `-c copy`, FFmpeg copies streams without re-encoding. This is fast and preserves quality, but the cut may not be exact to the frame when the requested timestamp does not align with available keyframes.

## AI Usage Notes

Use this tool when an AI agent needs deterministic local video trimming without re-encoding. Do not use it for downloading media, generating content, subtitles, AI processing, or full video editing workflows.
