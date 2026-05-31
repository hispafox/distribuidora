"""
Pedidos del día — distribuidora. (ESTADO BASE, cap-01 a cap-08)

Carga un CSV con columnas: fecha, producto, categoria, cantidad, precio_unitario
Genera estadísticas: total de ventas y ventas por categoría.

NOTA: esta es la versión de partida del proyecto. El "importe medio por unidad
y categoría" NO está todavía — es la mejora que el equipo de agentes añade en M9
(rama cap-09/complete). Compara este fichero con distribuidora/python/pedidos.py
para ver exactamente qué añadió el flujo E2E.
"""

import csv
from pathlib import Path
from collections import defaultdict


def cargar_pedidos(ruta_csv: str) -> list[dict]:
    """Carga los pedidos desde un fichero CSV."""
    pedidos: list[dict] = []
    with open(ruta_csv, newline='', encoding='utf-8') as f:
        lector = csv.DictReader(f)
        for fila in lector:
            pedidos.append({
                'fecha': fila['fecha'],
                'producto': fila['producto'],
                'categoria': fila['categoria'],
                'cantidad': int(fila['cantidad']),
                'precio_unitario': float(fila['precio_unitario']),
            })
    return pedidos


def calcular_estadisticas(pedidos: list[dict]) -> dict:
    """Calcula estadísticas básicas del parte de pedidos."""
    total_ventas = sum(p['cantidad'] * p['precio_unitario'] for p in pedidos)

    ventas_por_categoria: dict[str, float] = defaultdict(float)
    for p in pedidos:
        importe = p['cantidad'] * p['precio_unitario']
        ventas_por_categoria[p['categoria']] += importe

    return {
        'total_ventas': round(total_ventas, 2),
        'ventas_por_categoria': {k: round(v, 2) for k, v in ventas_por_categoria.items()},
    }


def main() -> None:
    ruta = Path(__file__).parent / 'datos' / 'pedidos_dia.csv'
    pedidos = cargar_pedidos(str(ruta))
    stats = calcular_estadisticas(pedidos)

    print(f"Total ventas: {stats['total_ventas']} EUR")
    print("Ventas por categoria:")
    for cat, total in sorted(stats['ventas_por_categoria'].items()):
        print(f"  {cat}: {total} EUR")


if __name__ == '__main__':
    main()
