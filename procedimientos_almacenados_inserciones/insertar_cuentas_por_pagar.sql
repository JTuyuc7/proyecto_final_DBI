-- Cuentas por pagar --
CREATE PROCEDURE insertar_cuenta_por_pagar (
    @p_id_cuenta_por_pagar VARCHAR(50),
    @p_id_proveedor VARCHAR(50),
    @p_monto_total DECIMAL(10,2),
    @p_monto_restante DECIMAL(10,2),
    @p_fecha_emision DATETIME,
    @p_fecha_vencimiento DATETIME,
    @p_id_estado_cuenta INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el proveedor y el estado de cuenta existan
        IF EXISTS (SELECT 1 FROM proveedor WHERE id_proveedor = @p_id_proveedor)
        AND EXISTS (SELECT 1 FROM estado_cuenta WHERE id_estado_cuenta = @p_id_estado_cuenta)
        BEGIN
            -- Si el proveedor y el estado de cuenta existen, realizamos la inserción en 'cuenta_por_pagar'
            INSERT INTO cuenta_por_pagar (id_cuenta_por_pagar, id_proveedor, monto_total, monto_restante, fecha_emision, fecha_vencimiento, id_estado_cuenta)
            VALUES (@p_id_cuenta_por_pagar, @p_id_proveedor, @p_monto_total, @p_monto_restante, @p_fecha_emision, @p_fecha_vencimiento, @p_id_estado_cuenta);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el proveedor o el estado de cuenta no existen, lanzamos un error
            THROW 50001, 'El proveedor o el estado de cuenta especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una cuenta por pagar: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_cuenta_por_pagar 
    @p_id_cuenta_por_pagar = 'CP001',
    @p_id_proveedor = 'PROV001',
    @p_monto_total = 3000.00,
    @p_monto_restante = 1500.00,
    @p_fecha_emision = '2024-10-15 10:00:00',
    @p_fecha_vencimiento = '2024-12-15 10:00:00',
    @p_id_estado_cuenta = 1;

*/