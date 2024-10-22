-- 5 Estado credito --
CREATE PROCEDURE insertar_estado_credito (
    @p_id_estado_credito INT,
    @p_descripcion VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'estado_credito'
        INSERT INTO estado_credito (id_estado_credito, descripcion)
        VALUES (@p_id_estado_credito, @p_descripcion);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un estado de crédito: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_estado_credito 
    @p_id_estado_credito = 1,
    @p_descripcion = 'Aprobado';

*/