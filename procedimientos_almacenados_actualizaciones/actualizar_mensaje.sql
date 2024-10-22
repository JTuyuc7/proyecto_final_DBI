-- Mensaje --
CREATE PROCEDURE actualizar_mensaje (
    @p_id_mensaje VARCHAR(50),
    @p_m_de VARCHAR(50) = NULL,
    @p_m_para VARCHAR(50) = NULL,
    @p_titulo VARCHAR(255) = NULL,
    @p_mensaje TEXT = NULL,
    @p_fecha DATETIME = NULL,
    @p_leido BIT = NULL,
    @p_id_cliente VARCHAR(50) = NULL,
    @p_id_operador VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el mensaje exista
        IF EXISTS (SELECT 1 FROM mensaje WHERE id_mensaje = @p_id_mensaje)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE mensaje
            SET m_de = COALESCE(@p_m_de, m_de),
                m_para = COALESCE(@p_m_para, m_para),
                titulo = COALESCE(@p_titulo, titulo),
                mensaje = COALESCE(@p_mensaje, mensaje),
                fecha = COALESCE(@p_fecha, fecha),
                leido = COALESCE(@p_leido, leido),
                id_cliente = COALESCE(@p_id_cliente, id_cliente),
                id_operador = COALESCE(@p_id_operador, id_operador)
            WHERE id_mensaje = @p_id_mensaje;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el mensaje no existe, lanzamos un error
            THROW 50001, 'El mensaje especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un mensaje: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_mensaje
    @p_id_mensaje = 'M001',
    @p_titulo = 'Nuevo Asunto'; -- Solo se actualizará el título

*/