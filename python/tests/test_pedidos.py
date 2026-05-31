"""
Tests del parte de pedidos — distribuidora.

Framework: pytest.
    pip install pytest
    pytest            (desde la carpeta python/)

Dos tipos de prueba:
  1. Unitarias: con datos pequeños y controlados, verifican la lógica de cálculo.
  2. Characterization: con el CSV real, congelan el comportamiento actual del programa.
     Son la red de M8: antes de modernizar, capturan lo que el programa hace HOY,
     para detectar si una versión nueva cambia algún resultado.
"""

import sys
from pathlib import Path

import pytest

# Permite importar pedidos.py estando los tests en python/tests/
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from pedidos import calcular_estadisticas, cargar_pedidos  # noqa: E402


# ---------------------------------------------------------------------------
# 1. Unitarias — lógica de cálculo con datos controlados
# ---------------------------------------------------------------------------

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


def test_media_importe_por_unidad():
    # HW: 20 EUR / 15 unidades = 1.333... -> 1.33
    pedidos = [
        {'categoria': 'HW', 'cantidad': 10, 'precio_unitario': 1.0},
        {'categoria': 'HW', 'cantidad': 5, 'precio_unitario': 2.0},
    ]
    stats = calcular_estadisticas(pedidos)
    assert stats['media_importe_por_unidad_categoria']['HW'] == 1.33


def test_importes_se_redondean_a_dos_decimales():
    pedidos = [{'categoria': 'HW', 'cantidad': 3, 'precio_unitario': 0.1}]
    stats = calcular_estadisticas(pedidos)
    assert stats['total_ventas'] == 0.3


# ---------------------------------------------------------------------------
# Caso límite — el redondeo bancario (el error que "compila y miente", M8)
# ---------------------------------------------------------------------------

def test_borde_redondeo_a_la_mitad():
    # 0.125 redondeado a 2 decimales: round() de Python usa "banker's rounding"
    # -> 0.12, no 0.13. Una versión modernizada en otro lenguaje que redondee
    # "half up" daría 0.13 y divergiría aquí. Por eso este caso entra en la red.
    pedidos = [{'categoria': 'HW', 'cantidad': 1, 'precio_unitario': 0.125}]
    stats = calcular_estadisticas(pedidos)
    assert stats['total_ventas'] == 0.12


def test_lista_vacia_no_rompe():
    stats = calcular_estadisticas([])
    assert stats['total_ventas'] == 0
    assert stats['ventas_por_categoria'] == {}


# ---------------------------------------------------------------------------
# 2. Characterization — congela el comportamiento sobre el CSV real
# ---------------------------------------------------------------------------

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


def test_caracterizacion_media_por_unidad(stats_csv_real):
    assert stats_csv_real['media_importe_por_unidad_categoria'] == {
        'HW': 0.37,
        'EL': 11.08,
        'PL': 3.29,
    }
