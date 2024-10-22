-- Proveedor --
CREATE PROCEDURE actualizar_proveedor (
    @p_id_proveedor VARCHAR(50),
    @p_ruc VARCHAR(50) = NULL,
    @p_nombre VARCHAR(255) = NULL,
    @p_direccion VARCHAR(255) = NULL,
    @p_ciudad VARCHAR(255) = NULL,
    @p_pais VARCHAR(50) = NULL,
    @p_telefono VARCHAR(20) = NULL,
    @p_email VARCHAR(255) = NULL,
    @p_contacto VARCHAR(255) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el proveedor exista
        IF EXISTS (SELECT 1 FROM proveedor WHERE id_proveedor = @p_id_proveedor)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE proveedor
            SET ruc = COALESCE(@p_ruc, ruc),
                nombre = COALESCE(@p_nombre, nombre),
                direccion = COALESCE(@p_direccion, direccion),
                ciudad = COALESCE(@p_ciudad, ciudad),
                pais = COALESCE(@p_pais, pais),
                telefono = COALESCE(@p_telefono, telefono),
                email = COALESCE(@p_email, email),
                contacto = COALESCE(@p_contacto, contacto)
            WHERE id_proveedor = @p_id_proveedor;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el proveedor no existe, lanzamos un error
            THROW 50001, 'El proveedor especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un proveedor: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_proveedor 
    @p_id_proveedor = 'PROV001',
    @p_direccion = 'Nueva Dirección 456'; -- Solo se actualizará la dirección

*/