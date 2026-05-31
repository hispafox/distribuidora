# Extensiones recomendadas de VS Code

Este repo combina **tres lenguajes** (Python, COBOL, FORTRAN) más el flujo de **GitHub Copilot** del curso DEVCOP. Para ver, resaltar y validar cada lenguaje correctamente conviene instalar estas extensiones.

> VS Code las ofrece automáticamente al abrir el proyecto, porque están declaradas en [`.vscode/extensions.json`](../.vscode/extensions.json).
> También puedes verlas con **Ctrl+Mayús+P → «Extensions: Show Recommended Extensions»**.

---

## Tabla resumen

| Lenguaje / función | Extensión | ID (Marketplace) | Para qué sirve | Compilador/runtime que la acompaña |
|---|---|---|---|---|
| **Python** | Python | `ms-python.python` | Ejecutar, depurar y descubrir tests (pytest) | Python 3.13 + `pytest` |
| **Python** | Pylance | `ms-python.vscode-pylance` | IntelliSense, tipos, navegación | — (acompaña a la anterior) |
| **FORTRAN** | Modern Fortran | `fortran-lang.linter-gfortran` | Resaltado, formato y *linting* de `.f90` | `gfortran` (WinLibs/MinGW-w64) |
| **COBOL** | COBOL | `bitlang.cobol` | Resaltado y navegación de `.cob` / `.cut` | `cobc` (GnuCOBOL) |
| **Copilot** | GitHub Copilot | `github.copilot` | Sugerencias de código | — |
| **Copilot** | GitHub Copilot Chat | `github.copilot-chat` | Chat, instructions, skills, agents, MCP | — (suele venir integrada en VS Code) |

---

## Instalación rápida

### Desde la UI
Abre la pestaña **Extensions** (Ctrl+Mayús+X) y, en el filtro, escribe `@recommended`. Te aparecerán las de la lista para instalar de un clic.

### Desde la terminal (CLI `code`)
```bash
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension fortran-lang.linter-gfortran
code --install-extension bitlang.cobol
code --install-extension github.copilot
code --install-extension github.copilot-chat
```

---

## Notas por lenguaje

### Python — `ms-python.python` + Pylance
Da ejecución, depuración y el **Test Explorer** (descubre los tests de `python/tests/` con pytest). Pylance aporta el análisis de tipos y el autocompletado. Requiere tener Python en el PATH y `pytest` instalado (`pip install pytest`).

### FORTRAN — Modern Fortran (`fortran-lang.linter-gfortran`)
Resaltado moderno de Fortran libre (`.f90`), formateo e integración de *linter* apoyándose en **gfortran**. Para que el *linting* y la compilación funcionen, gfortran debe estar en el PATH (lo aporta WinLibs / MinGW-w64). Para compilar y probar:
```bash
gfortran fortran/envio_mod.f90 fortran/coste_envio.f90 -o coste_envio
gfortran fortran/envio_mod.f90 fortran/test_coste_envio.f90 -o test_coste && ./test_coste
```

### COBOL — `bitlang.cobol`
Resaltado de sintaxis y navegación para los programas `.cob` y los ficheros de prueba `.cut`. Es ligera y funciona sin conexión, ideal para leer y entender el legacy.
- *Alternativa para entornos mainframe:* **COBOL Language Support** de Broadcom (`broadcommfd.cobol-language-support`, parte de Code4z) — añade LSP y soporte de copybooks, pero es más pesada.
- Compilación con GnuCOBOL: `cobc -x cobol/inventario.cob -o inventario`.

### GitHub Copilot + Copilot Chat
El núcleo del curso: las **custom instructions** (`.github/copilot-instructions.md` + `applyTo`), las **skills** (`.github/skills/`), los **agentes** (`.github/agents/`) y el **MCP** (`.vscode/mcp.json`) los consume Copilot Chat. Copilot Chat suele venir ya integrada en versiones recientes de VS Code; si no, instálala con el ID de arriba.

---

*Las herramientas de línea de comandos (gfortran, cobc/GnuCOBOL, Java para cobol-check, pytest) se documentan aparte; estas extensiones son la capa del editor que las complementa.*
