-- Estado Cuenta --
CREATE PROCEDURE insertar_estado_cuenta (
    @p_id_estado_cuenta INT,
    @p_descripcion VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'estado_cuenta'
        INSERT INTO estado_cuenta (id_estado_cuenta, descripcion)
        VALUES (@p_id_estado_cuenta, @p_descripcion);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un estado de cuenta: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_estado_cuenta 
    @p_id_estado_cuenta = 1,
    @p_descripcion = 'Activo';

*/