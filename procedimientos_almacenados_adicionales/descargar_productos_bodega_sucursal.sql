CREATE PROCEDURE descargar_producto (
    @p_id_producto VARCHAR(50),
    @p_cantidad INT,
    @p_id_bodega VARCHAR(50) = NULL,   -- Opción para bodega
    @p_id_sucursal VARCHAR(50) = NULL, -- Opción para sucursal
    @p_fecha_actualizacion DATETIME
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el producto exista
        IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El producto especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Si se especifica bodega, realizamos la descarga de bodega
        IF @p_id_bodega IS NOT NULL
        BEGIN
            -- Verificamos que haya suficiente cantidad en la bodega
            IF EXISTS (SELECT 1 FROM inventario_bodega WHERE id_producto = @p_id_producto AND id_bodega = @p_id_bodega AND cantidad >= @p_cantidad)
            BEGIN
                -- Actualizamos la cantidad del producto en la bodega
                UPDATE inventario_bodega
                SET cantidad = cantidad - @p_cantidad, fecha_actualizacion = @p_fecha_actualizacion
                WHERE id_producto = @p_id_producto AND id_bodega = @p_id_bodega;
            END
            ELSE
            BEGIN
                DECLARE @ErrorMessage3 NVARCHAR(4000) = 'Cantidad insuficiente en la bodega';
                THROW 50002, @ErrorMessage3, 1;
            END
        END

        -- Si se especifica sucursal, realizamos la descarga de sucursal
        IF @p_id_sucursal IS NOT NULL
        BEGIN
            -- Verificamos que haya suficiente cantidad en la sucursal
            IF EXISTS (SELECT 1 FROM inventario_sucursal WHERE id_producto = @p_id_producto AND id_sucursal = @p_id_sucursal AND cantidad >= @p_cantidad)
            BEGIN
                -- Actualizamos la cantidad del producto en la sucursal
                UPDATE inventario_sucursal
                SET cantidad = cantidad - @p_cantidad, fecha_actualizacion = @p_fecha_actualizacion
                WHERE id_producto = @p_id_producto AND id_sucursal = @p_id_sucursal;
            END
            ELSE
            BEGIN
                DECLARE @ErrorMessage1 NVARCHAR(4000) = 'Cantidad insuficiente en la sucursal';
                THROW 50002, @ErrorMessage1, 1;
            END
        END

    END TRY
    BEGIN CATCH
        -- Capturamos y lanzamos cualquier error que ocurra
        DECLARE @ErrorMessage2 NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 50000, @ErrorMessage2, 1;
    END CATCH
END;
-- Ejecucion --
/*

DECLARE @fecha_actualizacion DATETIME = GETDATE();

-- Ejecutar procedimiento para descargar producto de la bodega
EXEC dbo.descargar_producto 
    @p_id_producto = 'PROD001',
    @p_cantidad = 20,
    @p_id_bodega = 'BOD001',   -- Indicamos la bodega
    @p_fecha_actualizacion = @fecha_actualizacion;


-- Ejecutar procedimiento para descargar producto de la sucursal
EXEC dbo.descargar_producto 
    @p_id_producto = 'PROD001',
    @p_cantidad = 15,
    @p_id_sucursal = 'SUC001', -- Indicamos la sucursal
    @p_fecha_actualizacion = @fecha_actualizacion;


*/