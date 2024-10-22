-- Actualizar Foto --
CREATE PROCEDURE actualizar_foto (
    @p_id_foto VARCHAR(50),
    @p_path VARCHAR(255) = NULL,
    @p_id_producto VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la foto exista
        IF EXISTS (SELECT 1 FROM foto WHERE id_foto = @p_id_foto)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE foto
            SET path = COALESCE(@p_path, path),
                id_producto = COALESCE(@p_id_producto, id_producto)
            WHERE id_foto = @p_id_foto;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la foto no existe, lanzamos un error
            THROW 50001, 'La foto especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una foto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_foto
    @p_id_foto = 'FOTO001',
    @p_path = '/imagenes/productos/nueva_foto.jpg'; -- Solo se actualizará el path

*/