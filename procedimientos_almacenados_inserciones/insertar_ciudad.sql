--------- Insertar Ciudad ----------
CREATE PROCEDURE insertar_ciudad (
    @p_id_ciudad INT,
    @p_nombre VARCHAR(255),
    @p_id_provincia INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la provincia exista en la tabla 'provincia'
        IF EXISTS (SELECT 1 FROM provincia WHERE id_provincia = @p_id_provincia)
        BEGIN
            -- Si la provincia existe, realizamos la inserción en 'ciudad'
            INSERT INTO ciudad (id_ciudad, nombre, id_provincia)
            VALUES (@p_id_ciudad, @p_nombre, @p_id_provincia);
        END
        ELSE
        BEGIN
			-- Manejo de errores personalizado
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
			
            -- Si la provincia no existe, lanzamos un error
            THROW 50001, 'La provincia especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH
		SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una ciudad: ' + @ErrorMessage;
        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

/*
	--- Ejecucion ---
	EXEC dbo.insertar_ciudad 
    @p_id_ciudad = 2,
    @p_nombre = 'Prueba 2',
    @p_id_provincia = 1;
*/