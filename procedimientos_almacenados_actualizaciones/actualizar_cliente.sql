-- Cliente --
CREATE PROCEDURE actualizar_cliente  (
    @p_id_cliente VARCHAR(50),
    @p_id_persona VARCHAR(50) = NULL,
    @p_direccion_facturacion VARCHAR(255) = NULL,
    @p_fax VARCHAR(20) = NULL,
    @p_celular VARCHAR(20) = NULL,
    @p_email_secundario VARCHAR(255) = NULL,
    @p_boletin BIT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el cliente exista
        IF EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE cliente
            SET id_persona = COALESCE(@p_id_persona, id_persona),
                direccion_facturacion = COALESCE(@p_direccion_facturacion, direccion_facturacion),
                fax = COALESCE(@p_fax, fax),
                celular = COALESCE(@p_celular, celular),
                email_secundario = COALESCE(@p_email_secundario, email_secundario),
                boletin = COALESCE(@p_boletin, boletin)
            WHERE id_cliente = @p_id_cliente;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el cliente no existe, lanzamos un error
            THROW 50001, 'El cliente especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un cliente: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- ejecucion --
/*
EXEC dbo.actualizar_cliente 
    @p_id_cliente = 'CL001',
    @p_celular = '111222333'; -- Solo se actualizará el celular

*/