SELECT 
    p.id_producto AS 'ID Producto',
    p.titulo_es AS 'Nombre del Producto',
    p.precio AS 'Precio',
    p.existencia AS 'Existencias'
FROM 
    producto p
WHERE 
    p.es_perecedero = 1;
