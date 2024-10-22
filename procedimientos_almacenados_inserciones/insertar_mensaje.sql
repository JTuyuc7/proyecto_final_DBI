CREATE PROCEDURE insertar_mensaje (
    @p_id_mensaje VARCHAR(50),
    @p_m_de VARCHAR(50),
    @p_m_para VARCHAR(50),
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
        -- Verificamos que el cliente y el operador existan
        IF EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        AND EXISTS (SELECT 1 FROM operador WHERE id_operador = @p_id_operador)
        BEGIN
            -- Si ambos existen, realizamos la inserción en 'mensaje'
            INSERT INTO mensaje (id_mensaje, m_de, m_para, titulo, mensaje, fecha, leido, id_cliente, id_operador)
            VALUES (@p_id_mensaje, @p_m_de, @p_m_para, @p_titulo, @p_mensaje, @p_fecha, @p_leido, @p_id_cliente, @p_id_operador);
        END
        ELSE
        BEGIN
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si no existe alguno de los datos relacionados, lanzamos un error con THROW
            THROW 50001, 'El cliente o el operador especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error original
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Imprimimos detalles del error para diagnóstico
        PRINT 'ErrorMessage: ' + @ErrorMessage;
        PRINT 'ErrorLine: ' + CAST(@ErrorLine AS NVARCHAR(5));
        PRINT 'ErrorSeverity: ' + CAST(@ErrorSeverity AS NVARCHAR(5));
        PRINT 'ErrorState: ' + CAST(@ErrorState AS NVARCHAR(5));

        -- Concatenamos el mensaje personalizado
        
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un mensaje: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;


--- Ejecucion ---
/*
EXEC dbo.insertar_mensaje 
    @p_id_mensaje = 'M001',
    @p_m_de = 'qO001',
    @p_m_para = 'qC001',
    @p_titulo = 'Asunto importante',
    @p_mensaje = 'Este es un mensaje de prueba.',
    @p_fecha = '2024-10-13',
    @p_leido = 0,
    @p_id_cliente = 'CL001',
    @p_id_operador = 'O001';


*/