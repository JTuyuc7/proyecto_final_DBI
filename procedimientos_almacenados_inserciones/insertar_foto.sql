-- Foto --
CREATE PROCEDURE insertar_foto (
    @p_id_foto VARCHAR(50),
    @p_path VARCHAR(255),
    @p_id_producto VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el producto exista
        IF EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si el producto existe, realizamos la inserción en 'foto'
            INSERT INTO foto (id_foto, path, id_producto)
            VALUES (@p_id_foto, @p_path, @p_id_producto);
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
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una foto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_foto 
    @p_id_foto = 'FOTO001',
    @p_path = '/imagenes/productos/foto1.jpg',
    @p_id_producto = 'PROD001';
*/