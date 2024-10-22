-- compra --
CREATE PROCEDURE actualizar_compra (
    @p_id_compra VARCHAR(50),
    @p_fecha DATETIME = NULL,
    @p_total DECIMAL(10,2) = NULL,
    @p_id_proveedor VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la compra exista
        IF EXISTS (SELECT 1 FROM compra WHERE id_compra = @p_id_compra)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE compra
            SET fecha = COALESCE(@p_fecha, fecha),
                total = COALESCE(@p_total, total),
                id_proveedor = COALESCE(@p_id_proveedor, id_proveedor)
            WHERE id_compra = @p_id_compra;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la compra no existe, lanzamos un error
            THROW 50001, 'La compra especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una compra: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.actualizar_compra 
    @p_id_compra = 'COMP001',
    @p_total = 1800.00; -- Solo se actualizará el total

*/