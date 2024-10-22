CREATE PROCEDURE cargar_producto (
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

        -- Si se especifica bodega, realizamos la carga en bodega
        IF @p_id_bodega IS NOT NULL
        BEGIN
            -- Verificamos si el producto ya está en el inventario de la bodega
            IF EXISTS (SELECT 1 FROM inventario_bodega WHERE id_producto = @p_id_producto AND id_bodega = @p_id_bodega)
            BEGIN
                -- Actualizamos la cantidad del producto en la bodega
                UPDATE inventario_bodega
                SET cantidad = cantidad + @p_cantidad, fecha_actualizacion = @p_fecha_actualizacion
                WHERE id_producto = @p_id_producto AND id_bodega = @p_id_bodega;
            END
            ELSE
            BEGIN
                -- Insertamos el producto en el inventario de la bodega
                INSERT INTO inventario_bodega (id_inventario, id_bodega, id_producto, cantidad, fecha_actualizacion)
                VALUES (NEWID(), @p_id_bodega, @p_id_producto, @p_cantidad, @p_fecha_actualizacion);
            END
        END

        -- Si se especifica sucursal, realizamos la carga en sucursal
        IF @p_id_sucursal IS NOT NULL
        BEGIN
            -- Verificamos si el producto ya está en el inventario de la sucursal
            IF EXISTS (SELECT 1 FROM inventario_sucursal WHERE id_producto = @p_id_producto AND id_sucursal = @p_id_sucursal)
            BEGIN
                -- Actualizamos la cantidad del producto en la sucursal
                UPDATE inventario_sucursal
                SET cantidad = cantidad + @p_cantidad, fecha_actualizacion = @p_fecha_actualizacion
                WHERE id_producto = @p_id_producto AND id_sucursal = @p_id_sucursal;
            END
            ELSE
            BEGIN
                -- Insertamos el producto en el inventario de la sucursal
                INSERT INTO inventario_sucursal (id_inventario, id_sucursal, id_producto, cantidad, fecha_actualizacion)
                VALUES (NEWID(), @p_id_sucursal, @p_id_producto, @p_cantidad, @p_fecha_actualizacion);
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

-- Ejecutar procedimiento para cargar producto en la bodega
EXEC dbo.cargar_producto 
    @p_id_producto = 'PROD001',
    @p_cantidad = 50,
    @p_id_bodega = 'BOD001',   -- Indicamos la bodega
    @p_fecha_actualizacion = @fecha_actualizacion;

-- Ejecutar procedimiento para cargar producto en la bodega
EXEC dbo.cargar_producto 
    @p_id_producto = 'PROD001',
    @p_cantidad = 50,
    @p_id_bodega = 'BOD001',   -- Indicamos la bodega
    @p_fecha_actualizacion = @fecha_actualizacion;


*/