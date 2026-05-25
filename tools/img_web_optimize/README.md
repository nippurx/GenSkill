# img-web

`img-web.bat` optimizes local images for web. It creates compressed copies with the `_web` suffix, resizes images whose longest side is too large, and never modifies the original file.

## Defaults

| Setting | Value |
|---|---|
| Max size | `1200` px on the longest side |
| Quality | `75` |
| Format | `webp` |
| Output folder | Same folder as input |
| Output suffix | `_web` |

## Usage

```bat
tools\img_web_optimize\img-web.bat foto.jpg
tools\img_web_optimize\img-web.bat foto.png --quality 70
tools\img_web_optimize\img-web.bat foto.jpg --max-size 1600
tools\img_web_optimize\img-web.bat foto.jpg --format jpg
tools\img_web_optimize\img-web.bat --all
tools\img_web_optimize\img-web.bat --all "C:\imagenes"
tools\img_web_optimize\img-web.bat --all "C:\imagenes" --output "C:\imagenes_web"
tools\img_web_optimize\img-web.bat --all --dry-run
tools\img_web_optimize\img-web.bat --help
```

## Parameters

| Parameter | Description |
|---|---|
| `imagen.jpg` | Input image for single-file mode. Supports `.jpg`, `.jpeg`, `.png`, `.webp`. |
| `--all [folder]` | Process all supported images in a folder. Defaults to the current folder. |
| `--output FOLDER` | Write optimized files to a specific output folder. |
| `--format webp|jpg` | Output format. Default: `webp`. |
| `--quality NUMBER` | Compression quality from `1` to `100`. Default: `75`. |
| `--max-size NUMBER` | Maximum longest side in pixels. Default: `1200`. |
| `--force` | Overwrite existing output files. Without this, a numbered alternative name is created. |
| `--dry-run` | Preview actions without writing files. Useful for folder mode. |
| `--json` | Print valid JSON for automation and AI agents. |
| `--help` | Show command help. |

## Output

For `foto.jpg`, the default output is:

```txt
foto_web.webp
```

If the output exists and `--force` is not used, the tool creates an alternative name:

```txt
foto_web_2.webp
```

## Human Output

```txt
OK: foto_web.webp creada
Tamano original: 2400x1600
Tamano final: 1200x800
Peso original: 1845000 bytes
Peso final: 142300 bytes
```

## JSON Output

```bat
tools\img_web_optimize\img-web.bat foto.jpg --json
```

Returns:

```json
{
  "success": true,
  "tool_id": "img_web_optimize",
  "input_path": "foto.jpg",
  "output_path": "foto_web.webp",
  "original_width": 2400,
  "original_height": 1600,
  "final_width": 1200,
  "final_height": 800,
  "original_size_bytes": 1845000,
  "final_size_bytes": 142300,
  "compression_ratio": 0.9229,
  "dry_run": false
}
```

## Dependencies

- Python 3.
- Pillow.

Install Pillow with:

```bat
pip install pillow
```

## Safety

- Does not delete original images.
- Does not modify original images.
- Does not overwrite outputs unless `--force` is used.
- Creates `_web` copies by default.
- Supports `--dry-run`.
- Does not access the network.
- Does not use AI.
- Does not use hardcoded absolute paths.

## Test

From the project root:

```bat
python -m pytest tools\img_web_optimize\tests\test_img_web_optimize.py
```

Manual smoke test:

```bat
tools\img_web_optimize\img-web.bat tools\img_web_optimize\examples\sample.jpg --dry-run
```

If you need a sample image, create one locally with Pillow:

```bat
python -c "from PIL import Image; Image.new('RGB',(1600,900),(30,120,200)).save('tools\\img_web_optimize\\examples\\sample.jpg')"
```

## AI Usage Notes

Use this tool when an AI agent needs deterministic local image optimization for web delivery. Do not use it for image generation, semantic image analysis, or remote image downloads.
