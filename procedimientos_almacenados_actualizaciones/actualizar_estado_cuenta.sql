-- Estado cuenta --
CREATE PROCEDURE actualizar_estado_cuenta (
    @p_id_estado_cuenta INT,
    @p_descripcion VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el estado de cuenta exista
        IF EXISTS (SELECT 1 FROM estado_cuenta WHERE id_estado_cuenta = @p_id_estado_cuenta)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE estado_cuenta
            SET descripcion = COALESCE(@p_descripcion, descripcion)
            WHERE id_estado_cuenta = @p_id_estado_cuenta;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el estado de cuenta no existe, lanzamos un error
            THROW 50001, 'El estado de cuenta especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un estado de cuenta: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_estado_cuenta 
    @p_id_estado_cuenta = 1,
    @p_descripcion = 'Inactivo'; -- Solo se actualizará la descripción

*/