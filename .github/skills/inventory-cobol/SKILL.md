---
name: inventory-cobol
description: Trabaja con el inventario de productos en COBOL GnuCOBOL formato fijo: alta de producto, listado completo, búsqueda por código de 6 caracteres donde los 2 primeros son la categoría (ej HW0023). Actívate cuando el usuario pida modificar, añadir funcionalidad o corregir el programa de inventario COBOL.
---

## Fichero principal

`cobol/inventario.cob` — GnuCOBOL, formato fijo.

## Estructura del registro de inventario

Fichero: `inventario.dat` (LINE SEQUENTIAL)

```
01  REGISTRO-INV.
    05  RI-CODIGO        PIC X(6)     -- codigo 6 car. (2 primeras = categoria)
    05  RI-DESCRIPCION   PIC X(30)    -- descripcion del producto
    05  RI-STOCK         PIC 9(5)     -- unidades en stock
    05  RI-PRECIO        PIC 9(5)V99  -- precio unitario en EUR
```

**NO cambiar el tamaño ni el orden de estos campos.**

## Operaciones actuales

- **Alta (A)**: añade un registro al fichero (OPEN EXTEND).
- **Listado (L)**: recorre todos los registros y los muestra.
- **Búsqueda (B)**: busca por código exacto de 6 caracteres; informa si no existe.

## Convenciones críticas

- Formato fijo: sentencias en columna 12+ (Area B).
- Variables de trabajo con prefijo `WS-`.
- Control de fin de fichero con `WS-EOF` ('N'='no eof', 'S'='eof').
- `WS-ENCONTRADO` ('N'/'S') para control de búsqueda.
- No usar GO TO en código nuevo.
- Compilar: `cobc -x -o inventario inventario.cob`

## Caso de prueba

Alta con código `HW0023`, descripción `Tornillo M6x20`, stock 500, precio 000.05.
Búsqueda de `HW0023` debe devolver esos mismos datos.
