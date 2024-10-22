-- Distribucion --
CREATE PROCEDURE actualizar_distribucion (
    @p_id_distribucion VARCHAR(50),
    @p_id_ruta VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL,
    @p_cantidad INT = NULL,
    @p_fecha_salida DATETIME = NULL,
    @p_fecha_entrega DATETIME = NULL,
    @p_estado VARCHAR(50) = NULL,
    @p_id_bodega_origen VARCHAR(50) = NULL,
    @p_id_sucursal_destino VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la distribución exista
        IF EXISTS (SELECT 1 FROM distribucion WHERE id_distribucion = @p_id_distribucion)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE distribucion
            SET id_ruta = COALESCE(@p_id_ruta, id_ruta),
                id_producto = COALESCE(@p_id_producto, id_producto),
                cantidad = COALESCE(@p_cantidad, cantidad),
                fecha_salida = COALESCE(@p_fecha_salida, fecha_salida),
                fecha_entrega = COALESCE(@p_fecha_entrega, fecha_entrega),
                estado = COALESCE(@p_estado, estado),
                id_bodega_origen = COALESCE(@p_id_bodega_origen, id_bodega_origen),
                id_sucursal_destino = COALESCE(@p_id_sucursal_destino, id_sucursal_destino)
            WHERE id_distribucion = @p_id_distribucion;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la distribución no existe, lanzamos un error
            THROW 50001, 'La distribución especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una distribución: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_distribucion 
    @p_id_distribucion = 'DIST001',
    @p_estado = 'Entregado'; -- Solo se actualizará el estado

*/