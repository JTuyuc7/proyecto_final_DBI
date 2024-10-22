--- Ruta ---
CREATE PROCEDURE insertar_ruta (
    @p_id_ruta VARCHAR(50),
    @p_nombre VARCHAR(255),
    @p_descripcion TEXT
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'ruta'
        INSERT INTO ruta (id_ruta, nombre, descripcion)
        VALUES (@p_id_ruta, @p_nombre, @p_descripcion);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una ruta: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_ruta 
    @p_id_ruta = 'RUTA001',
    @p_nombre = 'Ruta Principal',
    @p_descripcion = 'Esta es la ruta principal para la distribución de productos.';

*/