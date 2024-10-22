-- Pago Credito --
CREATE PROCEDURE insertar_pago_credito (
    @p_id_pago VARCHAR(50),
    @p_id_credito VARCHAR(50),
    @p_monto_pago DECIMAL(10,2),
    @p_fecha_pago DATETIME,
    @p_metodo_pago VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el crédito exista
        IF EXISTS (SELECT 1 FROM credito WHERE id_credito = @p_id_credito)
        BEGIN
            -- Si el crédito existe, realizamos la inserción en 'pago_credito'
            INSERT INTO pago_credito (id_pago, id_credito, monto_pago, fecha_pago, metodo_pago)
            VALUES (@p_id_pago, @p_id_credito, @p_monto_pago, @p_fecha_pago, @p_metodo_pago);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
        
            -- Si el crédito no existe, lanzamos un error
            THROW 50001, 'El crédito especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un pago de crédito: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_pago_credito 
    @p_id_pago = 'PAGO001',
    @p_id_credito = 'CRED001',
    @p_monto_pago = 500.00,
    @p_fecha_pago = '2024-10-15 10:00:00',
    @p_metodo_pago = 'Tarjeta de crédito';

*/