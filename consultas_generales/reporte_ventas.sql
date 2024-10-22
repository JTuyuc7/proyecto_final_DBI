DECLARE @fecha_inicio DATE = '2024-01-01'; -- cambiar fechas a conveniencia
DECLARE @fecha_fin DATE = '2024-12-31';

SELECT 
    p.id_pedido AS 'ID Pedido',
    p.fecha AS 'Fecha de Venta',
    p.total_pedido AS 'Total Venta',
    c.id_cliente AS 'ID Cliente',
    per.nombres + ' ' + per.apellidos AS 'Nombre del Cliente',
    dp.id_producto AS 'ID Producto',
    prod.titulo_es AS 'Nombre del Producto',
    dp.cantidad AS 'Cantidad Vendida',
    dp.precio AS 'Precio Unitario',
    dp.subtotal AS 'Subtotal'
FROM 
    pedido p
JOIN 
    cliente c ON p.id_cliente = c.id_cliente
JOIN 
    persona per ON c.id_persona = per.id_persona
JOIN 
    detalle_pedido dp ON p.id_pedido = dp.id_pedido
JOIN 
    producto prod ON dp.id_producto = prod.id_producto
WHERE 
    p.fecha BETWEEN @fecha_inicio AND @fecha_fin
ORDER BY 
    p.fecha DESC, p.id_pedido;
