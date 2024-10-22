-- Operador --
CREATE PROCEDURE actualizar_operador (
    @p_id_operador VARCHAR(50),
    @p_id_persona VARCHAR(50) = NULL,
    @p_tipo VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el operador exista
        IF EXISTS (SELECT 1 FROM operador WHERE id_operador = @p_id_operador)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE operador
            SET id_persona = COALESCE(@p_id_persona, id_persona),
                tipo = COALESCE(@p_tipo, tipo)
            WHERE id_operador = @p_id_operador;
        END
        ELSE
        BEGIN
		-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el operador no existe, lanzamos un error
            THROW 50001, 'El operador especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un operador: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_operador
    @p_id_operador = 'O001',
    @p_tipo = 'Supervisor'; -- Solo se actualizará el campo tipo

*/