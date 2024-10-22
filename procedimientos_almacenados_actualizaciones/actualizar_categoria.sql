-- categoria --
CREATE PROCEDURE actualizar_categoria (
    @p_id_categoria VARCHAR(50),
    @p_nombre_es VARCHAR(255) = NULL,
    @p_nombre_en VARCHAR(255) = NULL,
    @p_orden INT = NULL,
    @p_imagen_es VARCHAR(255) = NULL,
    @p_imagen_en VARCHAR(255) = NULL,
    @p_mostrar BIT = NULL,
    @p_nivel_atencion INT = NULL,
    @p_seccion VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la categoría exista
        IF EXISTS (SELECT 1 FROM categoria WHERE id_categoria = @p_id_categoria)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE categoria
            SET nombre_es = COALESCE(@p_nombre_es, nombre_es),
                nombre_en = COALESCE(@p_nombre_en, nombre_en),
                orden = COALESCE(@p_orden, orden),
                imagen_es = COALESCE(@p_imagen_es, imagen_es),
                imagen_en = COALESCE(@p_imagen_en, imagen_en),
                mostrar = COALESCE(@p_mostrar, mostrar),
                nivel_atencion = COALESCE(@p_nivel_atencion, nivel_atencion),
                seccion = COALESCE(@p_seccion, seccion)
            WHERE id_categoria = @p_id_categoria;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la categoría no existe, lanzamos un error
            THROW 50001, 'La categoría especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una categoría: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- ejecucion --
/*
EXEC dbo.actualizar_categoria
    @p_id_categoria = 'CAT001',
    @p_nombre_es = 'Electrodomésticos'; -- Solo se actualizará el nombre en español

*/