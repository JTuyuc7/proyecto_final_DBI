--- Detalle pedido ---
CREATE PROCEDURE insertar_detalle_pedido (
    @p_item INT,
    @p_cantidad INT,
    @p_precio DECIMAL(10,2),
    @p_subtotal DECIMAL(10,2),
    @p_id_pedido VARCHAR(50),
    @p_id_producto VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el pedido y el producto existan
        IF EXISTS (SELECT 1 FROM pedido WHERE id_pedido = @p_id_pedido)
        AND EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si el pedido y el producto existen, realizamos la inserción en 'detalle_pedido'
            INSERT INTO detalle_pedido (item, cantidad, precio, subtotal, id_pedido, id_producto)
            VALUES (@p_item, @p_cantidad, @p_precio, @p_subtotal, @p_id_pedido, @p_id_producto);
        END
        ELSE
        BEGIN
			-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el pedido o el producto no existen, lanzamos un error
            THROW 50001, 'El pedido o el producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un detalle de pedido: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_detalle_pedido 
    @p_item = 1,
    @p_cantidad = 2,
    @p_precio = 500.00,
    @p_subtotal = 1000.00,
    @p_id_pedido = 'P001',
    @p_id_producto = 'PROD001';

*/