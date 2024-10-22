--- Producto ---
CREATE PROCEDURE actualizar_producto (
    @p_id_producto VARCHAR(50),
    @p_titulo_es VARCHAR(255) = NULL,
    @p_titulo_en VARCHAR(255) = NULL,
    @p_descripcion_es TEXT = NULL,
    @p_descripcion_en TEXT = NULL,
    @p_precio DECIMAL(10,2) = NULL,
    @p_existencia INT = NULL,
    @p_peso NUMERIC = NULL,
    @p_mostrar_portada BIT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el producto exista
        IF EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE producto
            SET titulo_es = COALESCE(@p_titulo_es, titulo_es),
                titulo_en = COALESCE(@p_titulo_en, titulo_en),
                descripcion_es = COALESCE(@p_descripcion_es, descripcion_es),
                descripcion_en = COALESCE(@p_descripcion_en, descripcion_en),
                precio = COALESCE(@p_precio, precio),
                existencia = COALESCE(@p_existencia, existencia),
                peso = COALESCE(@p_peso, peso),
                mostrar_portada = COALESCE(@p_mostrar_portada, mostrar_portada)
            WHERE id_producto = @p_id_producto;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);

            -- Si el producto no existe, lanzamos un error
            THROW 50001, 'El producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_producto
    @p_id_producto = 'PROD001',
    @p_precio = 699.99; -- Solo se actualizará el precio

*/