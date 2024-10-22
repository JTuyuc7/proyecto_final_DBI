-- Detalle compra --
CREATE PROCEDURE actualizar_detalle_compra (
    @p_item INT,
    @p_cantidad INT = NULL,
    @p_precio DECIMAL(10,2) = NULL,
    @p_subtotal DECIMAL(10,2) = NULL,
    @p_id_compra VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el detalle de compra exista
        IF EXISTS (SELECT 1 FROM detalle_compra WHERE item = @p_item)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE detalle_compra
            SET cantidad = COALESCE(@p_cantidad, cantidad),
                precio = COALESCE(@p_precio, precio),
                subtotal = COALESCE(@p_subtotal, subtotal),
                id_compra = COALESCE(@p_id_compra, id_compra),
                id_producto = COALESCE(@p_id_producto, id_producto)
            WHERE item = @p_item;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el detalle de compra no existe, lanzamos un error
            THROW 50001, 'El detalle de compra especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un detalle de compra: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_detalle_compra 
    @p_item = 1,
    @p_cantidad = 5; -- Solo se actualizará la cantidad

*/
