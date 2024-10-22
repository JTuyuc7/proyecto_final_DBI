-- Ruta --
CREATE PROCEDURE actualizar_ruta (
    @p_id_ruta VARCHAR(50),
    @p_nombre VARCHAR(255) = NULL,
    @p_descripcion TEXT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ruta exista
        IF EXISTS (SELECT 1 FROM ruta WHERE id_ruta = @p_id_ruta)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE ruta
            SET nombre = COALESCE(@p_nombre, nombre),
                descripcion = COALESCE(@p_descripcion, descripcion)
            WHERE id_ruta = @p_id_ruta;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
		        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
				DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la ruta no existe, lanzamos un error
            THROW 50001, 'La ruta especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH



        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una ruta: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_ruta 
    @p_id_ruta = 'RUTA001',
    @p_nombre = 'Nueva Ruta'; -- Solo se actualizará el nombre

*/