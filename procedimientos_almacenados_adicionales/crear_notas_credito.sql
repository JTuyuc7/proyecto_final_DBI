CREATE PROCEDURE crear_nota_credito (
    @p_id_nota_credito VARCHAR(50),       -- ID de la nota de crédito
    @p_id_factura VARCHAR(50),            -- ID de la factura a la que está asociada la nota de crédito
    @p_fecha DATETIME,                    -- Fecha de la emisión de la nota de crédito
    @p_monto_total DECIMAL(10,2),         -- Monto total de la nota de crédito
    @p_razon NVARCHAR(255),               -- Razón de la nota de crédito
    @detalles_nota_credito NVARCHAR(MAX)  -- JSON con los detalles del crédito (productos, cantidades, precios, etc.)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos si la factura existe
        IF NOT EXISTS (SELECT 1 FROM factura WHERE id_factura = @p_id_factura)
        BEGIN
            -- Si no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'La factura especificada no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Insertamos la nota de crédito en la tabla 'nota_credito'
        INSERT INTO nota_credito (
            id_nota_credito, id_factura, fecha, monto_total, razon
        )
        VALUES (
            @p_id_nota_credito, @p_id_factura, @p_fecha, @p_monto_total, @p_razon
        );

        -- Crear una tabla temporal para los detalles de la nota de crédito
        DECLARE @DetalleCredito TABLE (
            id_producto VARCHAR(50),
            cantidad INT,
            precio DECIMAL(10,2)
        );

        -- Parsear el JSON de detalles de la nota de crédito y agregarlo a la tabla temporal
        INSERT INTO @DetalleCredito (id_producto, cantidad, precio)
        SELECT
            JSON_VALUE(value, '$.id_producto') AS id_producto,
            JSON_VALUE(value, '$.cantidad') AS cantidad,
            JSON_VALUE(value, '$.precio') AS precio
        FROM
            OPENJSON(@detalles_nota_credito);

        -- Declarar una variable para el número de ítem en la nota de crédito
        DECLARE @ItemId INT = 1;

        -- Iterar por los registros de la tabla temporal
        WHILE EXISTS (SELECT 1 FROM @DetalleCredito)
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
                @DetalleCredito;

            -- Verificar que el producto exista
            IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @IdProducto)
            BEGIN
                -- Si no existe el producto, lanzamos un error
                DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
                THROW 50002, @ErrorMessage2, 1;
            END

            -- Insertar el detalle de la nota de crédito
            INSERT INTO detalle_nota_credito (item, id_nota_credito, id_producto, cantidad, precio)
            VALUES (@ItemId, @p_id_nota_credito, @IdProducto, @Cantidad, @Precio);

            -- Incrementar el número de ítem
            SET @ItemId = @ItemId + 1;

            -- Eliminar el registro procesado de la tabla temporal
            DELETE FROM @DetalleCredito WHERE id_producto = @IdProducto;
        END
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
-- Ejecucion (PENDIENTE) --
/*
DECLARE @detalles_nota_credito NVARCHAR(MAX) = '[
    {"id_producto": "PROD001", "cantidad": 2, "precio": 100.00},
    {"id_producto": "PROD002", "cantidad": 1, "precio": 50.00}
]';

DECLARE @fecha DATETIME = GETDATE();

EXEC dbo.crear_nota_credito
    @p_id_nota_credito = 'NC001',
    @p_id_factura = 'FACT001',
    @p_fecha = @fecha,
    @p_monto_total = 250.00,
    @p_razon = 'Devolución parcial por producto defectuoso',
    @detalles_nota_credito = @detalles_nota_credito;

*/