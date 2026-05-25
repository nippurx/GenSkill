from __future__ import annotations

import argparse
import json
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable

TOOL_ID = "img_web_optimize"
VERSION = "1.0.0"
SUPPORTED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp"}


@dataclass
class OptimizeResult:
    success: bool
    tool_id: str
    input_path: str
    output_path: str
    original_width: int
    original_height: int
    final_width: int
    final_height: int
    original_size_bytes: int
    final_size_bytes: int
    compression_ratio: float
    dry_run: bool = False


class ToolError(Exception):
    pass


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="img-web.bat",
        description="Optimize local images for web without modifying originals.",
    )
    parser.add_argument("input", nargs="?", help="Image file, or folder when used with --all.")
    parser.add_argument("--all", action="store_true", help="Process all supported images in a folder. Defaults to current folder.")
    parser.add_argument("--output", help="Output folder. Defaults to each image folder.")
    parser.add_argument("--format", choices=["webp", "jpg"], default="webp", help="Output format. Default: webp.")
    parser.add_argument("--quality", type=int, default=75, help="Compression quality from 1 to 100. Default: 75.")
    parser.add_argument("--max-size", type=int, default=1200, help="Maximum longest side in pixels. Default: 1200.")
    parser.add_argument("--force", action="store_true", help="Overwrite output files when they already exist.")
    parser.add_argument("--dry-run", action="store_true", help="Preview actions without writing files. Useful with --all.")
    parser.add_argument("--json", action="store_true", help="Print valid JSON.")
    parser.add_argument("--version", action="store_true", help="Show version.")
    args = parser.parse_args(argv)

    if args.version:
        print(f"{TOOL_ID} {VERSION}")
        raise SystemExit(0)

    if not 1 <= args.quality <= 100:
        raise ToolError("--quality must be between 1 and 100.")
    if args.max_size < 1:
        raise ToolError("--max-size must be greater than 0.")
    if args.output and not args.all and not Path(args.output).suffix:
        # For single-file mode, --output is intentionally folder-only to keep
        # the output naming rule stable: original_name_web.ext.
        pass
    return args


def require_pillow():
    try:
        from PIL import Image, ImageOps
    except ImportError as exc:
        raise ToolError("Missing dependency: Pillow. Install it with: pip install pillow") from exc
    return Image, ImageOps


def iter_images(folder: Path) -> Iterable[Path]:
    for path in sorted(folder.iterdir()):
        if path.is_file() and path.suffix.lower() in SUPPORTED_EXTENSIONS:
            yield path


def output_path_for(input_path: Path, output_dir: Path | None, output_format: str, force: bool) -> Path:
    target_dir = output_dir if output_dir is not None else input_path.parent
    extension = ".jpg" if output_format == "jpg" else ".webp"
    candidate = target_dir / f"{input_path.stem}_web{extension}"
    if force or not candidate.exists():
        return candidate

    counter = 2
    while True:
        alternative = target_dir / f"{input_path.stem}_web_{counter}{extension}"
        if not alternative.exists():
            return alternative
        counter += 1


def resized_dimensions(width: int, height: int, max_size: int) -> tuple[int, int]:
    longest = max(width, height)
    if longest <= max_size:
        return width, height
    scale = max_size / longest
    return max(1, round(width * scale)), max(1, round(height * scale))


def optimize_image(input_path: Path, args: argparse.Namespace, output_dir: Path | None) -> OptimizeResult:
    Image, ImageOps = require_pillow()

    if input_path.suffix.lower() not in SUPPORTED_EXTENSIONS:
        raise ToolError(f"Unsupported image extension: {input_path.suffix}. Supported: .jpg, .jpeg, .png, .webp")
    if not input_path.exists() or not input_path.is_file():
        raise ToolError(f"Input image not found: {input_path}")

    original_size = input_path.stat().st_size
    output_path = output_path_for(input_path, output_dir, args.format, args.force)

    with Image.open(input_path) as image:
        image = ImageOps.exif_transpose(image)
        original_width, original_height = image.size
        final_width, final_height = resized_dimensions(original_width, original_height, args.max_size)

        if args.dry_run:
            return OptimizeResult(
                success=True,
                tool_id=TOOL_ID,
                input_path=str(input_path),
                output_path=str(output_path),
                original_width=original_width,
                original_height=original_height,
                final_width=final_width,
                final_height=final_height,
                original_size_bytes=original_size,
                final_size_bytes=0,
                compression_ratio=0.0,
                dry_run=True,
            )

        output_path.parent.mkdir(parents=True, exist_ok=True)
        if output_path.exists() and not args.force:
            raise ToolError(f"Output already exists: {output_path}. Use --force to overwrite.")

        if (final_width, final_height) != image.size:
            image = image.resize((final_width, final_height), Image.Resampling.LANCZOS)

        save_kwargs = {"quality": args.quality, "optimize": True}
        if args.format == "jpg":
            if image.mode in {"RGBA", "LA", "P"}:
                background = Image.new("RGB", image.size, (255, 255, 255))
                if image.mode == "P":
                    image = image.convert("RGBA")
                background.paste(image, mask=image.getchannel("A") if "A" in image.getbands() else None)
                image = background
            else:
                image = image.convert("RGB")
            image.save(output_path, "JPEG", progressive=True, **save_kwargs)
        else:
            image.save(output_path, "WEBP", method=6, **save_kwargs)

    final_size = output_path.stat().st_size
    compression_ratio = round(1 - (final_size / original_size), 4) if original_size else 0.0
    return OptimizeResult(
        success=True,
        tool_id=TOOL_ID,
        input_path=str(input_path),
        output_path=str(output_path),
        original_width=original_width,
        original_height=original_height,
        final_width=final_width,
        final_height=final_height,
        original_size_bytes=original_size,
        final_size_bytes=final_size,
        compression_ratio=compression_ratio,
    )


def print_human(result: OptimizeResult) -> None:
    if result.dry_run:
        print(f"DRY-RUN: {Path(result.output_path).name} se crearia")
    else:
        print(f"OK: {Path(result.output_path).name} creada")
    print(f"Tamano original: {result.original_width}x{result.original_height}")
    print(f"Tamano final: {result.final_width}x{result.final_height}")
    print(f"Peso original: {result.original_size_bytes} bytes")
    print(f"Peso final: {result.final_size_bytes} bytes")


def run(argv: list[str]) -> int:
    try:
        args = parse_args(argv)
        output_dir = Path(args.output).expanduser() if args.output else None

        if args.all:
            folder = Path(args.input).expanduser() if args.input else Path.cwd()
            if not folder.exists() or not folder.is_dir():
                raise ToolError(f"Folder not found: {folder}")
            images = list(iter_images(folder))
            if not images:
                raise ToolError(f"No supported images found in: {folder}")
            results = [optimize_image(path, args, output_dir) for path in images]
            if args.json:
                print(json.dumps([asdict(result) for result in results], ensure_ascii=False, indent=2))
            else:
                for index, result in enumerate(results):
                    if index:
                        print("")
                    print_human(result)
                action = "simuladas" if args.dry_run else "creadas"
                print(f"\nResumen: {len(results)} imagen(es) {action}.")
            return 0

        if not args.input:
            raise ToolError("Missing input image. Use --help for usage.")
        result = optimize_image(Path(args.input).expanduser(), args, output_dir)
        if args.json:
            print(json.dumps(asdict(result), ensure_ascii=False, indent=2))
        else:
            print_human(result)
        return 0
    except ToolError as exc:
        if "--json" in argv:
            print(json.dumps({"success": False, "tool_id": TOOL_ID, "error": str(exc)}, ensure_ascii=False))
        else:
            print(f"ERROR: {exc}", file=sys.stderr)
        return 2


def main() -> None:
    raise SystemExit(run(sys.argv[1:]))


if __name__ == "__main__":
    main()
