-- Actualizar ciudad --
CREATE PROCEDURE actualizar_ciudad (
    @p_id_ciudad INT,
    @p_nombre VARCHAR(255),
    @p_id_provincia INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ciudad y la provincia existan
        IF EXISTS (SELECT 1 FROM ciudad WHERE id_ciudad = @p_id_ciudad)
        AND EXISTS (SELECT 1 FROM provincia WHERE id_provincia = @p_id_provincia)
        BEGIN
            -- Si la ciudad y la provincia existen, realizamos la actualización
            UPDATE ciudad
            SET nombre = @p_nombre,
                id_provincia = @p_id_provincia
            WHERE id_ciudad = @p_id_ciudad;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la ciudad o la provincia no existen, lanzamos un error
            THROW 50001, 'La ciudad o la provincia especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH

        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una ciudad: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_ciudad 
    @p_id_ciudad = 2,
    @p_nombre = 'Ciudad Actualizada',
    @p_id_provincia = 1;

*/