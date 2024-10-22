--- Sucursal ---
CREATE PROCEDURE insertar_sucursal (
    @p_id_sucursal VARCHAR(50),
    @p_nombre VARCHAR(255),
    @p_direccion VARCHAR(255),
    @p_id_ciudad INT,
    @p_telefono VARCHAR(20),
    @p_email VARCHAR(255)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ciudad sucursal exista
        IF EXISTS (SELECT 1 FROM ciudad_sucursal WHERE id_ciudad = @p_id_ciudad)
        BEGIN
            -- Si la ciudad sucursal existe, realizamos la inserción en 'sucursal'
            INSERT INTO sucursal (id_sucursal, nombre, direccion, id_ciudad, telefono, email)
            VALUES (@p_id_sucursal, @p_nombre, @p_direccion, @p_id_ciudad, @p_telefono, @p_email);
        END
        ELSE
        BEGIN
			-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la ciudad no existe, lanzamos un error
            THROW 50001, 'La ciudad especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una sucursal: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_sucursal 
    @p_id_sucursal = 'SUC001',
    @p_nombre = 'Sucursal Principal',
    @p_direccion = 'Av. Principal 123',
    @p_id_ciudad = 1,
    @p_telefono = '123456789',
    @p_email = 'sucursal@empresa.com';

*/