-- Sucursal -- Ampliacion de las tablas 
CREATE PROCEDURE insertar_ciudad_sucursal (
    @p_id_ciudad INT,
    @p_nombre VARCHAR(255),
    @p_id_pais INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el país exista
        IF EXISTS (SELECT 1 FROM pais WHERE id_pais = @p_id_pais)
        BEGIN
            -- Si el país existe, realizamos la inserción en 'ciudad_sucursal'
            INSERT INTO ciudad_sucursal (id_ciudad, nombre, id_pais)
            VALUES (@p_id_ciudad, @p_nombre, @p_id_pais);
        END
        ELSE
        BEGIN
				-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el país no existe, lanzamos un error
            THROW 50001, 'El país especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una ciudad sucursal: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_ciudad_sucursal 
    @p_id_ciudad = 1,
    @p_nombre = 'Ciudad Sucursal 1',
    @p_id_pais = 3;

*/