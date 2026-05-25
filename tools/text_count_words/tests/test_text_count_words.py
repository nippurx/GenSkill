from pathlib import Path

import pytest

from tools.text_count_words.text_count_words import count_file, count_folder, count_text, run_tool


def test_count_text_counts_words_characters_and_lines():
    text = "hola mundo\nsegunda linea\n"

    result = count_text(text)

    assert result == {
        "words": 4,
        "characters": 25,
        "lines": 2,
    }


def test_count_file_reads_txt_file(tmp_path: Path):
    input_file = tmp_path / "input.txt"
    input_file.write_text("uno dos\ntres", encoding="utf-8")

    result = count_file(input_file, "utf-8")

    assert result["source"] == "file"
    assert result["words"] == 3
    assert result["characters"] == 12
    assert result["lines"] == 2


def test_count_folder_counts_txt_files_only(tmp_path: Path):
    (tmp_path / "a.txt").write_text("uno dos", encoding="utf-8")
    (tmp_path / "b.txt").write_text("tres", encoding="utf-8")
    (tmp_path / "skip.md").write_text("no contar", encoding="utf-8")

    result = count_folder(tmp_path, recursive=False, encoding="utf-8")

    assert result["processed"] == 2
    assert result["totals"]["words"] == 3
    assert result["totals"]["lines"] == 2


def test_run_tool_rejects_missing_input():
    class Args:
        text = None
        all_folder = None
        input_path = None
        recursive = False
        encoding = "utf-8"

    result = run_tool(Args())

    assert result["success"] is False
    assert result["error"]["code"] == "MISSING_INPUT"


def test_count_file_rejects_unsupported_extension(tmp_path: Path):
    input_file = tmp_path / "input.md"
    input_file.write_text("uno dos", encoding="utf-8")

    with pytest.raises(Exception) as exc_info:
        count_file(input_file, "utf-8")

    assert getattr(exc_info.value, "code") == "UNSUPPORTED_FORMAT"
