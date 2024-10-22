-- Comentario Producto --
CREATE PROCEDURE actualizar_comentario_producto (
    @p_id_comentario VARCHAR(50),
    @p_texto TEXT = NULL,
    @p_fecha DATETIME = NULL,
    @p_conestacion VARCHAR(255) = NULL,
    @p_fecha_conestacion DATETIME = NULL,
    @p_lenguaje VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL,
    @p_id_cliente VARCHAR(50) = NULL,
    @p_id_operador VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el comentario exista
        IF EXISTS (SELECT 1 FROM comentario_producto WHERE id_comentario = @p_id_comentario)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE comentario_producto
            SET texto = COALESCE(@p_texto, texto),
                fecha = COALESCE(@p_fecha, fecha),
                conestacion = COALESCE(@p_conestacion, conestacion),
                fecha_conestacion = COALESCE(@p_fecha_conestacion, fecha_conestacion),
                lenguaje = COALESCE(@p_lenguaje, lenguaje),
                id_producto = COALESCE(@p_id_producto, id_producto),
                id_cliente = COALESCE(@p_id_cliente, id_cliente),
                id_operador = COALESCE(@p_id_operador, id_operador)
            WHERE id_comentario = @p_id_comentario;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el comentario no existe, lanzamos un error
            THROW 50001, 'El comentario especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un comentario de producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_comentario_producto 
    @p_id_comentario = 'COM001',
    @p_conestacion = 'Gracias por tu opinión'; -- Solo se actualizará la contestación

*/