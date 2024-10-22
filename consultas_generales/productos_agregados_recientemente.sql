DECLARE @id_bodega nvarchar(50) = 'BOD001'

SELECT 
    p.id_producto, 
    p.titulo_es AS NombreProducto, 
    b.nombre AS NombreBodega, 
    ib.cantidad AS CantidadDisponible, 
    ib.fecha_actualizacion AS FechaActualizacion
FROM 
    inventario_bodega ib
INNER JOIN 
    producto p ON ib.id_producto = p.id_producto
INNER JOIN 
    bodega b ON ib.id_bodega = b.id_bodega
WHERE 
    b.id_bodega = @id_bodega  -- Puedes cambiar el ID de la bodega
ORDER BY 
    ib.fecha_actualizacion DESC;
