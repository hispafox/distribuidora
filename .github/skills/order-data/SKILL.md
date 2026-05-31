---
name: order-data
description: Procesa el parte de pedidos del día en Python: carga el CSV de pedidos (columnas fecha, producto, categoria, cantidad, precio_unitario), calcula estadísticas (total de ventas, ventas por categoría, media de importe por unidad y categoría). Actívate cuando el usuario pida modificar, extender o corregir el script de pedidos Python.
---

## Fichero principal

`python/pedidos.py` — carga un CSV y genera estadísticas de ventas.

## Estructura del CSV

Ruta: `python/datos/pedidos_dia.csv`
Columnas: `fecha,producto,categoria,cantidad,precio_unitario`
Encoding: UTF-8. Separador: coma.

## Funciones

- `cargar_pedidos(ruta_csv: str) -> list[dict]` — lee el CSV y devuelve lista de pedidos.
- `calcular_estadisticas(pedidos: list[dict]) -> dict` — calcula:
  - `total_ventas`: importe total del día (redondeado a 2 decimales).
  - `ventas_por_categoria`: importe total por categoría.
  - `media_importe_por_unidad_categoria`: importe medio por unidad vendida, por categoría.
- `main()` — orquesta la carga y el informe a stdout.

## Convenciones

- Type hints en todas las funciones.
- `pathlib.Path` para la ruta del CSV.
- Los importes van siempre redondeados a 2 decimales.
- No modificar la estructura del CSV (columnas y encoding fijos).

## Caso de prueba

Dados estos pedidos:
```
HW,100,0.05  →  5.00 EUR
EL,8,42.00   →  336.00 EUR
```
Total = 341.00 EUR. Media HW = 0.05. Media EL = 42.00.
