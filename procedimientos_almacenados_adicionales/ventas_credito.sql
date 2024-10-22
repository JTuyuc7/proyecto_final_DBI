CREATE PROCEDURE registrar_venta_credito (
    @p_id_pedido VARCHAR(50),       -- ID del pedido
    @p_fecha DATETIME,              -- Fecha de la venta
    @p_total_pedido DECIMAL(10,2),  -- Total del pedido
    @p_forma_pago VARCHAR(50),      -- Forma de pago (en este caso 'Crédito')
    @p_id_cliente VARCHAR(50),      -- ID del cliente
    @p_reco_facturacion VARCHAR(255),-- Dirección de facturación
    @p_empresa_transporte VARCHAR(50),-- Empresa de transporte
    @p_costo_transporte DECIMAL(10,2),-- Costo del transporte
    @p_id_direccion VARCHAR(255),   -- Dirección de entrega
    @detalles_pedido NVARCHAR(MAX), -- JSON con los detalles del pedido (productos, cantidades, precios, etc.)
    @monto_total_credito DECIMAL(10,2), -- Monto total del crédito
    @monto_restante_credito DECIMAL(10,2), -- Monto restante del crédito
    @p_fecha_vencimiento DATETIME  -- Fecha de vencimiento del crédito
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos si el cliente existe
        IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        BEGIN
            -- Si no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El cliente especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Insertar el pedido en la tabla 'pedido'
        INSERT INTO pedido (
            id_pedido, fecha, total_pedido, forma_pago, pagado, entregado, 
            reco_facturacion, empresa_transporte, costo_transporte, id_cliente, 
            id_direccion, nro_documento_pago
        )
        VALUES (
            @p_id_pedido, @p_fecha, @p_total_pedido, @p_forma_pago, 0, -- No pagado
            0, -- No entregado
            @p_reco_facturacion, @p_empresa_transporte, @p_costo_transporte, 
            @p_id_cliente, @p_id_direccion, NULL
        );

        -- Parsear el JSON de detalles del pedido y agregarlo a la tabla temporal
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

        -- Declarar una variable para el número de ítem en el pedido
        DECLARE @ItemId INT;
		SELECT @ItemId = ISNULL(MAX(item), 0) + 1 FROM detalle_pedido;

        -- Recorrer los detalles del pedido e insertar en la tabla 'detalle_pedido'
        WHILE EXISTS (SELECT 1 FROM @DetallePedido)
        BEGIN
            DECLARE @IdProducto VARCHAR(50);
            DECLARE @Cantidad INT;
            DECLARE @Precio DECIMAL(10,2);

            -- Obtener los valores del primer registro de la tabla temporal
            SELECT TOP 1
                @IdProducto = id_producto,
                @Cantidad = cantidad,
                @Precio = precio
            FROM
                @DetallePedido;

            -- Verificar que el producto exista
            IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @IdProducto)
            BEGIN
                -- Si no existe el producto, lanzamos un error
                DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
                THROW 50002, @ErrorMessage2, 1;
            END

            -- Calcular el subtotal
            DECLARE @Subtotal DECIMAL(10,2) = @Cantidad * @Precio;

            -- Insertar el detalle del pedido en 'detalle_pedido'
            INSERT INTO detalle_pedido (item, cantidad, precio, subtotal, id_pedido, id_producto)
            VALUES (@ItemId, @Cantidad, @Precio, @Subtotal, @p_id_pedido, @IdProducto);

            -- Incrementar el número de ítem
            SET @ItemId = @ItemId + 1;

            -- Eliminar el registro procesado de la tabla temporal
            DELETE FROM @DetallePedido WHERE id_producto = @IdProducto;
        END

        -- Registrar el crédito en la tabla 'credito'
        INSERT INTO credito (id_credito, id_cliente, monto_total, monto_restante, fecha_inicio, fecha_vencimiento, id_estado_credito)
        VALUES (NEWID(), @p_id_cliente, @monto_total_credito, @monto_restante_credito, @p_fecha, @p_fecha_vencimiento, 1); -- Estado 1: 'Aprobado'

    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage1 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage1, 1;
    END CATCH;
END;
-- Ejecucion --
/*
DECLARE @detalles_pedido NVARCHAR(MAX) = '[ 
    {"id_producto": "PROD001", "cantidad": 2, "precio": 500.00}, 
    {"id_producto": "PROD001", "cantidad": 1, "precio": 300.00} 
]';

DECLARE @fecha DATETIME = GETDATE();

EXEC dbo.registrar_venta_credito
    @p_id_pedido = 'P0021', -- Dinamico 
    @p_fecha = @fecha,
    @p_total_pedido = 1300.00,
    @p_forma_pago = 'Crédito',
    @p_id_cliente = 'CL001',
    @p_reco_facturacion = 'Direccion Facturacion 123',
    @p_empresa_transporte = 'DHL',
    @p_costo_transporte = 50.00,
    @p_id_direccion = 'Direccion Entrega 456',
    @detalles_pedido = @detalles_pedido,
    @monto_total_credito = 1300.00,
    @monto_restante_credito = 1300.00,
    @p_fecha_vencimiento = '2024-12-31';

*/