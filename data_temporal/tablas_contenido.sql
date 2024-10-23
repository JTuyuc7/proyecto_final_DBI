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
