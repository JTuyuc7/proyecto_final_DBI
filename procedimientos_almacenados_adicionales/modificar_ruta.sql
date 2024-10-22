CREATE PROCEDURE modificar_ruta (
    @p_id_ruta VARCHAR(50),
    @p_nombre VARCHAR(255),
    @p_descripcion TEXT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ruta exista en la tabla 'ruta'
        IF EXISTS (SELECT 1 FROM ruta WHERE id_ruta = @p_id_ruta)
        BEGIN
            -- Si la ruta existe, actualizamos los campos correspondientes
            UPDATE ruta
            SET nombre = @p_nombre,
                descripcion = @p_descripcion
            WHERE id_ruta = @p_id_ruta;

            PRINT 'La ruta ha sido actualizada correctamente.';
        END
        ELSE
        BEGIN
            -- Si la ruta no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'La ruta especificada no existe';
            THROW 50001, @ErrorMessage, 1;
        END
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage1 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage1, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.modificar_ruta 
    @p_id_ruta = 'RUTA001', -- Dinamica
    @p_nombre = 'Ruta Modificada',
    @p_descripcion = 'Descripción actualizada para la ruta.';

*/