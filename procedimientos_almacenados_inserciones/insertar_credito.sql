-- Insertar credito --
CREATE PROCEDURE insertar_credito (
    @p_id_credito VARCHAR(50),
    @p_id_cliente VARCHAR(50),
    @p_monto_total DECIMAL(10,2),
    @p_monto_restante DECIMAL(10,2),
    @p_fecha_inicio DATETIME,
    @p_fecha_vencimiento DATETIME,
    @p_id_estado_credito INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el cliente y el estado de crédito existan
        IF EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        AND EXISTS (SELECT 1 FROM estado_credito WHERE id_estado_credito = @p_id_estado_credito)
        BEGIN
            -- Si el cliente y el estado de crédito existen, realizamos la inserción en 'credito'
            INSERT INTO credito (id_credito, id_cliente, monto_total, monto_restante, fecha_inicio, fecha_vencimiento, id_estado_credito)
            VALUES (@p_id_credito, @p_id_cliente, @p_monto_total, @p_monto_restante, @p_fecha_inicio, @p_fecha_vencimiento, @p_id_estado_credito);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el cliente o el estado de crédito no existen, lanzamos un error
            THROW 50001, 'El cliente o el estado de crédito especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un crédito: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_credito 
    @p_id_credito = 'CRED001',
    @p_id_cliente = 'CL001',
    @p_monto_total = 5000.00,
    @p_monto_restante = 2500.00,
    @p_fecha_inicio = '2024-10-15 09:00:00',
    @p_fecha_vencimiento = '2025-10-15 09:00:00',
    @p_id_estado_credito = 1;

*/