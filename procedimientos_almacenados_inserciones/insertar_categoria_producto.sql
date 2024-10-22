-- Categoria Producto ---
CREATE PROCEDURE insertar_categoria_producto (
    @p_id_categoria VARCHAR(50),
    @p_id_producto VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la categoría y el producto existan
        IF EXISTS (SELECT 1 FROM categoria WHERE id_categoria = @p_id_categoria)
        AND EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si ambos existen, realizamos la inserción en 'categoria_producto'
            INSERT INTO categoria_producto (id_categoria, id_producto)
            VALUES (@p_id_categoria, @p_id_producto);
        END
        ELSE
        BEGIN
				-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la categoría o el producto no existen, lanzamos un error
            THROW 50001, 'La categoría o el producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una relación entre categoría y producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- ejecucion ---
/*
EXEC dbo.insertar_categoria_producto 
    @p_id_categoria = 'CAT001',
    @p_id_producto = 'PROD001';

*/