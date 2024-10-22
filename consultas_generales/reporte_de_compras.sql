DECLARE @fecha_inicio DATE = '2024-01-01';  -- Cambiar a la fecha de inicio deseada
DECLARE @fecha_fin DATE = '2024-12-31';     -- Cambiar a la fecha de fin deseada
DECLARE @id_proveedor VARCHAR(50) = 'PROV001';  -- Cambiar al ID del proveedor deseado

SELECT 
    c.id_compra AS 'ID Compra',
    c.fecha AS 'Fecha de Compra',
    c.total AS 'Total Compra',
    p.id_proveedor AS 'ID Proveedor',
    p.nombre AS 'Nombre del Proveedor',
    dc.id_producto AS 'ID Producto',
    prod.titulo_es AS 'Nombre del Producto',
    dc.cantidad AS 'Cantidad Comprada',
    dc.precio AS 'Precio Unitario',
    dc.subtotal AS 'Subtotal'
FROM 
    compra c
JOIN 
    proveedor p ON c.id_proveedor = p.id_proveedor
JOIN 
    detalle_compra dc ON c.id_compra = dc.id_compra
JOIN 
    producto prod ON dc.id_producto = prod.id_producto
WHERE 
    c.fecha BETWEEN @fecha_inicio AND @fecha_fin
    AND p.id_proveedor = @id_proveedor
ORDER BY 
    c.fecha DESC;
