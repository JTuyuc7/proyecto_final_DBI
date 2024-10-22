CREATE TABLE desperdicio_producto (
    id_desperdicio INT PRIMARY KEY,
    id_producto VARCHAR(50),
    cantidad INT,
    fecha DATETIME
);

SELECT 
    p.id_producto AS 'ID Producto',
    p.titulo_es AS 'Nombre del Producto',
    SUM(desp.cantidad) AS 'Cantidad Desperdiciada'
FROM 
    producto p
JOIN 
    desperdicio_producto desp ON p.id_producto = desp.id_producto
WHERE 
    desp.fecha BETWEEN '2024-01-01' AND '2024-12-31'  -- Filtrar por rango de fechas
GROUP BY 
    p.id_producto, p.titulo_es
ORDER BY 
    SUM(desp.cantidad) DESC;  -- Ordenar por cantidad desperdiciada en orden descendente
