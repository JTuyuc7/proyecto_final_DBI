-- Bodega --
CREATE PROCEDURE actualizar_bodega (
    @p_id_bodega VARCHAR(50),
    @p_nombre VARCHAR(255) = NULL,
    @p_direccion VARCHAR(255) = NULL,
    @p_id_sucursal VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la bodega exista
        IF EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE bodega
            SET nombre = COALESCE(@p_nombre, nombre),
                direccion = COALESCE(@p_direccion, direccion),
                id_sucursal = COALESCE(@p_id_sucursal, id_sucursal)
            WHERE id_bodega = @p_id_bodega;
        END
        ELSE
        BEGIN
			        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la bodega no existe, lanzamos un error
            THROW 50001, 'La bodega especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una bodega: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_bodega
    @p_id_bodega = 'BOD001',
    @p_nombre = 'Nueva Bodega'; -- Solo se actualizará el nombre

*/