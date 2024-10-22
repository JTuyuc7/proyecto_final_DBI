SELECT 
    p.id_pedido AS 'ID Pedido',
    p.fecha AS 'Fecha del Pedido',
    p.total_pedido AS 'Total del Pedido',
    p.forma_pago AS 'Forma de Pago',
    p.pagado AS 'Pagado',  -- 1 = Pagado, 0 = No Pagado
    p.entregado AS 'Entregado',  -- 1 = Entregado, 0 = No Entregado
    c.id_cliente AS 'ID Cliente',
    per.nombres + ' ' + per.apellidos AS 'Nombre del Cliente',
    p.empresa_transporte AS 'Empresa de Transporte',
    p.costo_transporte AS 'Costo de Transporte',
    p.reco_facturacion AS 'Dirección de Facturación'
FROM 
    pedido p
JOIN 
    cliente c ON p.id_cliente = c.id_cliente
JOIN 
    persona per ON c.id_persona = per.id_persona
	-- WHERE c.id_cliente = 'CL001'  -- Filtrar por un cliente específico
	-- WHERE p.entregado = 1  -- Solo mostrar pedidos entregados
	-- WHERE p.fecha BETWEEN '2024-10-01' AND '2024-10-31'  -- Filtrar por pedidos realizados en octubre de 2024
	WHERE p.pagado = 1  -- Solo mostrar pedidos pagados

ORDER BY 
    p.fecha DESC;  -- Ordenar por la fecha del pedido en orden descendente (del más reciente al más antiguo)
