CREATE PROCEDURE realizar_traslado (
    @p_id_traslado VARCHAR(50),
    @p_id_producto VARCHAR(50),
    @p_id_bodega_origen VARCHAR(50),
    @p_id_bodega_destino VARCHAR(50) = NULL, -- Puede ser nulo si el destino es una sucursal
    @p_id_sucursal_destino VARCHAR(50) = NULL, -- Puede ser nulo si el destino es una bodega
    @p_cantidad INT,
    @p_fecha_traslado DATETIME
)
AS
BEGIN
    BEGIN TRY
        -- Verificar que el producto exista
        IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El producto especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificar que la bodega origen exista
        IF NOT EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega_origen)
        BEGIN
            DECLARE @ErrorMessage1 NVARCHAR(4000) = 'La bodega de origen especificada no existe';
            THROW 50002, @ErrorMessage1, 1;
        END

        -- Verificar que el destino (bodega o sucursal) exista
        IF @p_id_bodega_destino IS NOT NULL
        BEGIN
            -- Verificar que la bodega destino exista
            IF NOT EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega_destino)
            BEGIN
                DECLARE @ErrorMessage2 NVARCHAR(4000) = 'La bodega de destino especificada no existe';
                THROW 50003, @ErrorMessage2, 1;
            END
        END
        ELSE IF @p_id_sucursal_destino IS NOT NULL
        BEGIN
            -- Verificar que la sucursal destino exista
            IF NOT EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal_destino)
            BEGIN
                DECLARE @ErrorMessage3 NVARCHAR(4000) = 'La sucursal de destino especificada no existe';
                THROW 50004, @ErrorMessage3, 1;
            END
        END
        ELSE
        BEGIN
            -- Si no se especifica ni bodega ni sucursal destino, lanzamos un error
            DECLARE @ErrorMessage4 NVARCHAR(4000) = 'Debe especificar una bodega o sucursal de destino';
            THROW 50005, @ErrorMessage4, 1;
        END

        -- Verificar que haya suficiente inventario en la bodega origen
        DECLARE @CantidadDisponible INT;
        SELECT @CantidadDisponible = cantidad
        FROM inventario_bodega
        WHERE id_bodega = @p_id_bodega_origen
        AND id_producto = @p_id_producto;

        IF @CantidadDisponible IS NULL OR @CantidadDisponible < @p_cantidad
        BEGIN
            DECLARE @ErrorMessage5 NVARCHAR(4000) = 'No hay suficiente inventario en la bodega de origen';
            THROW 50006, @ErrorMessage5, 1;
        END

        -- Restar la cantidad en la bodega origen
        UPDATE inventario_bodega
        SET cantidad = cantidad - @p_cantidad
        WHERE id_bodega = @p_id_bodega_origen
        AND id_producto = @p_id_producto;

        -- Actualizar el inventario en el destino (bodega o sucursal)
        IF @p_id_bodega_destino IS NOT NULL
        BEGIN
            -- Verificar si el producto ya existe en la bodega destino
            IF EXISTS (SELECT 1 FROM inventario_bodega WHERE id_bodega = @p_id_bodega_destino AND id_producto = @p_id_producto)
            BEGIN
                -- Sumar la cantidad al inventario existente
                UPDATE inventario_bodega
                SET cantidad = cantidad + @p_cantidad
                WHERE id_bodega = @p_id_bodega_destino
                AND id_producto = @p_id_producto;
            END
            ELSE
            BEGIN
                -- Insertar un nuevo registro en el inventario de la bodega destino
                INSERT INTO inventario_bodega (id_inventario, id_bodega, id_producto, cantidad, fecha_actualizacion)
                VALUES (NEWID(), @p_id_bodega_destino, @p_id_producto, @p_cantidad, @p_fecha_traslado);
            END
        END
        ELSE IF @p_id_sucursal_destino IS NOT NULL
        BEGIN
            -- Verificar si el producto ya existe en la sucursal destino
            IF EXISTS (SELECT 1 FROM inventario_sucursal WHERE id_sucursal = @p_id_sucursal_destino AND id_producto = @p_id_producto)
            BEGIN
                -- Sumar la cantidad al inventario existente
                UPDATE inventario_sucursal
                SET cantidad = cantidad + @p_cantidad
                WHERE id_sucursal = @p_id_sucursal_destino
                AND id_producto = @p_id_producto;
            END
            ELSE
            BEGIN
                -- Insertar un nuevo registro en el inventario de la sucursal destino
                INSERT INTO inventario_sucursal (id_inventario, id_sucursal, id_producto, cantidad, fecha_actualizacion)
                VALUES (NEWID(), @p_id_sucursal_destino, @p_id_producto, @p_cantidad, @p_fecha_traslado);
            END
        END

        -- Registrar el traslado en una tabla de traslados
        INSERT INTO distribucion (id_distribucion, id_ruta, id_producto, cantidad, fecha_salida, fecha_entrega, estado, id_bodega_origen, id_sucursal_destino)
        VALUES (@p_id_traslado, NULL, @p_id_producto, @p_cantidad, @p_fecha_traslado, NULL, 'En proceso', @p_id_bodega_origen, @p_id_sucursal_destino);
        
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage6 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error con el mensaje original
        THROW 50000, @ErrorMessage6, 1;
    END CATCH
END;

-- Ejecucion --
/*
-- Trasladar 50 unidades de PROD001 desde BOD001 a BOD002
-- Trasladar 50 unidades de PROD001 desde BOD001 a BOD002
DECLARE @fecha DATETIME = GETDATE();

EXEC dbo.realizar_traslado
    @p_id_traslado = 'TR002', -- Dinamico
    @p_id_producto = 'PROD001',
    @p_id_bodega_origen = 'BOD001',
    @p_id_bodega_destino = 'BOD002',
    @p_cantidad = 50,
    @p_fecha_traslado = @fecha;

-- Trasladar 20 unidades de PROD002 desde BOD001 a SUC001 (Sucursal)
EXEC dbo.realizar_traslado
    @p_id_traslado = 'TR003', -- Dinamico
    @p_id_producto = 'PROD001',
    @p_id_bodega_origen = 'BOD001',
    @p_id_sucursal_destino = 'SUC001',
    @p_cantidad = 20,
    @p_fecha_traslado = @fecha;


*/