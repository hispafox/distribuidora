---
name: shipping-cost
description: Calcula el coste de envío en FORTRAN gfortran según el peso real y el peso volumétrico de un paquete, usando el factor estándar de logística (divisor 5000) y tarifas por tramos definidas en el módulo tarifas. Actívate cuando el usuario pida modificar la fórmula, añadir tramos de tarifa o corregir el programa FORTRAN de coste de envío.
---

## Fichero principal

`fortran/coste_envio.f90` — gfortran, formato libre (Fortran 90).

## Lógica de cálculo

1. **Peso volumétrico** = (alto_cm × ancho_cm × largo_cm) / DIVISOR_VOLUM
   - `DIVISOR_VOLUM = 5000.0` (estándar logística: cm³ / 5000 = kg equivalente)
2. **Peso de tarificación** = `max(peso_real, peso_volumétrico)`
3. **Coste** = peso_tarificacion × tarifa_del_tramo

## Tramos de tarifa (módulo `tarifas`)

| Rango | Constante | Valor |
|---|---|---|
| 0 – 5 kg | TARIFA_0_5 | 2.50 EUR/kg |
| 5 – 15 kg | TARIFA_5_15 | 1.80 EUR/kg |
| 15 – 30 kg | TARIFA_15_30 | 1.40 EUR/kg |
| > 30 kg | TARIFA_MAS30 | 1.10 EUR/kg |

## Estructura del código

- Módulo `tarifas`: constantes TARIFA_* y DIVISOR_VOLUM.
- Función `peso_volumetrico(alto, ancho, largo)`: calcula el peso volumétrico.
- Función `coste_envio(peso_tarif_kg)`: aplica las tarifas por tramos.
- Programa `calcular_envio`: lee datos, llama a las funciones, muestra resultado.

## Convenciones

- `implicit none` en todo.
- Nuevas constantes siempre en el módulo `tarifas`.
- Si añades un tramo: añade la constante en `tarifas` y el `else if` en `coste_envio`.
- Compilar: `gfortran -o coste_envio coste_envio.f90`

## Caso de prueba

Paquete: 3 kg real, 40×30×25 cm.
- Peso volumétrico = (40×30×25)/5000 = 30 000/5000 = 6.0 kg
- Peso tarificación = max(3.0, 6.0) = **6.0 kg** → tramo 5-15 kg
- Coste = 6.0 × 1.80 = **10.80 EUR**
