CREATE PROCEDURE definir_recorrido_ruta (
	@p_id_distribucion VARCHAR(50),
    @p_id_ruta VARCHAR(50),
    @p_id_bodega_origen VARCHAR(50),
    @p_id_sucursal_destino VARCHAR(50),
    @p_fecha_salida DATETIME,
    @p_fecha_entrega DATETIME,
    @p_estado VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ruta exista
        IF NOT EXISTS (SELECT 1 FROM ruta WHERE id_ruta = @p_id_ruta)
        BEGIN
            -- Si la ruta no existe, lanzamos un error
            DECLARE @ErrorMessage1 NVARCHAR(4000) = 'La ruta especificada no existe';
            THROW 50001, @ErrorMessage1, 1;
        END
        
        -- Verificamos que la bodega de origen exista
        IF NOT EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega_origen)
        BEGIN
            -- Si la bodega de origen no existe, lanzamos un error
            DECLARE @ErrorMessage2 NVARCHAR(4000) = 'La bodega de origen especificada no existe';
            THROW 50002, @ErrorMessage2, 1;
        END
        
        -- Verificamos que la sucursal de destino exista
        IF NOT EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal_destino)
        BEGIN
            -- Si la sucursal de destino no existe, lanzamos un error
            DECLARE @ErrorMessage3 NVARCHAR(4000) = 'La sucursal de destino especificada no existe';
            THROW 50003, @ErrorMessage3, 1;
        END

        -- Insertamos el recorrido de la ruta en la tabla 'distribucion'
        INSERT INTO distribucion (
            id_distribucion, id_ruta, id_bodega_origen, id_sucursal_destino, fecha_salida, fecha_entrega, estado
        )
        VALUES (
            @p_id_distribucion, @p_id_ruta, @p_id_bodega_origen, @p_id_sucursal_destino, @p_fecha_salida, @p_fecha_entrega, @p_estado
        );

        PRINT 'El recorrido de la ruta ha sido definido correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.definir_recorrido_ruta 
	@p_id_distribucion = 'DIST001',
    @p_id_ruta = 'RUTA001',
    @p_id_bodega_origen = 'BOD001',
    @p_id_sucursal_destino = 'SUC002',
    @p_fecha_salida = '2024-10-16 08:00:00',
    @p_fecha_entrega = '2024-10-17 16:00:00',
    @p_estado = 'En camino';

*/
