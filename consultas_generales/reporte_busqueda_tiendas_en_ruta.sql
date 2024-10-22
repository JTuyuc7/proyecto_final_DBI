SELECT 
    r.id_ruta AS 'ID Ruta',
    r.nombre AS 'Nombre de la Ruta',
    r.descripcion AS 'Descripción de la Ruta',
    suc.id_sucursal AS 'ID Sucursal',
    suc.nombre AS 'Nombre de la Sucursal',
    suc.direccion AS 'Dirección de la Sucursal',
    suc.telefono AS 'Teléfono de la Sucursal',
    suc.email AS 'Email de la Sucursal',
    cs.nombre AS 'Ciudad de la Sucursal',
    p.nombre AS 'País'
FROM 
    distribucion d
JOIN 
    ruta r ON d.id_ruta = r.id_ruta
JOIN 
    sucursal suc ON d.id_sucursal_destino = suc.id_sucursal
JOIN 
    ciudad_sucursal cs ON suc.id_ciudad = cs.id_ciudad
JOIN 
    pais p ON cs.id_pais = p.id_pais

	--WHERE r.id_ruta = 'RUTA001'  -- Filtrar por una ruta específica
	--WHERE cs.nombre = 'Ciudad XYZ'  -- Filtrar por ciudad de la sucursal
	WHERE p.nombre = 'Mexico'  -- Filtrar por país

ORDER BY 
    r.id_ruta, suc.id_sucursal;  -- Ordenar por ruta y luego por sucursal
