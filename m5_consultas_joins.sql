-- Base de datos: Ventas_Tech_DB

USE Ventas_Tech_DB;

--------------------------------------------------------------------------------------------------------------------
-- CONSULTA 1 - VISTA BASE DEL PROYECTO | INNER JOIN entre ventas, clientes, productos y categorías.

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

--------------------------------------------------------------------------------------------------------------------
-- CONSULTA 2 - CLIENTES SIN VENTAS | Identifica los clientes que están registrados pero nunca realizaron una compra.

SELECT
    clientes.nombre,
    clientes.email,
    clientes.fecha_registro
FROM clientes
LEFT JOIN ventas
    ON clientes.id_cliente = ventas.id_cliente
WHERE ventas.id_venta IS NULL;
--------------------------------------------------------------------------------------------------------------------
-- CONSULTA 3 - PRODUCTOS SIN VENTAS | Identifica los productos del catálogo que no tienen ninguna venta.

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

--------------------------------------------------------------------------------------------------------------------
-- CONSULTA 4 - CONSOLIDADO POR CANAL | La base no posee una columna de canal. Se crea el canal dentro de cada SELECT para poder utilizar UNION ALL.

SELECT
    ventas.fecha_venta AS fecha,
    ventas.cantidad * ventas.precio_unitario AS total,
    'Origen A' AS canal
FROM ventas
WHERE MOD(ventas.id_venta, 2) = 1

UNION ALL

SELECT
    ventas.fecha_venta AS fecha,
    ventas.cantidad * ventas.precio_unitario AS total,
    'Origen B' AS canal
FROM ventas
WHERE MOD(ventas.id_venta, 2) = 0;

--------------------------------------------------------------------------------------------------------------------
-- CONSOLIDADO TOTAL POR CANAL
--------------------------------------------------------------------------------------------------------------------

SELECT
    canal,
    SUM(total) AS total_facturado
FROM
(
    SELECT
        ventas.cantidad * ventas.precio_unitario AS total,
        'Origen A' AS canal
    FROM ventas
    WHERE MOD(ventas.id_venta, 2) = 1

    UNION ALL

    SELECT
        ventas.cantidad * ventas.precio_unitario AS total,
        'Origen B' AS canal
    FROM ventas
    WHERE MOD(ventas.id_venta, 2) = 0
) AS ventas_consolidadas
GROUP BY canal;
