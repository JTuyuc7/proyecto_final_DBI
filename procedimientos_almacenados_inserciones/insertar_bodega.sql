-- 4 Bodega --
CREATE PROCEDURE insertar_bodega (
    @p_id_bodega VARCHAR(50),
    @p_nombre VARCHAR(255),
    @p_direccion VARCHAR(255),
    @p_id_sucursal VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la sucursal exista
        IF EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal)
        BEGIN
            -- Si la sucursal existe, realizamos la inserción en 'bodega'
            INSERT INTO bodega (id_bodega, nombre, direccion, id_sucursal)
            VALUES (@p_id_bodega, @p_nombre, @p_direccion, @p_id_sucursal);
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
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una bodega: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_bodega 
    @p_id_bodega = 'BOD001',
    @p_nombre = 'Bodega Principal',
    @p_direccion = 'Calle Comercio 123',
    @p_id_sucursal = 'SUC001';

*/