"""
Pedidos del día — distribuidora.

Carga un CSV con columnas: fecha, producto, categoria, cantidad, precio_unitario
Genera estadísticas: total de ventas, ventas por categoría, media de importe por unidad y categoría.
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
    unidades_por_categoria: dict[str, int] = defaultdict(int)
    for p in pedidos:
        importe = p['cantidad'] * p['precio_unitario']
        ventas_por_categoria[p['categoria']] += importe
        unidades_por_categoria[p['categoria']] += p['cantidad']

    media_por_categoria = {
        cat: ventas_por_categoria[cat] / unidades_por_categoria[cat]
        for cat in ventas_por_categoria
    }

    return {
        'total_ventas': round(total_ventas, 2),
        'ventas_por_categoria': {k: round(v, 2) for k, v in ventas_por_categoria.items()},
        'media_importe_por_unidad_categoria': {k: round(v, 2) for k, v in media_por_categoria.items()},
    }


def main() -> None:
    ruta = Path(__file__).parent / 'datos' / 'pedidos_dia.csv'
    pedidos = cargar_pedidos(str(ruta))
    stats = calcular_estadisticas(pedidos)

    print(f"Total ventas: {stats['total_ventas']} EUR")
    print("Ventas por categoria:")
    for cat, total in sorted(stats['ventas_por_categoria'].items()):
        media = stats['media_importe_por_unidad_categoria'][cat]
        print(f"  {cat}: {total} EUR  (media/unidad: {media} EUR)")


if __name__ == '__main__':
    main()
