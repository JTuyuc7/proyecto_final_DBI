-- Inventario Sucursal --
CREATE PROCEDURE actualizar_inventario_sucursal (
    @p_id_inventario VARCHAR(50),
    @p_id_sucursal VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL,
    @p_cantidad INT = NULL,
    @p_fecha_actualizacion DATETIME = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el inventario de sucursal exista
        IF EXISTS (SELECT 1 FROM inventario_sucursal WHERE id_inventario = @p_id_inventario)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE inventario_sucursal
            SET id_sucursal = COALESCE(@p_id_sucursal, id_sucursal),
                id_producto = COALESCE(@p_id_producto, id_producto),
                cantidad = COALESCE(@p_cantidad, cantidad),
                fecha_actualizacion = COALESCE(@p_fecha_actualizacion, fecha_actualizacion)
            WHERE id_inventario = @p_id_inventario;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el inventario no existe, lanzamos un error
            THROW 50001, 'El inventario de sucursal especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un inventario de sucursal: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_inventario_sucursal
    @p_id_inventario = 'INV001',
    @p_cantidad = 200; -- Solo se actualizará la cantidad

*/