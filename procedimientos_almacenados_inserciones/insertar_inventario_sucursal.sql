-- Inventario Sucursal --
CREATE PROCEDURE insertar_inventario_sucursal (
    @p_id_inventario VARCHAR(50),
    @p_id_sucursal VARCHAR(50),
    @p_id_producto VARCHAR(50),
    @p_cantidad INT,
    @p_fecha_actualizacion DATETIME
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la sucursal y el producto existan
        IF EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal)
        AND EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si la sucursal y el producto existen, realizamos la inserción en 'inventario_sucursal'
            INSERT INTO inventario_sucursal (id_inventario, id_sucursal, id_producto, cantidad, fecha_actualizacion)
            VALUES (@p_id_inventario, @p_id_sucursal, @p_id_producto, @p_cantidad, @p_fecha_actualizacion);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la sucursal o el producto no existen, lanzamos un error
            THROW 50001, 'La sucursal o el producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar en inventario de sucursal: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_inventario_sucursal 
    @p_id_inventario = 'INV001',
    @p_id_sucursal = 'SUC001',
    @p_id_producto = 'PROD001',
    @p_cantidad = 100,
    @p_fecha_actualizacion = '2024-10-15 12:00:00';

*/