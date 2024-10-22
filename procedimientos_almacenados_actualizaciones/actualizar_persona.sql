-- Persona --
CREATE PROCEDURE actualizar_persona  (
    @p_id_persona VARCHAR(50),
    @p_apellidos VARCHAR(255) = NULL,
    @p_nombres VARCHAR(255) = NULL,
    @p_direccion VARCHAR(255) = NULL,
    @p_telefono VARCHAR(20) = NULL,
    @p_fecha_nacimiento DATE = NULL,
    @p_id_pais INT = NULL,
    @p_id_ciudad INT = NULL,
    @p_id_provincia INT = NULL,
    @p_email VARCHAR(255) = NULL,
    @p_contrasena VARCHAR(255) = NULL,
    @p_sexo CHAR(1) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la persona exista
        IF EXISTS (SELECT 1 FROM persona WHERE id_persona = @p_id_persona)
        BEGIN
            -- Realizamos la actualización solo para los campos que no son NULL
            UPDATE persona
            SET apellidos = COALESCE(@p_apellidos, apellidos),
                nombres = COALESCE(@p_nombres, nombres),
                direccion = COALESCE(@p_direccion, direccion),
                telefono = COALESCE(@p_telefono, telefono),
                fecha_nacimiento = COALESCE(@p_fecha_nacimiento, fecha_nacimiento),
                id_pais = COALESCE(@p_id_pais, id_pais),
                id_ciudad = COALESCE(@p_id_ciudad, id_ciudad),
                id_provincia = COALESCE(@p_id_provincia, id_provincia),
                email = COALESCE(@p_email, email),
                contrasena = COALESCE(@p_contrasena, contrasena),
                sexo = COALESCE(@p_sexo, sexo)
            WHERE id_persona = @p_id_persona;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la persona no existe, lanzamos un error
            THROW 50001, 'La persona especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una persona: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;


-- ejecucion --
/*
EXEC dbo.actualizar_persona 
    @p_id_persona = 'P001',
    @p_apellidos = 'García',
    @p_nombres = 'Juan Carlos',
    @p_direccion = 'Avenida Principal 456',
    @p_telefono = '987654321',
    @p_fecha_nacimiento = '1990-05-20',
    @p_id_pais = 1,
    @p_id_ciudad = 1,
    @p_id_provincia = 1,
    @p_email = 'juancarlos.garcia@email.com',
    @p_contrasena = 'newpassword456',
    @p_sexo = 'M';

*/