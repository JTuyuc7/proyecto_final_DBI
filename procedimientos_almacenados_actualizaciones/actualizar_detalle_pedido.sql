-- Detalle pedido --
CREATE PROCEDURE actualizar_detalle_pedido (
    @p_item INT,
    @p_cantidad INT = NULL,
    @p_precio DECIMAL(10,2) = NULL,
    @p_subtotal DECIMAL(10,2) = NULL,
    @p_id_pedido VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el detalle del pedido exista
        IF EXISTS (SELECT 1 FROM detalle_pedido WHERE item = @p_item)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE detalle_pedido
            SET cantidad = COALESCE(@p_cantidad, cantidad),
                precio = COALESCE(@p_precio, precio),
                subtotal = COALESCE(@p_subtotal, subtotal),
                id_pedido = COALESCE(@p_id_pedido, id_pedido),
                id_producto = COALESCE(@p_id_producto, id_producto)
            WHERE item = @p_item;
        END
        ELSE
        BEGIN
			        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el detalle del pedido no existe, lanzamos un error
            THROW 50001, 'El detalle del pedido especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un detalle de pedido: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.actualizar_detalle_pedido 
    @p_item = 1,
    @p_cantidad = 5; -- Solo se actualizará la cantidad

*/