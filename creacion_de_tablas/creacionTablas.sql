
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

-- crear la tabla operador --
CREATE TABLE operador (
    id_operador VARCHAR(50) PRIMARY KEY,
    id_persona VARCHAR(50),
    tipo VARCHAR(50),
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
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

