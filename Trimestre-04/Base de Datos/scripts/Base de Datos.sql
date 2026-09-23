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
        idCliente INT NOT NULL,
        tipoCliente ENUM ('Nuevo', 'Frecuente', 'Ocasional') NOT NULL,
        direccion VARCHAR(150) NOT NULL,
        PRIMARY KEY (idCliente)
    );

CREATE TABLE
    IF NOT EXISTS panaderos (
        idPanadero INT NOT NULL,
        estadoActividad ENUM ('En turno', 'Descanso', 'Inactivo') NOT NULL,
        PRIMARY KEY (idPanadero)
    );

CREATE TABLE
    IF NOT EXISTS domiciliarios (
        idDomiciliario INT NOT NULL,
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
        estado ENUM ('Disponible', 'Agotado') NOT NULL,
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

-- 2. Insertar Clientes (10 clientes con su ID explícito)
INSERT INTO
    clientes (idCliente, tipoCliente, direccion)
VALUES
    (1, 'Nuevo', 'Calle 13 # 4-50, Soacha'),
    (2, 'Frecuente', 'Cra 7 # 12-34, Soacha'),
    (3, 'Ocasional', 'Calle 22 # 9-10, Soacha'),
    (4, 'Nuevo', 'Cra 4 # 15-20, Soacha'),
    (5, 'Frecuente', 'Calle 10 # 5-60, Soacha'),
    (6, 'Ocasional', 'Cra 8 # 11-11, Soacha'),
    (7, 'Nuevo', 'Calle 1 # 2-3, Soacha'),
    (8, 'Frecuente', 'Cra 9 # 14-22, Soacha'),
    (9, 'Ocasional', 'Calle 5 # 7-8, Soacha'),
    (10, 'Nuevo', 'Cra 3 # 1-15, Soacha');

-- 3. Insertar Panaderos (Exactamente 1 panadero con su ID explícito)
INSERT INTO
    panaderos (idPanadero, estadoActividad)
VALUES
    (1, 'En turno');

-- 4. Insertar Domiciliarios (Máximo 3 domiciliarios con su ID explícito)
INSERT INTO
    domiciliarios (idDomiciliario, estadoDisponibilidad)
VALUES
    (1, 'Libre'),
    (2, 'Ocupado'),
    (3, 'Inactivo');

-- 5. Insertar Usuarios (14 en total)
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
        1500.00,
        'Disponible',
        'Paquete de 5 unidades'
    ),
    (
        'Pan Rollo',
        1500.00,
        'Disponible',
        'Paquete de 5 unidades'
    ),
    (
        'Roscon',
        1500.00,
        'Agotado',
        'Paquete de 5 unidades rellenos de bocadillo o arequipe'
    ),
    (
        'Pan de Queso',
        3000.00,
        'Disponible',
        'Unidad grande tradicional'
    ),
    (
        'Pan Baguette',
        2000.00,
        'Disponible',
        'Pan alargado y crujiente'
    ),
    (
        'Pan Galleta',
        2000.00,
        'Agotado',
        'Pan tradicional con costra crujiente horneadas'
    ),
    (
        'Pan Mani',
        2500.00,
        'Disponible',
        'Pan con cubierta crujiente de maní'
    ),
    (
        'Pan Campesino',
        2500.00,
        'Disponible',
        'Cubierto con harina por encima'
    ),
    (
        'Lenguas',
        1500.00,
        'Disponible',
        'Paquete de 5 unidades'
    ),
    (
        'Pan Hojaldre',
        1500.00,
        'Agotado',
        'Paquete de 5 unidades'
    );

-- 7. Insertar Movimientos de Inventario (Originales + 20 nuevos variados)
INSERT INTO
    movimientos (
        tipoMovimiento,
        cantidad,
        fechaHora,
        panadero_idPanadero,
        producto_idProducto
    )
VALUES
    -- 10 Originales
    ('Entrada', 50, '2026-09-17 06:00:00', 1, 1),
    ('Salida', 10, '2026-09-17 07:30:00', 1, 1),
    ('Entrada', 30, '2026-09-17 06:15:00', 1, 2),
    ('Ajuste', 2, '2026-09-17 08:00:00', 1, 3),
    ('Entrada', 40, '2026-09-17 06:30:00', 1, 4),
    ('Salida', 5, '2026-09-17 09:00:00', 1, 4),
    ('Entrada', 20, '2026-09-17 07:00:00', 1, 5),
    ('Salida', 20, '2026-09-17 10:00:00', 1, 3),
    ('Entrada', 15, '2026-09-17 07:15:00', 1, 8),
    ('Ajuste', 1, '2026-09-17 11:00:00', 1, 5),
    -- 20 Nuevos (Agosto - Octubre)
    ('Entrada', 100, '2026-08-01 05:30:00', 1, 1),
    ('Entrada', 80, '2026-08-02 06:00:00', 1, 2),
    ('Salida', 25, '2026-08-05 10:15:00', 1, 1),
    ('Ajuste', 5, '2026-08-10 12:00:00', 1, 4),
    ('Entrada', 60, '2026-08-15 05:45:00', 1, 5),
    ('Salida', 15, '2026-08-18 16:20:00', 1, 5),
    ('Entrada', 50, '2026-08-25 06:10:00', 1, 7),
    ('Salida', 20, '2026-08-28 09:30:00', 1, 7),
    ('Entrada', 40, '2026-09-02 06:00:00', 1, 9),
    ('Ajuste', 3, '2026-09-05 14:00:00', 1, 9),
    ('Entrada', 70, '2026-09-10 05:50:00', 1, 10),
    ('Salida', 30, '2026-09-14 11:15:00', 1, 10),
    ('Entrada', 90, '2026-09-20 06:30:00', 1, 4),
    ('Salida', 40, '2026-09-25 15:45:00', 1, 4),
    ('Entrada', 65, '2026-10-01 06:00:00', 1, 3),
    ('Ajuste', 4, '2026-10-05 08:30:00', 1, 2),
    ('Entrada', 55, '2026-10-10 05:40:00', 1, 6),
    ('Salida', 10, '2026-10-15 13:20:00', 1, 6),
    ('Entrada', 45, '2026-10-20 06:15:00', 1, 8),
    ('Salida', 22, '2026-10-25 17:00:00', 1, 8);

-- 8. Insertar Inventarios (No se agregan más para mantener la consistencia de 1 registro por producto)
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

-- 9. Insertar Pedidos (10 Originales + 20 nuevos con fechas variadas)
INSERT INTO
    pedidos (
        fechaHoraCreacion,
        fechaHoraEntregaEstimada,
        estadoPedido,
        cliente_idCliente,
        domiciliario_idDomiciliario
    )
VALUES
    -- 10 Originales
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
    ),
    -- 20 Nuevos (Variedad desde Agosto hasta Octubre)
    (
        '2026-08-05 08:30:00',
        '2026-08-05 09:15:00',
        'Entregado',
        2,
        1
    ),
    (
        '2026-08-12 14:00:00',
        '2026-08-12 14:45:00',
        'Entregado',
        5,
        2
    ),
    (
        '2026-08-18 09:15:00',
        '2026-08-18 10:00:00',
        'Cancelado',
        8,
        3
    ),
    (
        '2026-08-25 18:45:00',
        '2026-08-25 19:30:00',
        'Entregado',
        9,
        1
    ),
    (
        '2026-09-02 07:30:00',
        '2026-09-02 08:00:00',
        'Entregado',
        3,
        2
    ),
    (
        '2026-09-05 11:20:00',
        '2026-09-05 12:00:00',
        'Entregado',
        1,
        3
    ),
    (
        '2026-09-10 16:10:00',
        '2026-09-10 16:50:00',
        'Entregado',
        7,
        1
    ),
    (
        '2026-09-14 19:00:00',
        '2026-09-14 19:40:00',
        'Cancelado',
        10,
        2
    ),
    (
        '2026-09-20 10:05:00',
        '2026-09-20 10:50:00',
        'Entregado',
        6,
        3
    ),
    (
        '2026-09-25 13:40:00',
        '2026-09-25 14:15:00',
        'Entregado',
        4,
        1
    ),
    (
        '2026-09-28 08:50:00',
        '2026-09-28 09:30:00',
        'Entregado',
        2,
        2
    ),
    (
        '2026-10-01 15:30:00',
        '2026-10-01 16:15:00',
        'Entregado',
        5,
        3
    ),
    (
        '2026-10-05 12:15:00',
        '2026-10-05 13:00:00',
        'Entregado',
        8,
        1
    ),
    (
        '2026-10-10 09:45:00',
        '2026-10-10 10:30:00',
        'Entregado',
        9,
        2
    ),
    (
        '2026-10-12 17:20:00',
        '2026-10-12 18:00:00',
        'Entregado',
        1,
        3
    ),
    (
        '2026-10-15 14:10:00',
        '2026-10-15 14:50:00',
        'Cancelado',
        3,
        1
    ),
    (
        '2026-10-18 10:30:00',
        '2026-10-18 11:15:00',
        'Entregado',
        7,
        2
    ),
    (
        '2026-10-20 11:00:00',
        '2026-10-20 11:45:00',
        'Entregado',
        10,
        3
    ),
    (
        '2026-10-22 16:45:00',
        '2026-10-22 17:30:00',
        'Entregado',
        4,
        1
    ),
    (
        '2026-10-25 08:00:00',
        '2026-10-25 08:45:00',
        'Entregado',
        6,
        2
    );

-- 10. Insertar Detalles de Pedidos (10 Originales + 20 Nuevos)
INSERT INTO
    detalle_pedidos (
        precioFijo,
        cantidad,
        pedido_idPedido,
        producto_idProducto
    )
VALUES
    -- 10 Originales
    (2500.00, 4, 1, 1),
    (1500.00, 2, 2, 2),
    (3500.00, 1, 3, 5),
    (2000.00, 5, 4, 4),
    (3200.00, 2, 5, 8),
    (1800.00, 10, 6, 7),
    (25000.00, 1, 7, 9),
    (2500.00, 2, 8, 1),
    (1500.00, 5, 9, 2),
    (2000.00, 3, 10, 4),
    -- 20 Nuevos (Asociados a los pedidos 11 al 30)
    (1500.00, 3, 11, 1),
    (3000.00, 2, 12, 4),
    (2000.00, 4, 13, 5),
    (1500.00, 5, 14, 2),
    (2500.00, 2, 15, 7),
    (2500.00, 3, 16, 8),
    (1500.00, 6, 17, 9),
    (1500.00, 2, 18, 1),
    (3000.00, 1, 19, 4),
    (2000.00, 2, 20, 5),
    (1500.00, 4, 21, 2),
    (2500.00, 3, 22, 7),
    (1500.00, 5, 23, 9),
    (2500.00, 2, 24, 8),
    (1500.00, 3, 25, 1),
    (3000.00, 2, 26, 4),
    (2000.00, 3, 27, 5),
    (1500.00, 4, 28, 2),
    (2500.00, 2, 29, 7),
    (1500.00, 5, 30, 9);

-- 11. Insertar Recibos (10 Originales + 20 Nuevos correspondientes a sus pedidos)
INSERT INTO
    recibos (totalPagar, fechaEmision, pedido_idPedido)
VALUES
    -- 10 Originales
    (10000.00, '2026-09-17 08:35:00', 1),
    (3000.00, '2026-09-17 09:50:00', 2),
    (3500.00, '2026-09-17 10:30:00', 3),
    (10000.00, '2026-09-17 12:00:00', 4),
    (6400.00, '2026-09-17 12:45:00', 5),
    (18000.00, '2026-09-17 13:30:00', 6),
    (25000.00, '2026-09-17 14:40:00', 7),
    (5000.00, '2026-09-17 15:00:00', 8),
    (7500.00, '2026-09-17 15:30:00', 9),
    (6000.00, '2026-09-17 16:15:00', 10),
    -- 20 Nuevos (Precios calculados base al detalle: precioFijo * cantidad)
    (4500.00, '2026-08-05 08:35:00', 11),
    (6000.00, '2026-08-12 14:10:00', 12),
    (8000.00, '2026-08-18 09:20:00', 13),
    (7500.00, '2026-08-25 18:50:00', 14),
    (5000.00, '2026-09-02 07:40:00', 15),
    (7500.00, '2026-09-05 11:30:00', 16),
    (9000.00, '2026-09-10 16:20:00', 17),
    (3000.00, '2026-09-14 19:10:00', 18),
    (3000.00, '2026-09-20 10:15:00', 19),
    (4000.00, '2026-09-25 13:50:00', 20),
    (6000.00, '2026-09-28 09:00:00', 21),
    (7500.00, '2026-10-01 15:40:00', 22),
    (7500.00, '2026-10-05 12:25:00', 23),
    (5000.00, '2026-10-10 09:55:00', 24),
    (4500.00, '2026-10-12 17:30:00', 25),
    (6000.00, '2026-10-15 14:15:00', 26),
    (6000.00, '2026-10-18 10:40:00', 27),
    (6000.00, '2026-10-20 11:10:00', 28),
    (5000.00, '2026-10-22 16:55:00', 29),
    (7500.00, '2026-10-25 08:10:00', 30);

-- 12. Insertar Rutas de Entrega (10 Originales + 20 Nuevas)
INSERT INTO
    rutasEntrega (
        estadoRuta,
        urlRutaGoogle,
        domiciliarios_idDomiciliario
    )
VALUES
    -- 10 Originales
    ('Completada', 'https://maps.google.com/ruta1', 1),
    ('Completada', 'https://maps.google.com/ruta2', 2),
    ('Cancelada', 'https://maps.google.com/ruta3', 3),
    ('En Curso', 'https://maps.google.com/ruta4', 1),
    ('En Curso', 'https://maps.google.com/ruta5', 2),
    ('Pendiente', 'https://maps.google.com/ruta6', 3),
    ('Pendiente', 'https://maps.google.com/ruta7', 1),
    ('Pendiente', 'https://maps.google.com/ruta8', 2),
    ('Completada', 'https://maps.google.com/ruta9', 3),
    ('Pendiente', 'https://maps.google.com/ruta10', 1),
    -- 20 Nuevas (Mayoría 'Completada' o 'Cancelada' por ser fechas pasadas)
    ('Completada', 'https://maps.google.com/ruta11', 1),
    ('Completada', 'https://maps.google.com/ruta12', 2),
    ('Cancelada', 'https://maps.google.com/ruta13', 3),
    ('Completada', 'https://maps.google.com/ruta14', 1),
    ('Completada', 'https://maps.google.com/ruta15', 2),
    ('Completada', 'https://maps.google.com/ruta16', 3),
    ('Completada', 'https://maps.google.com/ruta17', 1),
    ('Cancelada', 'https://maps.google.com/ruta18', 2),
    ('Completada', 'https://maps.google.com/ruta19', 3),
    ('Completada', 'https://maps.google.com/ruta20', 1),
    ('Completada', 'https://maps.google.com/ruta21', 2),
    ('Completada', 'https://maps.google.com/ruta22', 3),
    ('Completada', 'https://maps.google.com/ruta23', 1),
    ('Completada', 'https://maps.google.com/ruta24', 2),
    ('Completada', 'https://maps.google.com/ruta25', 3),
    ('Cancelada', 'https://maps.google.com/ruta26', 1),
    ('Completada', 'https://maps.google.com/ruta27', 2),
    ('Completada', 'https://maps.google.com/ruta28', 3),
    ('Completada', 'https://maps.google.com/ruta29', 1),
    ('Completada', 'https://maps.google.com/ruta30', 2);

-- 13. Insertar Paradas de Ruta (10 Originales + 20 Nuevas)
INSERT INTO
    rutasParada (
        rutasEntrega_idRutasEntrega,
        pedidos_idPedido,
        ordenEntrega,
        estadoParada
    )
VALUES
    -- 10 Originales
    (1, 1, 1, 'Entregado'),
    (2, 2, 1, 'Entregado'),
    (3, 3, 1, 'Fallido'),
    (4, 4, 1, 'Pendiente'),
    (5, 5, 1, 'Pendiente'),
    (6, 6, 1, 'Pendiente'),
    (7, 7, 1, 'Pendiente'),
    (8, 8, 1, 'Pendiente'),
    (4, 9, 2, 'Pendiente'),
    (5, 10, 2, 'Pendiente'),
    -- 20 Nuevas (Mapeando rutas 11-30 con pedidos 11-30 respectivamente)
    (11, 11, 1, 'Entregado'),
    (12, 12, 1, 'Entregado'),
    (13, 13, 1, 'Fallido'),
    (14, 14, 1, 'Entregado'),
    (15, 15, 1, 'Entregado'),
    (16, 16, 1, 'Entregado'),
    (17, 17, 1, 'Entregado'),
    (18, 18, 1, 'Fallido'),
    (19, 19, 1, 'Entregado'),
    (20, 20, 1, 'Entregado'),
    (21, 21, 1, 'Entregado'),
    (22, 22, 1, 'Entregado'),
    (23, 23, 1, 'Entregado'),
    (24, 24, 1, 'Entregado'),
    (25, 25, 1, 'Entregado'),
    (26, 26, 1, 'Fallido'),
    (27, 27, 1, 'Entregado'),
    (28, 28, 1, 'Entregado'),
    (29, 29, 1, 'Entregado'),
    (30, 30, 1, 'Entregado');