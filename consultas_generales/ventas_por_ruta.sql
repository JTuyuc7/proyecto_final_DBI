DECLARE @fecha_inicio DATE = '2024-01-01';
DECLARE @fecha_fin DATE = '2024-12-31';

SELECT 
    r.id_ruta AS 'ID Ruta',
    r.nombre AS 'Nombre de la Ruta',
    p.id_producto AS 'ID Producto',
    p.titulo_es AS 'Nombre del Producto',
    SUM(dp.cantidad) AS 'Cantidad Vendida',
    SUM(dp.subtotal) AS 'Total Vendido',
    d.fecha_entrega AS 'Fecha de Entrega',
    c.id_cliente AS 'ID Cliente',
    c.id_persona AS 'ID Persona',
    per.nombres + ' ' + per.apellidos AS 'Nombre del Cliente'
FROM 
    distribucion d
JOIN 
    ruta r ON d.id_ruta = r.id_ruta
JOIN 
    detalle_pedido dp ON dp.id_producto = d.id_producto
JOIN 
    pedido pe ON pe.id_pedido = dp.id_pedido
JOIN 
    producto p ON p.id_producto = dp.id_producto
JOIN 
    cliente c ON pe.id_cliente = c.id_cliente
JOIN 
    persona per ON c.id_persona = per.id_persona
WHERE 
    d.fecha_entrega BETWEEN @fecha_inicio AND @fecha_fin
GROUP BY 
    r.id_ruta, r.nombre, p.id_producto, p.titulo_es, d.fecha_entrega, c.id_cliente, c.id_persona, per.nombres, per.apellidos
ORDER BY 
    r.nombre, d.fecha_entrega DESC;
