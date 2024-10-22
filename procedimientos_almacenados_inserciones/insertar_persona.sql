---- Insertar Persona -----
CREATE PROCEDURE insertar_persona (
    @p_id_persona VARCHAR(50),
    @p_apellidos VARCHAR(255),
    @p_nombres VARCHAR(255),
    @p_direccion VARCHAR(255),
    @p_telefono VARCHAR(20),
    @p_fecha_nacimiento DATE,
    @p_id_pais INT,
    @p_id_ciudad INT,
    @p_id_provincia INT,
    @p_email VARCHAR(255),
    @p_contrasena VARCHAR(255),
    @p_sexo CHAR(1)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el país, provincia y ciudad existan
        IF EXISTS (SELECT 1 FROM pais WHERE id_pais = @p_id_pais)
        AND EXISTS (SELECT 1 FROM provincia WHERE id_provincia = @p_id_provincia)
        AND EXISTS (SELECT 1 FROM ciudad WHERE id_ciudad = @p_id_ciudad)
        BEGIN
            -- Si existen todos, realizamos la inserción en 'persona'
            INSERT INTO persona (id_persona, apellidos, nombres, direccion, telefono, fecha_nacimiento, id_pais, id_ciudad, id_provincia, email, contrasena, sexo)
            VALUES (@p_id_persona, @p_apellidos, @p_nombres, @p_direccion, @p_telefono, @p_fecha_nacimiento, @p_id_pais, @p_id_ciudad, @p_id_provincia, @p_email, @p_contrasena, @p_sexo);
        END
        ELSE
        BEGIN
			-- Manejo de errores personalizado
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si no existe algún dato relacionado, lanzamos un error
            THROW 50001, 'El país, la provincia o la ciudad especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH
        
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una persona: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

--- Ejecucion ---
/*
EXEC insertar_persona 
    @p_id_persona = 'P001',
    @p_apellidos = 'Garcia',
    @p_nombres = 'Juan',
    @p_direccion = 'Calle Falsa 123',
    @p_telefono = '123456789',
    @p_fecha_nacimiento = '1990-05-20',
    @p_id_pais = 1,
    @p_id_ciudad = 1,
    @p_id_provincia = 1,
    @p_email = 'juan.garcia@email.com',
    @p_contrasena = 'password123',
    @p_sexo = 'M';

*/