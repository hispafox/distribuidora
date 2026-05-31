# Distribuidora — instrucciones para GitHub Copilot

Este repositorio contiene el sistema de gestión de una pequeña distribuidora, en tres lenguajes:
- **Python**: parte de pedidos del día (CSV → estadísticas por categoría).
- **COBOL**: inventario de productos (alta, listado, búsqueda por código de 6 caracteres).
- **FORTRAN**: cálculo del coste de envío (peso real vs. volumétrico, tarifas por tramos).

## Stack

- Python 3.13 con type hints. `pathlib` para rutas. Sin librerías externas sin justificar.
- COBOL GnuCOBOL, formato fijo. Campos en MAYÚSCULAS con guiones. Compilar con `cobc`.
- FORTRAN gfortran, formato libre (Fortran 90+). `implicit none` siempre. Compilar con `gfortran`.

## Dominio del negocio

Una **distribuidora** que gestiona tres flujos:
1. Inventario de productos físicos en almacén, identificados por un código de 6 caracteres donde los 2 primeros son la categoría (ej: `HW0023` = hardware, nº 23).
2. Envíos a clientes: el coste se calcula por el peso de tarificación (mayor entre peso real y volumétrico).
3. Partes diarios de pedidos en CSV: resumen de ventas por categoría al final del día.

## Convenciones comunes

- No toques el formato de registro del inventario COBOL (estructura `REGISTRO-INV`).
- No cambies las constantes de tarifa o el factor volumétrico en FORTRAN sin documentar el motivo.
- Las constantes numéricas van en módulos o al nivel de datos, no incrustadas en la lógica.
- El control de errores en COBOL: flags `WS-` en WORKING-STORAGE, no parar ejecución.
- El control de errores en FORTRAN: devolver código de estado entero cuando aplique.

## No hacer

- No usar librerías externas en Python sin justificar.
- No usar `GO TO` en código COBOL nuevo.
- No cambiar `DIVISOR_VOLUM` en FORTRAN sin comparar resultados con el programa original.
- No modificar la estructura de columnas del fichero `inventario.dat`.
