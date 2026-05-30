# Tools Encyclopedia

## text-count

### Summary

Counts words, characters, and lines from a `.txt` file, a folder of `.txt` files, or text passed directly by parameter.

### Use Cases

- Quickly inspect the size of a text file.
- Get machine-readable text counts for automation.
- Count all `.txt` files in a local folder.

### Usage

```bat
text-count.bat archivo.txt
text-count.bat archivo.txt --json
text-count.bat --text "hola mundo"
text-count.bat --all examples
```

### Parameters

| Parameter | Description |
|---|---|
| `archivo.txt` | Input `.txt` file. |
| `--text "texto"` | Count text passed directly in the command. |
| `--all [folder]` | Count all `.txt` files in a folder. |
| `--recursive` | Include subfolders when using `--all`. |
| `--encoding NAME` | File encoding. Default: `utf-8`. |
| `--json` | Print valid JSON. |
| `--help` | Show command help. |
| `--version` | Show tool version. |

### Inputs

- `.txt` files.
- Folder of `.txt` files.
- Direct text passed with `--text`.

### Outputs

Prints counts to stdout in human-readable text or JSON.

### Examples

```bat
tools\text_count_words\text-count.bat tools\text_count_words\examples\input.txt
tools\text_count_words\text-count.bat tools\text_count_words\examples\input.txt --json
tools\text_count_words\text-count.bat --text "hola mundo"
```

### Dependencies

- Python 3.
- Python standard library only.

### Safety

- Read-only.
- Does not delete, modify, or overwrite files.
- Does not access the network.

### AI Notes

Use this tool when an AI agent needs deterministic local counts for plain text. Do not use it for binary files, PDFs, DOCX files, or semantic text analysis.

### Related Tools

- None yet.

## img-web

### Summary

Optimizes local images for web by resizing oversized images and exporting compressed `.webp` or `.jpg` copies with the `_web` suffix.

### Use Cases

- Prepare photos for websites.
- Reduce image weight before publishing.
- Batch-optimize a folder of `.jpg`, `.jpeg`, `.png`, and `.webp` files.

### Usage

```bat
tools\img_web_optimize\img-web.bat foto.jpg
tools\img_web_optimize\img-web.bat foto.png --quality 70
tools\img_web_optimize\img-web.bat foto.jpg --max-size 1600
tools\img_web_optimize\img-web.bat foto.jpg --format jpg
tools\img_web_optimize\img-web.bat --all
tools\img_web_optimize\img-web.bat --all "C:\imagenes" --output "C:\imagenes_web"
tools\img_web_optimize\img-web.bat --all --dry-run
```

### Parameters

| Parameter | Description |
|---|---|
| `imagen.jpg` | Input image for single-file mode. |
| `--all [folder]` | Process all supported images in a folder. Defaults to the current folder. |
| `--output FOLDER` | Write optimized files to another folder. |
| `--format webp|jpg` | Output format. Default: `webp`. |
| `--quality NUMBER` | Compression quality from `1` to `100`. Default: `75`. |
| `--max-size NUMBER` | Maximum longest side in pixels. Default: `1200`. |
| `--force` | Overwrite existing output files. |
| `--dry-run` | Preview actions without writing files. |
| `--json` | Print valid JSON. |
| `--help` | Show command help. |

### Inputs

- `.jpg`
- `.jpeg`
- `.png`
- `.webp`

### Outputs

Creates optimized image files with the `_web` suffix, for example `foto_web.webp`.

With `--json`, output includes paths, original and final dimensions, byte sizes, and compression ratio.

### Dependencies

- Python 3.
- Pillow: `pip install pillow`.

### Safety

- Does not delete original images.
- Does not modify original images.
- Does not overwrite outputs unless `--force` is used.
- Creates an alternative output name when the default output exists.
- Supports `--dry-run`.
- Does not access the network.
- Does not use AI.

### AI Notes

Use this tool when an AI agent needs deterministic local image optimization for web. Do not use it to generate images, inspect image semantics, or download remote assets.

### Related Tools

- `img_2web` exists as an earlier placeholder but is incomplete.

## video-2web

### Summary

Compresses local videos for web using FFmpeg. It creates `.mp4` copies with H.264 video, AAC audio, `faststart`, and the `_web` suffix by default.

### Use Cases

- Reduce video file size before publishing on a website.
- Convert common local video formats to web-ready MP4.
- Batch-optimize videos in a folder without modifying originals.

### Usage

```bat
tools\video_2web\video-2web.bat video.mp4
tools\video_2web\video-2web.bat video.mp4 --quality 26
tools\video_2web\video-2web.bat video.mp4 --max-width 1280
tools\video_2web\video-2web.bat video.mp4 --output salida_web.mp4
tools\video_2web\video-2web.bat --all
tools\video_2web\video-2web.bat --all "C:\Videos" --dry-run
```

### Parameters

| Parameter | Description |
|---|---|
| `video.mp4` | Input video for single-file mode. |
| `--quality NUMBER` | FFmpeg CRF quality value. Default: `28`. |
| `--max-width NUMBER` | Downscale only if the video is wider than this value. |
| `--output RUTA` | Output `.mp4` path in single mode, or existing folder in `--all` mode. |
| `--force` | Overwrite existing output files. |
| `--all [folder]` | Process all supported videos in a folder. |
| `--recursive` | Include subfolders when using `--all`. |
| `--dry-run` | Preview FFmpeg commands without writing files. |
| `--help` | Show command help. |
| `--version` | Show tool version. |

### Inputs

- `.mp4`
- `.mov`
- `.mkv`
- `.avi`
- `.webm`

### Outputs

Creates optimized `.mp4` video files with the `_web` suffix, for example `video_web.mp4`.

### Dependencies

- FFmpeg available in PATH.

### Safety

- Does not delete original videos.
- Does not modify original videos.
- Does not overwrite outputs unless `--force` is used.
- Supports `--dry-run`.
- Does not access the network.
- Does not use AI.

### AI Notes

Use this tool when an AI agent needs deterministic local video compression for web delivery. Use `--dry-run` before batch operations when the target folder may contain many files.

### Related Tools

- `img-web.bat`

## video-cortar

### Summary

Cuts local videos to a requested duration using FFmpeg stream copy, without re-encoding.

### Use Cases

- Create an 18-minute preview or excerpt from a local video.
- Cut a video quickly while preserving original stream quality.
- Produce a trimmed MP4 copy without modifying the source file.

### Usage

```bat
tools\video_trim\video-cortar.bat video.mp4
tools\video_trim\video-cortar.bat video.mp4 --duration 00:05:00
tools\video_trim\video-cortar.bat video.mp4 --output video_corte.mp4
tools\video_trim\video-cortar.bat "C:\Videos\mi video.mp4" --output "C:\Videos\mi video_18min.mp4"
```

### Parameters

| Parameter | Description |
|---|---|
| `video.mp4` | Input video for single-file mode. |
| `--duration HH:MM:SS` | Trim duration. Default: `00:18:00`. |
| `--output RUTA` | Output `.mp4` path. |
| `--force` | Overwrite the output file if it already exists. |
| `--help`, `-h`, `/?` | Show command help. |
| `--version` | Show tool version. |

### Inputs

- `.mp4`
- `.mov`
- `.mkv`
- `.avi`
- `.webm`

### Outputs

Creates a trimmed `.mp4` copy with a duration suffix, for example `video_18min.mp4`.

### Dependencies

- FFmpeg available in PATH.

### Safety

- Does not delete original videos.
- Does not modify original videos.
- Does not overwrite outputs unless `--force` is used.
- Refuses to use the input file itself as output.
- Does not access the network.
- Does not use AI.

### Limitations

Because it uses `-c copy`, trimming is fast and does not reduce quality, but cuts may not be exact to the frame when timestamps do not align with keyframes.

### AI Notes

Use this tool when an AI agent needs deterministic local video trimming without re-encoding. Do not use it for downloading media, AI processing, subtitles, or full video editing workflows.

### Related Tools

- `video-2web.bat`
