-- Categoria producto --
CREATE PROCEDURE actualizar_categoria_producto (
    @p_id_categoria_actual VARCHAR(50),
    @p_id_producto_actual VARCHAR(50),
    @p_id_categoria_nueva VARCHAR(50) = NULL,
    @p_id_producto_nuevo VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la relación entre la categoría y el producto exista
        IF EXISTS (SELECT 1 FROM categoria_producto WHERE id_categoria = @p_id_categoria_actual AND id_producto = @p_id_producto_actual)
        BEGIN
            -- Actualizamos la relación solo si se proporcionan nuevos valores
            UPDATE categoria_producto
            SET id_categoria = COALESCE(@p_id_categoria_nueva, id_categoria),
                id_producto = COALESCE(@p_id_producto_nuevo, id_producto)
            WHERE id_categoria = @p_id_categoria_actual AND id_producto = @p_id_producto_actual;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la relación no existe, lanzamos un error
            THROW 50001, 'La relación especificada entre categoría y producto no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar la relación entre categoría y producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_categoria_producto
    @p_id_categoria_actual = 'CAT001',
    @p_id_producto_actual = 'PROD001',
    @p_id_categoria_nueva = 'CAT002'; -- Solo se actualizará la categoría

*/