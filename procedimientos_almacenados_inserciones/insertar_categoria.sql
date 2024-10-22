--- Categoria ---
CREATE PROCEDURE insertar_categoria (
    @p_id_categoria VARCHAR(50),
    @p_nombre_es VARCHAR(255),
    @p_nombre_en VARCHAR(255),
    @p_orden INT,
    @p_imagen_es VARCHAR(255),
    @p_imagen_en VARCHAR(255),
    @p_mostrar BIT,
    @p_nivel_atencion INT,
    @p_seccion VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'categoria'
        INSERT INTO categoria (id_categoria, nombre_es, nombre_en, orden, imagen_es, imagen_en, mostrar, nivel_atencion, seccion)
        VALUES (@p_id_categoria, @p_nombre_es, @p_nombre_en, @p_orden, @p_imagen_es, @p_imagen_en, @p_mostrar, @p_nivel_atencion, @p_seccion);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una categoría: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

--- Ejecucion ---

/*
EXEC dbo.insertar_categoria 
    @p_id_categoria = 'CAT001',
    @p_nombre_es = 'Electrónica',
    @p_nombre_en = 'Electronics',
    @p_orden = 1,
    @p_imagen_es = 'imagen_es.png',
    @p_imagen_en = 'imagen_en.png',
    @p_mostrar = 1,
    @p_nivel_atencion = 3,
    @p_seccion = 'Tecnología';

*/