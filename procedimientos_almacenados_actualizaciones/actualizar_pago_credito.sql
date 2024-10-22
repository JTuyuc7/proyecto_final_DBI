-- Pago Credito --
CREATE PROCEDURE actualizar_pago_credito (
    @p_id_pago VARCHAR(50),
    @p_id_credito VARCHAR(50) = NULL,
    @p_monto_pago DECIMAL(10,2) = NULL,
    @p_fecha_pago DATETIME = NULL,
    @p_metodo_pago VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el pago de crédito exista
        IF EXISTS (SELECT 1 FROM pago_credito WHERE id_pago = @p_id_pago)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE pago_credito
            SET id_credito = COALESCE(@p_id_credito, id_credito),
                monto_pago = COALESCE(@p_monto_pago, monto_pago),
                fecha_pago = COALESCE(@p_fecha_pago, fecha_pago),
                metodo_pago = COALESCE(@p_metodo_pago, metodo_pago)
            WHERE id_pago = @p_id_pago;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el pago de crédito no existe, lanzamos un error
            THROW 50001, 'El pago de crédito especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un pago de crédito: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_pago_credito
    @p_id_pago = 'PAGO001',
    @p_monto_pago = 600.00; -- Solo se actualizará el monto del pago

*/