-- Comentario producto --
CREATE PROCEDURE insertar_comentario_producto (
    @p_id_comentario VARCHAR(50),
    @p_texto TEXT,
    @p_fecha DATETIME,
    @p_conestacion VARCHAR(255),
    @p_fecha_conestacion DATETIME,
    @p_lenguaje VARCHAR(50),
    @p_id_producto VARCHAR(50),
    @p_id_cliente VARCHAR(50),
    @p_id_operador VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el producto, cliente y operador existan
        IF EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        AND EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        AND EXISTS (SELECT 1 FROM operador WHERE id_operador = @p_id_operador)
        BEGIN
            -- Si el producto, cliente y operador existen, realizamos la inserción en 'comentario_producto'
            INSERT INTO comentario_producto (id_comentario, texto, fecha, conestacion, fecha_conestacion, lenguaje, id_producto, id_cliente, id_operador)
            VALUES (@p_id_comentario, @p_texto, @p_fecha, @p_conestacion, @p_fecha_conestacion, @p_lenguaje, @p_id_producto, @p_id_cliente, @p_id_operador);
        END
        ELSE
        BEGIN
			-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si alguno de ellos no existe, lanzamos un error
            THROW 50001, 'El producto, cliente o operador especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un comentario de producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion ---
/*
EXEC dbo.insertar_comentario_producto 
    @p_id_comentario = 'COM001',
    @p_texto = 'Muy buen producto',
    @p_fecha = '2024-10-14 12:00:00',
    @p_conestacion = 'Gracias por tu comentario',
    @p_fecha_conestacion = '2024-10-15 08:00:00',
    @p_lenguaje = 'es',
    @p_id_producto = 'PROD001',
    @p_id_cliente = 'CL001',
    @p_id_operador = 'O001';

*/