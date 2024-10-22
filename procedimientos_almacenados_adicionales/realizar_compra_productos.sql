CREATE PROCEDURE realizar_compra (
    @p_id_compra VARCHAR(50),
    @p_fecha DATETIME,
    @p_total DECIMAL(10,2),
    @p_id_proveedor VARCHAR(50),
    @detalles_compra NVARCHAR(MAX) -- JSON con los detalles de la compra
)
AS
BEGIN
    BEGIN TRY
        -- Verificar si el proveedor existe
        IF NOT EXISTS (SELECT 1 FROM proveedor WHERE id_proveedor = @p_id_proveedor)
        BEGIN
            -- Si no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El proveedor especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Insertar la compra en la tabla 'compra'
        INSERT INTO compra (id_compra, fecha, total, id_proveedor)
        VALUES (@p_id_compra, @p_fecha, @p_total, @p_id_proveedor);

        -- Crear una tabla temporal para los detalles de la compra
        DECLARE @DetalleCompra TABLE (
            id_producto VARCHAR(50),
            cantidad INT,
            precio DECIMAL(10,2)
        );

        -- Parsear el JSON de detalles de compra y agregarlo a la tabla temporal
        INSERT INTO @DetalleCompra (id_producto, cantidad, precio)
        SELECT
            JSON_VALUE(value, '$.id_producto') AS id_producto,
            JSON_VALUE(value, '$.cantidad') AS cantidad,
            JSON_VALUE(value, '$.precio') AS precio
        FROM
            OPENJSON(@detalles_compra);

        -- Declarar una variable para el número de ítem en la compra
        DECLARE @ItemId INT;
        SELECT @ItemId = ISNULL(MAX(item), 0) + 1 FROM detalle_compra;
		print 'item id' + cast(@ItemId as nvarchar(10));

        -- Recorrer los detalles de la compra e insertar en la tabla 'detalle_compra'
        WHILE EXISTS (SELECT 1 FROM @DetalleCompra)
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
                @DetalleCompra;

            -- Verificar que el producto exista
            IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @IdProducto)
            BEGIN
                -- Si no existe el producto, lanzamos un error
                DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
                THROW 50002, @ErrorMessage2, 1;
            END

            -- Calcular el subtotal
            DECLARE @Subtotal DECIMAL(10,2) = @Cantidad * @Precio;

            -- Insertar el detalle de la compra en 'detalle_compra'
            INSERT INTO detalle_compra (item, cantidad, precio, subtotal, id_compra, id_producto)
            VALUES (@ItemId, @Cantidad, @Precio, @Subtotal, @p_id_compra, @IdProducto);

            -- Incrementar el número de ítem
            SET @ItemId = @ItemId + 1;

            -- Eliminar el registro procesado de la tabla temporal
            DELETE FROM @DetalleCompra WHERE id_producto = @IdProducto;
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
-- Ejecucion --
/*
DECLARE @detalles_compra NVARCHAR(MAX) = '[
    {"id_producto": "PROD001", "cantidad": 10, "precio": 50.00}, -- validar producto ID
    {"id_producto": "PROD001", "cantidad": 5, "precio": 20.00}
]';

DECLARE @fecha DATETIME = GETDATE();

EXEC dbo.realizar_compra
    @p_id_compra = 'COMP0103', -- manual
    @p_fecha = @fecha,
    @p_total = 600.00,
    @p_id_proveedor = 'PROV001',
    @detalles_compra = @detalles_compra;

*/