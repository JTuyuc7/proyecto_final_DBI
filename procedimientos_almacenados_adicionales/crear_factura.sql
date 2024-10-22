CREATE PROCEDURE crear_factura (
    @p_id_factura VARCHAR(50),
    @p_fecha DATE,
    @p_total DECIMAL(10,2),
    @p_id_cliente VARCHAR(50),
    @detalles_factura NVARCHAR(MAX)  -- JSON con los detalles de la factura
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

        -- Insertamos la cabecera de la factura en la tabla 'factura'
        INSERT INTO factura (id_factura, fecha, total, id_cliente)
        VALUES (@p_id_factura, @p_fecha, @p_total, @p_id_cliente);

        -- Parseamos el JSON de detalles de factura
        DECLARE @DetalleFactura TABLE (
            id_producto VARCHAR(50),
            cantidad INT,
            precio DECIMAL(10,2)
        );

        INSERT INTO @DetalleFactura (id_producto, cantidad, precio)
        SELECT
            JSON_VALUE(value, '$.id_producto') AS id_producto,
            JSON_VALUE(value, '$.cantidad') AS cantidad,
            JSON_VALUE(value, '$.precio') AS precio
        FROM
            OPENJSON(@detalles_factura);

        -- Obtener el valor máximo de 'item' para este 'id_factura'
        DECLARE @ItemId INT;
        SELECT @ItemId = ISNULL(MAX(item), 0) + 1 FROM detalle_factura;

        -- Iteramos por los registros de la tabla temporal
        WHILE EXISTS (SELECT 1 FROM @DetalleFactura)
        BEGIN
            DECLARE @IdProducto VARCHAR(50);
            DECLARE @Cantidad INT;
            DECLARE @Precio DECIMAL(10,2);

            SELECT TOP 1
                @IdProducto = id_producto,
                @Cantidad = cantidad,
                @Precio = precio
            FROM
                @DetalleFactura;

            -- Verificamos que el producto exista
            IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @IdProducto)
            BEGIN
				DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
				THROW 50001, @ErrorMessage2, 1;
            END

            -- Calculamos el subtotal
            DECLARE @Subtotal DECIMAL(10,2) = @Cantidad * @Precio;

            -- Insertamos el detalle en 'detalle_factura'
            INSERT INTO detalle_factura (item, id_factura, id_producto, cantidad, precio, subtotal)
            VALUES (@ItemId, @p_id_factura, @IdProducto, @Cantidad, @Precio, @Subtotal);

            -- Incrementamos el contador de ítems
            SET @ItemId = @ItemId + 1;

            -- Eliminamos el registro procesado de la tabla temporal
            DELETE FROM @DetalleFactura WHERE id_producto = @IdProducto;
        END
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error real y lo lanzamos
        DECLARE @ErrorMessage NVARCHAR(4000) = 'Error al intentar insertar la factura: ';
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
DECLARE @detalles_factura NVARCHAR(MAX) = N'[
    {"id_producto": "PROD001", "cantidad": 2, "precio": 500.00},
    {"id_producto": "PROD002", "cantidad": 1, "precio": 300.00}
]';

EXEC dbo.crear_factura 
    @p_id_factura = 'F001',
    @p_fecha = '2024-10-16',
    @p_total = 1300.00,
    @p_id_cliente = 'CL001',
    @detalles_factura = @detalles_factura;

*/