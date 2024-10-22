-- Sucursal --
CREATE PROCEDURE actualizar_sucursal (
    @p_id_sucursal VARCHAR(50),
    @p_nombre VARCHAR(255) = NULL,
    @p_direccion VARCHAR(255) = NULL,
    @p_id_ciudad INT = NULL,
    @p_telefono VARCHAR(20) = NULL,
    @p_email VARCHAR(255) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la sucursal exista
        IF EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE sucursal
            SET nombre = COALESCE(@p_nombre, nombre),
                direccion = COALESCE(@p_direccion, direccion),
                id_ciudad = COALESCE(@p_id_ciudad, id_ciudad),
                telefono = COALESCE(@p_telefono, telefono),
                email = COALESCE(@p_email, email)
            WHERE id_sucursal = @p_id_sucursal;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la sucursal no existe, lanzamos un error
            THROW 50001, 'La sucursal especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una sucursal: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_sucursal 
    @p_id_sucursal = 'SUC001',
    @p_nombre = 'Nueva Sucursal'; -- Solo se actualizará el nombre

*/