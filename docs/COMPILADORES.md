# Compiladores y herramientas de línea de comandos

Para **compilar y validar cada paso** del repo (Python, FORTRAN, COBOL) en Windows. Complementa a [`EXTENSIONES-VSCODE.md`](EXTENSIONES-VSCODE.md), que cubre la capa del editor.

## Qué hay instalado

| Herramienta | Versión | Cómo se instaló | Para qué |
|---|---|---|---|
| **Python** | 3.13 + `pytest` 9 | (Python ya presente) `pip install pytest` | Tests de `python/` |
| **gfortran** | 16.1.0 (WinLibs/MinGW-w64) | `winget install BrechtSanders.WinLibs.POSIX.UCRT` | Compilar/ejecutar `.f90` |
| **GnuCOBOL** (`cobc`) | 3.2.0 | MSYS2 → `pacman -S mingw-w64-ucrt-x86_64-gnucobol` | Compilar `.cob` |
| **Java** (JRE) | Temurin 21 LTS | `winget install EclipseAdoptium.Temurin.21.JRE` | Ejecutar `cobol-check` (los `.cut`) |

> `gfortran` y `pytest` quedan en el PATH directamente. Para `cobc` se añadió `C:\msys64\ucrt64\bin` al PATH de usuario.

---

## ⚠️ COBOL: variables de entorno necesarias

`cobc` fuera del shell de MSYS2 no encuentra su configuración y falla con
`configuration error: .../config/default.conf: No such file or directory`.
Se resuelve con dos variables de entorno (ya fijadas de forma **persistente** a nivel de usuario):

```
COB_CONFIG_DIR = C:\msys64\ucrt64\share\gnucobol\config
COB_COPY_DIR   = C:\msys64\ucrt64\share\gnucobol\copy
```

Si en una máquina nueva vuelve a fallar, define esas dos variables (Sistema → Variables de entorno, o `setx`).

---

## Compilar y probar cada lenguaje

### Python
```bash
pip install pytest          # una vez
python -m pytest python/tests/ -q
```

### FORTRAN (gfortran)
```bash
# Programa principal
gfortran fortran/envio_mod.f90 fortran/coste_envio.f90 -o coste_envio

# Tests de caracterización (rama cap-08 en adelante)
gfortran fortran/envio_mod.f90 fortran/test_coste_envio.f90 -o test_coste
./test_coste          # imprime [OK] por cada caso
```

### COBOL (GnuCOBOL)
```bash
# Con COB_CONFIG_DIR / COB_COPY_DIR definidas (ver arriba)
cobc -x cobol/inventario.cob -o inventario
./inventario
```

---

## cobol-check (runner de los `.cut`)

Los tests del inventario están en formato **cobol-check** (`cobol/tests/inventario-tests.cut`). Estado actual:

- ✅ **Java 21** instalado (lo que necesita cobol-check para ejecutarse).
- ⚠️ **El JAR no está disponible como release prebuilt.** La única release publicada (`0.1.0`, 2021) solo trae código fuente. Para usarlo hay que **compilarlo desde el repo** [`openmainframeproject/cobol-check`](https://github.com/openmainframeproject/cobol-check) con Gradle (requiere **JDK**, no solo JRE):
  ```bash
  git clone https://github.com/openmainframeproject/cobol-check
  cd cobol-check && ./gradlew build      # genera build/libs/cobol-check-*.jar
  ```
- Mientras tanto, la compilación COBOL con `cobc` y la ejecución del programa **sí funcionan**; solo el *runner* de pruebas `.cut` queda pendiente de construir.

---

*Verificado el 2026-05-31: Python 9/9 tests, FORTRAN 10/10 tests, COBOL compila y ejecuta.*
