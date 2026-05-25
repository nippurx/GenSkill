# GenSkill — Roadmap tentativo mejorado
https://chatgpt.com/c/69faa85b-6e14-8327-87cd-5c6d553dd6eb

## Idea central

**GenSkill** sería un sistema donde la IA no resuelve todo desde cero cada vez.

En vez de eso:

```txt
Usuario pide una tarea
↓
GenSkill busca si ya existe una skill
↓
Si existe, la ejecuta
↓
Si no existe, usa IA para crearla
↓
La guarda, la prueba y la reutiliza en el futuro
```

La frase conceptual sería:

> GenSkill convierte inteligencia cara en automatización reutilizable.

---

# Fase 0 — Definir el alcance real

Antes de programar, conviene decidir qué NO va a hacer el MVP.

Al principio GenSkill no debería intentar controlar toda la PC como un agente universal.

Mejor arrancar con tareas concretas:

* archivos
* imágenes
* texto
* CSV/Excel
* scraping simple
* automatización local básica
* conversión de formatos
* procesamiento por lotes

Ejemplo de tareas ideales para el MVP:

```txt
Redimensionar 50 imágenes
Extraer texto de PDFs
Renombrar archivos por patrón
Convertir CSV a JSON
Limpiar una carpeta de duplicados
Crear miniaturas cuadradas
Unir varios TXT en uno
Extraer metadatos de imágenes
```

Esto permite probar la idea sin meterse de entrada en navegación web compleja, login, mouse, WhatsApp, redes sociales, etc.

---

# Fase 1 — Crear el formato de una Skill

Cada skill debe tener 2 partes:

## 1. El script Python

Ejemplo:

```txt
skills/image_resize/run.py
```

## 2. Un archivo de metadata

Ejemplo:

```json
{
  "id": "image_resize",
  "name": "Resize Image",
  "description": "Redimensiona una imagen manteniendo o no la proporción.",
  "category": "image",
  "inputs": {
    "input_path": "Ruta de la imagen original",
    "output_path": "Ruta de salida",
    "width": "Ancho final",
    "height": "Alto final"
  },
  "outputs": {
    "output_path": "Imagen generada"
  },
  "tags": ["imagen", "resize", "redimensionar", "thumbnail"],
  "risk_level": "low",
  "entrypoint": "run.py"
}
```

Esto es clave.

Sin metadata, GenSkill sería solo una carpeta de scripts.

Con metadata, GenSkill se convierte en una **biblioteca inteligente de capacidades**.

---

# Fase 2 — Skill Runner

El primer componente real debería ser un ejecutor.

Su trabajo:

```txt
Recibe una skill + parámetros
↓
Valida los datos
↓
Ejecuta el script
↓
Captura resultado
↓
Guarda logs
↓
Informa éxito o error
```

Acá todavía no hace falta IA.

Ejemplo:

```bash
genskill run image_resize --input foto.jpg --width 1080 --height 1080
```

Resultado:

```json
{
  "success": true,
  "output_path": "foto_resized.jpg",
  "duration": "0.8s"
}
```

Esta fase es fundamental porque te da la base confiable.

Sin runner sólido, después el agente se vuelve frágil.

---

# Fase 3 — Librería inicial de Skills

Acá habría que crear unas 30 o 40 skills manuales, bien hechas, no generadas automáticamente.

Categorías iniciales:

## Archivos

```txt
rename_files
move_files
find_duplicates
create_folder
zip_folder
unzip_file
list_files
```

## Imágenes

```txt
resize_image
crop_square
compress_image
convert_image_format
add_text_to_image
extract_image_metadata
```

## Texto

```txt
clean_text
split_text
merge_text_files
count_words
extract_keywords
convert_txt_to_srt
```

## Datos

```txt
csv_to_json
json_to_csv
merge_csv
filter_csv
deduplicate_rows
excel_to_csv
```

## Web simple

```txt
download_url
extract_links
save_html
screenshot_page
```

En esta etapa el objetivo no es tener miles de scripts.

El objetivo es validar que el sistema puede:

* registrar skills
* encontrarlas
* ejecutarlas
* medir si funcionaron
* reutilizarlas

---

# Fase 4 — Buscador de Skills

Antes de meter IA, haría un buscador clásico.

Ejemplo:

```txt
Usuario: "quiero hacer cuadradas varias imágenes"
```

GenSkill busca por:

* nombre
* descripción
* tags
* categoría

Y encuentra:

```txt
crop_square
resize_image
compress_image
```

Primer selector simple:

```txt
matching por palabras clave
```

Segundo selector:

```txt
embeddings locales
```

Tercer selector:

```txt
LLM router
```

No conviene saltar directo al LLM.

Primero hay que hacer que el sistema funcione barato y predecible.

---

# Fase 5 — Planner con IA

Recién acá entra la IA.

Pero con una regla importante:

> La IA no escribe código si no hace falta.

Su trabajo inicial es solo decidir qué skills usar y en qué orden.

Ejemplo:

```txt
Usuario:
"Tengo 40 imágenes verticales y quiero convertirlas en miniaturas cuadradas para YouTube con texto arriba."
```

El planner responde:

```json
[
  {
    "skill": "crop_square",
    "reason": "Convertir imagen a formato cuadrado"
  },
  {
    "skill": "resize_image",
    "reason": "Normalizar tamaño a 1080x1080"
  },
  {
    "skill": "add_text_to_image",
    "reason": "Agregar título legible"
  }
]
```

Esto reduce muchísimo el gasto de tokens porque la IA solo hace planificación, no programación completa.

---

# Fase 6 — Workflows reutilizables

Cuando un conjunto de skills se usa varias veces, GenSkill debería guardarlo como workflow.

Ejemplo:

```txt
Crear miniatura cuadrada
=
crop_square
+ resize_image
+ add_text_to_image
+ compress_image
```

Ese workflow después se guarda como:

```txt
workflow_youtube_thumbnail
```

Entonces GenSkill no solo guarda scripts.

También guarda **recetas de trabajo**.

Esto es muy importante porque muchas tareas reales no son una sola skill, sino una cadena.

---

# Fase 7 — Creación automática de nuevas Skills

Esta es la parte más potente, pero no debería ser la primera.

Cuando el usuario pide algo y no existe una skill adecuada:

```txt
No existe skill para "extraer capítulos de un EPUB"
```

Entonces GenSkill puede pedirle a la IA:

```txt
Crear nueva skill Python:
- input: archivo EPUB
- output: lista de capítulos en TXT
- debe incluir tests
- debe tener metadata
- debe no borrar archivos
```

Pero la skill nueva no debería entrar directamente a producción.

Primero pasa por:

```txt
Generar código
↓
Crear metadata
↓
Crear test mínimo
↓
Ejecutar en sandbox
↓
Validar salida
↓
Guardar como skill experimental
```

Al principio tendría estado:

```txt
experimental
```

Después de varios usos exitosos pasa a:

```txt
stable
```

---

# Fase 8 — Sistema de confianza

Cada skill debería tener score.

Ejemplo:

```json
{
  "skill": "crop_square",
  "runs": 148,
  "success_rate": 0.97,
  "avg_duration": "0.4s",
  "status": "stable",
  "last_error": null
}
```

Esto permite que GenSkill aprenda cuáles scripts son confiables.

También puede evitar usar skills peligrosas o poco probadas.

Estados posibles:

```txt
draft
experimental
stable
deprecated
dangerous
```

---

# Fase 9 — Seguridad

Esta parte es crítica.

Un sistema que ejecuta Python puede hacer daño si no está controlado.

Para el MVP:

```txt
Modo seguro
```

Reglas:

* no borrar archivos salvo permiso explícito
* no sobrescribir archivos sin backup
* no ejecutar comandos del sistema sin autorización
* trabajar dentro de una carpeta sandbox
* registrar todo en logs
* pedir confirmación para acciones destructivas

Después:

```txt
Docker sandbox
permisos por skill
modo solo lectura
modo escritura limitada
```

Ejemplo de permisos por skill:

```json
{
  "can_read_files": true,
  "can_write_files": true,
  "can_delete_files": false,
  "can_access_network": false,
  "can_execute_shell": false
}
```

---

# Fase 10 — Interfaz

Al principio no hace falta una interfaz compleja.

Orden recomendado:

## 1. CLI

```bash
genskill run crop_square imagen.jpg
```

## 2. API local

```txt
FastAPI
```

## 3. UI web simple

Panel con:

* lista de skills
* buscador
* ejecución
* logs
* workflows
* historial

## 4. UI visual tipo nodos

Más adelante:

```txt
Skill A → Skill B → Skill C
```

Tipo ComfyUI o n8n.

Pero no lo haría al principio.

La UI visual es tentadora, pero puede demorar mucho el MVP.

---

# Arquitectura recomendada para el MVP

```txt
GenSkill/
│
├── skills/
│   ├── image_resize/
│   │   ├── skill.json
│   │   ├── run.py
│   │   └── tests/
│   │
│   ├── crop_square/
│   │   ├── skill.json
│   │   ├── run.py
│   │   └── tests/
│
├── workflows/
│   └── youtube_thumbnail.json
│
├── core/
│   ├── runner.py
│   ├── registry.py
│   ├── search.py
│   ├── planner.py
│   ├── validator.py
│   └── logger.py
│
├── data/
│   ├── genskill.db
│   └── logs/
│
└── app.py
```

---

# Stack recomendado

Para arrancar simple:

```txt
Python
SQLite
Pydantic
Typer o Click para CLI
FastAPI para API
pytest para tests
```

Para búsqueda semántica:

```txt
sentence-transformers
FAISS o Chroma
```

Para IA:

```txt
OpenAI API al principio
modelo local después
```

Para UI:

```txt
React
Tailwind
React Flow más adelante
```

---

# Roadmap por etapas reales

## Etapa 1 — Núcleo sin IA

Objetivo:

```txt
Ejecutar skills reutilizables de forma confiable.
```

Entregables:

* formato skill.json
* runner
* logs
* 20 skills iniciales
* CLI básica

Resultado:

```txt
GenSkill ya sirve como toolbox ejecutable.
```

---

## Etapa 2 — Búsqueda inteligente

Objetivo:

```txt
Encontrar la skill correcta a partir de una intención.
```

Entregables:

* buscador por tags
* buscador semántico
* ranking de skills
* historial de uso

Resultado:

```txt
El usuario describe lo que quiere y GenSkill sugiere skills.
```

---

## Etapa 3 — Planner IA

Objetivo:

```txt
Que la IA arme planes usando skills existentes.
```

Entregables:

* LLM router
* composición de workflows
* validación antes de ejecutar
* explicación del plan

Resultado:

```txt
La IA usa herramientas existentes en vez de programar todo.
```

---

## Etapa 4 — Skill Generator

Objetivo:

```txt
Crear nuevas skills cuando no existan.
```

Entregables:

* generación automática de run.py
* generación automática de skill.json
* tests mínimos
* sandbox
* estado experimental

Resultado:

```txt
GenSkill empieza a crecer solo.
```

---

## Etapa 5 — Workflows y superskills

Objetivo:

```txt
Convertir cadenas repetidas en nuevas capacidades permanentes.
```

Entregables:

* workflows guardados
* plantillas
* detección de patrones
* compilación de workflows a superskills

Resultado:

```txt
GenSkill no solo acumula scripts, acumula experiencia.
```

---

# MVP más razonable

Yo lo haría así:

## MVP 1

```txt
CLI + runner + 20 skills
```

Sin IA.

Sirve para comprobar que la base funciona.

---

## MVP 2

```txt
Buscador semántico + sugerencia de skill
```

Ejemplo:

```txt
"achicar todas las fotos de una carpeta"
```

GenSkill sugiere:

```txt
batch_resize_images
```

---

## MVP 3

```txt
Planner IA que combine skills
```

Ejemplo:

```txt
"preparame estas imágenes para Instagram"
```

Plan:

```txt
resize_image
crop_square
compress_image
```

---

## MVP 4

```txt
Generador de skills faltantes
```

Este es el primer GenSkill completo.

---

# Lo más importante: no empezar por “agente universal”

Ese sería el error.

La tentación sería decir:

```txt
GenSkill controlará toda la PC.
```

Pero eso te mete en problemas difíciles:

* permisos
* ventanas
* errores visuales
* cambios de interfaz
* logins
* captchas
* riesgo de borrar cosas
* bugs impredecibles

Mejor empezar por:

```txt
GenSkill procesa archivos y datos de forma local.
```

Después sí pasar a:

```txt
GenSkill automatiza aplicaciones.
```

Y recién más adelante:

```txt
GenSkill opera la PC como agente.
```

---

# Diferencia clave con un agente común

Un agente común:

```txt
Piensa → programa → ejecuta → olvida
```

GenSkill:

```txt
Piensa → busca skill → ejecuta → aprende
```

Y cuando no sabe:

```txt
Piensa → programa → prueba → guarda → reutiliza
```

Esa diferencia es enorme.

Porque el costo baja con el tiempo.

---

# Versión corta del roadmap

```txt
1. Definir formato de skill
2. Crear runner
3. Crear 20–40 skills manuales
4. Crear buscador por tags
5. Agregar búsqueda semántica
6. Agregar planner IA
7. Permitir workflows
8. Generar nuevas skills con IA
9. Validarlas con tests y sandbox
10. Convertir workflows repetidos en superskills
```

---

# Eslogan posible

> GenSkill: la IA que no vuelve a aprender dos veces la misma tarea.

O más técnico:

> GenSkill convierte prompts en herramientas reutilizables.

O más de producto:

> Automatización inteligente que mejora cada vez que la usás.

---

Mi recomendación final: **arrancar muy chico, sin IA generadora**, con una librería de skills bien hechas. Si esa base funciona, después la IA encima se vuelve muchísimo más poderosa.
