"""
Tests del parte de pedidos — distribuidora. (ESTADO BASE, cap-08)

Framework: pytest.
    pip install pytest
    pytest            (desde la carpeta python/)

Caracterizan el comportamiento ACTUAL del programa (total de ventas y ventas
por categoría). Los tests del "importe medio por categoría" NO están aquí: esa
funcionalidad la añade el equipo de agentes en M9, junto con sus propios tests
(ver distribuidora/python/tests/test_pedidos.py).
"""

import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from pedidos import calcular_estadisticas, cargar_pedidos  # noqa: E402


# --- Unitarias ---

def test_total_ventas_un_pedido():
    pedidos = [{'categoria': 'HW', 'cantidad': 10, 'precio_unitario': 2.0}]
    stats = calcular_estadisticas(pedidos)
    assert stats['total_ventas'] == 20.0


def test_ventas_por_categoria_agrupa():
    pedidos = [
        {'categoria': 'HW', 'cantidad': 10, 'precio_unitario': 1.0},
        {'categoria': 'HW', 'cantidad': 5, 'precio_unitario': 2.0},
        {'categoria': 'EL', 'cantidad': 3, 'precio_unitario': 4.0},
    ]
    stats = calcular_estadisticas(pedidos)
    assert stats['ventas_por_categoria'] == {'HW': 20.0, 'EL': 12.0}


def test_importes_se_redondean_a_dos_decimales():
    pedidos = [{'categoria': 'HW', 'cantidad': 3, 'precio_unitario': 0.1}]
    stats = calcular_estadisticas(pedidos)
    assert stats['total_ventas'] == 0.3


def test_borde_redondeo_a_la_mitad():
    # 0.125 -> 0.12 con banker's rounding de Python (no 0.13).
    pedidos = [{'categoria': 'HW', 'cantidad': 1, 'precio_unitario': 0.125}]
    stats = calcular_estadisticas(pedidos)
    assert stats['total_ventas'] == 0.12


def test_lista_vacia_no_rompe():
    stats = calcular_estadisticas([])
    assert stats['total_ventas'] == 0
    assert stats['ventas_por_categoria'] == {}


# --- Characterization sobre el CSV real ---

@pytest.fixture
def stats_csv_real():
    ruta = Path(__file__).resolve().parent.parent / 'datos' / 'pedidos_dia.csv'
    pedidos = cargar_pedidos(str(ruta))
    return calcular_estadisticas(pedidos)


def test_caracterizacion_total_ventas(stats_csv_real):
    assert stats_csv_real['total_ventas'] == 955.50


def test_caracterizacion_ventas_por_categoria(stats_csv_real):
    assert stats_csv_real['ventas_por_categoria'] == {
        'HW': 265.00,
        'EL': 476.50,
        'PL': 214.00,
    }
