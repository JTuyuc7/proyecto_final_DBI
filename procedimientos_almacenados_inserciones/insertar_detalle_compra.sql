-- 3 Detalle Compra ---
CREATE PROCEDURE insertar_detalle_compra (
    @p_item INT,
    @p_cantidad INT,
    @p_precio DECIMAL(10,2),
    @p_subtotal DECIMAL(10,2),
    @p_id_compra VARCHAR(50),
    @p_id_producto VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la compra y el producto existan
        IF EXISTS (SELECT 1 FROM compra WHERE id_compra = @p_id_compra)
        AND EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si la compra y el producto existen, realizamos la inserción en 'detalle_compra'
            INSERT INTO detalle_compra (item, cantidad, precio, subtotal, id_compra, id_producto)
            VALUES (@p_item, @p_cantidad, @p_precio, @p_subtotal, @p_id_compra, @p_id_producto);
        END
        ELSE
        BEGIN
			-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la compra o el producto no existen, lanzamos un error
            THROW 50001, 'La compra o el producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH   
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un detalle de compra: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion ---
/*
EXEC dbo.insertar_detalle_compra 
    @p_item = 1,
    @p_cantidad = 3,
    @p_precio = 300.00,
    @p_subtotal = 900.00,
    @p_id_compra = 'COMP001',
    @p_id_producto = 'PROD001';

*/