DECLARE @id_bodega VARCHAR(50) = 'BOD001';

SELECT 
    p.id_producto AS 'ID Producto',
    p.titulo_es AS 'Nombre del Producto',
    ib.cantidad AS 'Cantidad en Bodega',
    b.nombre AS 'Nombre de Bodega',
    b.direccion AS 'Dirección de Bodega'
FROM 
    inventario_bodega ib
JOIN 
    producto p ON ib.id_producto = p.id_producto
JOIN 
    bodega b ON ib.id_bodega = b.id_bodega
WHERE 
    b.id_bodega = @id_bodega
ORDER BY 
    p.titulo_es;
