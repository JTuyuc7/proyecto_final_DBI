-- Producto ---
CREATE PROCEDURE insertar_producto (
    @p_id_producto VARCHAR(50),
    @p_titulo_es VARCHAR(255),
    @p_titulo_en VARCHAR(255),
    @p_descripcion_es TEXT,
    @p_descripcion_en TEXT,
    @p_precio DECIMAL(10,2) = 0,  -- Valor predeterminado
    @p_existencia INT = 0,        -- Valor predeterminado
    @p_peso NUMERIC = 0,          -- Valor predeterminado
    @p_mostrar_portada BIT = 0     -- Valor predeterminado
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'producto'
        INSERT INTO producto (id_producto, titulo_es, titulo_en, descripcion_es, descripcion_en, precio, existencia, peso, mostrar_portada)
        VALUES (@p_id_producto, @p_titulo_es, @p_titulo_en, @p_descripcion_es, @p_descripcion_en, @p_precio, @p_existencia, @p_peso, @p_mostrar_portada);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;


--- Ejecucion ---

/*
EXEC dbo.insertar_producto 
    @p_id_producto = 'PROD001',
    @p_titulo_es = 'Teléfono',
    @p_titulo_en = 'Phone',
    @p_descripcion_es = 'Un teléfono avanzado',
    @p_descripcion_en = 'An advanced phone',
    @p_precio = 599.99,
    @p_existencia = 100,
    @p_peso = 0.5,
    @p_mostrar_portada = 1;

*/