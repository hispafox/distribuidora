---
applyTo: "**/*.py"
---
- Python 3.13. Type hints obligatorios en todas las funciones.
- `pathlib.Path` para cualquier ruta; no usar `os.path`.
- Funciones pequeñas con una sola responsabilidad.
- No usar librerías externas sin justificar. Para CSV: solo `csv` de stdlib.
- Nombres en snake_case; constantes en MAYÚSCULAS.
- Redondear importes monetarios a 2 decimales con `round(..., 2)`.
- Los tests van en `tests/` con pytest.
