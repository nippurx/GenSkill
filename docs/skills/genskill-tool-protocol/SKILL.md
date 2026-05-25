---
name: genskill-tool-protocol
description: Use this skill whenever a programmer, AI agent, coding assistant, automation system, or user needs to create a reusable local tool, script, .bat, .py, CLI utility, or GenSkill-compatible automation. This skill defines the GenSkill Tool Protocol: every tool must be documented, parameterized, safe by default, usable by humans, readable by AI, batch-capable when possible, and prepared for future integration into GenSkill.
---

# GenSkill Tool Protocol

## Purpose

The GenSkill Tool Protocol is a standard for creating reusable tools from practical automation needs.

Use this skill whenever the user asks for:

- a `.bat` file
- a `.py` script
- a local utility
- a command-line tool
- an automation script
- a reusable workflow helper
- a file-processing tool
- an image/video/audio/PDF/text/data conversion script
- a tool that may later become part of GenSkill
- a script that should be easy for humans and AI agents to understand, run, document, index, test, and reuse

The goal is not to create disposable scripts.

The goal is to create **reusable tools**.

A GenSkill tool is not just code.

A GenSkill tool is:

- executable
- documented
- parameterized
- safe by default
- usable by humans
- readable by AI
- batch-capable when possible
- testable
- indexable
- machine-describable through `tool.json`
- ready to become part of a future GenSkill registry

Core principle:

```txt
A tool that is not documented, parameterized, and registered does not truly exist for GenSkill.
````

GenSkill exists to prevent AI agents from solving the same task from scratch again and again.

Instead:

```txt
Problem appears
↓
A reusable tool is created
↓
The tool is documented
↓
The tool is indexed
↓
The tool can be reused by humans and AI
↓
Future agents spend fewer tokens and less time
```

GenSkill converts disposable automation into permanent capability.

---

# Conceptual Foundation

GenSkill follows this principle:

```txt
AI should not repeatedly generate code for the same task.
AI should create or use reusable tools.
```

A normal agent often works like this:

```txt
Think → write code → execute → forget
```

GenSkill should work like this:

```txt
Think → search existing tool → execute → log → improve → reuse
```

And when no tool exists:

```txt
Think → create tool → document it → test it → register it → reuse it
```

A GenSkill tool is a reusable unit of capability.

In Claude Skills, the center is usually the instruction file, and scripts are optional.

In GenSkill, the center is the executable tool, and instructions/metadata exist so humans and AI systems can use it correctly.

```txt
Claude-style skill:
Instruction → optionally uses scripts

GenSkill tool:
Executable tool → includes instructions, metadata, tests, examples, and safety rules
```

In short:

```txt
Claude Skills expand the mind of the model.
GenSkill tools expand the hands of the model.
```

---

# When To Use This Skill

Use this protocol whenever a user says something like:

* “Make me a bat file for this”
* “Create a script that does X”
* “I need a command like `tool.bat file.jpg`”
* “Create a reusable tool”
* “Make this work for one file and all files in a folder”
* “Standardize this script”
* “Create a GenSkill tool”
* “Make a Python utility”
* “Make this easy for future AI agents to use”
* “Create documentation and metadata for this script”
* “Create a tool.json”
* “Create an index of tools”
* “Create a protocol for tools”

Also use it when the user provides an existing script and asks to improve or standardize it.

---

# High-Level Output Requirement

When creating a tool under this protocol, produce as much of the following as appropriate:

```txt
tool-folder/
├── executable script
├── tool.json
├── README.md
├── examples/
├── tests/
└── optional helper files
```

For a full GenSkill-compatible tool, produce:

```txt
tools/
└── tool_id/
    ├── tool.json
    ├── README.md
    ├── examples/
    ├── tests/
    ├── scripts/
    │   └── optional helper scripts
    ├── tool-name.bat
    └── tool_name.py
```

If the tool is intended to become a full GenSkill skill later, it may also be adapted to:

```txt
skills/
└── skill_id/
    ├── skill.json
    ├── run.py
    ├── README.md
    ├── examples/
    └── tests/
```

---

# Core Rule

Every tool must exist in three forms:

## 1. Executable

The real `.bat`, `.py`, `.ps1`, `.sh`, or other script.

## 2. Documented

Human-readable documentation in:

```txt
README.md
TOOLS_ENCYCLOPEDIA.md
TOOLS_INDEX.md
```

## 3. Structured

Machine-readable metadata in:

```txt
tool.json
```

This allows:

* humans to understand it
* AI agents to select it
* runners to execute it
* future systems to index it
* GenSkill to import it
* tests to validate it
* documentation to be generated automatically

---

# Naming Standard

## Human-facing script names

For `.bat` files, use short, clear, lowercase names with hyphens.

Preferred patterns:

```txt
verb-object.bat
object-action.bat
object-2target.bat
```

Examples:

```txt
img-2web.bat
video-cortar.bat
pdf-2img.bat
txt-unir.bat
files-renombrar.bat
img-resize.bat
audio-2mp3.bat
video-2short.bat
folder-clean.bat
```

Avoid:

```txt
script.bat
test.bat
new.bat
convert.bat
hacer_cosas.bat
achicar_archivos_para_web_version_final.bat
```

Names must be:

* short
* clear
* predictable
* easy to type
* easy to infer
* easy for AI agents to discover

## Internal tool IDs

For internal IDs, use `snake_case`.

Examples:

```txt
img_2web
video_trim
pdf_to_images
merge_text_files
rename_files
compress_images
```

## Relationship between file name and ID

Example:

```txt
Human command:
img-2web.bat

Internal ID:
img_2web
```

This keeps Windows commands comfortable while preserving clean Python/JSON/API identifiers.

---

# Required Command Behavior

Every tool must support direct execution with parameters.

Bad:

```txt
The script has hardcoded paths.
```

Good:

```bat
img-2web.bat imagen.jpg
```

Better:

```bat
img-2web.bat imagen.jpg --width 1200 --quality 70
```

Every tool should work without editing the script.

The user should not need to open the script to change:

* input file
* output file
* folder
* quality
* size
* mode
* options

Everything configurable should be exposed as parameters when reasonable.

---

# Mandatory Single File and Batch Logic

Whenever a tool can process one file, it should also support processing many files.

Minimum supported modes:

```bat
tool-name.bat archivo.ext
tool-name.bat --all
tool-name.bat --all carpeta
```

Recommended extended modes:

```bat
tool-name.bat archivo.ext --output salida.ext
tool-name.bat --all carpeta --output carpeta_salida
tool-name.bat --all carpeta --recursive
tool-name.bat --all carpeta --dry-run
```

Batch support should be included unless the task is inherently single-item only.

If batch mode is not possible, explain why in:

* script help
* README.md
* tool.json

---

# Standard Parameters

Use industry-style long flags with `--`.

Every tool should support these when applicable:

```txt
--help
-h
/?
```

Displays help.

```txt
--all
```

Processes all compatible files in a folder.

```txt
--input
```

Defines input file or folder.

```txt
--output
```

Defines output file or folder.

```txt
--force
```

Allows overwriting existing files.

```txt
--dry-run
```

Shows what would happen without modifying files.

```txt
--recursive
```

Includes subfolders.

```txt
--verbose
```

Shows detailed output.

```txt
--quiet
```

Shows minimal output.

```txt
--json
```

Outputs machine-readable JSON.

```txt
--version
```

Shows tool version.

```txt
--yes
```

Confirms dangerous actions without interactive prompt. Only allowed for clearly documented destructive operations.

Avoid unusual flag names unless necessary.

Prefer:

```txt
--quality
--width
--height
--format
--prefix
--suffix
--pattern
--duration
--start
--end
```

Avoid:

```txt
-qwerty
-x1
-magic
-doit
```

---

# Required Help Output

Every script must provide help.

Supported triggers:

```bat
tool-name.bat --help
tool-name.bat -h
tool-name.bat /?
```

The help must include:

```txt
Tool name
Version
Description
Usage
Examples
Parameters
Inputs
Outputs
Supported file types
Dependencies
Safety notes
Batch behavior
Exit codes if relevant
```

Example help:

```txt
img-2web 1.0.0

Description:
  Optimizes images for web by converting them to WEBP.

Usage:
  img-2web.bat image.jpg
  img-2web.bat image.jpg --width 1200 --quality 70
  img-2web.bat --all
  img-2web.bat --all "C:\Images"
  img-2web.bat --all "C:\Images" --output "C:\ImagesWeb"

Options:
  --all             Process all compatible images in a folder.
  --input PATH      Input file or folder.
  --output PATH     Output file or folder.
  --width NUMBER    Max width. Default: 1200.
  --quality NUMBER  Output quality. Default: 70.
  --force           Allow overwrite.
  --dry-run         Show planned actions without writing files.
  --recursive       Include subfolders.
  --json            Output JSON result.
  --help            Show this help.

Supported formats:
  .jpg, .jpeg, .png, .webp

Dependencies:
  ffmpeg

Safety:
  Does not delete original files.
  Does not overwrite files unless --force is used.
```

---

# Standard Header For `.bat` Tools

Every `.bat` file must start with a standard header.

Template:

```bat
:: ============================================================
:: Tool: TOOL-NAME
:: ID: tool_id
:: Version: 1.0.0
:: Type: batch
:: Status: experimental
:: Category: category_name
:: Description:
::   Short explanation of what this tool does.
::
:: Usage:
::   tool-name.bat input.ext
::   tool-name.bat --all
::   tool-name.bat --all folder
::
:: Inputs:
::   Describe expected input files or folders.
::
:: Outputs:
::   Describe generated files or folders.
::
:: Parameters:
::   --help       Show help.
::   --all        Process all compatible files in a folder.
::   --output     Output file or folder.
::   --force      Allow overwrite.
::   --dry-run    Preview actions without changing files.
::
:: Dependencies:
::   List required external programs.
::
:: Safety:
::   Does not delete originals.
::   Does not overwrite unless --force is used.
::
:: AI Notes:
::   This tool is part of the GenSkill Tool Protocol.
::   It is designed to be understandable by humans and AI agents.
::
:: Author:
::   GenSkill
:: ============================================================
```

The header must be written in a way that a human can understand and an AI agent can parse.

---

# Standard Header For `.py` Tools

Every Python tool must start with a docstring header.

Template:

```python
"""
Tool: TOOL-NAME
ID: tool_id
Version: 1.0.0
Type: python
Status: experimental
Category: category_name

Description:
    Short explanation of what this tool does.

Usage:
    python tool_name.py input.ext
    python tool_name.py --all
    python tool_name.py --all folder
    python tool_name.py input.ext --output output.ext

Inputs:
    Describe expected input files, folders, strings, or data.

Outputs:
    Describe generated files, folders, JSON, text, or other results.

Parameters:
    --help       Show help.
    --all        Process all compatible files in a folder.
    --output     Output file or folder.
    --force      Allow overwrite.
    --dry-run    Preview actions without changing files.
    --json       Output machine-readable JSON.

Dependencies:
    List required Python packages or external programs.

Safety:
    Does not delete originals.
    Does not overwrite unless --force is used.

AI Notes:
    This tool follows the GenSkill Tool Protocol.
    It is designed for reuse by humans, AI agents, and future GenSkill runners.

Machine-readable intent:
    category: category_name
    action: action_name
    batch_supported: true
"""
```

---

# Safety Rules

Safety is mandatory.

A GenSkill tool must be safe by default.

## Forbidden by default

Do not:

* delete original files
* overwrite original files
* modify user files destructively
* recurse through large directory trees unexpectedly
* access the network unless required and declared
* execute shell commands unless required and declared
* hide errors
* silently skip important failures
* write outside the expected output folder
* modify system directories
* require admin privileges unless absolutely necessary

## Overwriting

Never overwrite by default.

If output exists, the tool must:

* create a new name automatically, or
* stop with a clear message, or
* require `--force`

Example:

```txt
Output already exists: foto_web.webp
Use --force to overwrite.
```

## Deleting

Deleting must never happen unless:

* the tool is specifically a delete/cleaning tool
* the behavior is clearly documented
* `--dry-run` is supported
* confirmation is required
* `--yes` is needed for non-interactive destructive execution

## Dangerous operations

For dangerous actions, require explicit confirmation.

Examples of dangerous actions:

* delete files
* overwrite many files
* move many files
* rename many files
* edit files in place
* remove folders
* network upload
* credential handling
* shell execution
* registry/system changes

## Dry-run

`--dry-run` is mandatory for tools that perform batch operations or destructive operations.

Example:

```bat
files-renombrar.bat --all --dry-run
```

Must output:

```txt
Dry run mode. No files were changed.

Would rename:
  img001.jpg -> book_cover_001.jpg
  img002.jpg -> book_cover_002.jpg

Total planned changes: 2
```

---

# Output Standard

Tools must produce clear human-readable output.

Example:

```txt
OK: Created foto_web.webp
Processed: 1
Errors: 0
```

If `--json` is used, output must be valid JSON.

Example:

```json
{
  "success": true,
  "tool_id": "img_2web",
  "input": "foto.jpg",
  "output": "foto_web.webp",
  "processed": 1,
  "errors": 0,
  "warnings": [],
  "duration_ms": 842
}
```

For batch mode:

```json
{
  "success": true,
  "tool_id": "img_2web",
  "mode": "batch",
  "input_folder": "C:\\imagenes",
  "output_folder": "C:\\imagenes",
  "processed": 48,
  "errors": 0,
  "files": [
    {
      "input": "foto1.jpg",
      "output": "foto1_web.webp",
      "success": true
    },
    {
      "input": "foto2.png",
      "output": "foto2_web.webp",
      "success": true
    }
  ],
  "duration_ms": 12402
}
```

If there is an error:

```json
{
  "success": false,
  "tool_id": "img_2web",
  "error": {
    "code": "MISSING_DEPENDENCY",
    "message": "ffmpeg was not found in PATH."
  }
}
```

---

# Error Handling Standard

Errors must be understandable.

Bad:

```txt
The system cannot find the file specified.
```

Better:

```txt
ERROR: Input file not found: foto.jpg
```

Best:

```json
{
  "success": false,
  "error": {
    "code": "INPUT_NOT_FOUND",
    "message": "Input file not found: foto.jpg",
    "suggestion": "Check the file path or drag the file onto the .bat file."
  }
}
```

Use clear error codes when possible:

```txt
INPUT_NOT_FOUND
OUTPUT_EXISTS
MISSING_DEPENDENCY
UNSUPPORTED_FORMAT
INVALID_PARAMETER
PERMISSION_DENIED
NO_FILES_FOUND
EXECUTION_FAILED
DRY_RUN_ONLY
```

---

# Dependency Standard

Every tool must declare dependencies in:

* script header
* README.md
* tool.json

If the dependency can be checked, the script should check it before executing.

Example for `.bat`:

```bat
where ffmpeg >nul 2>nul
if errorlevel 1 (
    echo ERROR: ffmpeg is not installed or not found in PATH.
    exit /b 2
)
```

Example for Python:

```python
import shutil

if shutil.which("ffmpeg") is None:
    print("ERROR: ffmpeg is not installed or not found in PATH.")
    sys.exit(2)
```

Python packages should be listed in:

```txt
requirements.txt
```

or inside `tool.json`:

```json
"dependencies": [
  {
    "name": "pillow",
    "type": "python",
    "required": true
  },
  {
    "name": "ffmpeg",
    "type": "system",
    "required": true
  }
]
```

---

# Required `tool.json`

Every GenSkill tool must include a `tool.json`.

This file is the structured identity of the tool.

It allows AI agents, runners, documentation generators, search systems, and future GenSkill apps to understand the tool automatically.

Minimum `tool.json` structure:

```json
{
  "id": "tool_id",
  "name": "tool-name",
  "version": "1.0.0",
  "type": "bat",
  "status": "experimental",
  "category": "image",
  "description": "Short description of what the tool does.",
  "entrypoint": "tool-name.bat",
  "usage": [
    "tool-name.bat input.ext",
    "tool-name.bat --all",
    "tool-name.bat --all folder"
  ],
  "inputs": {
    "input_path": {
      "type": "file_or_folder",
      "required": true,
      "description": "Input file or folder."
    }
  },
  "outputs": {
    "output_path": {
      "type": "file_or_folder",
      "description": "Generated output."
    }
  },
  "parameters": {
    "--all": {
      "type": "boolean",
      "description": "Process all compatible files in a folder."
    },
    "--output": {
      "type": "string",
      "description": "Output file or folder."
    },
    "--force": {
      "type": "boolean",
      "description": "Allow overwriting existing files."
    },
    "--dry-run": {
      "type": "boolean",
      "description": "Preview actions without modifying files."
    },
    "--json": {
      "type": "boolean",
      "description": "Output machine-readable JSON."
    }
  },
  "supported_extensions": [],
  "dependencies": [],
  "safety": {
    "can_read_files": true,
    "can_write_files": true,
    "can_delete_files": false,
    "can_overwrite_files": false,
    "requires_force_to_overwrite": true,
    "supports_dry_run": true,
    "can_access_network": false,
    "can_execute_shell": false
  },
  "batch": {
    "supports_single_file": true,
    "supports_folder": true,
    "supports_recursive": false
  },
  "tags": [],
  "examples": [
    {
      "description": "Basic usage",
      "command": "tool-name.bat input.ext"
    }
  ]
}
```

Recommended complete `tool.json`:

```json
{
  "id": "img_2web",
  "name": "img-2web",
  "version": "1.0.0",
  "type": "bat",
  "language": "batch",
  "status": "stable",
  "category": "image",
  "description": "Optimizes images for web by converting them to WEBP and reducing their size.",
  "entrypoint": "img-2web.bat",
  "created_by": "GenSkill",
  "license": "MIT",
  "usage": [
    "img-2web.bat imagen.jpg",
    "img-2web.bat --all",
    "img-2web.bat --all carpeta",
    "img-2web.bat imagen.jpg --width 1200 --quality 70"
  ],
  "inputs": {
    "input_path": {
      "type": "file_or_folder",
      "required": true,
      "description": "Image file or folder of images to process."
    }
  },
  "outputs": {
    "output_path": {
      "type": "file_or_folder",
      "description": "Generated WEBP image or folder of optimized images."
    }
  },
  "parameters": {
    "--all": {
      "type": "boolean",
      "default": false,
      "description": "Process all compatible files in a folder."
    },
    "--width": {
      "type": "integer",
      "default": 1200,
      "description": "Maximum output width."
    },
    "--quality": {
      "type": "integer",
      "default": 70,
      "description": "Output compression quality."
    },
    "--output": {
      "type": "string",
      "required": false,
      "description": "Output file or folder."
    },
    "--force": {
      "type": "boolean",
      "default": false,
      "description": "Allow overwriting existing files."
    },
    "--dry-run": {
      "type": "boolean",
      "default": false,
      "description": "Preview actions without modifying files."
    },
    "--recursive": {
      "type": "boolean",
      "default": false,
      "description": "Include subfolders."
    },
    "--json": {
      "type": "boolean",
      "default": false,
      "description": "Return machine-readable JSON output."
    }
  },
  "supported_extensions": [
    ".jpg",
    ".jpeg",
    ".png",
    ".webp"
  ],
  "dependencies": [
    {
      "name": "ffmpeg",
      "type": "system",
      "required": true,
      "check_command": "ffmpeg -version"
    }
  ],
  "safety": {
    "can_read_files": true,
    "can_write_files": true,
    "can_delete_files": false,
    "can_overwrite_files": false,
    "requires_force_to_overwrite": true,
    "supports_dry_run": true,
    "can_access_network": false,
    "can_execute_shell": true,
    "allowed_paths": [
      "./",
      "./workspace"
    ],
    "notes": "Original files are never deleted or modified."
  },
  "batch": {
    "supports_single_file": true,
    "supports_folder": true,
    "supports_recursive": true,
    "default_recursive": false
  },
  "ai_usage": {
    "use_when": [
      "The user wants to optimize an image for web.",
      "The user wants to reduce image size.",
      "The user wants to convert images to WEBP.",
      "The user asks for a command like achicar.bat imagen.jpg."
    ],
    "do_not_use_when": [
      "The user wants to generate a new image from text.",
      "The user wants advanced photo editing.",
      "The user wants to preserve original format exactly."
    ],
    "required_user_inputs": [
      "input image or folder"
    ],
    "optional_user_inputs": [
      "width",
      "quality",
      "output folder"
    ]
  },
  "tags": [
    "image",
    "webp",
    "optimize",
    "compress",
    "web",
    "ffmpeg",
    "batch"
  ],
  "examples": [
    {
      "description": "Optimize one image",
      "command": "img-2web.bat foto.jpg"
    },
    {
      "description": "Optimize all images in current folder",
      "command": "img-2web.bat --all"
    },
    {
      "description": "Optimize all images in a folder with custom quality",
      "command": "img-2web.bat --all \"C:\\imagenes\" --quality 75"
    },
    {
      "description": "Preview changes without writing files",
      "command": "img-2web.bat --all --dry-run"
    }
  ],
  "test": {
    "manual_test_command": "img-2web.bat examples/input.jpg",
    "expected_output": "examples/input_web.webp"
  },
  "changelog": [
    {
      "version": "1.0.0",
      "date": "YYYY-MM-DD",
      "changes": [
        "Initial version."
      ]
    }
  ]
}
```

---

# Required README.md

Every tool folder should include a `README.md`.

Template:

````md
# TOOL-NAME

Short description.

## What it does

Explain the practical problem this tool solves.

## Usage

```bash
tool-name.bat input.ext
tool-name.bat --all
tool-name.bat --all folder
````

## Examples

```bash
tool-name.bat foto.jpg
tool-name.bat --all "C:\Images"
tool-name.bat --all --dry-run
```

## Parameters

| Parameter   | Description                              | Default |
| ----------- | ---------------------------------------- | ------- |
| `--all`     | Process all compatible files in a folder | false   |
| `--output`  | Output file or folder                    | auto    |
| `--force`   | Allow overwrite                          | false   |
| `--dry-run` | Preview without modifying files          | false   |

## Inputs

Describe input files or folders.

## Outputs

Describe output files or folders.

## Dependencies

List dependencies and installation notes.

## Safety

* Does not delete original files.
* Does not overwrite unless `--force` is used.
* Supports `--dry-run` for batch operations.

## AI Usage Notes

Use this tool when:

* condition 1
* condition 2

Do not use this tool when:

* condition 1
* condition 2

## Tests

```bash
tool-name.bat examples/input.ext
```

Expected result:

```txt
examples/output.ext
```

````

---

# Global Documentation Files

A GenSkill tool collection must maintain two global Markdown documents.

## 1. Quick Tool Index

File:

```txt
TOOLS_INDEX.md
````

Purpose:

A fast human and AI-readable index.

Format:

```md
# GenSkill Tools Index

| Tool | Utility | Example |
|---|---|---|
| `img-2web.bat` | Optimize images for web | `img-2web.bat foto.jpg` |
| `video-cortar.bat` | Trim videos | `video-cortar.bat video.mp4 --duration 00:18:00` |
| `pdf-2img.bat` | Convert PDF pages to images | `pdf-2img.bat archivo.pdf` |
| `txt-unir.bat` | Merge TXT files | `txt-unir.bat --all` |
| `files-renombrar.bat` | Rename files by pattern | `files-renombrar.bat --all --prefix img_` |
```

This file answers:

```txt
Which tool should I use?
```

## 2. Tool Encyclopedia

File:

```txt
TOOLS_ENCYCLOPEDIA.md
```

Purpose:

A complete, well-documented Markdown encyclopedia of all tools.

Each tool entry should include:

````md
## tool-name

### Summary

What the tool does.

### Use Cases

- Use case 1
- Use case 2

### Usage

```bash
tool-name.bat input.ext
tool-name.bat --all
````

### Parameters

| Parameter | Description |
| --------- | ----------- |

### Inputs

List supported inputs.

### Outputs

Describe outputs.

### Examples

Provide practical examples.

### Dependencies

List dependencies.

### Safety

Explain safety behavior.

### AI Notes

Explain when an AI agent should use this tool.

### Related Tools

List related tools.

````

This file answers:

```txt
How does this tool work and how should it be used?
````

---

# Documentation Difference

Use these distinctions:

```txt
TOOLS_INDEX.md
= quick guide
= "Which tool do I use?"

TOOLS_ENCYCLOPEDIA.md
= full documentation
= "How does each tool work?"

tool.json
= structured metadata
= "How does an AI or system understand and execute this tool?"
```

---

# Recommended Project Structure

For a collection of tools:

```txt
GenSkill/
├── tools/
│   ├── img_2web/
│   │   ├── img-2web.bat
│   │   ├── img_2web.py
│   │   ├── tool.json
│   │   ├── README.md
│   │   ├── examples/
│   │   │   ├── input.jpg
│   │   │   └── output.webp
│   │   └── tests/
│   │
│   ├── video_trim/
│   ├── pdf_to_images/
│   └── merge_text_files/
│
├── docs/
│   ├── TOOLS_INDEX.md
│   ├── TOOLS_ENCYCLOPEDIA.md
│   ├── TOOL_CREATION_PROTOCOL.md
│   └── TOOL_JSON_SCHEMA.md
```

For future GenSkill skill integration:

```txt
GenSkill/
├── skills/
│   ├── image_resize/
│   │   ├── skill.json
│   │   ├── run.py
│   │   └── tests/
│
├── workflows/
├── core/
├── data/
└── docs/
```

---

# Tool Status Values

Every tool must have a status.

Allowed statuses:

```txt
draft
experimental
stable
deprecated
dangerous
blocked
```

Optional future statuses:

```txt
community_verified
official
```

Meaning:

```txt
draft
Tool idea or incomplete implementation.

experimental
Works but has limited testing.

stable
Tested and considered reliable.

deprecated
Should not be used for new work.

dangerous
Can perform destructive or risky actions. Requires extra caution.

blocked
Known unsafe or broken. Must not be used.

community_verified
Verified by users or maintainers.

official
Approved as part of the official GenSkill library.
```

---

# Risk Levels

Each tool should declare a risk level.

Allowed values:

```txt
low
medium
high
dangerous
```

Examples:

```txt
low:
Read-only tools, format converters, image resizing.

medium:
Batch rename, batch move, large writes.

high:
Delete, overwrite, network upload, shell automation.

dangerous:
System changes, credential handling, irreversible deletion.
```

---

# Permissions Standard

Each tool must declare permissions.

Use this model:

```json
"permissions": {
  "can_read_files": true,
  "can_write_files": true,
  "can_delete_files": false,
  "can_overwrite_files": false,
  "can_access_network": false,
  "can_execute_shell": false,
  "allowed_paths": [
    "./workspace"
  ]
}
```

The declared permissions must match actual behavior.

If a tool accesses network, shell, system commands, or destructive operations, it must be explicit.

---

# Testing Standard

Every tool should include at least a smoke test.

Minimum:

```txt
examples/input.ext
expected output description
manual test command
```

Preferred:

```txt
tests/
├── test_basic.bat
├── test_basic.py
└── expected/
```

Every README should include:

````md
## Test

```bash
tool-name.bat examples/input.ext
````

Expected:

```txt
examples/output.ext
```

````

If Python is used, prefer automated tests with `pytest`.

Example:

```python
def test_tool_creates_output(tmp_path):
    # arrange
    # act
    # assert
````

---

# Logs

When a tool becomes part of a GenSkill runner, each execution should be loggable.

Recommended log fields:

```json
{
  "run_id": "unique_run_id",
  "tool_id": "img_2web",
  "timestamp": "YYYY-MM-DDTHH:MM:SS",
  "success": true,
  "duration_ms": 842,
  "input_summary": "foto.jpg",
  "output_summary": "foto_web.webp",
  "errors": [],
  "warnings": []
}
```

Do not log sensitive data unless necessary.

If parameters may contain personal or sensitive content, store:

```txt
params_hash
```

instead of raw parameters.

---

# Batch Processing Rules

Batch tools must:

* show how many files will be processed
* skip unsupported files clearly
* report successes and errors
* avoid stopping the whole batch unless necessary
* support `--dry-run`
* avoid overwriting without `--force`
* handle empty folders gracefully

Example output:

```txt
Found 48 compatible files.
Processed: 46
Skipped: 2
Errors: 0
```

If no files are found:

```txt
No compatible files found in: C:\Images
Supported extensions: .jpg, .jpeg, .png, .webp
```

---

# File Naming Output Rules

Outputs should be predictable.

Examples:

```txt
input.jpg → input_web.webp
video.mp4 → video_trimmed.mp4
document.pdf → document_pages/
text.txt → text_clean.txt
```

If output exists and `--force` is not used, create a safe alternate name or stop.

Safe alternate naming:

```txt
foto_web.webp
foto_web_2.webp
foto_web_3.webp
```

But if the user expects strict output path, prefer stopping with:

```txt
Output already exists. Use --force to overwrite.
```

---

# Windows `.bat` Standards

For Windows `.bat` tools:

Start with:

```bat
@echo off
setlocal
```

Always quote paths:

```bat
"%INPUT%"
```

Use `%~1`, `%~n1`, `%~x1`, `%~dp1` correctly.

Handle empty input.

Check dependencies.

Provide help.

Use `exit /b` codes.

Recommended exit codes:

```txt
0 = success
1 = general error
2 = missing dependency
3 = invalid arguments
4 = input not found
5 = output exists
6 = no files found
```

Do not end with `pause` unless the tool is intended for double-click use.

If including `pause`, make it optional.

Preferred:

```bat
--pause
```

or:

```bat
if "%INTERACTIVE%"=="1" pause
```

A command-line tool should not force `pause` by default because it breaks automation.

---

# Python Standards

For Python tools:

Use:

```python
argparse
pathlib
json
sys
subprocess
```

Prefer `pathlib.Path` for file handling.

Use `if __name__ == "__main__":`.

Return structured results internally.

Support `--json`.

Avoid hardcoded absolute paths.

Separate logic from CLI parsing:

```python
def run_tool(...):
    ...

def main():
    ...

if __name__ == "__main__":
    main()
```

This makes the tool easier to test and import later.

---

# Script Creation Workflow

When asked to create a new tool, follow this process:

## Step 1 — Understand the task

Identify:

```txt
What problem is being solved?
Input type?
Output type?
Single file or batch?
Does it modify originals?
Dependencies?
Risk level?
Human usage?
AI usage?
```

## Step 2 — Choose tool type

Prefer:

```txt
.bat
```

when:

* user wants a Windows command
* task wraps an existing CLI like ffmpeg
* simple file processing
* easy drag-and-drop usage

Prefer:

```txt
.py
```

when:

* logic is complex
* parsing is required
* structured JSON output is needed
* cross-platform support matters
* tests are important
* future GenSkill runner integration is expected

Prefer both when:

* `.bat` is a Windows launcher
* `.py` contains real logic

Example:

```txt
img-2web.bat → calls python img_2web.py
```

## Step 3 — Name the tool

Create:

```txt
human command name
internal tool_id
folder name
```

Example:

```txt
Command: img-2web.bat
Tool ID: img_2web
Folder: tools/img_2web/
```

## Step 4 — Implement the executable

Must include:

* standard header
* parameter parsing
* help
* input validation
* dependency validation
* safe output behavior
* batch support if possible
* dry-run if batch/destructive
* clear errors
* optional JSON output

## Step 5 — Create `tool.json`

Include all required metadata.

## Step 6 — Create README.md

Document usage and examples.

## Step 7 — Update global docs

Update:

```txt
TOOLS_INDEX.md
TOOLS_ENCYCLOPEDIA.md
```

If the user only asked for one standalone tool, provide entries that can be copied later.

## Step 8 — Add tests or manual test instructions

Include at least one test command.

## Step 9 — Explain briefly what was created

End with:

```txt
Created:
- executable
- tool.json
- README entry
- index entry
- encyclopedia entry
- test command
```

---

# Required Deliverables When Creating A Tool

Unless the user explicitly asks for only one file, output the following:

```txt
1. Tool folder structure
2. Executable script
3. tool.json
4. README.md
5. TOOLS_INDEX.md entry
6. TOOLS_ENCYCLOPEDIA.md entry
7. Test command
```

If the user asks for a `.bat`, still include `tool.json` and documentation unless they explicitly ask for the script only.

If the user asks for a quick answer, provide a minimal but protocol-compliant version.

---

# Example: Image To Web Tool

This is a canonical example based on the GenSkill Tool Protocol.

## Folder

```txt
tools/
└── img_2web/
    ├── img-2web.bat
    ├── tool.json
    ├── README.md
    ├── examples/
    └── tests/
```

## Command behavior

```bat
img-2web.bat imagen.jpg
img-2web.bat imagen.jpg --width 1200 --quality 70
img-2web.bat --all
img-2web.bat --all "C:\imagenes"
img-2web.bat --all "C:\imagenes" --output "C:\imagenes_web"
img-2web.bat --all --dry-run
```

## Safety

```txt
Does not delete originals.
Does not overwrite unless --force is used.
Supports --dry-run.
Validates ffmpeg.
Supports batch processing.
```

## Output naming

```txt
foto.jpg → foto_web.webp
```

---

# Template For A `.bat` Tool

Use this template when creating a Windows batch tool.

```bat
@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: Tool: TOOL-NAME
:: ID: tool_id
:: Version: 1.0.0
:: Type: batch
:: Status: experimental
:: Category: category_name
:: Description:
::   Describe what this tool does.
::
:: Usage:
::   tool-name.bat input.ext
::   tool-name.bat --all
::   tool-name.bat --all folder
::
:: Inputs:
::   Describe inputs.
::
:: Outputs:
::   Describe outputs.
::
:: Parameters:
::   --help       Show help.
::   --all        Process all compatible files in a folder.
::   --output     Output file or folder.
::   --force      Allow overwrite.
::   --dry-run    Preview actions without changing files.
::   --json       Output JSON result when supported.
::
:: Dependencies:
::   List dependencies.
::
:: Safety:
::   Does not delete originals.
::   Does not overwrite unless --force is used.
::
:: AI Notes:
::   Follows GenSkill Tool Protocol.
:: ============================================================

set "TOOL_NAME=TOOL-NAME"
set "TOOL_ID=tool_id"
set "VERSION=1.0.0"

if "%~1"=="" goto :help
if /I "%~1"=="--help" goto :help
if /I "%~1"=="-h" goto :help
if /I "%~1"=="/?" goto :help
if /I "%~1"=="--version" (
    echo %TOOL_NAME% %VERSION%
    exit /b 0
)

:: Dependency checks go here.
:: Parameter parsing goes here.
:: Main execution goes here.

exit /b 0

:help
echo %TOOL_NAME% %VERSION%
echo.
echo Description:
echo   Describe what this tool does.
echo.
echo Usage:
echo   tool-name.bat input.ext
echo   tool-name.bat --all
echo   tool-name.bat --all folder
echo.
echo Options:
echo   --help       Show this help.
echo   --all        Process all compatible files in a folder.
echo   --output     Output file or folder.
echo   --force      Allow overwrite.
echo   --dry-run    Preview actions without changing files.
echo   --json       Output JSON result when supported.
echo.
echo Safety:
echo   Does not delete original files.
echo   Does not overwrite unless --force is used.
exit /b 0
```

---

# Template For A Python Tool

Use this template when creating a Python tool.

```python
#!/usr/bin/env python3
"""
Tool: TOOL-NAME
ID: tool_id
Version: 1.0.0
Type: python
Status: experimental
Category: category_name

Description:
    Describe what this tool does.

Usage:
    python tool_name.py input.ext
    python tool_name.py --all
    python tool_name.py --all folder
    python tool_name.py input.ext --output output.ext

Inputs:
    Describe inputs.

Outputs:
    Describe outputs.

Parameters:
    --help       Show help.
    --all        Process all compatible files in a folder.
    --output     Output file or folder.
    --force      Allow overwrite.
    --dry-run    Preview actions without changing files.
    --json       Output machine-readable JSON.

Dependencies:
    List dependencies.

Safety:
    Does not delete originals.
    Does not overwrite unless --force is used.

AI Notes:
    This tool follows the GenSkill Tool Protocol.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any


TOOL_ID = "tool_id"
TOOL_NAME = "TOOL-NAME"
VERSION = "1.0.0"


def build_result(
    success: bool,
    output: Any = None,
    error: Any = None,
    warnings: list[str] | None = None,
) -> dict[str, Any]:
    return {
        "success": success,
        "tool_id": TOOL_ID,
        "tool_name": TOOL_NAME,
        "version": VERSION,
        "output": output,
        "error": error,
        "warnings": warnings or [],
    }


def run_tool(args: argparse.Namespace) -> dict[str, Any]:
    # Implement tool logic here.
    return build_result(success=True, output={"message": "Tool executed."})


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog=TOOL_NAME,
        description="Describe what this tool does.",
    )

    parser.add_argument("input", nargs="?", help="Input file or folder.")
    parser.add_argument("--all", action="store_true", help="Process all compatible files.")
    parser.add_argument("--output", help="Output file or folder.")
    parser.add_argument("--force", action="store_true", help="Allow overwrite.")
    parser.add_argument("--dry-run", action="store_true", help="Preview without modifying files.")
    parser.add_argument("--recursive", action="store_true", help="Include subfolders.")
    parser.add_argument("--json", action="store_true", help="Output JSON.")
    parser.add_argument("--version", action="store_true", help="Show version.")

    return parser.parse_args()


def main() -> int:
    args = parse_args()

    if args.version:
        print(f"{TOOL_NAME} {VERSION}")
        return 0

    result = run_tool(args)

    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=2))
    else:
        if result["success"]:
            print("OK:", result.get("output"))
        else:
            print("ERROR:", result.get("error"))

    return 0 if result["success"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
```

---

# When The User Provides An Existing Script

When the user provides an existing `.bat` or `.py`, do not merely patch it.

First analyze it against the GenSkill Tool Protocol:

```txt
Does it have a clear name?
Does it have a standard header?
Does it accept parameters?
Does it support --help?
Does it support one file?
Does it support --all for folders?
Does it avoid overwriting originals?
Does it support --dry-run when needed?
Does it validate dependencies?
Does it produce clear output?
Does it have tool.json?
Does it have README.md?
Does it have index and encyclopedia entries?
```

Then provide a standardized version.

---

# Human + AI Readability Rule

Every tool must be understandable at three levels:

## 1. Beginner human

Can run:

```bat
tool-name.bat file.ext
```

and understand what happened.

## 2. Power user

Can run:

```bat
tool-name.bat --all folder --output out --force --dry-run
```

and control behavior.

## 3. AI agent / runner

Can read:

```txt
tool.json
README.md
--help
--json output
```

and decide when and how to use the tool.

---

# GenSkill Philosophy

Use this final rule to guide all tool creation:

```txt
Do not create one-off scripts.
Create reusable capabilities.
```

A GenSkill tool should feel like a small product.

It should have:

```txt
name
purpose
parameters
documentation
metadata
examples
safety
tests
future compatibility
```

The end goal:

```txt
Every automation created by AI should stop dying inside a chat
and become a reusable tool for the future.
```

GenSkill turns practical solutions into permanent infrastructure.

---

# Final Checklist

Before delivering a GenSkill tool, verify:

```txt
[ ] The tool has a short, clear name.
[ ] The internal ID uses snake_case.
[ ] The script has a standard header.
[ ] The script supports --help.
[ ] The script accepts parameters.
[ ] The script avoids hardcoded paths.
[ ] The script can process one file.
[ ] The script can process a folder with --all when applicable.
[ ] The script supports --dry-run for batch or risky actions.
[ ] The script does not delete originals by default.
[ ] The script does not overwrite without --force.
[ ] Dependencies are declared and checked.
[ ] Errors are clear.
[ ] Output is human-readable.
[ ] JSON output is available when useful.
[ ] tool.json exists.
[ ] README.md exists.
[ ] TOOLS_INDEX.md entry exists.
[ ] TOOLS_ENCYCLOPEDIA.md entry exists.
[ ] Test command or test files exist.
[ ] Safety permissions are declared.
[ ] Status and risk level are declared.
[ ] The tool is easy for humans and AI agents to understand.
```

If any item is missing, either add it or explicitly explain why it does not apply.

```
```
