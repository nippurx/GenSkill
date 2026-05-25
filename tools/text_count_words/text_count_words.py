#!/usr/bin/env python3
"""
Tool: text-count
ID: text_count_words
Version: 1.0.0
Type: python
Status: experimental
Category: text

Description:
    Counts words, characters, and lines from a text file or from text passed
    through the command line.

Usage:
    python text_count_words.py archivo.txt
    python text_count_words.py archivo.txt --json
    python text_count_words.py --text "hola mundo"
    python text_count_words.py --all examples

Inputs:
    A .txt file, a folder of .txt files with --all, or text passed with --text.

Outputs:
    Human-readable counts or machine-readable JSON printed to stdout.

Parameters:
    --help       Show help.
    --text       Count text provided as an argument.
    --all        Count all .txt files in a folder.
    --recursive  Include subfolders when using --all.
    --encoding   Text encoding used for file input. Default: utf-8.
    --json       Output machine-readable JSON.

Dependencies:
    Python standard library only.

Safety:
    Read-only. Does not delete, modify, or overwrite files.
    Does not access the network.

AI Notes:
    This tool follows the GenSkill Tool Protocol.
    It is designed for reuse by humans, AI agents, and future GenSkill runners.

Machine-readable intent:
    category: text
    action: count_words_characters_lines
    batch_supported: true
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


TOOL_ID = "text_count_words"
TOOL_NAME = "text-count"
VERSION = "1.0.0"
SUPPORTED_EXTENSIONS = {".txt"}


class ToolError(Exception):
    def __init__(self, code: str, message: str, suggestion: str | None = None) -> None:
        super().__init__(message)
        self.code = code
        self.message = message
        self.suggestion = suggestion

    def as_dict(self) -> dict[str, str]:
        error = {"code": self.code, "message": self.message}
        if self.suggestion:
            error["suggestion"] = self.suggestion
        return error


def count_text(text: str) -> dict[str, int]:
    """Count non-whitespace words, Unicode characters, and logical lines."""
    if not text:
        line_count = 0
    else:
        line_count = text.count("\n") + (0 if text.endswith("\n") else 1)

    return {
        "words": len(re.findall(r"\S+", text)),
        "characters": len(text),
        "lines": line_count,
    }


def read_text_file(path: Path, encoding: str) -> str:
    if not path.exists():
        raise ToolError(
            "INPUT_NOT_FOUND",
            f"Input file not found: {path}",
            "Check the file path or pass text with --text.",
        )
    if not path.is_file():
        raise ToolError(
            "INVALID_INPUT",
            f"Input path is not a file: {path}",
            "Use a .txt file, --text, or --all for folders.",
        )
    if path.suffix.lower() not in SUPPORTED_EXTENSIONS:
        raise ToolError(
            "UNSUPPORTED_FORMAT",
            f"Unsupported file extension: {path.suffix or '(none)'}",
            "Use a .txt file.",
        )

    try:
        return path.read_text(encoding=encoding)
    except UnicodeDecodeError as exc:
        raise ToolError(
            "ENCODING_ERROR",
            f"Could not read file with encoding {encoding}: {path}",
            "Try --encoding latin-1 or another encoding used by the file.",
        ) from exc
    except OSError as exc:
        raise ToolError("READ_ERROR", f"Could not read file: {path}") from exc


def count_file(path: Path, encoding: str) -> dict[str, Any]:
    text = read_text_file(path, encoding)
    counts = count_text(text)
    return {
        "input": str(path),
        "source": "file",
        **counts,
    }


def count_folder(folder: Path, recursive: bool, encoding: str) -> dict[str, Any]:
    if not folder.exists():
        raise ToolError(
            "INPUT_NOT_FOUND",
            f"Input folder not found: {folder}",
            "Check the folder path.",
        )
    if not folder.is_dir():
        raise ToolError(
            "INVALID_INPUT",
            f"Input path is not a folder: {folder}",
            "Use --all with a folder path.",
        )

    pattern = "**/*.txt" if recursive else "*.txt"
    files = sorted(path for path in folder.glob(pattern) if path.is_file())
    if not files:
        raise ToolError(
            "NO_FILES_FOUND",
            f"No .txt files found in: {folder}",
            "Use --recursive to include subfolders.",
        )

    items: list[dict[str, Any]] = []
    totals = {"words": 0, "characters": 0, "lines": 0}
    errors: list[dict[str, str]] = []

    for path in files:
        try:
            item = count_file(path, encoding)
            items.append(item)
            for key in totals:
                totals[key] += item[key]
        except ToolError as exc:
            errors.append({"input": str(path), **exc.as_dict()})

    return {
        "mode": "batch",
        "input_folder": str(folder),
        "recursive": recursive,
        "processed": len(items),
        "errors": errors,
        "totals": totals,
        "files": items,
    }


def build_result(success: bool, output: Any = None, error: Any = None) -> dict[str, Any]:
    return {
        "success": success,
        "tool_id": TOOL_ID,
        "tool_name": TOOL_NAME,
        "version": VERSION,
        "output": output,
        "error": error,
        "warnings": [],
    }


def run_tool(args: argparse.Namespace) -> dict[str, Any]:
    try:
        if args.text is not None:
            if args.input_path or args.all_folder is not None:
                raise ToolError(
                    "INVALID_ARGUMENTS",
                    "--text cannot be combined with file input or --all.",
                )
            return build_result(
                True,
                {
                    "source": "text",
                    **count_text(args.text),
                },
            )

        if args.all_folder is not None:
            folder = Path(args.all_folder)
            return build_result(
                True,
                count_folder(folder, recursive=args.recursive, encoding=args.encoding),
            )

        if not args.input_path:
            raise ToolError(
                "MISSING_INPUT",
                "Missing input file or --text value.",
                "Run text-count.bat --help for usage examples.",
            )

        return build_result(True, count_file(Path(args.input_path), args.encoding))
    except ToolError as exc:
        return build_result(False, error=exc.as_dict())


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="text-count.bat",
        description="Count words, characters, and lines from .txt files or text.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "Examples:\n"
            "  text-count.bat archivo.txt\n"
            "  text-count.bat archivo.txt --json\n"
            "  text-count.bat --text \"hola mundo\"\n"
            "  text-count.bat --all examples\n"
        ),
    )
    parser.add_argument("input_path", nargs="?", help="Input .txt file.")
    parser.add_argument("--text", help="Text to count.")
    parser.add_argument(
        "--all",
        dest="all_folder",
        nargs="?",
        const=".",
        help="Count all .txt files in a folder. Defaults to current folder.",
    )
    parser.add_argument(
        "--recursive",
        action="store_true",
        help="Include subfolders when using --all.",
    )
    parser.add_argument(
        "--encoding",
        default="utf-8",
        help="Encoding for file input. Default: utf-8.",
    )
    parser.add_argument("--json", action="store_true", help="Output valid JSON.")
    parser.add_argument("--version", action="store_true", help="Show version.")
    return parser.parse_args(argv)


def print_human_result(result: dict[str, Any]) -> None:
    if not result["success"]:
        error = result["error"]
        print(f"ERROR [{error['code']}]: {error['message']}", file=sys.stderr)
        if "suggestion" in error:
            print(f"Suggestion: {error['suggestion']}", file=sys.stderr)
        return

    output = result["output"]
    if output.get("mode") == "batch":
        print(f"Tool: {TOOL_NAME} {VERSION}")
        print(f"Input folder: {output['input_folder']}")
        print(f"Recursive: {output['recursive']}")
        print(f"Processed files: {output['processed']}")
        print(f"Errors: {len(output['errors'])}")
        print("Totals:")
        print(f"  Words: {output['totals']['words']}")
        print(f"  Characters: {output['totals']['characters']}")
        print(f"  Lines: {output['totals']['lines']}")
        return

    print(f"Tool: {TOOL_NAME} {VERSION}")
    print(f"Source: {output['source']}")
    if "input" in output:
        print(f"Input: {output['input']}")
    print(f"Words: {output['words']}")
    print(f"Characters: {output['characters']}")
    print(f"Lines: {output['lines']}")


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    if args.version:
        print(f"{TOOL_NAME} {VERSION}")
        return 0

    result = run_tool(args)
    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=2))
    else:
        print_human_result(result)

    return 0 if result["success"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
