SELECT 
    co.id_compra, 
    co.fecha AS FechaCompra, 
    p.nombre AS NombreProveedor, 
    co.total AS TotalCompra
FROM 
    compra co
INNER JOIN 
    proveedor p ON co.id_proveedor = p.id_proveedor
WHERE 
    co.fecha >= DATEADD(MONTH, -1, GETDATE())  -- Filtra por el último mes
ORDER BY 
    co.fecha DESC;
