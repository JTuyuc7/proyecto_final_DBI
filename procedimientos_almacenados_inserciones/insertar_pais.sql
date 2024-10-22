-- 1 Insertar Pais --
CREATE PROCEDURE insertar_pais (
    @p_id_pais INT,
    @p_nombre VARCHAR(255),
    @p_iso_codigo2 VARCHAR(50),
    @p_iso_codigo3 VARCHAR(50),
    @p_address_format VARCHAR(255)
)
AS
BEGIN
    BEGIN TRY
        -- Intentamos realizar la inserción
        INSERT INTO pais (id_pais, nombre, iso_codigo2, iso_codigo3, address_format)
        VALUES (@p_id_pais, @p_nombre, @p_iso_codigo2, @p_iso_codigo3, @p_address_format);
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, lo manejamos aquí
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @CustomErrorMessage NVARCHAR(4000);
		SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un pais: ' + @ErrorMessage;

        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

/*
		-- ejecucion --
	EXEC dbo.insertar_pais 
    @p_id_pais = 5,
    @p_nombre = 'El Salvador',
    @p_iso_codigo2 = 'ES',
    @p_iso_codigo3 = 'ES',
    @p_address_format = 'Formato de dirección estándar 2';
*/