CREATE DATABASE IF NOT EXISTS panify;

USE panify;

CREATE TABLE
    IF NOT EXISTS roles (
        idRol INT NOT NULL AUTO_INCREMENT,
        nombre VARCHAR(45) NOT NULL,
        PRIMARY KEY (idRol),
        UNIQUE (nombre)
    );

CREATE TABLE
    IF NOT EXISTS clientes (
        idCliente INT NOT NULL AUTO_INCREMENT,
        tipoCliente ENUM ('Nuevo', 'Frecuente', 'Ocasional') NOT NULL,
        direccion VARCHAR(150) NOT NULL,
        PRIMARY KEY (idCliente)
    );

CREATE TABLE
    IF NOT EXISTS panaderos (
        idPanadero INT NOT NULL AUTO_INCREMENT,
        estadoActivdad ENUM ('En turno', 'Descanso', 'Inactivo') NOT NULL,
        PRIMARY KEY (idPanadero)
    );

CREATE TABLE
    IF NOT EXISTS domiciliarios (
        idDomiciliario INT NOT NULL AUTO_INCREMENT,
        estadoDisponibilidad ENUM ('Libre', 'Ocupado', 'Inactivo') NOT NULL,
        PRIMARY KEY (idDomiciliario)
    );

CREATE TABLE
    IF NOT EXISTS usuarios (
        idUsuario INT NOT NULL AUTO_INCREMENT,
        nombre VARCHAR(45) NOT NULL,
        apellido VARCHAR(45) NOT NULL,
        correo VARCHAR(150) NOT NULL,
        contrasena VARCHAR(255) NOT NULL,
        telefono VARCHAR(15) NOT NULL,
        estado ENUM ('Activo', 'Inactivo') NOT NULL,
        Rol_idRol INT NOT NULL,
        cliente_idCliente INT NULL,
        panadero_idPanadero INT NULL,
        domiciliario_idDomiciliario INT NULL,
        PRIMARY KEY (idUsuario),
        UNIQUE (correo),
        UNIQUE (cliente_idCliente),
        UNIQUE (panadero_idPanadero),
        UNIQUE (domiciliario_idDomiciliario),
        CONSTRAINT fk_usuarios_roles1 FOREIGN KEY (Rol_idRol) REFERENCES roles (idRol),
        CONSTRAINT fk_usuarios_clientes1 FOREIGN KEY (cliente_idCliente) REFERENCES clientes (idCliente),
        CONSTRAINT fk_usuarios_panaderos1 FOREIGN KEY (panadero_idPanadero) REFERENCES panaderos (idPanadero),
        CONSTRAINT fk_usuarios_domiciliarios1 FOREIGN KEY (domiciliario_idDomiciliario) REFERENCES domiciliarios (idDomiciliario)
    );

CREATE TABLE
    IF NOT EXISTS productos (
        idProducto INT NOT NULL AUTO_INCREMENT,
        nombre VARCHAR(45) NOT NULL,
        precio DECIMAL(10, 2) NOT NULL,
        estado ENUM ('Disponbile', 'Agotado') NOT NULL,
        descripcion VARCHAR(100) NULL DEFAULT NULL,
        PRIMARY KEY (idProducto)
    );

CREATE TABLE
    IF NOT EXISTS movimientos (
        idMovimiento INT NOT NULL AUTO_INCREMENT,
        tipoMovimiento ENUM ('Entrada', 'Salida', 'Ajuste') NOT NULL,
        cantidad INT NOT NULL,
        fechaHora DATETIME NOT NULL,
        panadero_idPanadero INT NOT NULL,
        producto_idProducto INT NOT NULL,
        PRIMARY KEY (idMovimiento),
        CONSTRAINT fk_movimientos_panaderos1 FOREIGN KEY (panadero_idPanadero) REFERENCES panaderos (idPanadero),
        CONSTRAINT fk_movimientos_productos1 FOREIGN KEY (producto_idProducto) REFERENCES productos (idProducto)
    );

CREATE TABLE
    IF NOT EXISTS inventarios (
        idInventario INT NOT NULL AUTO_INCREMENT,
        stockMinimo INT NOT NULL,
        stockActual INT NOT NULL,
        producto_idProducto INT NOT NULL,
        PRIMARY KEY (idInventario),
        UNIQUE (producto_idProducto),
        CONSTRAINT fk_inventarios_productos1 FOREIGN KEY (producto_idProducto) REFERENCES productos (idProducto)
    );

CREATE TABLE
    IF NOT EXISTS pedidos (
        idPedido INT NOT NULL AUTO_INCREMENT,
        fechaHoraCreacion DATETIME NOT NULL,
        fechaHoraEntregaEstimada DATETIME NOT NULL,
        estadoPedido ENUM (
            'Pendiente',
            'En preparación',
            'Listo',
            'En camino',
            'Entregado',
            'Cancelado'
        ) NOT NULL,
        cliente_idCliente INT NOT NULL,
        domiciliario_idDomiciliario INT NOT NULL,
        PRIMARY KEY (idPedido),
        CONSTRAINT fk_pedidos_clientes1 FOREIGN KEY (cliente_idCliente) REFERENCES clientes (idCliente),
        CONSTRAINT fk_pedidos_domiciliarios1 FOREIGN KEY (domiciliario_idDomiciliario) REFERENCES domiciliarios (idDomiciliario)
    );

CREATE TABLE
    IF NOT EXISTS detalle_pedidos (
        idDetalle_Pedido INT NOT NULL AUTO_INCREMENT,
        precioFijo DECIMAL(10, 2) NOT NULL,
        cantidad INT NOT NULL,
        pedido_idPedido INT NOT NULL,
        producto_idProducto INT NOT NULL,
        PRIMARY KEY (idDetalle_Pedido),
        CONSTRAINT fk_detalle_pedidos_pedidos1 FOREIGN KEY (pedido_idPedido) REFERENCES pedidos (idPedido),
        CONSTRAINT fk_detalle_pedidos_productos1 FOREIGN KEY (producto_idProducto) REFERENCES productos (idProducto)
    );

CREATE TABLE
    IF NOT EXISTS recibos (
        idRecibo INT NOT NULL AUTO_INCREMENT,
        totalPagar DECIMAL(10, 2) NOT NULL,
        fechaEmision DATETIME NOT NULL,
        pedido_idPedido INT NOT NULL,
        PRIMARY KEY (idRecibo),
        UNIQUE (pedido_idPedido),
        CONSTRAINT fk_recibos_pedidos1 FOREIGN KEY (pedido_idPedido) REFERENCES pedidos (idPedido)
    );

CREATE TABLE
    IF NOT EXISTS rutasEntrega (
        idRutasEntrega INT NOT NULL AUTO_INCREMENT,
        estadoRuta ENUM (
            'Pendiente',
            'En Curso',
            'Completada',
            'Cancelada'
        ) NOT NULL,
        urlRutaGoogle VARCHAR(500) NOT NULL,
        domiciliarios_idDomiciliario INT NOT NULL,
        PRIMARY KEY (idRutasEntrega),
        CONSTRAINT fk_rutasEntrega_domiciliarios1 FOREIGN KEY (domiciliarios_idDomiciliario) REFERENCES domiciliarios (idDomiciliario)
    );

CREATE TABLE
    IF NOT EXISTS rutasParada (
        idRutasParada INT NOT NULL AUTO_INCREMENT,
        rutasEntrega_idRutasEntrega INT NOT NULL,
        pedidos_idPedido INT NOT NULL,
        ordenEntrega INT NOT NULL,
        estadoParada ENUM ('Pendiente', 'Entregado', 'Fallido') NOT NULL DEFAULT 'Pendiente',
        PRIMARY KEY (idRutasParada),
        CONSTRAINT fk_rutasParada_rutasEntrega1 FOREIGN KEY (rutasEntrega_idRutasEntrega) REFERENCES rutasEntrega (idRutasEntrega),
        CONSTRAINT fk_rutasParada_pedidos1 FOREIGN KEY (pedidos_idPedido) REFERENCES pedidos (idPedido)
    );

-- 1. Insertar Roles (Exactamente 3 roles en el orden solicitado)
INSERT INTO
    roles (nombre)
VALUES
    ('Cliente'),
    ('Domiciliario'),
    ('Panadero');

-- 2. Insertar Clientes (10 clientes)
INSERT INTO
    clientes (tipoCliente, direccion)
VALUES
    ('Nuevo', 'Calle 13 # 4-50, Soacha'),
    ('Frecuente', 'Cra 7 # 12-34, Soacha'),
    ('Ocasional', 'Calle 22 # 9-10, Soacha'),
    ('Nuevo', 'Cra 4 # 15-20, Soacha'),
    ('Frecuente', 'Calle 10 # 5-60, Soacha'),
    ('Ocasional', 'Cra 8 # 11-11, Soacha'),
    ('Nuevo', 'Calle 1 # 2-3, Soacha'),
    ('Frecuente', 'Cra 9 # 14-22, Soacha'),
    ('Ocasional', 'Calle 5 # 7-8, Soacha'),
    ('Nuevo', 'Cra 3 # 1-15, Soacha');

-- 3. Insertar Panaderos (Exactamente 1 panadero)
INSERT INTO
    panaderos (estadoActivdad)
VALUES
    ('En turno');

-- 4. Insertar Domiciliarios (Máximo 3 domiciliarios)
INSERT INTO
    domiciliarios (estadoDisponibilidad)
VALUES
    ('Libre'),
    ('Ocupado'),
    ('Inactivo');

-- 5. Insertar Usuarios (14 en total para cubrir exactamente a los 10 clientes, 3 domiciliarios y 1 panadero)
INSERT INTO
    usuarios (
        nombre,
        apellido,
        correo,
        contrasena,
        telefono,
        estado,
        Rol_idRol,
        cliente_idCliente,
        panadero_idPanadero,
        domiciliario_idDomiciliario
    )
VALUES
    -- 10 Clientes (Rol 1)
    (
        'Ana',
        'Gomez',
        'ana@mail.com',
        'hash123',
        '3001234560',
        'Activo',
        1,
        1,
        NULL,
        NULL
    ),
    (
        'Luis',
        'Perez',
        'luis@mail.com',
        'hash123',
        '3001234561',
        'Activo',
        1,
        2,
        NULL,
        NULL
    ),
    (
        'Carlos',
        'Ruiz',
        'carlos@mail.com',
        'hash123',
        '3001234562',
        'Inactivo',
        1,
        3,
        NULL,
        NULL
    ),
    (
        'Laura',
        'Mora',
        'laura@mail.com',
        'hash123',
        '3001234563',
        'Activo',
        1,
        4,
        NULL,
        NULL
    ),
    (
        'Juan',
        'Cruz',
        'juan@mail.com',
        'hash123',
        '3001234564',
        'Activo',
        1,
        5,
        NULL,
        NULL
    ),
    (
        'Sofia',
        'Rios',
        'sofia@mail.com',
        'hash123',
        '3001234565',
        'Activo',
        1,
        6,
        NULL,
        NULL
    ),
    (
        'Marta',
        'Velez',
        'marta@mail.com',
        'hash123',
        '3001234566',
        'Activo',
        1,
        7,
        NULL,
        NULL
    ),
    (
        'Andres',
        'Bulla',
        'andres@mail.com',
        'hash123',
        '3001234567',
        'Activo',
        1,
        8,
        NULL,
        NULL
    ),
    (
        'Diana',
        'Rojas',
        'diana@mail.com',
        'hash123',
        '3001234568',
        'Activo',
        1,
        9,
        NULL,
        NULL
    ),
    (
        'Camilo',
        'Ortiz',
        'camilo@mail.com',
        'hash123',
        '3001234569',
        'Activo',
        1,
        10,
        NULL,
        NULL
    ),
    -- 3 Domiciliarios (Rol 2)
    (
        'Pedro',
        'Diaz',
        'pedro@mail.com',
        'hash123',
        '3001234570',
        'Activo',
        2,
        NULL,
        NULL,
        1
    ),
    (
        'Jorge',
        'Vega',
        'jorge@mail.com',
        'hash123',
        '3001234571',
        'Inactivo',
        2,
        NULL,
        NULL,
        2
    ),
    (
        'Mateo',
        'Gil',
        'mateo@mail.com',
        'hash123',
        '3001234572',
        'Activo',
        2,
        NULL,
        NULL,
        3
    ),
    -- 1 Panadero (Rol 3)
    (
        'Diego',
        'Luna',
        'diego@mail.com',
        'hash123',
        '3001234573',
        'Activo',
        3,
        NULL,
        1,
        NULL
    );

-- 6. Insertar Productos 
INSERT INTO
    productos (nombre, precio, estado, descripcion)
VALUES
    (
        'Pan Aliñado',
        2500.00,
        'Disponbile',
        'Pan suave con queso'
    ),
    (
        'Pan Rollo',
        1500.00,
        'Disponbile',
        'Pan tradicional pequeño'
    ),
    (
        'Roscon',
        3000.00,
        'Agotado',
        'Roscón relleno de bocadillo'
    ),
    ('Pan de Queso', 2000.00, 'Disponbile', NULL),
    (
        'Croissant',
        3500.00,
        'Disponbile',
        'Croissant de mantequilla'
    ),
    (
        'Galletas Choco',
        1200.00,
        'Agotado',
        'Galletas horneadas'
    ),
    (
        'Buñuelo',
        1800.00,
        'Disponbile',
        'Buñuelo fresco'
    ),
    (
        'Pan Integral',
        3200.00,
        'Disponbile',
        'Alto en fibra'
    ),
    (
        'Torta de Vainilla',
        25000.00,
        'Disponbile',
        'Para 10 porciones'
    ),
    (
        'Mantecada',
        4000.00,
        'Agotado',
        'Porción individual'
    );

-- 7. Insertar Movimientos de Inventario (Todos registrados por el único panadero: ID 1)
INSERT INTO
    movimientos (
        tipoMovimiento,
        cantidad,
        fechaHora,
        panadero_idPanadero,
        producto_idProducto
    )
VALUES
    ('Entrada', 50, '2026-09-17 06:00:00', 1, 1),
    ('Salida', 10, '2026-09-17 07:30:00', 1, 1),
    ('Entrada', 30, '2026-09-17 06:15:00', 1, 2),
    ('Ajuste', 2, '2026-09-17 08:00:00', 1, 3),
    ('Entrada', 40, '2026-09-17 06:30:00', 1, 4),
    ('Salida', 5, '2026-09-17 09:00:00', 1, 4),
    ('Entrada', 20, '2026-09-17 07:00:00', 1, 5),
    ('Salida', 20, '2026-09-17 10:00:00', 1, 3),
    ('Entrada', 15, '2026-09-17 07:15:00', 1, 8),
    ('Ajuste', 1, '2026-09-17 11:00:00', 1, 5);

-- 8. Insertar Inventarios
INSERT INTO
    inventarios (stockMinimo, stockActual, producto_idProducto)
VALUES
    (10, 40, 1),
    (15, 30, 2),
    (5, 0, 3),
    (10, 35, 4),
    (5, 19, 5),
    (10, 0, 6),
    (20, 15, 7),
    (5, 15, 8),
    (2, 5, 9),
    (5, 0, 10);

-- 9. Insertar Pedidos (Asignados a los domiciliarios 1, 2 y 3)
INSERT INTO
    pedidos (
        fechaHoraCreacion,
        fechaHoraEntregaEstimada,
        estadoPedido,
        cliente_idCliente,
        domiciliario_idDomiciliario
    )
VALUES
    (
        '2026-09-17 08:00:00',
        '2026-09-17 08:30:00',
        'Entregado',
        1,
        1
    ),
    (
        '2026-09-17 09:00:00',
        '2026-09-17 09:45:00',
        'Entregado',
        2,
        2
    ),
    (
        '2026-09-17 10:00:00',
        '2026-09-17 10:30:00',
        'Cancelado',
        3,
        3
    ),
    (
        '2026-09-17 11:30:00',
        '2026-09-17 12:00:00',
        'En camino',
        4,
        1
    ),
    (
        '2026-09-17 12:00:00',
        '2026-09-17 12:45:00',
        'Listo',
        5,
        2
    ),
    (
        '2026-09-17 13:00:00',
        '2026-09-17 13:30:00',
        'En preparación',
        1,
        3
    ),
    (
        '2026-09-17 14:00:00',
        '2026-09-17 14:40:00',
        'Pendiente',
        2,
        1
    ),
    (
        '2026-09-17 14:15:00',
        '2026-09-17 15:00:00',
        'Pendiente',
        6,
        2
    ),
    (
        '2026-09-17 15:00:00',
        '2026-09-17 15:30:00',
        'En camino',
        7,
        3
    ),
    (
        '2026-09-17 15:30:00',
        '2026-09-17 16:15:00',
        'Listo',
        8,
        1
    );

-- 10. Insertar Detalles de Pedidos
INSERT INTO
    detalle_pedidos (
        precioFijo,
        cantidad,
        pedido_idPedido,
        producto_idProducto
    )
VALUES
    (2500.00, 4, 1, 1),
    (1500.00, 2, 2, 2),
    (3500.00, 1, 3, 5),
    (2000.00, 5, 4, 4),
    (3200.00, 2, 5, 8),
    (1800.00, 10, 6, 7),
    (25000.00, 1, 7, 9),
    (2500.00, 2, 8, 1),
    (1500.00, 5, 9, 2),
    (2000.00, 3, 10, 4);

-- 11. Insertar Recibos
INSERT INTO
    recibos (totalPagar, fechaEmision, pedido_idPedido)
VALUES
    (10000.00, '2026-09-17 08:35:00', 1),
    (3000.00, '2026-09-17 09:50:00', 2),
    (3500.00, '2026-09-17 10:30:00', 3),
    (10000.00, '2026-09-17 12:00:00', 4),
    (6400.00, '2026-09-17 12:45:00', 5),
    (18000.00, '2026-09-17 13:30:00', 6),
    (25000.00, '2026-09-17 14:40:00', 7),
    (5000.00, '2026-09-17 15:00:00', 8),
    (7500.00, '2026-09-17 15:30:00', 9),
    (6000.00, '2026-09-17 16:15:00', 10);

-- 12. Insertar Rutas de Entrega
INSERT INTO
    rutasEntrega (
        estadoRuta,
        urlRutaGoogle,
        domiciliarios_idDomiciliario
    )
VALUES
    ('Completada', 'https://maps.google.com/ruta1', 1),
    ('Completada', 'https://maps.google.com/ruta2', 2),
    ('Cancelada', 'https://maps.google.com/ruta3', 3),
    ('En Curso', 'https://maps.google.com/ruta4', 1),
    ('En Curso', 'https://maps.google.com/ruta5', 2),
    ('Pendiente', 'https://maps.google.com/ruta6', 3),
    ('Pendiente', 'https://maps.google.com/ruta7', 1),
    ('Pendiente', 'https://maps.google.com/ruta8', 2),
    ('Completada', 'https://maps.google.com/ruta9', 3),
    ('Pendiente', 'https://maps.google.com/ruta10', 1);

-- 13. Insertar Paradas de Ruta
INSERT INTO
    rutasParada (
        rutasEntrega_idRutasEntrega,
        pedidos_idPedido,
        ordenEntrega,
        estadoParada
    )
VALUES
    (1, 1, 1, 'Entregado'),
    (2, 2, 1, 'Entregado'),
    (3, 3, 1, 'Fallido'),
    (4, 4, 1, 'Pendiente'),
    (5, 5, 1, 'Pendiente'),
    (6, 6, 1, 'Pendiente'),
    (7, 7, 1, 'Pendiente'),
    (8, 8, 1, 'Pendiente'),
    (4, 9, 2, 'Pendiente'),
    (5, 10, 2, 'Pendiente');