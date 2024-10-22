------------- Provincia -------------
CREATE PROCEDURE insertar_provincia (
    @p_id_provincia INT,
    @p_nombre VARCHAR(255),
    @p_id_pais INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el país exista en la tabla 'pais'
        IF EXISTS (SELECT 1 FROM pais WHERE id_pais = @p_id_pais)
        BEGIN
            -- Si el país existe, realizamos la inserción en 'provincia'

            INSERT INTO provincia (id_provincia, nombre, id_pais)
            VALUES (@p_id_provincia, @p_nombre, @p_id_pais);
        END
        ELSE
        BEGIN
            -- Si el país no existe, lanzamos un error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            DECLARE @CustomErrorMessage NVARCHAR(4000);
			SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una provincia: ' + @ErrorMessage;

			THROW 50000, @CustomErrorMessage, 1;
        END
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, lo manejamos aquí
		SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una provincia: ' + @ErrorMessage;

        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

/*
	--- Ejecucion ---
	EXEC dbo.insertar_provincia 
    @p_id_provincia = 1,
    @p_nombre = 'Prueba',
    @p_id_pais = 1;
*/