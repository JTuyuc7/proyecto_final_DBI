DECLARE @fecha_inicio DATE = '2024-01-01';
DECLARE @fecha_fin DATE = '2024-12-31';

SELECT 
    r.id_ruta AS 'ID Ruta',
    r.nombre AS 'Nombre de la Ruta',
    r.descripcion AS 'Descripción de la Ruta',
    d.id_producto AS 'ID Producto',
    p.titulo_es AS 'Nombre del Producto',
    d.cantidad AS 'Cantidad Distribuida',
    d.fecha_salida AS 'Fecha de Salida',
    d.fecha_entrega AS 'Fecha de Entrega',
    b.nombre AS 'Bodega Origen',
    s.nombre AS 'Sucursal Destino'
FROM 
    distribucion d
JOIN 
    ruta r ON d.id_ruta = r.id_ruta
JOIN 
    producto p ON d.id_producto = p.id_producto
JOIN 
    bodega b ON d.id_bodega_origen = b.id_bodega
JOIN 
    sucursal s ON d.id_sucursal_destino = s.id_sucursal
WHERE 
    d.fecha_salida BETWEEN @fecha_inicio AND @fecha_fin
ORDER BY 
    r.nombre, d.fecha_salida DESC;
