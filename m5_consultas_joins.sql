-- Base de datos: Ventas_Tech_DB

USE Ventas_Tech_DB;

--------------------------------------------------------------------------------------------------------------------
-- CONSULTA 1 - VISTA BASE DEL PROYECTO | INNER JOIN entre ventas, clientes, productos y categorías.
-- ============================================================
-- CONSULTA 1 - VISTA BASE DEL PROYECTO
-- INNER JOIN: ventas, clientes, productos y categorías
-- ============================================================

SELECT
    ventas.fecha_venta AS fecha,
    clientes.id_cliente,
    clientes.nombre AS nombre_cliente,
    clientes.ciudad AS region,
    productos.nombre_producto AS producto,
    categorias.nombre_categoria AS categoria,
    ventas.cantidad,
    ventas.precio_unitario,
    ventas.cantidad * ventas.precio_unitario AS total_venta
FROM ventas
INNER JOIN clientes
    ON ventas.id_cliente = clientes.id_cliente
INNER JOIN productos
    ON ventas.id_producto = productos.id_producto
INNER JOIN categorias
    ON productos.id_categoria = categorias.id_categoria
ORDER BY ventas.fecha_venta;


-- ============================================================
-- CONSULTA 2 - CLIENTES SIN VENTAS
-- LEFT JOIN: clientes que nunca realizaron una compra
-- ============================================================

SELECT
    clientes.nombre,
    clientes.email,
    clientes.fecha_registro
FROM clientes
LEFT JOIN ventas
    ON clientes.id_cliente = ventas.id_cliente
WHERE ventas.id_venta IS NULL;


-- ============================================================
-- CONSULTA 3 - PRODUCTOS SIN VENTAS
-- LEFT JOIN: productos que no registran ventas
-- ============================================================

SELECT
    productos.nombre_producto AS producto,
    categorias.nombre_categoria AS categoria,
    productos.precio
FROM productos
LEFT JOIN ventas
    ON productos.id_producto = ventas.id_producto
INNER JOIN categorias
    ON productos.id_categoria = categorias.id_categoria
WHERE ventas.id_venta IS NULL;


-- ============================================================
-- CONSULTA 4 - CONSOLIDADO POR CANAL
-- Se separan las ventas en dos períodos.
-- Período 1: del 1 al 10 de marzo de 2024.
-- Período 2: del 11 al 31 de marzo de 2024.
-- ============================================================

SELECT
    consolidado.canal,
    SUM(consolidado.total) AS total_canal
FROM
(
    SELECT
        ventas.fecha_venta,
        ventas.cantidad * ventas.precio_unitario AS total,
        'Período 1' AS canal
    FROM ventas
    WHERE ventas.fecha_venta >= '2024-03-01'
      AND ventas.fecha_venta < '2024-03-11'

    UNION ALL

    SELECT
        ventas.fecha_venta,
        ventas.cantidad * ventas.precio_unitario AS total,
        'Período 2' AS canal
    FROM ventas
    WHERE ventas.fecha_venta >= '2024-03-11'
      AND ventas.fecha_venta < '2024-04-01'
) AS consolidado
GROUP BY consolidado.canal
ORDER BY consolidado.canal;
