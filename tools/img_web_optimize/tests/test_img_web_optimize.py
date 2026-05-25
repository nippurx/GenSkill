from pathlib import Path
import sys

import pytest

PIL = pytest.importorskip("PIL")
from PIL import Image

TOOL_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(TOOL_DIR))

import img_web_optimize


def test_resized_dimensions_do_not_upscale():
    assert img_web_optimize.resized_dimensions(800, 600, 1200) == (800, 600)


def test_resized_dimensions_scale_longest_side():
    assert img_web_optimize.resized_dimensions(2400, 1600, 1200) == (1200, 800)


def test_optimize_single_image_creates_webp_copy(tmp_path):
    source = tmp_path / "foto.jpg"
    Image.new("RGB", (1600, 900), (30, 120, 200)).save(source)

    exit_code = img_web_optimize.run([str(source), "--json"])

    output = tmp_path / "foto_web.webp"
    assert exit_code == 0
    assert source.exists()
    assert output.exists()
    with Image.open(output) as image:
        assert image.size == (1200, 675)


def test_existing_output_gets_alternative_name(tmp_path):
    source = tmp_path / "foto.jpg"
    Image.new("RGB", (800, 600), (30, 120, 200)).save(source)
    (tmp_path / "foto_web.webp").write_bytes(b"existing")

    exit_code = img_web_optimize.run([str(source)])

    assert exit_code == 0
    assert (tmp_path / "foto_web_2.webp").exists()


def test_all_dry_run_does_not_create_outputs(tmp_path):
    source = tmp_path / "foto.png"
    Image.new("RGB", (1600, 900), (30, 120, 200)).save(source)

    exit_code = img_web_optimize.run(["--all", str(tmp_path), "--dry-run"])

    assert exit_code == 0
    assert not (tmp_path / "foto_web.webp").exists()
