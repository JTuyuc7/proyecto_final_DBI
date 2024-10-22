DECLARE @fecha_inicio DATE = '2024-01-01'; -- cambiar fechas a conveniencia
DECLARE @fecha_fin DATE = '2024-12-31';

SELECT 
    p.id_producto AS 'ID Producto',
    p.titulo_es AS 'Nombre del Producto',
    SUM(dp.cantidad) AS 'Cantidad Vendida',
    SUM(dp.subtotal) AS 'Total de Ventas'
FROM 
    pedido ped
JOIN 
    detalle_pedido dp ON ped.id_pedido = dp.id_pedido
JOIN 
    producto p ON dp.id_producto = p.id_producto
WHERE 
    ped.fecha BETWEEN @fecha_inicio AND @fecha_fin  -- Filtrar por rango de fechas
GROUP BY 
    p.id_producto, p.titulo_es
ORDER BY 
    SUM(dp.cantidad) DESC;  -- Ordenar por cantidad vendida en orden descendente
