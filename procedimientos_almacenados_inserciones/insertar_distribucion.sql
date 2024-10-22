--- Insertar distribucion ---
CREATE PROCEDURE insertar_distribucion (
    @p_id_distribucion VARCHAR(50),
    @p_id_ruta VARCHAR(50),
    @p_id_producto VARCHAR(50),
    @p_cantidad INT,
    @p_fecha_salida DATETIME,
    @p_fecha_entrega DATETIME,
    @p_estado VARCHAR(50),
    @p_id_bodega_origen VARCHAR(50),
    @p_id_sucursal_destino VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ruta, producto, bodega de origen y sucursal de destino existan
        IF EXISTS (SELECT 1 FROM ruta WHERE id_ruta = @p_id_ruta)
        AND EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        AND EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega_origen)
        AND EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal_destino)
        BEGIN
            -- Si todo existe, realizamos la inserción en 'distribucion'
            INSERT INTO distribucion (id_distribucion, id_ruta, id_producto, cantidad, fecha_salida, fecha_entrega, estado, id_bodega_origen, id_sucursal_destino)
            VALUES (@p_id_distribucion, @p_id_ruta, @p_id_producto, @p_cantidad, @p_fecha_salida, @p_fecha_entrega, @p_estado, @p_id_bodega_origen, @p_id_sucursal_destino);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si alguno no existe, lanzamos un error
            THROW 50001, 'La ruta, producto, bodega o sucursal especificados no existen', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una distribución: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_distribucion 
    @p_id_distribucion = 'DIST001',
    @p_id_ruta = 'RUTA001',
    @p_id_producto = 'PROD001',
    @p_cantidad = 50,
    @p_fecha_salida = '2024-10-15 09:00:00',
    @p_fecha_entrega = '2024-10-16 12:00:00',
    @p_estado = 'En camino',
    @p_id_bodega_origen = 'BOD001',
    @p_id_sucursal_destino = 'SUC001';

*/