-- Credito --
CREATE PROCEDURE actualizar_credito (
    @p_id_credito VARCHAR(50),
    @p_id_cliente VARCHAR(50) = NULL,
    @p_monto_total DECIMAL(10,2) = NULL,
    @p_monto_restante DECIMAL(10,2) = NULL,
    @p_fecha_inicio DATETIME = NULL,
    @p_fecha_vencimiento DATETIME = NULL,
    @p_id_estado_credito INT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el crédito exista
        IF EXISTS (SELECT 1 FROM credito WHERE id_credito = @p_id_credito)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE credito
            SET id_cliente = COALESCE(@p_id_cliente, id_cliente),
                monto_total = COALESCE(@p_monto_total, monto_total),
                monto_restante = COALESCE(@p_monto_restante, monto_restante),
                fecha_inicio = COALESCE(@p_fecha_inicio, fecha_inicio),
                fecha_vencimiento = COALESCE(@p_fecha_vencimiento, fecha_vencimiento),
                id_estado_credito = COALESCE(@p_id_estado_credito, id_estado_credito)
            WHERE id_credito = @p_id_credito;
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
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un crédito: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_credito 
    @p_id_credito = 'CRED001',
    @p_monto_restante = 2000.00; -- Solo se actualizará el monto restante

*/