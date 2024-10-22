-- Pais --
CREATE PROCEDURE actualizar_pais (
    @p_id_pais INT,
    @p_nombre VARCHAR(255),
    @p_iso_codigo2 VARCHAR(50),
    @p_iso_codigo3 VARCHAR(50),
    @p_address_format VARCHAR(255)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el país exista antes de intentar actualizar
        IF EXISTS (SELECT 1 FROM pais WHERE id_pais = @p_id_pais)
        BEGIN
            -- Si el país existe, realizamos la actualización
            UPDATE pais
            SET nombre = @p_nombre,
                iso_codigo2 = @p_iso_codigo2,
                iso_codigo3 = @p_iso_codigo3,
                address_format = @p_address_format
            WHERE id_pais = @p_id_pais;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
        
            -- Si el país no existe, lanzamos un error
            THROW 50001, 'El país especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un país: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.actualizar_pais 
    @p_id_pais = 5,
    @p_nombre = 'El Salvador',
    @p_iso_codigo2 = 'SV',
    @p_iso_codigo3 = 'SLV',
    @p_address_format = 'Nuevo formato de dirección estándar';

*/