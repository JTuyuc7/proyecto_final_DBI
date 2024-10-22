--- Proveedor ---
CREATE PROCEDURE insertar_proveedor (
    @p_id_proveedor VARCHAR(50),
    @p_ruc VARCHAR(50),
    @p_nombre VARCHAR(255),
    @p_direccion VARCHAR(255),
    @p_ciudad VARCHAR(255),
    @p_pais VARCHAR(50),
    @p_telefono VARCHAR(20),
    @p_email VARCHAR(255),
    @p_contacto VARCHAR(255)
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'proveedor'
        INSERT INTO proveedor (id_proveedor, ruc, nombre, direccion, ciudad, pais, telefono, email, contacto)
        VALUES (@p_id_proveedor, @p_ruc, @p_nombre, @p_direccion, @p_ciudad, @p_pais, @p_telefono, @p_email, @p_contacto);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un proveedor: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

--- Ejecucion ---
/*

EXEC dbo.insertar_proveedor 
    @p_id_proveedor = 'PROV001',
    @p_ruc = '1234567890',
    @p_nombre = 'Proveedor ABC',
    @p_direccion = 'Calle Comercio 123',
    @p_ciudad = 'Lima',
    @p_pais = 'Perú',
    @p_telefono = '987654321',
    @p_email = 'proveedor@abc.com',
    @p_contacto = 'Juan Pérez';

*/