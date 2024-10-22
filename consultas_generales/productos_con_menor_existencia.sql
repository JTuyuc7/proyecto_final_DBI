SELECT 
    p.id_producto, 
    p.titulo_es AS NombreProducto, 
    SUM(ib.cantidad) AS CantidadTotal
FROM 
    inventario_bodega ib
INNER JOIN 
    producto p ON ib.id_producto = p.id_producto
GROUP BY 
    p.id_producto, p.titulo_es
HAVING 
    SUM(ib.cantidad) <= 10  -- Puedes ajustar el umbral de cantidad
ORDER BY 
    CantidadTotal ASC;
