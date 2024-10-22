-- Provincia --
CREATE PROCEDURE actualizar_provincia (
    @p_id_provincia INT,
    @p_nombre VARCHAR(255),
    @p_id_pais INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la provincia y el país existan
        IF EXISTS (SELECT 1 FROM provincia WHERE id_provincia = @p_id_provincia)
        AND EXISTS (SELECT 1 FROM pais WHERE id_pais = @p_id_pais)
        BEGIN
            -- Si la provincia y el país existen, realizamos la actualización
            UPDATE provincia
            SET nombre = @p_nombre,
                id_pais = @p_id_pais
            WHERE id_provincia = @p_id_provincia;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la provincia o el país no existen, lanzamos un error
            THROW 50001, 'La provincia o el país especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una provincia: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.actualizar_provincia 
    @p_id_provincia = 1,
    @p_nombre = 'Nueva Provincia',
    @p_id_pais = 1;

*/