CREATE PROCEDURE eliminar_producto_de_ruta (
    @p_id_ruta VARCHAR(50),
    @p_id_producto VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la asignación exista en la tabla 'distribucion'
        IF EXISTS (SELECT 1 FROM distribucion WHERE id_ruta = @p_id_ruta AND id_producto = @p_id_producto)
        BEGIN
            -- Si la asignación existe, eliminamos el producto de la ruta
            DELETE FROM distribucion
            WHERE id_ruta = @p_id_ruta AND id_producto = @p_id_producto;

            PRINT 'El producto ha sido eliminado de la ruta correctamente.';
        END
        ELSE
        BEGIN
            -- Si no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'La asignación del producto a la ruta especificada no existe';
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
EXEC dbo.eliminar_producto_de_ruta 
    @p_id_ruta = 'RUTA003', -- validar que este en la tabla distribucion
		@p_id_producto = 'PROD003'; -- validar que este en la tabla distribucion

*/