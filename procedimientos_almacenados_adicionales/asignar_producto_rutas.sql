CREATE PROCEDURE asignar_producto_a_ruta (
    @p_id_ruta VARCHAR(50),            -- ID de la ruta
    @p_id_producto VARCHAR(50),        -- ID del producto
    @p_cantidad INT,                   -- Cantidad del producto
    @p_fecha_salida DATETIME,          -- Fecha de salida del producto
    @p_fecha_entrega DATETIME,         -- Fecha estimada de entrega
    @p_id_bodega_origen VARCHAR(50),   -- ID de la bodega de origen
    @p_id_sucursal_destino VARCHAR(50) -- ID de la sucursal de destino
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos si la ruta existe
        IF NOT EXISTS (SELECT 1 FROM ruta WHERE id_ruta = @p_id_ruta)
        BEGIN
            -- Si la ruta no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'La ruta especificada no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificamos si el producto existe
        IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si el producto no existe, lanzamos un error
            DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
            THROW 50002, @ErrorMessage2, 1;
        END

        -- Verificamos si la bodega de origen existe
        IF NOT EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega_origen)
        BEGIN
            -- Si la bodega no existe, lanzamos un error
            DECLARE @ErrorMessage3 NVARCHAR(4000) = 'La bodega de origen especificada no existe';
            THROW 50003, @ErrorMessage3, 1;
        END

        -- Verificamos si la sucursal de destino existe
        IF NOT EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal_destino)
        BEGIN
            -- Si la sucursal no existe, lanzamos un error
            DECLARE @ErrorMessage4 NVARCHAR(4000) = 'La sucursal de destino especificada no existe';
            THROW 50004, @ErrorMessage4, 1;
        END

        -- Insertar la asignación en la tabla 'distribucion'
        INSERT INTO distribucion (
            id_distribucion, id_ruta, id_producto, cantidad, fecha_salida, 
            fecha_entrega, estado, id_bodega_origen, id_sucursal_destino
        )
        VALUES (
            NEWID(), @p_id_ruta, @p_id_producto, @p_cantidad, @p_fecha_salida, 
            @p_fecha_entrega, 'Asignado', @p_id_bodega_origen, @p_id_sucursal_destino
        );

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
DECLARE @fecha_salida DATETIME = GETDATE();
DECLARE @fecha_entrega DATETIME = DATEADD(DAY, 3, @fecha_salida);

EXEC dbo.asignar_producto_a_ruta
    @p_id_ruta = 'RUTA001',
    @p_id_producto = 'PROD001',
    @p_cantidad = 50,
    @p_fecha_salida = @fecha_salida,
    @p_fecha_entrega = @fecha_entrega,
    @p_id_bodega_origen = 'BOD001',
    @p_id_sucursal_destino = 'SUC001';

*/