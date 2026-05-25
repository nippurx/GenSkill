# text-count

`text-count.bat` counts words, characters, and lines from a `.txt` file, a folder of `.txt` files, or text passed directly by parameter.

## Usage

```bat
text-count.bat archivo.txt
text-count.bat archivo.txt --json
text-count.bat --text "hola mundo"
text-count.bat --all examples
text-count.bat --all examples --recursive
```

## Parameters

| Parameter | Description |
|---|---|
| `archivo.txt` | Input text file. Must use `.txt`. |
| `--text "texto"` | Count text passed directly in the command. |
| `--all [folder]` | Count every `.txt` file in a folder. Defaults to the current folder. |
| `--recursive` | Include subfolders when using `--all`. |
| `--encoding NAME` | File encoding. Default: `utf-8`. |
| `--json` | Print valid JSON for automation and AI agents. |
| `--help` | Show command help. |
| `--version` | Show tool version. |

## Inputs

- `.txt` file.
- Direct text passed with `--text`.
- Folder containing `.txt` files when using `--all`.

## Outputs

The tool prints counts to stdout:

- words
- characters
- lines

With `--json`, output is structured JSON.

## Safety

- Read-only.
- Does not delete files.
- Does not modify files.
- Does not overwrite files.
- Does not access the network.
- Uses Python standard library only.

## Examples

```bat
text-count.bat examples\input.txt
```

```bat
text-count.bat examples\input.txt --json
```

```bat
text-count.bat --text "hola mundo"
```

## Test

From the project root:

```bat
text-count.bat examples\input.txt
```

Expected counts for the included example:

```txt
Words: 11
Characters: 73
Lines: 3
```

Automated test:

```bat
python -m pytest tools\text_count_words\tests\test_text_count_words.py
```

## AI Usage Notes

Use this tool when an agent needs a fast local count of words, characters, and lines from text input or `.txt` files.

Do not use this tool for binary files, document formats such as `.docx` or `.pdf`, or tasks that require semantic analysis.
