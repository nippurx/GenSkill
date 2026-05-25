# Examples

Example commands from the project root:

```bat
tools\img_web_optimize\img-web.bat foto.jpg
tools\img_web_optimize\img-web.bat foto.png --quality 70
tools\img_web_optimize\img-web.bat foto.jpg --format jpg
tools\img_web_optimize\img-web.bat --all "C:\imagenes" --output "C:\imagenes_web"
tools\img_web_optimize\img-web.bat --all --dry-run
```

Create a local sample image for testing:

```bat
python -c "from PIL import Image; Image.new('RGB',(1600,900),(30,120,200)).save('tools\\img_web_optimize\\examples\\sample.jpg')"
```
