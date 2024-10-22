-- Estado Credito --
CREATE PROCEDURE actualizar_estado_credito (
    @p_id_estado_credito INT,
    @p_descripcion VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el estado de crédito exista
        IF EXISTS (SELECT 1 FROM estado_credito WHERE id_estado_credito = @p_id_estado_credito)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE estado_credito
            SET descripcion = COALESCE(@p_descripcion, descripcion)
            WHERE id_estado_credito = @p_id_estado_credito;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el estado de crédito no existe, lanzamos un error
            THROW 50001, 'El estado de crédito especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un estado de crédito: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_estado_credito 
    @p_id_estado_credito = 1,
    @p_descripcion = 'Rechazado'; -- Solo se actualizará la descripción

*/