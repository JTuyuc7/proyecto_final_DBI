-- Compra ---
CREATE PROCEDURE insertar_compra (
    @p_id_compra VARCHAR(50),
    @p_fecha DATETIME,
    @p_total DECIMAL(10,2),
    @p_id_proveedor VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el proveedor exista en la tabla 'proveedor'
        IF EXISTS (SELECT 1 FROM proveedor WHERE id_proveedor = @p_id_proveedor)
        BEGIN
            -- Si el proveedor existe, realizamos la inserción en 'compra'
            INSERT INTO compra (id_compra, fecha, total, id_proveedor)
            VALUES (@p_id_compra, @p_fecha, @p_total, @p_id_proveedor);
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
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una compra: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

--- Ejecucion ---
/*
EXEC dbo.insertar_compra 
    @p_id_compra = 'COMP001',
    @p_fecha = '2024-10-14 10:30:00',
    @p_total = 1500.00,
    @p_id_proveedor = 'PROV001';

*/