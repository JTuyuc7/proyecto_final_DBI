----- Clientes ----
CREATE PROCEDURE insertar_cliente (
    @p_id_cliente VARCHAR(50),
    @p_id_persona VARCHAR(50),
    @p_direccion_facturacion VARCHAR(255),
    @p_fax VARCHAR(20),
    @p_celular VARCHAR(20),
    @p_email_secundario VARCHAR(255),
    @p_boletin BIT
)
AS
BEGIN
    BEGIN TRY
        -- Intentamos realizar la inserción
        INSERT INTO cliente(id_cliente, id_persona, direccion_facturacion, fax, celular, email_secundario, boletin)
        VALUES (@p_id_cliente, @p_id_persona, @p_direccion_facturacion, @p_fax, @p_celular, @p_email_secundario, @p_boletin);
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, lo manejamos aquí
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);

        -- Construimos el mensaje concatenado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un cliente: ' + @ErrorMessage;

        -- Lanzar un mensaje de error personalizado con el mensaje concatenado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

--- Ejecucion ---

/*
EXEC insertar_cliente 
    @p_id_cliente = 'CL001',
    @p_id_persona = 'P001',
    @p_direccion_facturacion = '123 Calle Falsa',
    @p_fax = '123456789',
    @p_celular = '987654321',
    @p_email_secundario = 'cliente@email.com',
    @p_boletin = 1;
*/