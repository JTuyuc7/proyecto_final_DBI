-- Todas las queries --

-- 1 crear la tabla pais --
CREATE TABLE pais (
    id_pais INT PRIMARY KEY,
    nombre VARCHAR(255),
    iso_codigo2 VARCHAR(50),
    iso_codigo3 VARCHAR(50),
    address_format VARCHAR(255)
);


-- crear la tabla provincia --
CREATE TABLE provincia (
    id_provincia INT PRIMARY KEY,
    nombre VARCHAR(255),
    id_pais INT,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

-- Crer la tabla ciudad --
CREATE TABLE ciudad (
    id_ciudad INT PRIMARY KEY,
    nombre VARCHAR(255),
    id_provincia INT,
    FOREIGN KEY (id_provincia) REFERENCES provincia(id_provincia)
);

-- Crear la tabla persona --
CREATE TABLE persona (
    id_persona VARCHAR(50) PRIMARY KEY,
    apellidos VARCHAR(255),
    nombres VARCHAR(255),
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    fecha_nacimiento DATE,
    id_pais INT,
    id_ciudad INT,
    id_provincia INT,
    email VARCHAR(255),
    contrasena VARCHAR(255),
    sexo CHAR(1),
    FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad),
    FOREIGN KEY (id_provincia) REFERENCES provincia(id_provincia),
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);


-- crear la tabla cliente --
CREATE TABLE cliente (
    id_cliente VARCHAR(50) PRIMARY KEY,
    id_persona VARCHAR(50),
    direccion_facturacion VARCHAR(255),
    fax VARCHAR(20),
    celular VARCHAR(20),
    email_secundario VARCHAR(255),
    boletin BIT,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);

-- crear la tabla operador --
CREATE TABLE operador (
    id_operador VARCHAR(50) PRIMARY KEY,
    id_persona VARCHAR(50),
    tipo VARCHAR(50),
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);


-- crear la tabla mensaje --
CREATE TABLE mensaje (
    id_mensaje VARCHAR(50) PRIMARY KEY,
    m_de VARCHAR(50),
    m_para VARCHAR(50),
    titulo VARCHAR(255),
    mensaje TEXT,
    fecha DATETIME,
    leido BIT,
    	-- Llaves foraneas para operador y cliente --
		id_cliente VARCHAR(50),
		id_operador VARCHAR(50),
		FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
		FOREIGN KEY (id_operador) REFERENCES operador(id_operador)
);


-- Crear la tabla pedido --
CREATE TABLE pedido (
    id_pedido VARCHAR(50) PRIMARY KEY,
    fecha DATETIME,
    total_pedido DECIMAL(10,2),
    forma_pago VARCHAR(50),
    pagado BIT DEFAULT 0,
    entregado BIT DEFAULT 0,
    reco_facturacion VARCHAR(255),
    empresa_transporte VARCHAR(255),
    costo_transporte DECIMAL(10,2),
    id_cliente VARCHAR(50),
    id_direccion VARCHAR(255),
    nro_documento_pago VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- crar la tabla categoria --
CREATE TABLE categoria (
    id_categoria VARCHAR(50) PRIMARY KEY,
    nombre_es VARCHAR(255),
    nombre_en VARCHAR(255),
    orden INT,
    imagen_es VARCHAR(255),
    imagen_en VARCHAR(255),
    mostrar BIT,
    nivel_atencion INT,
    seccion VARCHAR(50)
);

-- crear la tabla produto --
CREATE TABLE producto (
    id_producto VARCHAR(50) PRIMARY KEY,
    titulo_es VARCHAR(255),
    titulo_en VARCHAR(255),
    descripcion_es TEXT,
    descripcion_en TEXT,
    precio DECIMAL(10,2) DEFAULT 0,
    existencia INT DEFAULT 0,
    peso NUMERIC DEFAULT 0,
    mostrar_portada BIT DEFAULT 0,
    -- Agregar campo nuevo
    es_perecedero BIT DEFAULT 0
);

-- crear la tabla proveedor --
CREATE TABLE proveedor (
    id_proveedor VARCHAR(50) PRIMARY KEY,
    ruc VARCHAR(50),
    nombre VARCHAR(255),
    direccion VARCHAR(255),
    ciudad VARCHAR(255),
    pais VARCHAR(50),
    telefono VARCHAR(20),
    email VARCHAR(255),
    contacto VARCHAR(255)
);

-- crear la tabla compra --
CREATE TABLE compra (
    id_compra VARCHAR(50) PRIMARY KEY,
    fecha DATETIME,
    total DECIMAL(10,2),
    id_proveedor VARCHAR(50),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);


-- crear la tabla detalle pedido --
CREATE TABLE detalle_pedido (
    item INT PRIMARY KEY,
    cantidad INT,
    precio DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    id_pedido VARCHAR(50),
    id_producto VARCHAR(50),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- crear la tabla detalle --
CREATE TABLE detalle_compra (
    item INT PRIMARY KEY,
    cantidad INT,
    precio DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    id_compra VARCHAR(50),
    id_producto VARCHAR(50),
    FOREIGN KEY (id_compra) REFERENCES compra(id_compra),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- crear la tabla categoria del producto --
CREATE TABLE categoria_producto (
    id_categoria VARCHAR(50),
    id_producto VARCHAR(50),
    PRIMARY KEY (id_categoria, id_producto),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- crear la tabla comentario del producto --
CREATE TABLE comentario_producto (
    id_comentario VARCHAR(50) PRIMARY KEY,
    texto TEXT,
    fecha DATETIME,
    conestacion VARCHAR(255),
    fecha_conestacion DATETIME,
    lenguaje VARCHAR(50),
    id_producto VARCHAR(50),
    id_cliente VARCHAR(50),
    id_operador VARCHAR(50)
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_operador) REFERENCES operador(id_operador)
);

-- crear la tabla foto --
CREATE TABLE foto (
    id_foto VARCHAR(50) PRIMARY KEY,
    path VARCHAR(255),
    id_producto VARCHAR(50),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

--- 2 Ampliacion de las tablas ---
/*
	With expanded code
*/


-- Tablas de soporte para ciudad, país y provincia para sucursales
CREATE TABLE ciudad_sucursal (
    id_ciudad INT PRIMARY KEY,
    nombre VARCHAR(255),
    id_pais INT,
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

-- Tabla para las sucursales
CREATE TABLE sucursal (
    id_sucursal VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(255),
    direccion VARCHAR(255),
    id_ciudad INT,
    telefono VARCHAR(20),
    email VARCHAR(255),
    FOREIGN KEY (id_ciudad) REFERENCES ciudad_sucursal(id_ciudad)
);

-- Tabla para las bodegas
CREATE TABLE bodega (
    id_bodega VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(255),
    direccion VARCHAR(255),
    id_sucursal VARCHAR(50),
    FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
);

-- Modulo de Distribución de Producto en Ruta
CREATE TABLE ruta (
    id_ruta VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion TEXT
);

CREATE TABLE distribucion (
    id_distribucion VARCHAR(50) PRIMARY KEY,
    id_ruta VARCHAR(50),
    id_producto VARCHAR(50),
    cantidad INT,
    fecha_salida DATETIME,
    fecha_entrega DATETIME,
    estado VARCHAR(50),
    id_bodega_origen VARCHAR(50),
    id_sucursal_destino VARCHAR(50),
    FOREIGN KEY (id_ruta) REFERENCES ruta(id_ruta),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_bodega_origen) REFERENCES bodega(id_bodega),
    FOREIGN KEY (id_sucursal_destino) REFERENCES sucursal(id_sucursal)
);

-- Manejo de diversos inventarios (bodegas, sucursales, rutas)
CREATE TABLE inventario_bodega (
    id_inventario VARCHAR(50) PRIMARY KEY,
    id_bodega VARCHAR(50),
    id_producto VARCHAR(50),
    cantidad INT,
    fecha_actualizacion DATETIME,
    FOREIGN KEY (id_bodega) REFERENCES bodega(id_bodega),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE inventario_sucursal (
    id_inventario VARCHAR(50) PRIMARY KEY,
    id_sucursal VARCHAR(50),
    id_producto VARCHAR(50),
    cantidad INT,
    fecha_actualizacion DATETIME,
    FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE inventario_ruta (
    id_inventario VARCHAR(50) PRIMARY KEY,
    id_ruta VARCHAR(50),
    id_producto VARCHAR(50),
    cantidad INT,
    fecha_actualizacion DATETIME,
    FOREIGN KEY (id_ruta) REFERENCES ruta(id_ruta),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- Estado de Créditos
CREATE TABLE estado_credito (
    id_estado_credito INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

-- Modulo de Créditos
CREATE TABLE credito (
    id_credito VARCHAR(50) PRIMARY KEY,
    id_cliente VARCHAR(50),
    monto_total DECIMAL(10,2),
    monto_restante DECIMAL(10,2),
    fecha_inicio DATETIME,
    fecha_vencimiento DATETIME,
    id_estado_credito INT,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_estado_credito) REFERENCES estado_credito(id_estado_credito)
);

CREATE TABLE pago_credito (
    id_pago VARCHAR(50) PRIMARY KEY,
    id_credito VARCHAR(50),
    monto_pago DECIMAL(10,2),
    fecha_pago DATETIME,
    metodo_pago VARCHAR(50),
    FOREIGN KEY (id_credito) REFERENCES credito(id_credito)
);

-- Estado de Cuentas por Pagar
CREATE TABLE estado_cuenta (
    id_estado_cuenta INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

-- Modulo de Cuentas por Pagar
CREATE TABLE cuenta_por_pagar (
    id_cuenta_por_pagar VARCHAR(50) PRIMARY KEY,
    id_proveedor VARCHAR(50),
    monto_total DECIMAL(10,2),
    monto_restante DECIMAL(10,2),
    fecha_emision DATETIME,
    fecha_vencimiento DATETIME,
    id_estado_cuenta INT,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_estado_cuenta) REFERENCES estado_cuenta(id_estado_cuenta)
);

CREATE TABLE pago_cuenta_por_pagar (
    id_pago VARCHAR(50) PRIMARY KEY,
    id_cuenta_por_pagar VARCHAR(50),
    monto_pago DECIMAL(10,2),
    fecha_pago DATETIME,
    metodo_pago VARCHAR(50),
    FOREIGN KEY (id_cuenta_por_pagar) REFERENCES cuenta_por_pagar(id_cuenta_por_pagar)
);

-- INSERCION DE DATOS DE PRUEBA --

-- Pais --
INSERT INTO pais (id_pais, nombre, iso_codigo2, iso_codigo3, address_format) VALUES 
(1, 'Argentina', 'AR', 'ARG', '12345'),
(2, 'Brasil', 'BR', 'BRA', '67890'),
(3, 'Chile', 'CL', 'CHL', '54321'),
(4, 'Colombia', 'CO', 'COL', '98765'),
(5, 'Perú', 'PE', 'PER', '45678');


-- Provincias --
INSERT INTO provincia (id_provincia, nombre, id_pais) VALUES 
(1, 'Buenos Aires', 1),
(2, 'São Paulo', 2),
(3, 'Santiago', 3),
(4, 'Bogotá', 4),
(5, 'Lima', 5);


-- Ciudad --
INSERT INTO ciudad (id_ciudad, nombre, id_provincia) VALUES 
(1, 'La Plata', 1),
(2, 'Campinas', 2),
(3, 'Valparaíso', 3),
(4, 'Medellín', 4),
(5, 'Arequipa', 5);


-- Persona --
INSERT INTO persona (id_persona, apellidos, nombres, direccion, telefono, fecha_nacimiento, id_pais, id_ciudad, id_provincia, email, contrasena, sexo) VALUES 
('PER001', 'Gonzalez', 'Juan', 'Calle 1', '123456789', '1980-01-01', 1, 1, 1, 'juan.gonzalez@mail.com', 'password123', 'M'),
('PER002', 'Silva', 'Maria', 'Calle 2', '987654321', '1985-02-02', 2, 2, 2, 'maria.silva@mail.com', 'password123', 'F'),
('PER003', 'Rojas', 'Carlos', 'Calle 3', '456789123', '1990-03-03', 3, 3, 3, 'carlos.rojas@mail.com', 'password123', 'M'),
('PER004', 'Martinez', 'Ana', 'Calle 4', '789123456', '1995-04-04', 4, 4, 4, 'ana.martinez@mail.com', 'password123', 'F'),
('PER005', 'Perez', 'Luis', 'Calle 5', '321654987', '2000-05-05', 5, 5, 5, 'luis.perez@mail.com', 'password123', 'M');

-- Cliente -- 
INSERT INTO cliente (id_cliente, id_persona, direccion_facturacion, fax, celular, email_secundario, boletin) VALUES 
('CLI001', 'PER001', 'Calle 1', '111111', '123456789', 'juan.gonzalez@secmail.com', 1),
('CLI002', 'PER002', 'Calle 2', '222222', '987654321', 'maria.silva@secmail.com', 0),
('CLI003', 'PER003', 'Calle 3', '333333', '456789123', 'carlos.rojas@secmail.com', 1),
('CLI004', 'PER004', 'Calle 4', '444444', '789123456', 'ana.martinez@secmail.com', 0),
('CLI005', 'PER005', 'Calle 5', '555555', '321654987', 'luis.perez@secmail.com', 1);

-- Operador --
INSERT INTO operador (id_operador, id_persona, tipo) VALUES 
('OPE001', 'PER001', 'Admin'),
('OPE002', 'PER002', 'Supervisor'),
('OPE003', 'PER003', 'Gerente'),
('OPE004', 'PER004', 'Soporte'),
('OPE005', 'PER005', 'Vendedor');

-- Mensaje --
INSERT INTO mensaje (id_mensaje, m_de, m_para, titulo, mensaje, fecha, leido, id_cliente, id_operador) VALUES 
('MSG001', 'OPE001', 'CLI001', 'Bienvenido', 'Gracias por registrarse.', '2024-10-15 12:00:00', 1, 'CLI001', 'OPE001'),
('MSG002', 'OPE002', 'CLI002', 'Información', 'Su pedido ha sido enviado.', '2024-10-15 13:00:00', 0, 'CLI002', 'OPE002'),
('MSG003', 'OPE003', 'CLI003', 'Actualización', 'Su cuenta ha sido actualizada.', '2024-10-15 14:00:00', 1, 'CLI003', 'OPE003'),
('MSG004', 'OPE004', 'CLI004', 'Soporte', 'Estamos aquí para ayudar.', '2024-10-15 15:00:00', 0, 'CLI004', 'OPE004'),
('MSG005', 'OPE005', 'CLI005', 'Promoción', 'Descuentos en productos seleccionados.', '2024-10-15 16:00:00', 1, 'CLI005', 'OPE005');


-- Pedido --
INSERT INTO pedido (id_pedido, fecha, total_pedido, forma_pago, pagado, entregado, reco_facturacion, empresa_transporte, costo_transporte, id_cliente, id_direccion, nro_documento_pago) VALUES 
('PED001', '2024-10-15 12:00:00', 500.00, 'Tarjeta', 1, 0, 'Calle 1', 'DHL', 50.00, 'CLI001', 'Calle 1', 'DOC001'),
('PED002', '2024-10-15 13:00:00', 300.00, 'Efectivo', 1, 1, 'Calle 2', 'FedEx', 30.00, 'CLI002', 'Calle 2', 'DOC002'),
('PED003', '2024-10-15 14:00:00', 700.00, 'Tarjeta', 0, 0, 'Calle 3', 'UPS', 70.00, 'CLI003', 'Calle 3', 'DOC003'),
('PED004', '2024-10-15 15:00:00', 400.00, 'Transferencia', 1, 0, 'Calle 4', 'DHL', 40.00, 'CLI004', 'Calle 4', 'DOC004'),
('PED005', '2024-10-15 16:00:00', 600.00, 'Efectivo', 0, 1, 'Calle 5', 'FedEx', 60.00, 'CLI005', 'Calle 5', 'DOC005');


-- Producto -- 
INSERT INTO producto (id_producto, titulo_es, titulo_en, descripcion_es, descripcion_en, precio, existencia, peso, mostrar_portada, es_perecedero) VALUES 
('PROD001', 'Producto A', 'Product A', 'Descripción A', 'Description A', 50.00, 100, 1, 1, 0),
('PROD002', 'Producto B', 'Product B', 'Descripción B', 'Description B', 30.00, 200, 2, 0, 1),
('PROD003', 'Producto C', 'Product C', 'Descripción C', 'Description C', 20.00, 150, 1, 1, 0),
('PROD004', 'Producto D', 'Product D', 'Descripción D', 'Description D', 80.00, 120, 3, 0, 1),
('PROD005', 'Producto E', 'Product E', 'Descripción E', 'Description E', 60.00, 180, 2, 1, 0);

-- Detalle producto --
INSERT INTO detalle_pedido (item, cantidad, precio, subtotal, id_pedido, id_producto) VALUES 
(1, 2, 50.00, 100.00, 'PED001', 'PROD001'),
(2, 3, 30.00, 90.00, 'PED002', 'PROD002'),
(3, 1, 20.00, 20.00, 'PED003', 'PROD003'),
(4, 4, 80.00, 320.00, 'PED004', 'PROD004'),
(5, 5, 60.00, 300.00, 'PED005', 'PROD005');

-- Categoria --
INSERT INTO categoria (id_categoria, nombre_es, nombre_en, orden, imagen_es, imagen_en, mostrar, nivel_atencion, seccion) VALUES 
('CAT001', 'Categoría A', 'Category A', 1, 'img_a_es.jpg', 'img_a_en.jpg', 1, 1, 'Sección A'),
('CAT002', 'Categoría B', 'Category B', 2, 'img_b_es.jpg', 'img_b_en.jpg', 0, 2, 'Sección B'),
('CAT003', 'Categoría C', 'Category C', 3, 'img_c_es.jpg', 'img_c_en.jpg', 1, 1, 'Sección C'),
('CAT004', 'Categoría D', 'Category D', 4, 'img_d_es.jpg', 'img_d_en.jpg', 0, 2, 'Sección D'),
('CAT005', 'Categoría E', 'Category E', 5, 'img_e_es.jpg', 'img_e_en.jpg', 1, 1, 'Sección E');

-- proveedor --
-- Insertar datos en la tabla proveedor --
INSERT INTO proveedor (id_proveedor, ruc, nombre, direccion, ciudad, pais, telefono, email, contacto) VALUES
('PROV001', '1234567890', 'Proveedor A', 'Dirección A', 'Ciudad A', 'País A', '111111111', 'proveedora@mail.com', 'Contacto A'),
('PROV002', '0987654321', 'Proveedor B', 'Dirección B', 'Ciudad B', 'País B', '222222222', 'proveedorb@mail.com', 'Contacto B');


-- Compra --
INSERT INTO compra (id_compra, fecha, total, id_proveedor) VALUES
('COMP001', '2024-10-16 10:00:00', 1000.00, 'PROV001'),
('COMP002', '2024-10-16 11:00:00', 800.00, 'PROV002');

-- Detalle compra --
INSERT INTO detalle_compra (item, cantidad, precio, subtotal, id_compra, id_producto) VALUES
(1, 10, 50.00, 500.00, 'COMP001', 'PROD001'),
(2, 5, 60.00, 300.00, 'COMP002', 'PROD002');

-- Insertar datos en la tabla ciudad_sucursal --
INSERT INTO ciudad_sucursal (id_ciudad, nombre, id_pais) VALUES
(1, 'Rosario', 1),
(2, 'Rio de Janeiro', 2),
(3, 'Concepción', 3),
(4, 'Cali', 4),
(5, 'Cusco', 5);


---aca
-- Insertar datos en la tabla sucursal --
INSERT INTO sucursal (id_sucursal, nombre, direccion, id_ciudad, telefono, email) VALUES
('SUC001', 'Sucursal A', 'Dirección Sucursal A', 1, '333333333', 'sucursalA@mail.com'),
('SUC002', 'Sucursal B', 'Dirección Sucursal B', 2, '444444444', 'sucursalB@mail.com');

-- Insertar datos en la tabla bodega --
INSERT INTO bodega (id_bodega, nombre, direccion, id_sucursal) VALUES
('BOD001', 'Bodega A', 'Dirección Bodega A', 'SUC001'),
('BOD002', 'Bodega B', 'Dirección Bodega B', 'SUC002');

-- aca
-- Ruta --
INSERT INTO ruta (id_ruta, nombre, descripcion) VALUES
('RUTA001', 'Ruta Norte', 'Distribución al norte del país'),
('RUTA002', 'Ruta Sur', 'Distribución al sur del país');

-- Distribucion --
INSERT INTO distribucion (id_distribucion, id_ruta, id_producto, cantidad, fecha_salida, fecha_entrega, estado, id_bodega_origen, id_sucursal_destino) VALUES
('DIST001', 'RUTA001', 'PROD001', 100, '2024-10-16 08:00:00', '2024-10-17 10:00:00', 'Enviado', 'BOD001', 'SUC001'),
('DIST002', 'RUTA002', 'PROD002', 50, '2024-10-16 09:00:00', '2024-10-17 11:00:00', 'Pendiente', 'BOD002', 'SUC002');


-- Estado credito --
INSERT INTO estado_credito (id_estado_credito, descripcion) VALUES
(1, 'Activo'),
(2, 'Vencido');

-- Credito --
INSERT INTO credito (id_credito, id_cliente, monto_total, monto_restante, fecha_inicio, fecha_vencimiento, id_estado_credito) VALUES
('CRED001', 'CLI001', 5000.00, 2500.00, '2024-01-01', '2024-12-31', 1),
('CRED002', 'CLI002', 3000.00, 1000.00, '2024-01-15', '2024-11-30', 1);

-- Pago credito --
INSERT INTO pago_credito (id_pago, id_credito, monto_pago, fecha_pago, metodo_pago) VALUES
('PAGO001', 'CRED001', 1000.00, '2024-10-16 09:30:00', 'Tarjeta de Crédito'),
('PAGO002', 'CRED002', 500.00, '2024-10-16 10:00:00', 'Transferencia Bancaria');

-- categoria producto --
INSERT INTO categoria_producto (id_categoria, id_producto) VALUES
('CAT001', 'PROD001'),
('CAT002', 'PROD002');

-- inventario producto --
INSERT INTO inventario_bodega (id_inventario, id_bodega, id_producto, cantidad, fecha_actualizacion) VALUES
('INV001', 'BOD001', 'PROD001', 200, '2024-10-16 08:00:00'),
('INV002', 'BOD002', 'PROD002', 150, '2024-10-16 09:00:00');

-- Inventario sucursal --
INSERT INTO inventario_sucursal (id_inventario, id_sucursal, id_producto, cantidad, fecha_actualizacion) VALUES
('INV001', 'SUC001', 'PROD001', 50, '2024-10-16 10:00:00'),
('INV002', 'SUC002', 'PROD002', 30, '2024-10-16 11:00:00');

-- Inventario ruta --
INSERT INTO inventario_ruta (id_inventario, id_ruta, id_producto, cantidad, fecha_actualizacion) VALUES
('INV001', 'RUTA001', 'PROD001', 100, '2024-10-16 12:00:00'),
('INV002', 'RUTA002', 'PROD002', 80, '2024-10-16 13:00:00');

--! procedimietos --

GO;
-- FINALIZACION DE DATOS DE PRUEBA --


-- PROCEDIMIENTOS INSERCION DE DATOS --
-- 1 Insertar Pais --
CREATE PROCEDURE insertar_pais (
    @p_id_pais INT,
    @p_nombre VARCHAR(255),
    @p_iso_codigo2 VARCHAR(50),
    @p_iso_codigo3 VARCHAR(50),
    @p_address_format VARCHAR(255)
)
AS
BEGIN
    BEGIN TRY
        -- Intentamos realizar la inserción
        INSERT INTO pais (id_pais, nombre, iso_codigo2, iso_codigo3, address_format)
        VALUES (@p_id_pais, @p_nombre, @p_iso_codigo2, @p_iso_codigo3, @p_address_format);
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, lo manejamos aquí
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @CustomErrorMessage NVARCHAR(4000);
		SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un pais: ' + @ErrorMessage;

        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

/*
		-- ejecucion --
	EXEC dbo.insertar_pais 
    @p_id_pais = 5,
    @p_nombre = 'El Salvador',
    @p_iso_codigo2 = 'ES',
    @p_iso_codigo3 = 'ES',
    @p_address_format = 'Formato de dirección estándar 2';
*/
GO;
------------- Provincia -------------
CREATE PROCEDURE insertar_provincia (
    @p_id_provincia INT,
    @p_nombre VARCHAR(255),
    @p_id_pais INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el país exista en la tabla 'pais'
        IF EXISTS (SELECT 1 FROM pais WHERE id_pais = @p_id_pais)
        BEGIN
            -- Si el país existe, realizamos la inserción en 'provincia'

            INSERT INTO provincia (id_provincia, nombre, id_pais)
            VALUES (@p_id_provincia, @p_nombre, @p_id_pais);
        END
        ELSE
        BEGIN
            -- Si el país no existe, lanzamos un error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            DECLARE @CustomErrorMessage NVARCHAR(4000);
			SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una provincia: ' + @ErrorMessage;

			THROW 50000, @CustomErrorMessage, 1;
        END
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, lo manejamos aquí
		SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una provincia: ' + @ErrorMessage;

        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

/*
	--- Ejecucion ---
	EXEC dbo.insertar_provincia 
    @p_id_provincia = 1,
    @p_nombre = 'Prueba',
    @p_id_pais = 1;
*/

GO;
--------- Insertar Ciudad ----------
CREATE PROCEDURE insertar_ciudad (
    @p_id_ciudad INT,
    @p_nombre VARCHAR(255),
    @p_id_provincia INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la provincia exista en la tabla 'provincia'
        IF EXISTS (SELECT 1 FROM provincia WHERE id_provincia = @p_id_provincia)
        BEGIN
            -- Si la provincia existe, realizamos la inserción en 'ciudad'
            INSERT INTO ciudad (id_ciudad, nombre, id_provincia)
            VALUES (@p_id_ciudad, @p_nombre, @p_id_provincia);
        END
        ELSE
        BEGIN
			-- Manejo de errores personalizado
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
			
            -- Si la provincia no existe, lanzamos un error
            THROW 50001, 'La provincia especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH
		SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una ciudad: ' + @ErrorMessage;
        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

/*
	--- Ejecucion ---
	EXEC dbo.insertar_ciudad 
    @p_id_ciudad = 2,
    @p_nombre = 'Prueba 2',
    @p_id_provincia = 1;
*/
GO;

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
GO;

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
GO;

---- Operador ----
CREATE PROCEDURE insertar_operador (
    @p_id_operador VARCHAR(50),
    @p_id_persona VARCHAR(50),
    @p_tipo VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la persona exista en la tabla 'persona'
        IF EXISTS (SELECT 1 FROM persona WHERE id_persona = @p_id_persona)
        BEGIN
            -- Si la persona existe, realizamos la inserción en 'operador'
            INSERT INTO operador (id_operador, id_persona, tipo)
            VALUES (@p_id_operador, @p_id_persona, @p_tipo);
        END
        ELSE
        BEGIN
			-- Manejo de errores personalizado
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la persona no existe, lanzamos un error
            THROW 50001, 'La persona especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH
        
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un operador: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

--- Ejecucion ----

/*
	EXEC dbo.insertar_operador 
		@p_id_operador = 'O001',
		@p_id_persona = 'P001',
		@p_tipo = 'Administrador';

*/

GO;

CREATE PROCEDURE insertar_mensaje (
    @p_id_mensaje VARCHAR(50),
    @p_m_de VARCHAR(50),
    @p_m_para VARCHAR(50),
    @p_titulo VARCHAR(255),
    @p_mensaje TEXT,
    @p_fecha DATETIME,
    @p_leido BIT,
    @p_id_cliente VARCHAR(50),
    @p_id_operador VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el cliente y el operador existan
        IF EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        AND EXISTS (SELECT 1 FROM operador WHERE id_operador = @p_id_operador)
        BEGIN
            -- Si ambos existen, realizamos la inserción en 'mensaje'
            INSERT INTO mensaje (id_mensaje, m_de, m_para, titulo, mensaje, fecha, leido, id_cliente, id_operador)
            VALUES (@p_id_mensaje, @p_m_de, @p_m_para, @p_titulo, @p_mensaje, @p_fecha, @p_leido, @p_id_cliente, @p_id_operador);
        END
        ELSE
        BEGIN
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si no existe alguno de los datos relacionados, lanzamos un error con THROW
            THROW 50001, 'El cliente o el operador especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error original
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        -- Imprimimos detalles del error para diagnóstico
        PRINT 'ErrorMessage: ' + @ErrorMessage;
        PRINT 'ErrorLine: ' + CAST(@ErrorLine AS NVARCHAR(5));
        PRINT 'ErrorSeverity: ' + CAST(@ErrorSeverity AS NVARCHAR(5));
        PRINT 'ErrorState: ' + CAST(@ErrorState AS NVARCHAR(5));

        -- Concatenamos el mensaje personalizado
        
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un mensaje: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;


--- Ejecucion ---
/*
EXEC dbo.insertar_mensaje 
    @p_id_mensaje = 'M001',
    @p_m_de = 'qO001',
    @p_m_para = 'qC001',
    @p_titulo = 'Asunto importante',
    @p_mensaje = 'Este es un mensaje de prueba.',
    @p_fecha = '2024-10-13',
    @p_leido = 0,
    @p_id_cliente = 'CL001',
    @p_id_operador = 'O001';


*/
GO;

--- Categoria ---
CREATE PROCEDURE insertar_categoria (
    @p_id_categoria VARCHAR(50),
    @p_nombre_es VARCHAR(255),
    @p_nombre_en VARCHAR(255),
    @p_orden INT,
    @p_imagen_es VARCHAR(255),
    @p_imagen_en VARCHAR(255),
    @p_mostrar BIT,
    @p_nivel_atencion INT,
    @p_seccion VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'categoria'
        INSERT INTO categoria (id_categoria, nombre_es, nombre_en, orden, imagen_es, imagen_en, mostrar, nivel_atencion, seccion)
        VALUES (@p_id_categoria, @p_nombre_es, @p_nombre_en, @p_orden, @p_imagen_es, @p_imagen_en, @p_mostrar, @p_nivel_atencion, @p_seccion);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una categoría: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

--- Ejecucion ---

/*
EXEC dbo.insertar_categoria 
    @p_id_categoria = 'CAT001',
    @p_nombre_es = 'Electrónica',
    @p_nombre_en = 'Electronics',
    @p_orden = 1,
    @p_imagen_es = 'imagen_es.png',
    @p_imagen_en = 'imagen_en.png',
    @p_mostrar = 1,
    @p_nivel_atencion = 3,
    @p_seccion = 'Tecnología';

*/
GO;

-- Producto ---
CREATE PROCEDURE insertar_producto (
    @p_id_producto VARCHAR(50),
    @p_titulo_es VARCHAR(255),
    @p_titulo_en VARCHAR(255),
    @p_descripcion_es TEXT,
    @p_descripcion_en TEXT,
    @p_precio DECIMAL(10,2) = 0,  -- Valor predeterminado
    @p_existencia INT = 0,        -- Valor predeterminado
    @p_peso NUMERIC = 0,          -- Valor predeterminado
    @p_mostrar_portada BIT = 0     -- Valor predeterminado
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'producto'
        INSERT INTO producto (id_producto, titulo_es, titulo_en, descripcion_es, descripcion_en, precio, existencia, peso, mostrar_portada)
        VALUES (@p_id_producto, @p_titulo_es, @p_titulo_en, @p_descripcion_es, @p_descripcion_en, @p_precio, @p_existencia, @p_peso, @p_mostrar_portada);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;


--- Ejecucion ---

/*
EXEC dbo.insertar_producto 
    @p_id_producto = 'PROD001',
    @p_titulo_es = 'Teléfono',
    @p_titulo_en = 'Phone',
    @p_descripcion_es = 'Un teléfono avanzado',
    @p_descripcion_en = 'An advanced phone',
    @p_precio = 599.99,
    @p_existencia = 100,
    @p_peso = 0.5,
    @p_mostrar_portada = 1;

*/
GO;

--- Proveedor ---
CREATE PROCEDURE insertar_proveedor (
    @p_id_proveedor VARCHAR(50),
    @p_ruc VARCHAR(50),
    @p_nombre VARCHAR(255),
    @p_direccion VARCHAR(255),
    @p_ciudad VARCHAR(255),
    @p_pais VARCHAR(50),
    @p_telefono VARCHAR(20),
    @p_email VARCHAR(255),
    @p_contacto VARCHAR(255)
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'proveedor'
        INSERT INTO proveedor (id_proveedor, ruc, nombre, direccion, ciudad, pais, telefono, email, contacto)
        VALUES (@p_id_proveedor, @p_ruc, @p_nombre, @p_direccion, @p_ciudad, @p_pais, @p_telefono, @p_email, @p_contacto);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un proveedor: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

--- Ejecucion ---
/*

EXEC dbo.insertar_proveedor 
    @p_id_proveedor = 'PROV001',
    @p_ruc = '1234567890',
    @p_nombre = 'Proveedor ABC',
    @p_direccion = 'Calle Comercio 123',
    @p_ciudad = 'Lima',
    @p_pais = 'Perú',
    @p_telefono = '987654321',
    @p_email = 'proveedor@abc.com',
    @p_contacto = 'Juan Pérez';

*/
GO;

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
GO;

--- Detalle pedido ---
CREATE PROCEDURE insertar_detalle_pedido (
    @p_item INT,
    @p_cantidad INT,
    @p_precio DECIMAL(10,2),
    @p_subtotal DECIMAL(10,2),
    @p_id_pedido VARCHAR(50),
    @p_id_producto VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el pedido y el producto existan
        IF EXISTS (SELECT 1 FROM pedido WHERE id_pedido = @p_id_pedido)
        AND EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si el pedido y el producto existen, realizamos la inserción en 'detalle_pedido'
            INSERT INTO detalle_pedido (item, cantidad, precio, subtotal, id_pedido, id_producto)
            VALUES (@p_item, @p_cantidad, @p_precio, @p_subtotal, @p_id_pedido, @p_id_producto);
        END
        ELSE
        BEGIN
			-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el pedido o el producto no existen, lanzamos un error
            THROW 50001, 'El pedido o el producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un detalle de pedido: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_detalle_pedido 
    @p_item = 1,
    @p_cantidad = 2,
    @p_precio = 500.00,
    @p_subtotal = 1000.00,
    @p_id_pedido = 'P001',
    @p_id_producto = 'PROD001';

*/
GO;

-- 3 Detalle Compra ---
CREATE PROCEDURE insertar_detalle_compra (
    @p_item INT,
    @p_cantidad INT,
    @p_precio DECIMAL(10,2),
    @p_subtotal DECIMAL(10,2),
    @p_id_compra VARCHAR(50),
    @p_id_producto VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la compra y el producto existan
        IF EXISTS (SELECT 1 FROM compra WHERE id_compra = @p_id_compra)
        AND EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si la compra y el producto existen, realizamos la inserción en 'detalle_compra'
            INSERT INTO detalle_compra (item, cantidad, precio, subtotal, id_compra, id_producto)
            VALUES (@p_item, @p_cantidad, @p_precio, @p_subtotal, @p_id_compra, @p_id_producto);
        END
        ELSE
        BEGIN
			-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la compra o el producto no existen, lanzamos un error
            THROW 50001, 'La compra o el producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH   
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un detalle de compra: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion ---
/*
EXEC dbo.insertar_detalle_compra 
    @p_item = 1,
    @p_cantidad = 3,
    @p_precio = 300.00,
    @p_subtotal = 900.00,
    @p_id_compra = 'COMP001',
    @p_id_producto = 'PROD001';

*/
GO;

-- Categoria Producto ---
CREATE PROCEDURE insertar_categoria_producto (
    @p_id_categoria VARCHAR(50),
    @p_id_producto VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la categoría y el producto existan
        IF EXISTS (SELECT 1 FROM categoria WHERE id_categoria = @p_id_categoria)
        AND EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si ambos existen, realizamos la inserción en 'categoria_producto'
            INSERT INTO categoria_producto (id_categoria, id_producto)
            VALUES (@p_id_categoria, @p_id_producto);
        END
        ELSE
        BEGIN
				-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la categoría o el producto no existen, lanzamos un error
            THROW 50001, 'La categoría o el producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una relación entre categoría y producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- ejecucion ---
/*
EXEC dbo.insertar_categoria_producto 
    @p_id_categoria = 'CAT001',
    @p_id_producto = 'PROD001';

*/
GO;

-- Comentario producto --
CREATE PROCEDURE insertar_comentario_producto (
    @p_id_comentario VARCHAR(50),
    @p_texto TEXT,
    @p_fecha DATETIME,
    @p_conestacion VARCHAR(255),
    @p_fecha_conestacion DATETIME,
    @p_lenguaje VARCHAR(50),
    @p_id_producto VARCHAR(50),
    @p_id_cliente VARCHAR(50),
    @p_id_operador VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el producto, cliente y operador existan
        IF EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        AND EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        AND EXISTS (SELECT 1 FROM operador WHERE id_operador = @p_id_operador)
        BEGIN
            -- Si el producto, cliente y operador existen, realizamos la inserción en 'comentario_producto'
            INSERT INTO comentario_producto (id_comentario, texto, fecha, conestacion, fecha_conestacion, lenguaje, id_producto, id_cliente, id_operador)
            VALUES (@p_id_comentario, @p_texto, @p_fecha, @p_conestacion, @p_fecha_conestacion, @p_lenguaje, @p_id_producto, @p_id_cliente, @p_id_operador);
        END
        ELSE
        BEGIN
			-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si alguno de ellos no existe, lanzamos un error
            THROW 50001, 'El producto, cliente o operador especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un comentario de producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion ---
/*
EXEC dbo.insertar_comentario_producto 
    @p_id_comentario = 'COM001',
    @p_texto = 'Muy buen producto',
    @p_fecha = '2024-10-14 12:00:00',
    @p_conestacion = 'Gracias por tu comentario',
    @p_fecha_conestacion = '2024-10-15 08:00:00',
    @p_lenguaje = 'es',
    @p_id_producto = 'PROD001',
    @p_id_cliente = 'CL001',
    @p_id_operador = 'O001';

*/
GO;

-- Foto --
CREATE PROCEDURE insertar_foto (
    @p_id_foto VARCHAR(50),
    @p_path VARCHAR(255),
    @p_id_producto VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el producto exista
        IF EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si el producto existe, realizamos la inserción en 'foto'
            INSERT INTO foto (id_foto, path, id_producto)
            VALUES (@p_id_foto, @p_path, @p_id_producto);
        END
        ELSE
        BEGIN
			-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el producto no existe, lanzamos un error
            THROW 50001, 'El producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una foto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_foto 
    @p_id_foto = 'FOTO001',
    @p_path = '/imagenes/productos/foto1.jpg',
    @p_id_producto = 'PROD001';
*/
GO;

-- Sucursal -- Ampliacion de las tablas 
CREATE PROCEDURE insertar_ciudad_sucursal (
    @p_id_ciudad INT,
    @p_nombre VARCHAR(255),
    @p_id_pais INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el país exista
        IF EXISTS (SELECT 1 FROM pais WHERE id_pais = @p_id_pais)
        BEGIN
            -- Si el país existe, realizamos la inserción en 'ciudad_sucursal'
            INSERT INTO ciudad_sucursal (id_ciudad, nombre, id_pais)
            VALUES (@p_id_ciudad, @p_nombre, @p_id_pais);
        END
        ELSE
        BEGIN
				-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el país no existe, lanzamos un error
            THROW 50001, 'El país especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una ciudad sucursal: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_ciudad_sucursal 
    @p_id_ciudad = 1,
    @p_nombre = 'Ciudad Sucursal 1',
    @p_id_pais = 3;

*/
GO;

--- Sucursal ---
CREATE PROCEDURE insertar_sucursal (
    @p_id_sucursal VARCHAR(50),
    @p_nombre VARCHAR(255),
    @p_direccion VARCHAR(255),
    @p_id_ciudad INT,
    @p_telefono VARCHAR(20),
    @p_email VARCHAR(255)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ciudad sucursal exista
        IF EXISTS (SELECT 1 FROM ciudad_sucursal WHERE id_ciudad = @p_id_ciudad)
        BEGIN
            -- Si la ciudad sucursal existe, realizamos la inserción en 'sucursal'
            INSERT INTO sucursal (id_sucursal, nombre, direccion, id_ciudad, telefono, email)
            VALUES (@p_id_sucursal, @p_nombre, @p_direccion, @p_id_ciudad, @p_telefono, @p_email);
        END
        ELSE
        BEGIN
			-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la ciudad no existe, lanzamos un error
            THROW 50001, 'La ciudad especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una sucursal: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_sucursal 
    @p_id_sucursal = 'SUC001',
    @p_nombre = 'Sucursal Principal',
    @p_direccion = 'Av. Principal 123',
    @p_id_ciudad = 1,
    @p_telefono = '123456789',
    @p_email = 'sucursal@empresa.com';

*/
GO;

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
GO;

--- Ruta ---
CREATE PROCEDURE insertar_ruta (
    @p_id_ruta VARCHAR(50),
    @p_nombre VARCHAR(255),
    @p_descripcion TEXT
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'ruta'
        INSERT INTO ruta (id_ruta, nombre, descripcion)
        VALUES (@p_id_ruta, @p_nombre, @p_descripcion);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una ruta: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_ruta 
    @p_id_ruta = 'RUTA001',
    @p_nombre = 'Ruta Principal',
    @p_descripcion = 'Esta es la ruta principal para la distribución de productos.';

*/
GO;

--- Insertar distribucion ---
CREATE PROCEDURE insertar_distribucion (
    @p_id_distribucion VARCHAR(50),
    @p_id_ruta VARCHAR(50),
    @p_id_producto VARCHAR(50),
    @p_cantidad INT,
    @p_fecha_salida DATETIME,
    @p_fecha_entrega DATETIME,
    @p_estado VARCHAR(50),
    @p_id_bodega_origen VARCHAR(50),
    @p_id_sucursal_destino VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ruta, producto, bodega de origen y sucursal de destino existan
        IF EXISTS (SELECT 1 FROM ruta WHERE id_ruta = @p_id_ruta)
        AND EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        AND EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega_origen)
        AND EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal_destino)
        BEGIN
            -- Si todo existe, realizamos la inserción en 'distribucion'
            INSERT INTO distribucion (id_distribucion, id_ruta, id_producto, cantidad, fecha_salida, fecha_entrega, estado, id_bodega_origen, id_sucursal_destino)
            VALUES (@p_id_distribucion, @p_id_ruta, @p_id_producto, @p_cantidad, @p_fecha_salida, @p_fecha_entrega, @p_estado, @p_id_bodega_origen, @p_id_sucursal_destino);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si alguno no existe, lanzamos un error
            THROW 50001, 'La ruta, producto, bodega o sucursal especificados no existen', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una distribución: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_distribucion 
    @p_id_distribucion = 'DIST001',
    @p_id_ruta = 'RUTA001',
    @p_id_producto = 'PROD001',
    @p_cantidad = 50,
    @p_fecha_salida = '2024-10-15 09:00:00',
    @p_fecha_entrega = '2024-10-16 12:00:00',
    @p_estado = 'En camino',
    @p_id_bodega_origen = 'BOD001',
    @p_id_sucursal_destino = 'SUC001';

*/
GO;

-- Inventaio Bodega --
CREATE PROCEDURE insertar_inventario_bodega (
    @p_id_inventario VARCHAR(50),
    @p_id_bodega VARCHAR(50),
    @p_id_producto VARCHAR(50),
    @p_cantidad INT,
    @p_fecha_actualizacion DATETIME
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la bodega y el producto existan
        IF EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega)
        AND EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si la bodega y el producto existen, realizamos la inserción en 'inventario_bodega'
            INSERT INTO inventario_bodega (id_inventario, id_bodega, id_producto, cantidad, fecha_actualizacion)
            VALUES (@p_id_inventario, @p_id_bodega, @p_id_producto, @p_cantidad, @p_fecha_actualizacion);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
        
            -- Si la bodega o el producto no existen, lanzamos un error
            THROW 50001, 'La bodega o el producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar en inventario de bodega: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_inventario_bodega 
    @p_id_inventario = 'INV001',
    @p_id_bodega = 'BOD001',
    @p_id_producto = 'PROD001',
    @p_cantidad = 100,
    @p_fecha_actualizacion = '2024-10-15 10:00:00';

*/
GO;

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
GO;

-- Inventario Ruta --
CREATE PROCEDURE insertar_inventario_ruta (
    @p_id_inventario VARCHAR(50),
    @p_id_ruta VARCHAR(50),
    @p_id_producto VARCHAR(50),
    @p_cantidad INT,
    @p_fecha_actualizacion DATETIME
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ruta y el producto existan
        IF EXISTS (SELECT 1 FROM ruta WHERE id_ruta = @p_id_ruta)
        AND EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si la ruta y el producto existen, realizamos la inserción en 'inventario_ruta'
            INSERT INTO inventario_ruta (id_inventario, id_ruta, id_producto, cantidad, fecha_actualizacion)
            VALUES (@p_id_inventario, @p_id_ruta, @p_id_producto, @p_cantidad, @p_fecha_actualizacion);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
        
            -- Si la ruta o el producto no existen, lanzamos un error
            THROW 50001, 'La ruta o el producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar en inventario de ruta: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_inventario_ruta 
    @p_id_inventario = 'INV001',
    @p_id_ruta = 'RUTA001',
    @p_id_producto = 'PROD001',
    @p_cantidad = 50,
    @p_fecha_actualizacion = '2024-10-15 12:00:00';

*/
GO;

-- 5 Estado credito --
CREATE PROCEDURE insertar_estado_credito (
    @p_id_estado_credito INT,
    @p_descripcion VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'estado_credito'
        INSERT INTO estado_credito (id_estado_credito, descripcion)
        VALUES (@p_id_estado_credito, @p_descripcion);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un estado de crédito: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_estado_credito 
    @p_id_estado_credito = 1,
    @p_descripcion = 'Aprobado';

*/
GO;

-- Insertar credito --
CREATE PROCEDURE insertar_credito (
    @p_id_credito VARCHAR(50),
    @p_id_cliente VARCHAR(50),
    @p_monto_total DECIMAL(10,2),
    @p_monto_restante DECIMAL(10,2),
    @p_fecha_inicio DATETIME,
    @p_fecha_vencimiento DATETIME,
    @p_id_estado_credito INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el cliente y el estado de crédito existan
        IF EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        AND EXISTS (SELECT 1 FROM estado_credito WHERE id_estado_credito = @p_id_estado_credito)
        BEGIN
            -- Si el cliente y el estado de crédito existen, realizamos la inserción en 'credito'
            INSERT INTO credito (id_credito, id_cliente, monto_total, monto_restante, fecha_inicio, fecha_vencimiento, id_estado_credito)
            VALUES (@p_id_credito, @p_id_cliente, @p_monto_total, @p_monto_restante, @p_fecha_inicio, @p_fecha_vencimiento, @p_id_estado_credito);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el cliente o el estado de crédito no existen, lanzamos un error
            THROW 50001, 'El cliente o el estado de crédito especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un crédito: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_credito 
    @p_id_credito = 'CRED001',
    @p_id_cliente = 'CL001',
    @p_monto_total = 5000.00,
    @p_monto_restante = 2500.00,
    @p_fecha_inicio = '2024-10-15 09:00:00',
    @p_fecha_vencimiento = '2025-10-15 09:00:00',
    @p_id_estado_credito = 1;

*/
GO;

-- Pago Credito --
CREATE PROCEDURE insertar_pago_credito (
    @p_id_pago VARCHAR(50),
    @p_id_credito VARCHAR(50),
    @p_monto_pago DECIMAL(10,2),
    @p_fecha_pago DATETIME,
    @p_metodo_pago VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el crédito exista
        IF EXISTS (SELECT 1 FROM credito WHERE id_credito = @p_id_credito)
        BEGIN
            -- Si el crédito existe, realizamos la inserción en 'pago_credito'
            INSERT INTO pago_credito (id_pago, id_credito, monto_pago, fecha_pago, metodo_pago)
            VALUES (@p_id_pago, @p_id_credito, @p_monto_pago, @p_fecha_pago, @p_metodo_pago);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
        
            -- Si el crédito no existe, lanzamos un error
            THROW 50001, 'El crédito especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un pago de crédito: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_pago_credito 
    @p_id_pago = 'PAGO001',
    @p_id_credito = 'CRED001',
    @p_monto_pago = 500.00,
    @p_fecha_pago = '2024-10-15 10:00:00',
    @p_metodo_pago = 'Tarjeta de crédito';

*/
GO;

-- Estado Cuenta --
CREATE PROCEDURE insertar_estado_cuenta (
    @p_id_estado_cuenta INT,
    @p_descripcion VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Realizamos la inserción en la tabla 'estado_cuenta'
        INSERT INTO estado_cuenta (id_estado_cuenta, descripcion)
        VALUES (@p_id_estado_cuenta, @p_descripcion);
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un estado de cuenta: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_estado_cuenta 
    @p_id_estado_cuenta = 1,
    @p_descripcion = 'Activo';

*/
GO;

-- Cuentas por pagar --
CREATE PROCEDURE insertar_cuenta_por_pagar (
    @p_id_cuenta_por_pagar VARCHAR(50),
    @p_id_proveedor VARCHAR(50),
    @p_monto_total DECIMAL(10,2),
    @p_monto_restante DECIMAL(10,2),
    @p_fecha_emision DATETIME,
    @p_fecha_vencimiento DATETIME,
    @p_id_estado_cuenta INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el proveedor y el estado de cuenta existan
        IF EXISTS (SELECT 1 FROM proveedor WHERE id_proveedor = @p_id_proveedor)
        AND EXISTS (SELECT 1 FROM estado_cuenta WHERE id_estado_cuenta = @p_id_estado_cuenta)
        BEGIN
            -- Si el proveedor y el estado de cuenta existen, realizamos la inserción en 'cuenta_por_pagar'
            INSERT INTO cuenta_por_pagar (id_cuenta_por_pagar, id_proveedor, monto_total, monto_restante, fecha_emision, fecha_vencimiento, id_estado_cuenta)
            VALUES (@p_id_cuenta_por_pagar, @p_id_proveedor, @p_monto_total, @p_monto_restante, @p_fecha_emision, @p_fecha_vencimiento, @p_id_estado_cuenta);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el proveedor o el estado de cuenta no existen, lanzamos un error
            THROW 50001, 'El proveedor o el estado de cuenta especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar una cuenta por pagar: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.insertar_cuenta_por_pagar 
    @p_id_cuenta_por_pagar = 'CP001',
    @p_id_proveedor = 'PROV001',
    @p_monto_total = 3000.00,
    @p_monto_restante = 1500.00,
    @p_fecha_emision = '2024-10-15 10:00:00',
    @p_fecha_vencimiento = '2024-12-15 10:00:00',
    @p_id_estado_cuenta = 1;

*/
GO;

-- Pago cuenta por pagar --
CREATE PROCEDURE insertar_pago_cuenta_por_pagar (
    @p_id_pago VARCHAR(50),
    @p_id_cuenta_por_pagar VARCHAR(50),
    @p_monto_pago DECIMAL(10,2),
    @p_fecha_pago DATETIME,
    @p_metodo_pago VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la cuenta por pagar exista
        IF EXISTS (SELECT 1 FROM cuenta_por_pagar WHERE id_cuenta_por_pagar = @p_id_cuenta_por_pagar)
        BEGIN
            -- Si la cuenta por pagar existe, realizamos la inserción en 'pago_cuenta_por_pagar'
            INSERT INTO pago_cuenta_por_pagar (id_pago, id_cuenta_por_pagar, monto_pago, fecha_pago, metodo_pago)
            VALUES (@p_id_pago, @p_id_cuenta_por_pagar, @p_monto_pago, @p_fecha_pago, @p_metodo_pago);
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
        
            -- Si la cuenta por pagar no existe, lanzamos un error
            THROW 50001, 'La cuenta por pagar especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar insertar un pago de cuenta por pagar: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.insertar_pago_cuenta_por_pagar 
    @p_id_pago = 'PAG001',
    @p_id_cuenta_por_pagar = 'CP001',
    @p_monto_pago = 1000.00,
    @p_fecha_pago = '2024-10-15 14:00:00',
    @p_metodo_pago = 'Transferencia bancaria';

*/
GO;

-- PROCEDIMIENTOS ACTUALIZACIONES --

-- Pais --
CREATE PROCEDURE actualizar_pais (
    @p_id_pais INT,
    @p_nombre VARCHAR(255),
    @p_iso_codigo2 VARCHAR(50),
    @p_iso_codigo3 VARCHAR(50),
    @p_address_format VARCHAR(255)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el país exista antes de intentar actualizar
        IF EXISTS (SELECT 1 FROM pais WHERE id_pais = @p_id_pais)
        BEGIN
            -- Si el país existe, realizamos la actualización
            UPDATE pais
            SET nombre = @p_nombre,
                iso_codigo2 = @p_iso_codigo2,
                iso_codigo3 = @p_iso_codigo3,
                address_format = @p_address_format
            WHERE id_pais = @p_id_pais;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
        
            -- Si el país no existe, lanzamos un error
            THROW 50001, 'El país especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un país: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.actualizar_pais 
    @p_id_pais = 5,
    @p_nombre = 'El Salvador',
    @p_iso_codigo2 = 'SV',
    @p_iso_codigo3 = 'SLV',
    @p_address_format = 'Nuevo formato de dirección estándar';

*/
GO;

-- Provincia --
CREATE PROCEDURE actualizar_provincia (
    @p_id_provincia INT,
    @p_nombre VARCHAR(255),
    @p_id_pais INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la provincia y el país existan
        IF EXISTS (SELECT 1 FROM provincia WHERE id_provincia = @p_id_provincia)
        AND EXISTS (SELECT 1 FROM pais WHERE id_pais = @p_id_pais)
        BEGIN
            -- Si la provincia y el país existen, realizamos la actualización
            UPDATE provincia
            SET nombre = @p_nombre,
                id_pais = @p_id_pais
            WHERE id_provincia = @p_id_provincia;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la provincia o el país no existen, lanzamos un error
            THROW 50001, 'La provincia o el país especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una provincia: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.actualizar_provincia 
    @p_id_provincia = 1,
    @p_nombre = 'Nueva Provincia',
    @p_id_pais = 1;

*/
GO;

-- Actualizar ciudad --
CREATE PROCEDURE actualizar_ciudad (
    @p_id_ciudad INT,
    @p_nombre VARCHAR(255),
    @p_id_provincia INT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ciudad y la provincia existan
        IF EXISTS (SELECT 1 FROM ciudad WHERE id_ciudad = @p_id_ciudad)
        AND EXISTS (SELECT 1 FROM provincia WHERE id_provincia = @p_id_provincia)
        BEGIN
            -- Si la ciudad y la provincia existen, realizamos la actualización
            UPDATE ciudad
            SET nombre = @p_nombre,
                id_provincia = @p_id_provincia
            WHERE id_ciudad = @p_id_ciudad;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la ciudad o la provincia no existen, lanzamos un error
            THROW 50001, 'La ciudad o la provincia especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH

        
        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una ciudad: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_ciudad 
    @p_id_ciudad = 2,
    @p_nombre = 'Ciudad Actualizada',
    @p_id_provincia = 1;

*/
GO;

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
GO;

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
GO;

-- Operador --
CREATE PROCEDURE actualizar_operador (
    @p_id_operador VARCHAR(50),
    @p_id_persona VARCHAR(50) = NULL,
    @p_tipo VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el operador exista
        IF EXISTS (SELECT 1 FROM operador WHERE id_operador = @p_id_operador)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE operador
            SET id_persona = COALESCE(@p_id_persona, id_persona),
                tipo = COALESCE(@p_tipo, tipo)
            WHERE id_operador = @p_id_operador;
        END
        ELSE
        BEGIN
		-- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el operador no existe, lanzamos un error
            THROW 50001, 'El operador especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH
        

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un operador: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_operador
    @p_id_operador = 'O001',
    @p_tipo = 'Supervisor'; -- Solo se actualizará el campo tipo

*/
GO;

-- Mensaje --
CREATE PROCEDURE actualizar_mensaje (
    @p_id_mensaje VARCHAR(50),
    @p_m_de VARCHAR(50) = NULL,
    @p_m_para VARCHAR(50) = NULL,
    @p_titulo VARCHAR(255) = NULL,
    @p_mensaje TEXT = NULL,
    @p_fecha DATETIME = NULL,
    @p_leido BIT = NULL,
    @p_id_cliente VARCHAR(50) = NULL,
    @p_id_operador VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el mensaje exista
        IF EXISTS (SELECT 1 FROM mensaje WHERE id_mensaje = @p_id_mensaje)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE mensaje
            SET m_de = COALESCE(@p_m_de, m_de),
                m_para = COALESCE(@p_m_para, m_para),
                titulo = COALESCE(@p_titulo, titulo),
                mensaje = COALESCE(@p_mensaje, mensaje),
                fecha = COALESCE(@p_fecha, fecha),
                leido = COALESCE(@p_leido, leido),
                id_cliente = COALESCE(@p_id_cliente, id_cliente),
                id_operador = COALESCE(@p_id_operador, id_operador)
            WHERE id_mensaje = @p_id_mensaje;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el mensaje no existe, lanzamos un error
            THROW 50001, 'El mensaje especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un mensaje: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_mensaje
    @p_id_mensaje = 'M001',
    @p_titulo = 'Nuevo Asunto'; -- Solo se actualizará el título

*/
GO;

-- categoria --
CREATE PROCEDURE actualizar_categoria (
    @p_id_categoria VARCHAR(50),
    @p_nombre_es VARCHAR(255) = NULL,
    @p_nombre_en VARCHAR(255) = NULL,
    @p_orden INT = NULL,
    @p_imagen_es VARCHAR(255) = NULL,
    @p_imagen_en VARCHAR(255) = NULL,
    @p_mostrar BIT = NULL,
    @p_nivel_atencion INT = NULL,
    @p_seccion VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la categoría exista
        IF EXISTS (SELECT 1 FROM categoria WHERE id_categoria = @p_id_categoria)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE categoria
            SET nombre_es = COALESCE(@p_nombre_es, nombre_es),
                nombre_en = COALESCE(@p_nombre_en, nombre_en),
                orden = COALESCE(@p_orden, orden),
                imagen_es = COALESCE(@p_imagen_es, imagen_es),
                imagen_en = COALESCE(@p_imagen_en, imagen_en),
                mostrar = COALESCE(@p_mostrar, mostrar),
                nivel_atencion = COALESCE(@p_nivel_atencion, nivel_atencion),
                seccion = COALESCE(@p_seccion, seccion)
            WHERE id_categoria = @p_id_categoria;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la categoría no existe, lanzamos un error
            THROW 50001, 'La categoría especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una categoría: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- ejecucion --
/*
EXEC dbo.actualizar_categoria
    @p_id_categoria = 'CAT001',
    @p_nombre_es = 'Electrodomésticos'; -- Solo se actualizará el nombre en español

*/
GO;

--- Producto ---
CREATE PROCEDURE actualizar_producto (
    @p_id_producto VARCHAR(50),
    @p_titulo_es VARCHAR(255) = NULL,
    @p_titulo_en VARCHAR(255) = NULL,
    @p_descripcion_es TEXT = NULL,
    @p_descripcion_en TEXT = NULL,
    @p_precio DECIMAL(10,2) = NULL,
    @p_existencia INT = NULL,
    @p_peso NUMERIC = NULL,
    @p_mostrar_portada BIT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el producto exista
        IF EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE producto
            SET titulo_es = COALESCE(@p_titulo_es, titulo_es),
                titulo_en = COALESCE(@p_titulo_en, titulo_en),
                descripcion_es = COALESCE(@p_descripcion_es, descripcion_es),
                descripcion_en = COALESCE(@p_descripcion_en, descripcion_en),
                precio = COALESCE(@p_precio, precio),
                existencia = COALESCE(@p_existencia, existencia),
                peso = COALESCE(@p_peso, peso),
                mostrar_portada = COALESCE(@p_mostrar_portada, mostrar_portada)
            WHERE id_producto = @p_id_producto;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);

            -- Si el producto no existe, lanzamos un error
            THROW 50001, 'El producto especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH

        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_producto
    @p_id_producto = 'PROD001',
    @p_precio = 699.99; -- Solo se actualizará el precio

*/
GO;

-- Proveedor --
CREATE PROCEDURE actualizar_proveedor (
    @p_id_proveedor VARCHAR(50),
    @p_ruc VARCHAR(50) = NULL,
    @p_nombre VARCHAR(255) = NULL,
    @p_direccion VARCHAR(255) = NULL,
    @p_ciudad VARCHAR(255) = NULL,
    @p_pais VARCHAR(50) = NULL,
    @p_telefono VARCHAR(20) = NULL,
    @p_email VARCHAR(255) = NULL,
    @p_contacto VARCHAR(255) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el proveedor exista
        IF EXISTS (SELECT 1 FROM proveedor WHERE id_proveedor = @p_id_proveedor)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE proveedor
            SET ruc = COALESCE(@p_ruc, ruc),
                nombre = COALESCE(@p_nombre, nombre),
                direccion = COALESCE(@p_direccion, direccion),
                ciudad = COALESCE(@p_ciudad, ciudad),
                pais = COALESCE(@p_pais, pais),
                telefono = COALESCE(@p_telefono, telefono),
                email = COALESCE(@p_email, email),
                contacto = COALESCE(@p_contacto, contacto)
            WHERE id_proveedor = @p_id_proveedor;
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
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un proveedor: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_proveedor 
    @p_id_proveedor = 'PROV001',
    @p_direccion = 'Nueva Dirección 456'; -- Solo se actualizará la dirección

*/
GO;

-- compra --
CREATE PROCEDURE actualizar_compra (
    @p_id_compra VARCHAR(50),
    @p_fecha DATETIME = NULL,
    @p_total DECIMAL(10,2) = NULL,
    @p_id_proveedor VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la compra exista
        IF EXISTS (SELECT 1 FROM compra WHERE id_compra = @p_id_compra)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE compra
            SET fecha = COALESCE(@p_fecha, fecha),
                total = COALESCE(@p_total, total),
                id_proveedor = COALESCE(@p_id_proveedor, id_proveedor)
            WHERE id_compra = @p_id_compra;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la compra no existe, lanzamos un error
            THROW 50001, 'La compra especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una compra: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.actualizar_compra 
    @p_id_compra = 'COMP001',
    @p_total = 1800.00; -- Solo se actualizará el total

*/
GO;

-- Detalle pedido --
CREATE PROCEDURE actualizar_detalle_pedido (
    @p_item INT,
    @p_cantidad INT = NULL,
    @p_precio DECIMAL(10,2) = NULL,
    @p_subtotal DECIMAL(10,2) = NULL,
    @p_id_pedido VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el detalle del pedido exista
        IF EXISTS (SELECT 1 FROM detalle_pedido WHERE item = @p_item)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE detalle_pedido
            SET cantidad = COALESCE(@p_cantidad, cantidad),
                precio = COALESCE(@p_precio, precio),
                subtotal = COALESCE(@p_subtotal, subtotal),
                id_pedido = COALESCE(@p_id_pedido, id_pedido),
                id_producto = COALESCE(@p_id_producto, id_producto)
            WHERE item = @p_item;
        END
        ELSE
        BEGIN
			        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el detalle del pedido no existe, lanzamos un error
            THROW 50001, 'El detalle del pedido especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un detalle de pedido: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;

-- Ejecucion --
/*
EXEC dbo.actualizar_detalle_pedido 
    @p_item = 1,
    @p_cantidad = 5; -- Solo se actualizará la cantidad

*/
GO;

-- Detalle compra --
CREATE PROCEDURE actualizar_detalle_compra (
    @p_item INT,
    @p_cantidad INT = NULL,
    @p_precio DECIMAL(10,2) = NULL,
    @p_subtotal DECIMAL(10,2) = NULL,
    @p_id_compra VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el detalle de compra exista
        IF EXISTS (SELECT 1 FROM detalle_compra WHERE item = @p_item)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE detalle_compra
            SET cantidad = COALESCE(@p_cantidad, cantidad),
                precio = COALESCE(@p_precio, precio),
                subtotal = COALESCE(@p_subtotal, subtotal),
                id_compra = COALESCE(@p_id_compra, id_compra),
                id_producto = COALESCE(@p_id_producto, id_producto)
            WHERE item = @p_item;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el detalle de compra no existe, lanzamos un error
            THROW 50001, 'El detalle de compra especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un detalle de compra: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_detalle_compra 
    @p_item = 1,
    @p_cantidad = 5; -- Solo se actualizará la cantidad

*/
GO;

-- Categoria producto --
CREATE PROCEDURE actualizar_categoria_producto (
    @p_id_categoria_actual VARCHAR(50),
    @p_id_producto_actual VARCHAR(50),
    @p_id_categoria_nueva VARCHAR(50) = NULL,
    @p_id_producto_nuevo VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la relación entre la categoría y el producto exista
        IF EXISTS (SELECT 1 FROM categoria_producto WHERE id_categoria = @p_id_categoria_actual AND id_producto = @p_id_producto_actual)
        BEGIN
            -- Actualizamos la relación solo si se proporcionan nuevos valores
            UPDATE categoria_producto
            SET id_categoria = COALESCE(@p_id_categoria_nueva, id_categoria),
                id_producto = COALESCE(@p_id_producto_nuevo, id_producto)
            WHERE id_categoria = @p_id_categoria_actual AND id_producto = @p_id_producto_actual;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la relación no existe, lanzamos un error
            THROW 50001, 'La relación especificada entre categoría y producto no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar la relación entre categoría y producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_categoria_producto
    @p_id_categoria_actual = 'CAT001',
    @p_id_producto_actual = 'PROD001',
    @p_id_categoria_nueva = 'CAT002'; -- Solo se actualizará la categoría

*/
GO;

-- Comentario Producto --
CREATE PROCEDURE actualizar_comentario_producto (
    @p_id_comentario VARCHAR(50),
    @p_texto TEXT = NULL,
    @p_fecha DATETIME = NULL,
    @p_conestacion VARCHAR(255) = NULL,
    @p_fecha_conestacion DATETIME = NULL,
    @p_lenguaje VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL,
    @p_id_cliente VARCHAR(50) = NULL,
    @p_id_operador VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el comentario exista
        IF EXISTS (SELECT 1 FROM comentario_producto WHERE id_comentario = @p_id_comentario)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE comentario_producto
            SET texto = COALESCE(@p_texto, texto),
                fecha = COALESCE(@p_fecha, fecha),
                conestacion = COALESCE(@p_conestacion, conestacion),
                fecha_conestacion = COALESCE(@p_fecha_conestacion, fecha_conestacion),
                lenguaje = COALESCE(@p_lenguaje, lenguaje),
                id_producto = COALESCE(@p_id_producto, id_producto),
                id_cliente = COALESCE(@p_id_cliente, id_cliente),
                id_operador = COALESCE(@p_id_operador, id_operador)
            WHERE id_comentario = @p_id_comentario;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el comentario no existe, lanzamos un error
            THROW 50001, 'El comentario especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un comentario de producto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_comentario_producto 
    @p_id_comentario = 'COM001',
    @p_conestacion = 'Gracias por tu opinión'; -- Solo se actualizará la contestación

*/
GO;

-- Actualizar Foto --
CREATE PROCEDURE actualizar_foto (
    @p_id_foto VARCHAR(50),
    @p_path VARCHAR(255) = NULL,
    @p_id_producto VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la foto exista
        IF EXISTS (SELECT 1 FROM foto WHERE id_foto = @p_id_foto)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE foto
            SET path = COALESCE(@p_path, path),
                id_producto = COALESCE(@p_id_producto, id_producto)
            WHERE id_foto = @p_id_foto;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la foto no existe, lanzamos un error
            THROW 50001, 'La foto especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una foto: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_foto
    @p_id_foto = 'FOTO001',
    @p_path = '/imagenes/productos/nueva_foto.jpg'; -- Solo se actualizará el path

*/
GO;

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
GO;

-- Sucursal --
CREATE PROCEDURE actualizar_sucursal (
    @p_id_sucursal VARCHAR(50),
    @p_nombre VARCHAR(255) = NULL,
    @p_direccion VARCHAR(255) = NULL,
    @p_id_ciudad INT = NULL,
    @p_telefono VARCHAR(20) = NULL,
    @p_email VARCHAR(255) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la sucursal exista
        IF EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE sucursal
            SET nombre = COALESCE(@p_nombre, nombre),
                direccion = COALESCE(@p_direccion, direccion),
                id_ciudad = COALESCE(@p_id_ciudad, id_ciudad),
                telefono = COALESCE(@p_telefono, telefono),
                email = COALESCE(@p_email, email)
            WHERE id_sucursal = @p_id_sucursal;
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
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una sucursal: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_sucursal 
    @p_id_sucursal = 'SUC001',
    @p_nombre = 'Nueva Sucursal'; -- Solo se actualizará el nombre

*/
GO;

-- Bodega --
CREATE PROCEDURE actualizar_bodega (
    @p_id_bodega VARCHAR(50),
    @p_nombre VARCHAR(255) = NULL,
    @p_direccion VARCHAR(255) = NULL,
    @p_id_sucursal VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la bodega exista
        IF EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE bodega
            SET nombre = COALESCE(@p_nombre, nombre),
                direccion = COALESCE(@p_direccion, direccion),
                id_sucursal = COALESCE(@p_id_sucursal, id_sucursal)
            WHERE id_bodega = @p_id_bodega;
        END
        ELSE
        BEGIN
			        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la bodega no existe, lanzamos un error
            THROW 50001, 'La bodega especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una bodega: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_bodega
    @p_id_bodega = 'BOD001',
    @p_nombre = 'Nueva Bodega'; -- Solo se actualizará el nombre

*/
GO;

-- Ruta --
CREATE PROCEDURE actualizar_ruta (
    @p_id_ruta VARCHAR(50),
    @p_nombre VARCHAR(255) = NULL,
    @p_descripcion TEXT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ruta exista
        IF EXISTS (SELECT 1 FROM ruta WHERE id_ruta = @p_id_ruta)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE ruta
            SET nombre = COALESCE(@p_nombre, nombre),
                descripcion = COALESCE(@p_descripcion, descripcion)
            WHERE id_ruta = @p_id_ruta;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
		        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
				DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la ruta no existe, lanzamos un error
            THROW 50001, 'La ruta especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH



        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una ruta: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_ruta 
    @p_id_ruta = 'RUTA001',
    @p_nombre = 'Nueva Ruta'; -- Solo se actualizará el nombre

*/
GO;

-- Distribucion --
CREATE PROCEDURE actualizar_distribucion (
    @p_id_distribucion VARCHAR(50),
    @p_id_ruta VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL,
    @p_cantidad INT = NULL,
    @p_fecha_salida DATETIME = NULL,
    @p_fecha_entrega DATETIME = NULL,
    @p_estado VARCHAR(50) = NULL,
    @p_id_bodega_origen VARCHAR(50) = NULL,
    @p_id_sucursal_destino VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la distribución exista
        IF EXISTS (SELECT 1 FROM distribucion WHERE id_distribucion = @p_id_distribucion)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE distribucion
            SET id_ruta = COALESCE(@p_id_ruta, id_ruta),
                id_producto = COALESCE(@p_id_producto, id_producto),
                cantidad = COALESCE(@p_cantidad, cantidad),
                fecha_salida = COALESCE(@p_fecha_salida, fecha_salida),
                fecha_entrega = COALESCE(@p_fecha_entrega, fecha_entrega),
                estado = COALESCE(@p_estado, estado),
                id_bodega_origen = COALESCE(@p_id_bodega_origen, id_bodega_origen),
                id_sucursal_destino = COALESCE(@p_id_sucursal_destino, id_sucursal_destino)
            WHERE id_distribucion = @p_id_distribucion;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la distribución no existe, lanzamos un error
            THROW 50001, 'La distribución especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una distribución: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_distribucion 
    @p_id_distribucion = 'DIST001',
    @p_estado = 'Entregado'; -- Solo se actualizará el estado

*/
GO;

-- Inventario Bodega --
CREATE PROCEDURE actualizar_inventario_bodega (
    @p_id_inventario VARCHAR(50),
    @p_id_bodega VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL,
    @p_cantidad INT = NULL,
    @p_fecha_actualizacion DATETIME = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el inventario de bodega exista
        IF EXISTS (SELECT 1 FROM inventario_bodega WHERE id_inventario = @p_id_inventario)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE inventario_bodega
            SET id_bodega = COALESCE(@p_id_bodega, id_bodega),
                id_producto = COALESCE(@p_id_producto, id_producto),
                cantidad = COALESCE(@p_cantidad, cantidad),
                fecha_actualizacion = COALESCE(@p_fecha_actualizacion, fecha_actualizacion)
            WHERE id_inventario = @p_id_inventario;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el inventario no existe, lanzamos un error
            THROW 50001, 'El inventario de bodega especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un inventario de bodega: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- ejecucion --
/*
EXEC dbo.actualizar_inventario_bodega
    @p_id_inventario = 'INV001',
    @p_cantidad = 200; -- Solo se actualizará la cantidad

*/
GO;

-- Inventario Sucursal --
CREATE PROCEDURE actualizar_inventario_sucursal (
    @p_id_inventario VARCHAR(50),
    @p_id_sucursal VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL,
    @p_cantidad INT = NULL,
    @p_fecha_actualizacion DATETIME = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el inventario de sucursal exista
        IF EXISTS (SELECT 1 FROM inventario_sucursal WHERE id_inventario = @p_id_inventario)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE inventario_sucursal
            SET id_sucursal = COALESCE(@p_id_sucursal, id_sucursal),
                id_producto = COALESCE(@p_id_producto, id_producto),
                cantidad = COALESCE(@p_cantidad, cantidad),
                fecha_actualizacion = COALESCE(@p_fecha_actualizacion, fecha_actualizacion)
            WHERE id_inventario = @p_id_inventario;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el inventario no existe, lanzamos un error
            THROW 50001, 'El inventario de sucursal especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un inventario de sucursal: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_inventario_sucursal
    @p_id_inventario = 'INV001',
    @p_cantidad = 200; -- Solo se actualizará la cantidad

*/
GO;

-- Inventario ruta --
CREATE PROCEDURE actualizar_inventario_ruta (
    @p_id_inventario VARCHAR(50),
    @p_id_ruta VARCHAR(50) = NULL,
    @p_id_producto VARCHAR(50) = NULL,
    @p_cantidad INT = NULL,
    @p_fecha_actualizacion DATETIME = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el inventario de ruta exista
        IF EXISTS (SELECT 1 FROM inventario_ruta WHERE id_inventario = @p_id_inventario)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE inventario_ruta
            SET id_ruta = COALESCE(@p_id_ruta, id_ruta),
                id_producto = COALESCE(@p_id_producto, id_producto),
                cantidad = COALESCE(@p_cantidad, cantidad),
                fecha_actualizacion = COALESCE(@p_fecha_actualizacion, fecha_actualizacion)
            WHERE id_inventario = @p_id_inventario;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el inventario no existe, lanzamos un error
            THROW 50001, 'El inventario de ruta especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un inventario de ruta: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_inventario_ruta
    @p_id_inventario = 'INV001',
    @p_cantidad = 100; -- Solo se actualizará la cantidad

*/
GO;

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
GO;

-- Credito --
CREATE PROCEDURE actualizar_credito (
    @p_id_credito VARCHAR(50),
    @p_id_cliente VARCHAR(50) = NULL,
    @p_monto_total DECIMAL(10,2) = NULL,
    @p_monto_restante DECIMAL(10,2) = NULL,
    @p_fecha_inicio DATETIME = NULL,
    @p_fecha_vencimiento DATETIME = NULL,
    @p_id_estado_credito INT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el crédito exista
        IF EXISTS (SELECT 1 FROM credito WHERE id_credito = @p_id_credito)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE credito
            SET id_cliente = COALESCE(@p_id_cliente, id_cliente),
                monto_total = COALESCE(@p_monto_total, monto_total),
                monto_restante = COALESCE(@p_monto_restante, monto_restante),
                fecha_inicio = COALESCE(@p_fecha_inicio, fecha_inicio),
                fecha_vencimiento = COALESCE(@p_fecha_vencimiento, fecha_vencimiento),
                id_estado_credito = COALESCE(@p_id_estado_credito, id_estado_credito)
            WHERE id_credito = @p_id_credito;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el crédito no existe, lanzamos un error
            THROW 50001, 'El crédito especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un crédito: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_credito 
    @p_id_credito = 'CRED001',
    @p_monto_restante = 2000.00; -- Solo se actualizará el monto restante

*/
GO;

-- Pago Credito --
CREATE PROCEDURE actualizar_pago_credito (
    @p_id_pago VARCHAR(50),
    @p_id_credito VARCHAR(50) = NULL,
    @p_monto_pago DECIMAL(10,2) = NULL,
    @p_fecha_pago DATETIME = NULL,
    @p_metodo_pago VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el pago de crédito exista
        IF EXISTS (SELECT 1 FROM pago_credito WHERE id_pago = @p_id_pago)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE pago_credito
            SET id_credito = COALESCE(@p_id_credito, id_credito),
                monto_pago = COALESCE(@p_monto_pago, monto_pago),
                fecha_pago = COALESCE(@p_fecha_pago, fecha_pago),
                metodo_pago = COALESCE(@p_metodo_pago, metodo_pago)
            WHERE id_pago = @p_id_pago;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el pago de crédito no existe, lanzamos un error
            THROW 50001, 'El pago de crédito especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un pago de crédito: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_pago_credito
    @p_id_pago = 'PAGO001',
    @p_monto_pago = 600.00; -- Solo se actualizará el monto del pago

*/
GO;

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
GO;

-- Cuenta por pagar --
CREATE PROCEDURE actualizar_cuenta_por_pagar (
    @p_id_cuenta_por_pagar VARCHAR(50),
    @p_id_proveedor VARCHAR(50) = NULL,
    @p_monto_total DECIMAL(10,2) = NULL,
    @p_monto_restante DECIMAL(10,2) = NULL,
    @p_fecha_emision DATETIME = NULL,
    @p_fecha_vencimiento DATETIME = NULL,
    @p_id_estado_cuenta INT = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la cuenta por pagar exista
        IF EXISTS (SELECT 1 FROM cuenta_por_pagar WHERE id_cuenta_por_pagar = @p_id_cuenta_por_pagar)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE cuenta_por_pagar
            SET id_proveedor = COALESCE(@p_id_proveedor, id_proveedor),
                monto_total = COALESCE(@p_monto_total, monto_total),
                monto_restante = COALESCE(@p_monto_restante, monto_restante),
                fecha_emision = COALESCE(@p_fecha_emision, fecha_emision),
                fecha_vencimiento = COALESCE(@p_fecha_vencimiento, fecha_vencimiento),
                id_estado_cuenta = COALESCE(@p_id_estado_cuenta, id_estado_cuenta)
            WHERE id_cuenta_por_pagar = @p_id_cuenta_por_pagar;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si la cuenta por pagar no existe, lanzamos un error
            THROW 50001, 'La cuenta por pagar especificada no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar una cuenta por pagar: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_cuenta_por_pagar
    @p_id_cuenta_por_pagar = 'CP001',
    @p_monto_restante = 1000.00; -- Solo se actualizará el monto restante

*/
GO;

-- Pago cuenta por pagar --
CREATE PROCEDURE actualizar_pago_cuenta_por_pagar (
    @p_id_pago VARCHAR(50),
    @p_id_cuenta_por_pagar VARCHAR(50) = NULL,
    @p_monto_pago DECIMAL(10,2) = NULL,
    @p_fecha_pago DATETIME = NULL,
    @p_metodo_pago VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el pago de cuenta por pagar exista
        IF EXISTS (SELECT 1 FROM pago_cuenta_por_pagar WHERE id_pago = @p_id_pago)
        BEGIN
            -- Realizamos la actualización solo para los campos que no sean NULL
            UPDATE pago_cuenta_por_pagar
            SET id_cuenta_por_pagar = COALESCE(@p_id_cuenta_por_pagar, id_cuenta_por_pagar),
                monto_pago = COALESCE(@p_monto_pago, monto_pago),
                fecha_pago = COALESCE(@p_fecha_pago, fecha_pago),
                metodo_pago = COALESCE(@p_metodo_pago, metodo_pago)
            WHERE id_pago = @p_id_pago;
        END
        ELSE
        BEGIN
		        -- Capturamos el mensaje de error
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @CustomErrorMessage NVARCHAR(4000);
            -- Si el pago de cuenta por pagar no existe, lanzamos un error
            THROW 50001, 'El pago de cuenta por pagar especificado no existe', 1;
        END
    END TRY
    BEGIN CATCH


        -- Concatenamos el mensaje personalizado
        SET @CustomErrorMessage = 'Ha ocurrido un error al intentar actualizar un pago de cuenta por pagar: ' + @ErrorMessage;

        -- Lanzar el error con el mensaje personalizado
        THROW 50000, @CustomErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.actualizar_pago_cuenta_por_pagar
    @p_id_pago = 'PAG001',
    @p_monto_pago = 1500.00; -- Solo se actualizará el monto del pago

*/
GO;

-- PROCEDIMIENTOS ALMACENADOS ADICIONALES --

CREATE PROCEDURE llenar_pedido (
    @p_id_pedido VARCHAR(50),
    @p_fecha DATE,
    @p_total_pedido DECIMAL(10,2),
    @p_forma_pago VARCHAR(50),
    @p_pagado BIT,
    @p_entregado BIT,
    @p_reco_facturacion VARCHAR(255),
    @p_empresa_transporte VARCHAR(50),
    @p_costo_transporte DECIMAL(10,2),
    @p_id_cliente VARCHAR(50),
    @p_id_direccion VARCHAR(255),
    @p_nro_documento_pago VARCHAR(50),
    @detalles_pedido NVARCHAR(MAX)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el cliente exista
        IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        BEGIN
			DECLARE @ErrorMessage1 NVARCHAR(4000) = 'El cliente especificado no existe';
            THROW 50001, @ErrorMessage1, 1;
        END

        -- Insertamos el pedido en la tabla 'pedido'
        INSERT INTO pedido (
            id_pedido, fecha, total_pedido, forma_pago, pagado, entregado, 
            reco_facturacion, empresa_transporte, costo_transporte, id_cliente, 
            id_direccion, nro_documento_pago
        )
        VALUES (
            @p_id_pedido, @p_fecha, @p_total_pedido, @p_forma_pago, @p_pagado, 
            @p_entregado, @p_reco_facturacion, @p_empresa_transporte, @p_costo_transporte, 
            @p_id_cliente, @p_id_direccion, @p_nro_documento_pago
        );

        -- Parseamos el JSON de detalles de pedido
        DECLARE @DetallePedido TABLE (
            id_producto VARCHAR(50),
            cantidad INT,
            precio DECIMAL(10,2)
        );

        INSERT INTO @DetallePedido (id_producto, cantidad, precio)
        SELECT
            JSON_VALUE(value, '$.id_producto') AS id_producto,
            JSON_VALUE(value, '$.cantidad') AS cantidad,
            JSON_VALUE(value, '$.precio') AS precio
        FROM
            OPENJSON(@detalles_pedido);

        -- Obtener el valor máximo de 'item' para este 'id_pedido'
        DECLARE @ItemId INT;
        SELECT @ItemId = ISNULL(MAX(item), 0) + 1 FROM detalle_pedido;

        -- Imprimir el valor inicial de @ItemId
        PRINT 'Valor inicial de ItemId: ' + CAST(@ItemId AS NVARCHAR(10));

        -- Iteramos por los registros de la tabla temporal
        WHILE EXISTS (SELECT 1 FROM @DetallePedido)
        BEGIN
            DECLARE @IdProducto VARCHAR(50);
            DECLARE @Cantidad INT;
            DECLARE @Precio DECIMAL(10,2);

            SELECT TOP 1
                @IdProducto = id_producto,
                @Cantidad = cantidad,
                @Precio = precio
            FROM
                @DetallePedido;

            -- Verificamos que el producto exista
            IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @IdProducto)
            BEGIN
				DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
				THROW 50001, @ErrorMessage2, 1;
            END

            -- Calculamos el subtotal
            DECLARE @Subtotal DECIMAL(10,2) = @Cantidad * @Precio;

            -- Imprimir el valor actual de @ItemId antes de insertar
            PRINT 'Insertando detalle con ItemId: ' + CAST(@ItemId AS NVARCHAR(10));

            -- Insertamos el detalle en 'detalle_pedido'
            INSERT INTO detalle_pedido (item, cantidad, precio, subtotal, id_pedido, id_producto)
            VALUES (@ItemId, @Cantidad, @Precio, @Subtotal, @p_id_pedido, @IdProducto);

            -- Incrementamos el contador de ítems
            SET @ItemId = @ItemId + 1;

            -- Eliminamos el registro procesado de la tabla temporal
            DELETE FROM @DetallePedido WHERE id_producto = @IdProducto;
        END
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error real y lo lanzamos
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
		DECLARE @ERRORMESSAGEPEDIDO NVARCHAR(4000) = 'Error al intentar insertar el pedido: ';

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage, 1;
    END CATCH;
END;


-- ejecucion --
/*
DECLARE @detalles_pedido NVARCHAR(MAX) = N'[
		-- asegurar que el producto ID exista --
    {"id_producto": "PROD001", "cantidad": 2, "precio": 500.00},
    {"id_producto": "PROD001", "cantidad": 1, "precio": 300.00}
]';

EXEC dbo.llenar_pedido 
		-- Cambiar el pedido ID --
    @p_id_pedido = 'P0015',
    @p_fecha = '2024-10-16',
    @p_total_pedido = 1300.00,
    @p_forma_pago = 'Tarjeta de crédito',
    @p_pagado = 1,
    @p_entregado = 0,
    @p_reco_facturacion = 'Direccion 123',
    @p_empresa_transporte = 'DHL',
    @p_costo_transporte = 50.00,
    @p_id_cliente = 'CL001',
    @p_id_direccion = 'Direccion de entrega 456',
    @p_nro_documento_pago = '123456',
    @detalles_pedido = @detalles_pedido;

*/
GO;

-- Crear factura --
CREATE PROCEDURE crear_factura (
    @p_id_factura VARCHAR(50),
    @p_fecha DATE,
    @p_total DECIMAL(10,2),
    @p_id_cliente VARCHAR(50),
    @detalles_factura NVARCHAR(MAX)  -- JSON con los detalles de la factura
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el cliente exista
        IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        BEGIN
			DECLARE @ErrorMessage1 NVARCHAR(4000) = 'El cliente especificado no existe';
            THROW 50001, @ErrorMessage1, 1;
        END

        -- Insertamos la cabecera de la factura en la tabla 'factura'
        INSERT INTO factura (id_factura, fecha, total, id_cliente)
        VALUES (@p_id_factura, @p_fecha, @p_total, @p_id_cliente);

        -- Parseamos el JSON de detalles de factura
        DECLARE @DetalleFactura TABLE (
            id_producto VARCHAR(50),
            cantidad INT,
            precio DECIMAL(10,2)
        );

        INSERT INTO @DetalleFactura (id_producto, cantidad, precio)
        SELECT
            JSON_VALUE(value, '$.id_producto') AS id_producto,
            JSON_VALUE(value, '$.cantidad') AS cantidad,
            JSON_VALUE(value, '$.precio') AS precio
        FROM
            OPENJSON(@detalles_factura);

        -- Obtener el valor máximo de 'item' para este 'id_factura'
        DECLARE @ItemId INT;
        SELECT @ItemId = ISNULL(MAX(item), 0) + 1 FROM detalle_factura;

        -- Iteramos por los registros de la tabla temporal
        WHILE EXISTS (SELECT 1 FROM @DetalleFactura)
        BEGIN
            DECLARE @IdProducto VARCHAR(50);
            DECLARE @Cantidad INT;
            DECLARE @Precio DECIMAL(10,2);

            SELECT TOP 1
                @IdProducto = id_producto,
                @Cantidad = cantidad,
                @Precio = precio
            FROM
                @DetalleFactura;

            -- Verificamos que el producto exista
            IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @IdProducto)
            BEGIN
				DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
				THROW 50001, @ErrorMessage2, 1;
            END

            -- Calculamos el subtotal
            DECLARE @Subtotal DECIMAL(10,2) = @Cantidad * @Precio;

            -- Insertamos el detalle en 'detalle_factura'
            INSERT INTO detalle_factura (item, id_factura, id_producto, cantidad, precio, subtotal)
            VALUES (@ItemId, @p_id_factura, @IdProducto, @Cantidad, @Precio, @Subtotal);

            -- Incrementamos el contador de ítems
            SET @ItemId = @ItemId + 1;

            -- Eliminamos el registro procesado de la tabla temporal
            DELETE FROM @DetalleFactura WHERE id_producto = @IdProducto;
        END
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error real y lo lanzamos
        DECLARE @ErrorMessage NVARCHAR(4000) = 'Error al intentar insertar la factura: ';
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
DECLARE @detalles_factura NVARCHAR(MAX) = N'[
    {"id_producto": "PROD001", "cantidad": 2, "precio": 500.00},
    {"id_producto": "PROD002", "cantidad": 1, "precio": 300.00}
]';

EXEC dbo.crear_factura 
    @p_id_factura = 'F001',
    @p_fecha = '2024-10-16',
    @p_total = 1300.00,
    @p_id_cliente = 'CL001',
    @detalles_factura = @detalles_factura;

*/
GO;

CREATE PROCEDURE cargar_producto (
    @p_id_producto VARCHAR(50),
    @p_cantidad INT,
    @p_id_bodega VARCHAR(50) = NULL,   -- Opción para bodega
    @p_id_sucursal VARCHAR(50) = NULL, -- Opción para sucursal
    @p_fecha_actualizacion DATETIME
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el producto exista
        IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El producto especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Si se especifica bodega, realizamos la carga en bodega
        IF @p_id_bodega IS NOT NULL
        BEGIN
            -- Verificamos si el producto ya está en el inventario de la bodega
            IF EXISTS (SELECT 1 FROM inventario_bodega WHERE id_producto = @p_id_producto AND id_bodega = @p_id_bodega)
            BEGIN
                -- Actualizamos la cantidad del producto en la bodega
                UPDATE inventario_bodega
                SET cantidad = cantidad + @p_cantidad, fecha_actualizacion = @p_fecha_actualizacion
                WHERE id_producto = @p_id_producto AND id_bodega = @p_id_bodega;
            END
            ELSE
            BEGIN
                -- Insertamos el producto en el inventario de la bodega
                INSERT INTO inventario_bodega (id_inventario, id_bodega, id_producto, cantidad, fecha_actualizacion)
                VALUES (NEWID(), @p_id_bodega, @p_id_producto, @p_cantidad, @p_fecha_actualizacion);
            END
        END

        -- Si se especifica sucursal, realizamos la carga en sucursal
        IF @p_id_sucursal IS NOT NULL
        BEGIN
            -- Verificamos si el producto ya está en el inventario de la sucursal
            IF EXISTS (SELECT 1 FROM inventario_sucursal WHERE id_producto = @p_id_producto AND id_sucursal = @p_id_sucursal)
            BEGIN
                -- Actualizamos la cantidad del producto en la sucursal
                UPDATE inventario_sucursal
                SET cantidad = cantidad + @p_cantidad, fecha_actualizacion = @p_fecha_actualizacion
                WHERE id_producto = @p_id_producto AND id_sucursal = @p_id_sucursal;
            END
            ELSE
            BEGIN
                -- Insertamos el producto en el inventario de la sucursal
                INSERT INTO inventario_sucursal (id_inventario, id_sucursal, id_producto, cantidad, fecha_actualizacion)
                VALUES (NEWID(), @p_id_sucursal, @p_id_producto, @p_cantidad, @p_fecha_actualizacion);
            END
        END

    END TRY
    BEGIN CATCH
        -- Capturamos y lanzamos cualquier error que ocurra
        DECLARE @ErrorMessage2 NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 50000, @ErrorMessage2, 1;
    END CATCH
END;

-- Ejecucion --
/*
DECLARE @fecha_actualizacion DATETIME = GETDATE();

-- Ejecutar procedimiento para cargar producto en la bodega
EXEC dbo.cargar_producto 
    @p_id_producto = 'PROD001',
    @p_cantidad = 50,
    @p_id_bodega = 'BOD001',   -- Indicamos la bodega
    @p_fecha_actualizacion = @fecha_actualizacion;

-- Ejecutar procedimiento para cargar producto en la bodega
EXEC dbo.cargar_producto 
    @p_id_producto = 'PROD001',
    @p_cantidad = 50,
    @p_id_bodega = 'BOD001',   -- Indicamos la bodega
    @p_fecha_actualizacion = @fecha_actualizacion;


*/
GO;

CREATE PROCEDURE descargar_producto (
    @p_id_producto VARCHAR(50),
    @p_cantidad INT,
    @p_id_bodega VARCHAR(50) = NULL,   -- Opción para bodega
    @p_id_sucursal VARCHAR(50) = NULL, -- Opción para sucursal
    @p_fecha_actualizacion DATETIME
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el producto exista
        IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El producto especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Si se especifica bodega, realizamos la descarga de bodega
        IF @p_id_bodega IS NOT NULL
        BEGIN
            -- Verificamos que haya suficiente cantidad en la bodega
            IF EXISTS (SELECT 1 FROM inventario_bodega WHERE id_producto = @p_id_producto AND id_bodega = @p_id_bodega AND cantidad >= @p_cantidad)
            BEGIN
                -- Actualizamos la cantidad del producto en la bodega
                UPDATE inventario_bodega
                SET cantidad = cantidad - @p_cantidad, fecha_actualizacion = @p_fecha_actualizacion
                WHERE id_producto = @p_id_producto AND id_bodega = @p_id_bodega;
            END
            ELSE
            BEGIN
                DECLARE @ErrorMessage3 NVARCHAR(4000) = 'Cantidad insuficiente en la bodega';
                THROW 50002, @ErrorMessage3, 1;
            END
        END

        -- Si se especifica sucursal, realizamos la descarga de sucursal
        IF @p_id_sucursal IS NOT NULL
        BEGIN
            -- Verificamos que haya suficiente cantidad en la sucursal
            IF EXISTS (SELECT 1 FROM inventario_sucursal WHERE id_producto = @p_id_producto AND id_sucursal = @p_id_sucursal AND cantidad >= @p_cantidad)
            BEGIN
                -- Actualizamos la cantidad del producto en la sucursal
                UPDATE inventario_sucursal
                SET cantidad = cantidad - @p_cantidad, fecha_actualizacion = @p_fecha_actualizacion
                WHERE id_producto = @p_id_producto AND id_sucursal = @p_id_sucursal;
            END
            ELSE
            BEGIN
                DECLARE @ErrorMessage1 NVARCHAR(4000) = 'Cantidad insuficiente en la sucursal';
                THROW 50002, @ErrorMessage1, 1;
            END
        END

    END TRY
    BEGIN CATCH
        -- Capturamos y lanzamos cualquier error que ocurra
        DECLARE @ErrorMessage2 NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 50000, @ErrorMessage2, 1;
    END CATCH
END;
-- Ejecucion --
/*

DECLARE @fecha_actualizacion DATETIME = GETDATE();

-- Ejecutar procedimiento para descargar producto de la bodega
EXEC dbo.descargar_producto 
    @p_id_producto = 'PROD001',
    @p_cantidad = 20,
    @p_id_bodega = 'BOD001',   -- Indicamos la bodega
    @p_fecha_actualizacion = @fecha_actualizacion;


-- Ejecutar procedimiento para descargar producto de la sucursal
EXEC dbo.descargar_producto 
    @p_id_producto = 'PROD001',
    @p_cantidad = 15,
    @p_id_sucursal = 'SUC001', -- Indicamos la sucursal
    @p_fecha_actualizacion = @fecha_actualizacion;


*/
GO;

-- realizar compras productos --
CREATE PROCEDURE realizar_compra (
    @p_id_compra VARCHAR(50),
    @p_fecha DATETIME,
    @p_total DECIMAL(10,2),
    @p_id_proveedor VARCHAR(50),
    @detalles_compra NVARCHAR(MAX) -- JSON con los detalles de la compra
)
AS
BEGIN
    BEGIN TRY
        -- Verificar si el proveedor existe
        IF NOT EXISTS (SELECT 1 FROM proveedor WHERE id_proveedor = @p_id_proveedor)
        BEGIN
            -- Si no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El proveedor especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Insertar la compra en la tabla 'compra'
        INSERT INTO compra (id_compra, fecha, total, id_proveedor)
        VALUES (@p_id_compra, @p_fecha, @p_total, @p_id_proveedor);

        -- Crear una tabla temporal para los detalles de la compra
        DECLARE @DetalleCompra TABLE (
            id_producto VARCHAR(50),
            cantidad INT,
            precio DECIMAL(10,2)
        );

        -- Parsear el JSON de detalles de compra y agregarlo a la tabla temporal
        INSERT INTO @DetalleCompra (id_producto, cantidad, precio)
        SELECT
            JSON_VALUE(value, '$.id_producto') AS id_producto,
            JSON_VALUE(value, '$.cantidad') AS cantidad,
            JSON_VALUE(value, '$.precio') AS precio
        FROM
            OPENJSON(@detalles_compra);

        -- Declarar una variable para el número de ítem en la compra
        DECLARE @ItemId INT;
        SELECT @ItemId = ISNULL(MAX(item), 0) + 1 FROM detalle_compra;
		print 'item id' + cast(@ItemId as nvarchar(10));

        -- Recorrer los detalles de la compra e insertar en la tabla 'detalle_compra'
        WHILE EXISTS (SELECT 1 FROM @DetalleCompra)
        BEGIN
            DECLARE @IdProducto VARCHAR(50);
            DECLARE @Cantidad INT;
            DECLARE @Precio DECIMAL(10,2);

            -- Obtener los valores del primer registro de la tabla temporal
            SELECT TOP 1
                @IdProducto = id_producto,
                @Cantidad = cantidad,
                @Precio = precio
            FROM
                @DetalleCompra;

            -- Verificar que el producto exista
            IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @IdProducto)
            BEGIN
                -- Si no existe el producto, lanzamos un error
                DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
                THROW 50002, @ErrorMessage2, 1;
            END

            -- Calcular el subtotal
            DECLARE @Subtotal DECIMAL(10,2) = @Cantidad * @Precio;

            -- Insertar el detalle de la compra en 'detalle_compra'
            INSERT INTO detalle_compra (item, cantidad, precio, subtotal, id_compra, id_producto)
            VALUES (@ItemId, @Cantidad, @Precio, @Subtotal, @p_id_compra, @IdProducto);

            -- Incrementar el número de ítem
            SET @ItemId = @ItemId + 1;

            -- Eliminar el registro procesado de la tabla temporal
            DELETE FROM @DetalleCompra WHERE id_producto = @IdProducto;
        END
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage1 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage1, 1;
    END CATCH;
END;
-- Ejecucion --
/*
DECLARE @detalles_compra NVARCHAR(MAX) = '[
    {"id_producto": "PROD001", "cantidad": 10, "precio": 50.00}, -- validar producto ID
    {"id_producto": "PROD001", "cantidad": 5, "precio": 20.00}
]';

DECLARE @fecha DATETIME = GETDATE();

EXEC dbo.realizar_compra
    @p_id_compra = 'COMP0103', -- manual
    @p_fecha = @fecha,
    @p_total = 600.00,
    @p_id_proveedor = 'PROV001',
    @detalles_compra = @detalles_compra;

*/
GO;

-- realizar traslados de productos entre bodegas y sucursales --
CREATE PROCEDURE realizar_traslado (
    @p_id_traslado VARCHAR(50),
    @p_id_producto VARCHAR(50),
    @p_id_bodega_origen VARCHAR(50),
    @p_id_bodega_destino VARCHAR(50) = NULL, -- Puede ser nulo si el destino es una sucursal
    @p_id_sucursal_destino VARCHAR(50) = NULL, -- Puede ser nulo si el destino es una bodega
    @p_cantidad INT,
    @p_fecha_traslado DATETIME
)
AS
BEGIN
    BEGIN TRY
        -- Verificar que el producto exista
        IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El producto especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificar que la bodega origen exista
        IF NOT EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega_origen)
        BEGIN
            DECLARE @ErrorMessage1 NVARCHAR(4000) = 'La bodega de origen especificada no existe';
            THROW 50002, @ErrorMessage1, 1;
        END

        -- Verificar que el destino (bodega o sucursal) exista
        IF @p_id_bodega_destino IS NOT NULL
        BEGIN
            -- Verificar que la bodega destino exista
            IF NOT EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega_destino)
            BEGIN
                DECLARE @ErrorMessage2 NVARCHAR(4000) = 'La bodega de destino especificada no existe';
                THROW 50003, @ErrorMessage2, 1;
            END
        END
        ELSE IF @p_id_sucursal_destino IS NOT NULL
        BEGIN
            -- Verificar que la sucursal destino exista
            IF NOT EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal_destino)
            BEGIN
                DECLARE @ErrorMessage3 NVARCHAR(4000) = 'La sucursal de destino especificada no existe';
                THROW 50004, @ErrorMessage3, 1;
            END
        END
        ELSE
        BEGIN
            -- Si no se especifica ni bodega ni sucursal destino, lanzamos un error
            DECLARE @ErrorMessage4 NVARCHAR(4000) = 'Debe especificar una bodega o sucursal de destino';
            THROW 50005, @ErrorMessage4, 1;
        END

        -- Verificar que haya suficiente inventario en la bodega origen
        DECLARE @CantidadDisponible INT;
        SELECT @CantidadDisponible = cantidad
        FROM inventario_bodega
        WHERE id_bodega = @p_id_bodega_origen
        AND id_producto = @p_id_producto;

        IF @CantidadDisponible IS NULL OR @CantidadDisponible < @p_cantidad
        BEGIN
            DECLARE @ErrorMessage5 NVARCHAR(4000) = 'No hay suficiente inventario en la bodega de origen';
            THROW 50006, @ErrorMessage5, 1;
        END

        -- Restar la cantidad en la bodega origen
        UPDATE inventario_bodega
        SET cantidad = cantidad - @p_cantidad
        WHERE id_bodega = @p_id_bodega_origen
        AND id_producto = @p_id_producto;

        -- Actualizar el inventario en el destino (bodega o sucursal)
        IF @p_id_bodega_destino IS NOT NULL
        BEGIN
            -- Verificar si el producto ya existe en la bodega destino
            IF EXISTS (SELECT 1 FROM inventario_bodega WHERE id_bodega = @p_id_bodega_destino AND id_producto = @p_id_producto)
            BEGIN
                -- Sumar la cantidad al inventario existente
                UPDATE inventario_bodega
                SET cantidad = cantidad + @p_cantidad
                WHERE id_bodega = @p_id_bodega_destino
                AND id_producto = @p_id_producto;
            END
            ELSE
            BEGIN
                -- Insertar un nuevo registro en el inventario de la bodega destino
                INSERT INTO inventario_bodega (id_inventario, id_bodega, id_producto, cantidad, fecha_actualizacion)
                VALUES (NEWID(), @p_id_bodega_destino, @p_id_producto, @p_cantidad, @p_fecha_traslado);
            END
        END
        ELSE IF @p_id_sucursal_destino IS NOT NULL
        BEGIN
            -- Verificar si el producto ya existe en la sucursal destino
            IF EXISTS (SELECT 1 FROM inventario_sucursal WHERE id_sucursal = @p_id_sucursal_destino AND id_producto = @p_id_producto)
            BEGIN
                -- Sumar la cantidad al inventario existente
                UPDATE inventario_sucursal
                SET cantidad = cantidad + @p_cantidad
                WHERE id_sucursal = @p_id_sucursal_destino
                AND id_producto = @p_id_producto;
            END
            ELSE
            BEGIN
                -- Insertar un nuevo registro en el inventario de la sucursal destino
                INSERT INTO inventario_sucursal (id_inventario, id_sucursal, id_producto, cantidad, fecha_actualizacion)
                VALUES (NEWID(), @p_id_sucursal_destino, @p_id_producto, @p_cantidad, @p_fecha_traslado);
            END
        END

        -- Registrar el traslado en una tabla de traslados
        INSERT INTO distribucion (id_distribucion, id_ruta, id_producto, cantidad, fecha_salida, fecha_entrega, estado, id_bodega_origen, id_sucursal_destino)
        VALUES (@p_id_traslado, NULL, @p_id_producto, @p_cantidad, @p_fecha_traslado, NULL, 'En proceso', @p_id_bodega_origen, @p_id_sucursal_destino);
        
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage6 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error con el mensaje original
        THROW 50000, @ErrorMessage6, 1;
    END CATCH
END;

-- Ejecucion --
/*
-- Trasladar 50 unidades de PROD001 desde BOD001 a BOD002
-- Trasladar 50 unidades de PROD001 desde BOD001 a BOD002
DECLARE @fecha DATETIME = GETDATE();

EXEC dbo.realizar_traslado
    @p_id_traslado = 'TR002', -- Dinamico
    @p_id_producto = 'PROD001',
    @p_id_bodega_origen = 'BOD001',
    @p_id_bodega_destino = 'BOD002',
    @p_cantidad = 50,
    @p_fecha_traslado = @fecha;

-- Trasladar 20 unidades de PROD002 desde BOD001 a SUC001 (Sucursal)
EXEC dbo.realizar_traslado
    @p_id_traslado = 'TR003', -- Dinamico
    @p_id_producto = 'PROD001',
    @p_id_bodega_origen = 'BOD001',
    @p_id_sucursal_destino = 'SUC001',
    @p_cantidad = 20,
    @p_fecha_traslado = @fecha;


*/
GO;

-- notas creditos -- verificar --
CREATE PROCEDURE crear_nota_credito (
    @p_id_nota_credito VARCHAR(50),       -- ID de la nota de crédito
    @p_id_factura VARCHAR(50),            -- ID de la factura a la que está asociada la nota de crédito
    @p_fecha DATETIME,                    -- Fecha de la emisión de la nota de crédito
    @p_monto_total DECIMAL(10,2),         -- Monto total de la nota de crédito
    @p_razon NVARCHAR(255),               -- Razón de la nota de crédito
    @detalles_nota_credito NVARCHAR(MAX)  -- JSON con los detalles del crédito (productos, cantidades, precios, etc.)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos si la factura existe
        IF NOT EXISTS (SELECT 1 FROM factura WHERE id_factura = @p_id_factura)
        BEGIN
            -- Si no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'La factura especificada no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Insertamos la nota de crédito en la tabla 'nota_credito'
        INSERT INTO nota_credito (
            id_nota_credito, id_factura, fecha, monto_total, razon
        )
        VALUES (
            @p_id_nota_credito, @p_id_factura, @p_fecha, @p_monto_total, @p_razon
        );

        -- Crear una tabla temporal para los detalles de la nota de crédito
        DECLARE @DetalleCredito TABLE (
            id_producto VARCHAR(50),
            cantidad INT,
            precio DECIMAL(10,2)
        );

        -- Parsear el JSON de detalles de la nota de crédito y agregarlo a la tabla temporal
        INSERT INTO @DetalleCredito (id_producto, cantidad, precio)
        SELECT
            JSON_VALUE(value, '$.id_producto') AS id_producto,
            JSON_VALUE(value, '$.cantidad') AS cantidad,
            JSON_VALUE(value, '$.precio') AS precio
        FROM
            OPENJSON(@detalles_nota_credito);

        -- Declarar una variable para el número de ítem en la nota de crédito
        DECLARE @ItemId INT = 1;

        -- Iterar por los registros de la tabla temporal
        WHILE EXISTS (SELECT 1 FROM @DetalleCredito)
        BEGIN
            DECLARE @IdProducto VARCHAR(50);
            DECLARE @Cantidad INT;
            DECLARE @Precio DECIMAL(10,2);

            -- Obtener los valores del primer registro de la tabla temporal
            SELECT TOP 1
                @IdProducto = id_producto,
                @Cantidad = cantidad,
                @Precio = precio
            FROM
                @DetalleCredito;

            -- Verificar que el producto exista
            IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @IdProducto)
            BEGIN
                -- Si no existe el producto, lanzamos un error
                DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
                THROW 50002, @ErrorMessage2, 1;
            END

            -- Insertar el detalle de la nota de crédito
            INSERT INTO detalle_nota_credito (item, id_nota_credito, id_producto, cantidad, precio)
            VALUES (@ItemId, @p_id_nota_credito, @IdProducto, @Cantidad, @Precio);

            -- Incrementar el número de ítem
            SET @ItemId = @ItemId + 1;

            -- Eliminar el registro procesado de la tabla temporal
            DELETE FROM @DetalleCredito WHERE id_producto = @IdProducto;
        END
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage1 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage1, 1;
    END CATCH;
END;
-- Ejecucion (PENDIENTE) --
/*
DECLARE @detalles_nota_credito NVARCHAR(MAX) = '[
    {"id_producto": "PROD001", "cantidad": 2, "precio": 100.00},
    {"id_producto": "PROD002", "cantidad": 1, "precio": 50.00}
]';

DECLARE @fecha DATETIME = GETDATE();

EXEC dbo.crear_nota_credito
    @p_id_nota_credito = 'NC001',
    @p_id_factura = 'FACT001',
    @p_fecha = @fecha,
    @p_monto_total = 250.00,
    @p_razon = 'Devolución parcial por producto defectuoso',
    @detalles_nota_credito = @detalles_nota_credito;

*/
GO;

-- ventas en credito --
CREATE PROCEDURE registrar_venta_credito (
    @p_id_pedido VARCHAR(50),       -- ID del pedido
    @p_fecha DATETIME,              -- Fecha de la venta
    @p_total_pedido DECIMAL(10,2),  -- Total del pedido
    @p_forma_pago VARCHAR(50),      -- Forma de pago (en este caso 'Crédito')
    @p_id_cliente VARCHAR(50),      -- ID del cliente
    @p_reco_facturacion VARCHAR(255),-- Dirección de facturación
    @p_empresa_transporte VARCHAR(50),-- Empresa de transporte
    @p_costo_transporte DECIMAL(10,2),-- Costo del transporte
    @p_id_direccion VARCHAR(255),   -- Dirección de entrega
    @detalles_pedido NVARCHAR(MAX), -- JSON con los detalles del pedido (productos, cantidades, precios, etc.)
    @monto_total_credito DECIMAL(10,2), -- Monto total del crédito
    @monto_restante_credito DECIMAL(10,2), -- Monto restante del crédito
    @p_fecha_vencimiento DATETIME  -- Fecha de vencimiento del crédito
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos si el cliente existe
        IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        BEGIN
            -- Si no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El cliente especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Insertar el pedido en la tabla 'pedido'
        INSERT INTO pedido (
            id_pedido, fecha, total_pedido, forma_pago, pagado, entregado, 
            reco_facturacion, empresa_transporte, costo_transporte, id_cliente, 
            id_direccion, nro_documento_pago
        )
        VALUES (
            @p_id_pedido, @p_fecha, @p_total_pedido, @p_forma_pago, 0, -- No pagado
            0, -- No entregado
            @p_reco_facturacion, @p_empresa_transporte, @p_costo_transporte, 
            @p_id_cliente, @p_id_direccion, NULL
        );

        -- Parsear el JSON de detalles del pedido y agregarlo a la tabla temporal
        DECLARE @DetallePedido TABLE (
            id_producto VARCHAR(50),
            cantidad INT,
            precio DECIMAL(10,2)
        );

        INSERT INTO @DetallePedido (id_producto, cantidad, precio)
        SELECT
            JSON_VALUE(value, '$.id_producto') AS id_producto,
            JSON_VALUE(value, '$.cantidad') AS cantidad,
            JSON_VALUE(value, '$.precio') AS precio
        FROM
            OPENJSON(@detalles_pedido);

        -- Declarar una variable para el número de ítem en el pedido
        DECLARE @ItemId INT;
		SELECT @ItemId = ISNULL(MAX(item), 0) + 1 FROM detalle_pedido;

        -- Recorrer los detalles del pedido e insertar en la tabla 'detalle_pedido'
        WHILE EXISTS (SELECT 1 FROM @DetallePedido)
        BEGIN
            DECLARE @IdProducto VARCHAR(50);
            DECLARE @Cantidad INT;
            DECLARE @Precio DECIMAL(10,2);

            -- Obtener los valores del primer registro de la tabla temporal
            SELECT TOP 1
                @IdProducto = id_producto,
                @Cantidad = cantidad,
                @Precio = precio
            FROM
                @DetallePedido;

            -- Verificar que el producto exista
            IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @IdProducto)
            BEGIN
                -- Si no existe el producto, lanzamos un error
                DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
                THROW 50002, @ErrorMessage2, 1;
            END

            -- Calcular el subtotal
            DECLARE @Subtotal DECIMAL(10,2) = @Cantidad * @Precio;

            -- Insertar el detalle del pedido en 'detalle_pedido'
            INSERT INTO detalle_pedido (item, cantidad, precio, subtotal, id_pedido, id_producto)
            VALUES (@ItemId, @Cantidad, @Precio, @Subtotal, @p_id_pedido, @IdProducto);

            -- Incrementar el número de ítem
            SET @ItemId = @ItemId + 1;

            -- Eliminar el registro procesado de la tabla temporal
            DELETE FROM @DetallePedido WHERE id_producto = @IdProducto;
        END

        -- Registrar el crédito en la tabla 'credito'
        INSERT INTO credito (id_credito, id_cliente, monto_total, monto_restante, fecha_inicio, fecha_vencimiento, id_estado_credito)
        VALUES (NEWID(), @p_id_cliente, @monto_total_credito, @monto_restante_credito, @p_fecha, @p_fecha_vencimiento, 1); -- Estado 1: 'Aprobado'

    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage1 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage1, 1;
    END CATCH;
END;
-- Ejecucion --
/*
DECLARE @detalles_pedido NVARCHAR(MAX) = '[ 
    {"id_producto": "PROD001", "cantidad": 2, "precio": 500.00}, 
    {"id_producto": "PROD001", "cantidad": 1, "precio": 300.00} 
]';

DECLARE @fecha DATETIME = GETDATE();

EXEC dbo.registrar_venta_credito
    @p_id_pedido = 'P0021', -- Dinamico 
    @p_fecha = @fecha,
    @p_total_pedido = 1300.00,
    @p_forma_pago = 'Crédito',
    @p_id_cliente = 'CL001',
    @p_reco_facturacion = 'Direccion Facturacion 123',
    @p_empresa_transporte = 'DHL',
    @p_costo_transporte = 50.00,
    @p_id_direccion = 'Direccion Entrega 456',
    @detalles_pedido = @detalles_pedido,
    @monto_total_credito = 1300.00,
    @monto_restante_credito = 1300.00,
    @p_fecha_vencimiento = '2024-12-31';

*/
GO;

-- asignacion producto a ruta --
CREATE PROCEDURE asignar_producto_a_ruta (
    @p_id_ruta VARCHAR(50),            -- ID de la ruta
    @p_id_producto VARCHAR(50),        -- ID del producto
    @p_cantidad INT,                   -- Cantidad del producto
    @p_fecha_salida DATETIME,          -- Fecha de salida del producto
    @p_fecha_entrega DATETIME,         -- Fecha estimada de entrega
    @p_id_bodega_origen VARCHAR(50),   -- ID de la bodega de origen
    @p_id_sucursal_destino VARCHAR(50) -- ID de la sucursal de destino
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos si la ruta existe
        IF NOT EXISTS (SELECT 1 FROM ruta WHERE id_ruta = @p_id_ruta)
        BEGIN
            -- Si la ruta no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'La ruta especificada no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificamos si el producto existe
        IF NOT EXISTS (SELECT 1 FROM producto WHERE id_producto = @p_id_producto)
        BEGIN
            -- Si el producto no existe, lanzamos un error
            DECLARE @ErrorMessage2 NVARCHAR(4000) = 'El producto especificado no existe';
            THROW 50002, @ErrorMessage2, 1;
        END

        -- Verificamos si la bodega de origen existe
        IF NOT EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega_origen)
        BEGIN
            -- Si la bodega no existe, lanzamos un error
            DECLARE @ErrorMessage3 NVARCHAR(4000) = 'La bodega de origen especificada no existe';
            THROW 50003, @ErrorMessage3, 1;
        END

        -- Verificamos si la sucursal de destino existe
        IF NOT EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal_destino)
        BEGIN
            -- Si la sucursal no existe, lanzamos un error
            DECLARE @ErrorMessage4 NVARCHAR(4000) = 'La sucursal de destino especificada no existe';
            THROW 50004, @ErrorMessage4, 1;
        END

        -- Insertar la asignación en la tabla 'distribucion'
        INSERT INTO distribucion (
            id_distribucion, id_ruta, id_producto, cantidad, fecha_salida, 
            fecha_entrega, estado, id_bodega_origen, id_sucursal_destino
        )
        VALUES (
            NEWID(), @p_id_ruta, @p_id_producto, @p_cantidad, @p_fecha_salida, 
            @p_fecha_entrega, 'Asignado', @p_id_bodega_origen, @p_id_sucursal_destino
        );

    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage1 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage1, 1;
    END CATCH;
END;
-- Ejecucion --
/*
DECLARE @fecha_salida DATETIME = GETDATE();
DECLARE @fecha_entrega DATETIME = DATEADD(DAY, 3, @fecha_salida);

EXEC dbo.asignar_producto_a_ruta
    @p_id_ruta = 'RUTA001',
    @p_id_producto = 'PROD001',
    @p_cantidad = 50,
    @p_fecha_salida = @fecha_salida,
    @p_fecha_entrega = @fecha_entrega,
    @p_id_bodega_origen = 'BOD001',
    @p_id_sucursal_destino = 'SUC001';

*/
GO;

-- eliminar producto de ruta --
CREATE PROCEDURE eliminar_producto_de_ruta (
    @p_id_ruta VARCHAR(50),
    @p_id_producto VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la asignación exista en la tabla 'distribucion'
        IF EXISTS (SELECT 1 FROM distribucion WHERE id_ruta = @p_id_ruta AND id_producto = @p_id_producto)
        BEGIN
            -- Si la asignación existe, eliminamos el producto de la ruta
            DELETE FROM distribucion
            WHERE id_ruta = @p_id_ruta AND id_producto = @p_id_producto;

            PRINT 'El producto ha sido eliminado de la ruta correctamente.';
        END
        ELSE
        BEGIN
            -- Si no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'La asignación del producto a la ruta especificada no existe';
            THROW 50001, @ErrorMessage, 1;
        END
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage1 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage1, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.eliminar_producto_de_ruta 
    @p_id_ruta = 'RUTA003', -- validar que este en la tabla distribucion
		@p_id_producto = 'PROD003'; -- validar que este en la tabla distribucion

*/
GO;

-- modificar ruta --
CREATE PROCEDURE modificar_ruta (
    @p_id_ruta VARCHAR(50),
    @p_nombre VARCHAR(255),
    @p_descripcion TEXT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ruta exista en la tabla 'ruta'
        IF EXISTS (SELECT 1 FROM ruta WHERE id_ruta = @p_id_ruta)
        BEGIN
            -- Si la ruta existe, actualizamos los campos correspondientes
            UPDATE ruta
            SET nombre = @p_nombre,
                descripcion = @p_descripcion
            WHERE id_ruta = @p_id_ruta;

            PRINT 'La ruta ha sido actualizada correctamente.';
        END
        ELSE
        BEGIN
            -- Si la ruta no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'La ruta especificada no existe';
            THROW 50001, @ErrorMessage, 1;
        END
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage1 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage1, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.modificar_ruta 
    @p_id_ruta = 'RUTA001', -- Dinamica
    @p_nombre = 'Ruta Modificada',
    @p_descripcion = 'Descripción actualizada para la ruta.';

*/
GO;

-- definir recorrido ruta --
CREATE PROCEDURE definir_recorrido_ruta (
	@p_id_distribucion VARCHAR(50),
    @p_id_ruta VARCHAR(50),
    @p_id_bodega_origen VARCHAR(50),
    @p_id_sucursal_destino VARCHAR(50),
    @p_fecha_salida DATETIME,
    @p_fecha_entrega DATETIME,
    @p_estado VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que la ruta exista
        IF NOT EXISTS (SELECT 1 FROM ruta WHERE id_ruta = @p_id_ruta)
        BEGIN
            -- Si la ruta no existe, lanzamos un error
            DECLARE @ErrorMessage1 NVARCHAR(4000) = 'La ruta especificada no existe';
            THROW 50001, @ErrorMessage1, 1;
        END
        
        -- Verificamos que la bodega de origen exista
        IF NOT EXISTS (SELECT 1 FROM bodega WHERE id_bodega = @p_id_bodega_origen)
        BEGIN
            -- Si la bodega de origen no existe, lanzamos un error
            DECLARE @ErrorMessage2 NVARCHAR(4000) = 'La bodega de origen especificada no existe';
            THROW 50002, @ErrorMessage2, 1;
        END
        
        -- Verificamos que la sucursal de destino exista
        IF NOT EXISTS (SELECT 1 FROM sucursal WHERE id_sucursal = @p_id_sucursal_destino)
        BEGIN
            -- Si la sucursal de destino no existe, lanzamos un error
            DECLARE @ErrorMessage3 NVARCHAR(4000) = 'La sucursal de destino especificada no existe';
            THROW 50003, @ErrorMessage3, 1;
        END

        -- Insertamos el recorrido de la ruta en la tabla 'distribucion'
        INSERT INTO distribucion (
            id_distribucion, id_ruta, id_bodega_origen, id_sucursal_destino, fecha_salida, fecha_entrega, estado
        )
        VALUES (
            @p_id_distribucion, @p_id_ruta, @p_id_bodega_origen, @p_id_sucursal_destino, @p_fecha_salida, @p_fecha_entrega, @p_estado
        );

        PRINT 'El recorrido de la ruta ha sido definido correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.definir_recorrido_ruta 
	@p_id_distribucion = 'DIST001',
    @p_id_ruta = 'RUTA001',
    @p_id_bodega_origen = 'BOD001',
    @p_id_sucursal_destino = 'SUC002',
    @p_fecha_salida = '2024-10-16 08:00:00',
    @p_fecha_entrega = '2024-10-17 16:00:00',
    @p_estado = 'En camino';

*/
GO;

-- registrar pago producto -- not functional
CREATE PROCEDURE registrar_pago_producto (
    @p_id_pago VARCHAR(50),
    @p_id_pedido VARCHAR(50),
    @p_monto_pago DECIMAL(10,2),
    @p_fecha_pago DATETIME,
    @p_metodo_pago VARCHAR(50),
    @p_pagado BIT
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el pedido exista
        IF NOT EXISTS (SELECT 1 FROM pedido WHERE id_pedido = @p_id_pedido)
        BEGIN
            -- Si el pedido no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El pedido especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificamos si el monto total ya fue pagado (opcional)
        DECLARE @MontoTotal DECIMAL(10,2) = (SELECT total_pedido FROM pedido WHERE id_pedido = @p_id_pedido);
        DECLARE @MontoPagado DECIMAL(10,2) = (SELECT ISNULL(SUM(monto_pago), 0) FROM pago_credito WHERE id_credito = @p_id_pedido);

        IF (@MontoPagado + @p_monto_pago > @MontoTotal)
        BEGIN
            -- Si el monto pagado excede el total del pedido, lanzamos un error
            DECLARE @ErrorMessage1 NVARCHAR(4000) = 'El monto del pago excede el total del pedido';
            THROW 50002, @ErrorMessage1, 1;
        END

        -- Insertamos el pago en la tabla 'pago_credito'
        INSERT INTO pago_credito (id_pago, id_credito, monto_pago, fecha_pago, metodo_pago)
        VALUES (@p_id_pago, @p_id_pedido, @p_monto_pago, @p_fecha_pago, @p_metodo_pago);

        -- Actualizamos el estado de pago del pedido si ya se ha pagado completamente
        IF (@MontoPagado + @p_monto_pago = @MontoTotal)
        BEGIN
            UPDATE pedido
            SET pagado = 1
            WHERE id_pedido = @p_id_pedido;
        END

        -- Devolver un mensaje de éxito
        PRINT 'El pago ha sido registrado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage2 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage2, 1;
    END CATCH;
END;
-- ejecucion --
/*
EXEC dbo.registrar_pago_producto
    @p_id_pago = 'PAGO0011',
    @p_id_pedido = 'P0010',
    @p_monto_pago = 200.00,
    @p_fecha_pago = '2024-10-16 15:00:00',
    @p_metodo_pago = 'Tarjeta de crédito',
    @p_pagado = 1;


*/
GO;


-- Envio mensaje --
CREATE PROCEDURE enviar_mensaje (
    @p_id_mensaje VARCHAR(50),
    @p_m_de VARCHAR(50),           -- Puede ser id_cliente o id_operador
    @p_m_para VARCHAR(50),         -- Puede ser id_cliente o id_operador
    @p_titulo VARCHAR(255),
    @p_mensaje TEXT,
    @p_fecha DATETIME,
    @p_leido BIT,
    @p_id_cliente VARCHAR(50),
    @p_id_operador VARCHAR(50)
)
AS
BEGIN
    BEGIN TRY
        -- Verificamos que el cliente exista
        IF NOT EXISTS (SELECT 1 FROM cliente WHERE id_cliente = @p_id_cliente)
        BEGIN
            -- Si el cliente no existe, lanzamos un error
            DECLARE @ErrorMessage NVARCHAR(4000) = 'El cliente especificado no existe';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificamos que el operador exista
        IF NOT EXISTS (SELECT 1 FROM operador WHERE id_operador = @p_id_operador)
        BEGIN
            -- Si el operador no existe, lanzamos un error
            DECLARE @ErrorMessage1 NVARCHAR(4000) = 'El operador especificado no existe';
            THROW 50002, @ErrorMessage1, 1;
        END

        -- Insertamos el mensaje en la tabla 'mensaje'
        INSERT INTO mensaje (id_mensaje, m_de, m_para, titulo, mensaje, fecha, leido, id_cliente, id_operador)
        VALUES (@p_id_mensaje, @p_m_de, @p_m_para, @p_titulo, @p_mensaje, @p_fecha, @p_leido, @p_id_cliente, @p_id_operador);

        -- Mensaje de éxito
        PRINT 'Mensaje enviado con éxito.';
    END TRY
    BEGIN CATCH
        -- Capturamos el mensaje de error
        DECLARE @ErrorMessage2 NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Lanzamos el error original con el mensaje detallado
        THROW 50000, @ErrorMessage2, 1;
    END CATCH;
END;
-- Ejecucion --
/*
EXEC dbo.enviar_mensaje 
    @p_id_mensaje = 'MSG001',
    @p_m_de = 'CL001',               -- Cliente enviando mensaje
    @p_m_para = 'O001',              -- Operador recibiendo mensaje
    @p_titulo = 'Consulta sobre un pedido',
    @p_mensaje = 'Tengo una consulta sobre mi pedido.',
    @p_fecha = GETDATE(),
    @p_leido = 0,                    -- No leído
    @p_id_cliente = 'CL001',
    @p_id_operador = 'O001';

*/

