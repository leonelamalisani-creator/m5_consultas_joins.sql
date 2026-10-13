
-- M4 - CONSULTAS DE NEGOCIO
-- Base de datos: Ventas_Tech_DBB
-- Tabla utilizada: ventas

USE Ventas_Tech_DB;
GO

-- ============================================================
-- CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
-- Total facturado, cantidad de pedidos y ticket promedio.
-- ============================================================

SELECT
    MONTH(ventas.fecha_venta) AS mes,
    SUM(ventas.cantidad * ventas.precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(ventas.cantidad * ventas.precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(ventas.fecha_venta)
ORDER BY MONTH(ventas.fecha_venta);


-- ============================================================
-- CONSULTA 2 - RANKING DE PRODUCTOS
-- Top 5 productos por total facturado.
-- Muestra unidades vendidas y total generado.
-- ============================================================

SELECT TOP 5
    ventas.id_producto,
    SUM(ventas.cantidad) AS unidades_vendidas,
    SUM(ventas.cantidad * ventas.precio_unitario) AS total_facturado
FROM ventas
GROUP BY ventas.id_producto
ORDER BY total_facturado DESC;


-- ============================================================
-- CONSULTA 3 - CLIENTES RECURRENTES
-- Clientes con más de un pedido.
-- Muestra cantidad de pedidos y total gastado.
-- ============================================================

SELECT
    ventas.id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(ventas.cantidad * ventas.precio_unitario) AS total_gastado
FROM ventas
GROUP BY ventas.id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;


-- ============================================================
-- CONSULTA 4 - MESES POR ENCIMA O POR DEBAJO DEL PROMEDIO
-- Compara la facturación mensual con el promedio general.
-- ============================================================

WITH totales_mensuales AS
(
    SELECT
        MONTH(ventas.fecha_venta) AS mes,
        SUM(ventas.cantidad * ventas.precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(ventas.fecha_venta)
)
SELECT
    totales_mensuales.mes,
    totales_mensuales.total_facturado,
    AVG(totales_mensuales.total_facturado) OVER () AS promedio_mensual,
    CASE
        WHEN totales_mensuales.total_facturado >
             AVG(totales_mensuales.total_facturado) OVER ()
            THEN 'Por encima'
        WHEN totales_mensuales.total_facturado <
             AVG(totales_mensuales.total_facturado) OVER ()
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_promedio
FROM totales_mensuales
ORDER BY totales_mensuales.mes;


-- ============================================================
-- BLOQUE DE CIERRE - TRES HALLAZGOS DEL ANÁLISIS
-- ============================================================

-- 1. El producto con id_producto 1 genera la mayor facturación,
--    con un total de 3600.

-- 2. El producto con id_producto 2 registra la mayor cantidad
--    de unidades vendidas, con 13 unidades.

-- 3. Los cinco clientes registrados en las ventas realizaron
--    dos pedidos cada uno, por lo que todos son recurrentes.
