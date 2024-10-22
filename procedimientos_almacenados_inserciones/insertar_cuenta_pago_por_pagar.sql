-- Pago cuenta por pagar --
CREATE PROCEDURE insertar_pago_cuenta_por_pagar (
    @p_id_pago VARCHAR(50),
    @p_id_cuenta_por_pagar VARCHAR(50),
    @p_monto_pago DECIMAL(10,2),
    @p_fecha_pago DATETIME,
    @p_metodo_pago VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la cuenta por pagar exista
        IF EXISTS (SELECT 1 FROM cuenta_por_pagar WHERE id_cuenta_por_pagar = @p_id_cuenta_por_pagar)
        BEGIN
            -- Si la cuenta por pagar existe, realizamos la inserción en 'pago_cuenta_por_pagar'
            INSERT INTO pago_cuenta_por_pagar (id_pago, id_cuenta_por_pagar, monto_pago, fecha_pago, metodo_pago)
            VALUES (@p_id_pago, @p_id_cuenta_por_pagar, @p_monto_pago, @p_fecha_pago, @p_metodo_pago);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
        
            -- Si la cuenta por pagar no existe, lanzamos un error
            THROW 50001, 'La cuenta por pagar especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un pago de cuenta por pagar: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_pago_cuenta_por_pagar 
    @p_id_pago = 'PAG001',
    @p_id_cuenta_por_pagar = 'CP001',
    @p_monto_pago = 1000.00,
    @p_fecha_pago = '2024-10-15 14:00:00',
    @p_metodo_pago = 'Transferencia bancaria';

*/