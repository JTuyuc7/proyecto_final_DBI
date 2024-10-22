SELECT 
    pc.id_pago AS 'ID Pago',
    pc.fecha_pago AS 'Fecha del Pago',
    pc.monto_pago AS 'Monto del Pago',
    pc.metodo_pago AS 'Método de Pago',
    c.id_cliente AS 'ID Cliente',
    per.nombres + ' ' + per.apellidos AS 'Nombre del Cliente',
    cred.id_credito AS 'ID Crédito',
    cred.monto_total AS 'Monto Total del Crédito',
    cred.monto_restante AS 'Monto Restante del Crédito'
FROM 
    pago_credito pc
JOIN 
    credito cred ON pc.id_credito = cred.id_credito
JOIN 
    cliente c ON cred.id_cliente = c.id_cliente
JOIN 
    persona per ON c.id_persona = per.id_persona

	-- WHERE c.id_cliente = 'CL001'  -- Filtrar por un cliente específico
	-- WHERE pc.fecha_pago BETWEEN '2024-10-01' AND '2024-10-31'  -- Pagos realizados en octubre de 2024
	WHERE pc.metodo_pago = 'Tarjeta de crédito'  -- Filtrar por método de pago

ORDER BY 
    pc.fecha_pago DESC;  -- Ordenar por la fecha del pago en orden descendente (del más reciente al más antiguo)
