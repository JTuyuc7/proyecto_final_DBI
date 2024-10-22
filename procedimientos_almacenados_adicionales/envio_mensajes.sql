CREATE PROCEDURE enviar_mensaje (
    @p_id_mensaje VARCHAR(50),
    @p_m_de VARCHAR(50),           -- Puede ser id_cliente o id_operador
    @p_m_para VARCHAR(50),         -- Puede ser id_cliente o id_operador
    @p_titulo VARCHAR(255),
    @p_mensaje TEXT,
    @p_fecha DATETIME,
    @p_leido BIT,
    @p_id_cliente VARCHAR(50),
    @p_id_operador VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el cliente exista
        IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        BEGIN
            -- Si el cliente no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El cliente especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificamos que el operador exista
        IF NOT EXISTS (SELECT 1 FROM operador WHERE id_operador = @p_id_operador)
        BEGIN
            -- Si el operador no existe, lanzamos un error
            DECLARE @ErrorMessage1 NVARCHAR(4000) = 'El operador especificado no existe';
            THROW 50002, @ErrorMessage1, 1;
        END

        -- Insertamos el mensaje en la tabla 'mensaje'
        INSERT INTO mensaje (id_mensaje, m_de, m_para, titulo, mensaje, fecha, leido, id_cliente, id_operador)
        VALUES (@p_id_mensaje, @p_m_de, @p_m_para, @p_titulo, @p_mensaje, @p_fecha, @p_leido, @p_id_cliente, @p_id_operador);

        -- Mensaje de éxito
        PRINT 'Mensaje enviado con éxito.';
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage2 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage2, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.enviar_mensaje 
    @p_id_mensaje = 'MSG001',
    @p_m_de = 'CL001',               -- Cliente enviando mensaje
    @p_m_para = 'O001',              -- Operador recibiendo mensaje
    @p_titulo = 'Consulta sobre un pedido',
    @p_mensaje = 'Tengo una consulta sobre mi pedido.',
    @p_fecha = GETDATE(),
    @p_leido = 0,                    -- No leído
    @p_id_cliente = 'CL001',
    @p_id_operador = 'O001';

*/