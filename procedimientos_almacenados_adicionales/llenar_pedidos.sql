CREATE PROCEDURE llenar_pedido (
    @p_id_pedido VARCHAR(50),
    @p_fecha DATE,
    @p_total_pedido DECIMAL(10,2),
    @p_forma_pago VARCHAR(50),
    @p_pagado BIT,
    @p_entregado BIT,
    @p_reco_facturacion VARCHAR(255),
    @p_empresa_transporte VARCHAR(50),
    @p_costo_transporte DECIMAL(10,2),
    @p_id_cliente VARCHAR(50),
    @p_id_direccion VARCHAR(255),
    @p_nro_documento_pago VARCHAR(50),
    @detalles_pedido NVARCHAR(MAX)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el cliente exista
        IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        BEGIN
			DECLARE @ErrorMessage1 NVARCHAR(4000) = 'El cliente especificado no existe';
            THROW 50001, @ErrorMessage1, 1;
        END

        -- Insertamos el pedido en la tabla 'pedido'
        INSERT INTO pedido (
            id_pedido, fecha, total_pedido, forma_pago, pagado, entregado, 
            reco_facturacion, empresa_transporte, costo_transporte, id_cliente, 
            id_direccion, nro_documento_pago
        )
        VALUES (
            @p_id_pedido, @p_fecha, @p_total_pedido, @p_forma_pago, @p_pagado, 
            @p_entregado, @p_reco_facturacion, @p_empresa_transporte, @p_costo_transporte, 
            @p_id_cliente, @p_id_direccion, @p_nro_documento_pago
        );

        -- Parseamos el JSON de detalles de pedido
        DECLARE @DetallePedido TABLE (
            id_producto VARCHAR(50),
            cantidad INT,
            precio DECIMAL(10,2)
        );

        INSERT INTO @DetallePedido (id_producto, cantidad, precio)
        SELECT
            JSON_VALUE(value, '$.id_producto') AS id_producto,
            JSON_VALUE(value, '$.cantidad') AS cantidad,
            JSON_VALUE(value, '$.precio') AS precio
        FROM
            OPENJSON(@detalles_pedido);

        -- Obtener el valor máximo de 'item' para este 'id_pedido'
        DECLARE @ItemId INT;
        SELECT @ItemId = ISNULL(MAX(item), 0) + 1 FROM detalle_pedido;

        -- Imprimir el valor inicial de @ItemId
        PRINT 'Valor inicial de ItemId: ' + CAST(@ItemId AS NVARCHAR(10));

        -- Iteramos por los registros de la tabla temporal
        WHILE EXISTS (SELECT 1 FROM @DetallePedido)
        BEGIN
            DECLARE @IdProducto VARCHAR(50);
            DECLARE @Cantidad INT;
            DECLARE @Precio DECIMAL(10,2);

            SELECT TOP 1
                @IdProducto = id_producto,
                @Cantidad = cantidad,
                @Precio = precio
            FROM
                @DetallePedido;

            -- Verificamos que el producto exista
            IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @IdProducto)
            BEGIN
				DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
				THROW 50001, @ErrorMessage2, 1;
            END

            -- Calculamos el subtotal
            DECLARE @Subtotal DECIMAL(10,2) = @Cantidad * @Precio;

            -- Imprimir el valor actual de @ItemId antes de insertar
            PRINT 'Insertando detalle con ItemId: ' + CAST(@ItemId AS NVARCHAR(10));

            -- Insertamos el detalle en 'detalle_pedido'
            INSERT INTO detalle_pedido (item, cantidad, precio, subtotal, id_pedido, id_producto)
            VALUES (@ItemId, @Cantidad, @Precio, @Subtotal, @p_id_pedido, @IdProducto);

            -- Incrementamos el contador de ítems
            SET @ItemId = @ItemId + 1;

            -- Eliminamos el registro procesado de la tabla temporal
            DELETE FROM @DetallePedido WHERE id_producto = @IdProducto;
        END
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error real y lo lanzamos
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
		DECLARE @ERRORMESSAGEPEDIDO NVARCHAR(4000) = 'Error al intentar insertar el pedido: ';

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage, 1;
    END CATCH;
END;


-- ejecucion --
/*
DECLARE @detalles_pedido NVARCHAR(MAX) = N'[
		-- asegurar que el producto ID exista --
    {"id_producto": "PROD001", "cantidad": 2, "precio": 500.00},
    {"id_producto": "PROD001", "cantidad": 1, "precio": 300.00}
]';

EXEC dbo.llenar_pedido 
		-- Cambiar el pedido ID --
    @p_id_pedido = 'P0015',
    @p_fecha = '2024-10-16',
    @p_total_pedido = 1300.00,
    @p_forma_pago = 'Tarjeta de crédito',
    @p_pagado = 1,
    @p_entregado = 0,
    @p_reco_facturacion = 'Direccion 123',
    @p_empresa_transporte = 'DHL',
    @p_costo_transporte = 50.00,
    @p_id_cliente = 'CL001',
    @p_id_direccion = 'Direccion de entrega 456',
    @p_nro_documento_pago = '123456',
    @detalles_pedido = @detalles_pedido;

*/