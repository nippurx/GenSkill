# video-cortar tests

Run these commands from the project root:

```bat
tools\video_trim\video-cortar.bat --help
tools\video_trim\video-cortar.bat -h
tools\video_trim\video-cortar.bat /?
tools\video_trim\video-cortar.bat --version
python -m json.tool tools\video_trim\tool.json
```

Manual smoke test with a real local video:

```bat
tools\video_trim\video-cortar.bat "C:\Videos\video.mp4"
tools\video_trim\video-cortar.bat "C:\Videos\video.mp4" --duration 00:05:00 --output "C:\Videos\video_5min.mp4"
```

Expected safety behavior:

```bat
tools\video_trim\video-cortar.bat "C:\Videos\video.mp4"
tools\video_trim\video-cortar.bat "C:\Videos\video.mp4"
```

The second command should fail with `ERROR [OUTPUT_EXISTS]` unless `--force` is used.
