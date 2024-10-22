CREATE PROCEDURE registrar_pago_producto (
    @p_id_pago VARCHAR(50),
    @p_id_pedido VARCHAR(50),
    @p_monto_pago DECIMAL(10,2),
    @p_fecha_pago DATETIME,
    @p_metodo_pago VARCHAR(50),
    @p_pagado BIT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el pedido exista
        IF NOT EXISTS (SELECT 1 FROM pedido WHERE id_pedido = @p_id_pedido)
        BEGIN
            -- Si el pedido no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El pedido especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificamos si el monto total ya fue pagado (opcional)
        DECLARE @MontoTotal DECIMAL(10,2) = (SELECT total_pedido FROM pedido WHERE id_pedido = @p_id_pedido);
        DECLARE @MontoPagado DECIMAL(10,2) = (SELECT ISNULL(SUM(monto_pago), 0) FROM pago_credito WHERE id_credito = @p_id_pedido);

        IF (@MontoPagado + @p_monto_pago > @MontoTotal)
        BEGIN
            -- Si el monto pagado excede el total del pedido, lanzamos un error
            DECLARE @ErrorMessage1 NVARCHAR(4000) = 'El monto del pago excede el total del pedido';
            THROW 50002, @ErrorMessage1, 1;
        END

        -- Insertamos el pago en la tabla 'pago_credito'
        INSERT INTO pago_credito (id_pago, id_credito, monto_pago, fecha_pago, metodo_pago)
        VALUES (@p_id_pago, @p_id_pedido, @p_monto_pago, @p_fecha_pago, @p_metodo_pago);

        -- Actualizamos el estado de pago del pedido si ya se ha pagado completamente
        IF (@MontoPagado + @p_monto_pago = @MontoTotal)
        BEGIN
            UPDATE pedido
            SET pagado = 1
            WHERE id_pedido = @p_id_pedido;
        END

        -- Devolver un mensaje de éxito
        PRINT 'El pago ha sido registrado exitosamente.';
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
-- ejecucion --
/*
EXEC dbo.registrar_pago_producto
    @p_id_pago = 'PAGO0011',
    @p_id_pedido = 'P0010',
    @p_monto_pago = 200.00,
    @p_fecha_pago = '2024-10-16 15:00:00',
    @p_metodo_pago = 'Tarjeta de crédito',
    @p_pagado = 1;


*/