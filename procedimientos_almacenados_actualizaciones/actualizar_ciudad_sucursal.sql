-- Ciudad sucursal --
CREATE PROCEDURE actualizar_ciudad_sucursal (
    @p_id_ciudad INT,
    @p_nombre VARCHAR(255) = NULL,
    @p_id_pais INT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ciudad sucursal exista
        IF EXISTS (SELECT 1 FROM ciudad_sucursal WHERE id_ciudad = @p_id_ciudad)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE ciudad_sucursal
            SET nombre = COALESCE(@p_nombre, nombre),
                id_pais = COALESCE(@p_id_pais, id_pais)
            WHERE id_ciudad = @p_id_ciudad;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la ciudad sucursal no existe, lanzamos un error
            THROW 50001, 'La ciudad sucursal especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una ciudad sucursal: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_ciudad_sucursal
    @p_id_ciudad = 1,
    @p_nombre = 'Nueva Ciudad Sucursal'; -- Solo se actualizará el nombre

*/