---- Operador ----
CREATE PROCEDURE insertar_operador (
    @p_id_operador VARCHAR(50),
    @p_id_persona VARCHAR(50),
    @p_tipo VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la persona exista en la tabla 'persona'
        IF EXISTS (SELECT 1 FROM persona WHERE id_persona = @p_id_persona)
        BEGIN
            -- Si la persona existe, realizamos la inserción en 'operador'
            INSERT INTO operador (id_operador, id_persona, tipo)
            VALUES (@p_id_operador, @p_id_persona, @p_tipo);
        END
        ELSE
        BEGIN
			-- Manejo de errores personalizado
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la persona no existe, lanzamos un error
            THROW 50001, 'La persona especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH
        
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un operador: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

--- Ejecucion ----

/*
	EXEC dbo.insertar_operador 
		@p_id_operador = 'O001',
		@p_id_persona = 'P001',
		@p_tipo = 'Administrador';

*/