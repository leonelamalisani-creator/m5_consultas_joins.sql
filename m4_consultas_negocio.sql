
-- M4 - CONSULTAS DE NEGOCIO
-- Base de datos: Ventas_Tech_DBB
-- Tabla utilizada: ventas

USE Ventas_Tech_DBB;

-----------------------------------------------------------------------------------------------------------------------
-- CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
-- Total facturado, cantidad de pedidos y ticket promedio,
-- agrupados por mes.

SELECT
    EXTRACT (MONTH FROM fecha_venta AS) mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;

-----------------------------------------------------------------------------------------------------------------------

-- CONSULTA 2 - RANKING DE PRODUCTOS
-- Top 5 de productos por total facturado.

SELECT
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;

-----------------------------------------------------------------------------------------------------------------------
-- CONSULTA 3 - CLIENTES RECURRENTES
-- Clientes que realizaron más de un pedido.

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;

-----------------------------------------------------------------------------------------------------------------------
-- CONSULTA 4 - MESES POR ENCIMA / POR DEBAJO DEL PROMEDIO
-- Compara la facturación de cada mes contra el promedio
-- de facturación mensual.

WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)

SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(total_facturado)
            FROM facturacion_mensual
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;
-----------------------------------------------------------------------------------------------------------------------
-- BLOQUE DE CIERRE - HALLAZGOS
-----------------------------------------------------------------------------------------------------------------------

-- 1. El producto 1 fue el que mayor facturación generó, alcanzando un total de $3600.

-- 2. Todos los clientes realizaron más de un pedido, por lo que todos en la base son recurrentes.

-- 3. Marzo concentró el 100% de las ventas registradas, ya que todas las operaciones de la base corresponden al mes 3.
