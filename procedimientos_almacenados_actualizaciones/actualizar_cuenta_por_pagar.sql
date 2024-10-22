-- Cuenta por pagar --
CREATE PROCEDURE actualizar_cuenta_por_pagar (
    @p_id_cuenta_por_pagar VARCHAR(50),
    @p_id_proveedor VARCHAR(50) = NULL,
    @p_monto_total DECIMAL(10,2) = NULL,
    @p_monto_restante DECIMAL(10,2) = NULL,
    @p_fecha_emision DATETIME = NULL,
    @p_fecha_vencimiento DATETIME = NULL,
    @p_id_estado_cuenta INT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la cuenta por pagar exista
        IF EXISTS (SELECT 1 FROM cuenta_por_pagar WHERE id_cuenta_por_pagar = @p_id_cuenta_por_pagar)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE cuenta_por_pagar
            SET id_proveedor = COALESCE(@p_id_proveedor, id_proveedor),
                monto_total = COALESCE(@p_monto_total, monto_total),
                monto_restante = COALESCE(@p_monto_restante, monto_restante),
                fecha_emision = COALESCE(@p_fecha_emision, fecha_emision),
                fecha_vencimiento = COALESCE(@p_fecha_vencimiento, fecha_vencimiento),
                id_estado_cuenta = COALESCE(@p_id_estado_cuenta, id_estado_cuenta)
            WHERE id_cuenta_por_pagar = @p_id_cuenta_por_pagar;
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
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una cuenta por pagar: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_cuenta_por_pagar
    @p_id_cuenta_por_pagar = 'CP001',
    @p_monto_restante = 1000.00; -- Solo se actualizará el monto restante

*/