SELECT 
    c.id_cliente, 
    p.apellidos + ' ' + p.nombres AS NombreCompleto, 
    COUNT(pe.id_pedido) AS NumeroDePedidos
FROM 
    cliente c
INNER JOIN 
    persona p ON c.id_persona = p.id_persona
INNER JOIN 
    pedido pe ON c.id_cliente = pe.id_cliente
GROUP BY 
    c.id_cliente, p.apellidos, p.nombres
ORDER BY 
    NumeroDePedidos DESC;
