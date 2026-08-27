-- =====================================================================
-- PROYECTO: PANIFY - Sistema de Gestión para Panadería "Distribuciones Oro Pan"
-- SENA - ADSO - Ficha 3315796 - Grupo 4
-- =====================================================================
-- Script: panify_esquema_ddl.sql
-- Propósito: Creación completa de la base de datos y sus 13 tablas.
-- Público objetivo de este script: cualquier programador Junior del
-- equipo debe poder leerlo de arriba a abajo y entender QUÉ hace cada
-- tabla, QUÉ regla de negocio representa cada columna, y QUÉ cosas
-- NO están controladas por la base de datos (para que se controlen
-- obligatoriamente desde la capa de aplicación / backend).
--
-- CÓMO EJECUTAR ESTE SCRIPT:
--   Se ejecuta de un solo golpe en MySQL Workbench (Ctrl+Shift+Enter)
--   o desde consola: mysql -u usuario -p < panify_esquema_ddl.sql
--   Es seguro volver a ejecutarlo: todas las tablas usan
--   "CREATE TABLE IF NOT EXISTS", así que no falla si ya existen.
--
-- NOTA IMPORTANTE SOBRE NOMBRES DE COLUMNAS (transparencia para el equipo):
--   El Diccionario de Datos original nombra dos columnas de forma
--   distinta a como aparecen en el diagrama ER final aprobado:
--     - Diccionario: "correoElectronico"   -> Diagrama final: "correo"
--     - Diccionario: "estadoCuenta"        -> Diagrama final: "estado"
--   Este script sigue el DIAGRAMA FINAL (la versión que el equipo
--   revisó y aprobó explícitamente en la última iteración), ya que
--   es la fuente más reciente y validada. Si el equipo prefiere
--   volver a los nombres originales del diccionario, es un simple
--   "RENAME COLUMN" antes de poblar datos reales.
--
-- NOTA SOBRE AUTO_INCREMENT:
--   El Diccionario de Datos no especifica explícitamente si las
--   claves primarias son autoincrementales. Se asume AUTO_INCREMENT
--   en todas las PK por ser la práctica estándar en MySQL y porque
--   ninguna regla de negocio exige asignar IDs manualmente.
-- =====================================================================


-- =====================================================================
-- PASO 1: Crear la base de datos y posicionarse en ella
-- =====================================================================
CREATE DATABASE IF NOT EXISTS panify
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE panify;


-- =====================================================================
-- PASO 2: Deshabilitar temporalmente la verificación de llaves foráneas
-- =====================================================================
-- ¿Por qué? Porque varias tablas se referencian entre sí (ej. usuarios
-- depende de clientes/panaderos/domiciliarios, pedidos depende de
-- clientes y domiciliarios, etc.). Si MySQL valida cada FK a medida
-- que se crea cada tabla, el orden de creación importaría muchísimo
-- y un solo error de secuencia bloquearía todo el script.
-- Desactivamos la validación, creamos TODAS las tablas, y la
-- reactivamos al final (Paso 4). A partir de ahí, MySQL sí exige
-- integridad referencial en cada INSERT/UPDATE/DELETE futuro.
SET FOREIGN_KEY_CHECKS = 0;


-- =====================================================================
-- PASO 3: Creación de tablas, organizadas por módulo
-- =====================================================================

-- ---------------------------------------------------------------------
-- MÓDULO: GESTIÓN DE USUARIOS Y ROLES
-- ---------------------------------------------------------------------

-- Tabla: roles
-- Catálogo fijo de los 3 roles del sistema. Regla de negocio: siempre
-- deben existir exactamente 3 filas (Cliente, Panadero, Domiciliario).
CREATE TABLE IF NOT EXISTS roles (
    idRol   INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único del rol.',
    nombre  VARCHAR(45) NOT NULL
        COMMENT 'Nombre del rol: Cliente, Panadero o Domiciliario.',
    PRIMARY KEY (idRol),
    UNIQUE KEY nombre_UNIQUE (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Catálogo fijo de roles. Regla de negocio: exactamente 3 filas.';


-- Tabla: clientes
-- Subtipo de usuario. Es la única entidad que puede originar un pedido.
CREATE TABLE IF NOT EXISTS clientes (
    idCliente    INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único del cliente.',
    tipoCliente  ENUM('Nuevo','Frecuente','Ocasional') NOT NULL
        COMMENT 'Clasificación comercial del cliente.',
    direccion    VARCHAR(150) NOT NULL
        COMMENT 'Dirección de despacho/residencia. Cobertura actual: municipio de Soacha (no se maneja tabla de barrios/zonas por decisión de negocio: baja dispersión geográfica).',
    PRIMARY KEY (idCliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Subtipo de usuario: clientes que realizan pedidos.';


-- Tabla: panaderos
-- Subtipo de usuario. Regla de negocio: debe existir exactamente 1
-- fila (un único panadero fijo en la empresa). Esta regla NO se
-- fuerza a nivel de esquema (requeriría un TRIGGER o CHECK avanzado
-- que aún no se ha cubierto en la etapa formativa); se controla desde
-- la aplicación.
CREATE TABLE IF NOT EXISTS panaderos (
    idPanadero      INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único del operario de producción.',
    estadoActivdad  ENUM('En turno','Descanso','Inactivo') NOT NULL
        COMMENT 'Estado operativo actual del panadero. OJO: el nombre de esta columna ("estadoActivdad", sin la "i" de Actividad) se conserva EXACTAMENTE así porque así está documentado en el Diccionario de Datos oficial del proyecto. No es un error de este script.',
    PRIMARY KEY (idPanadero)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Subtipo de usuario. Regla de negocio: exactamente 1 fila (controlada por aplicación, no por el esquema).';


-- Tabla: domiciliarios
-- Subtipo de usuario. Regla de negocio: deben existir exactamente 2
-- filas (dos domiciliarios fijos, se desplazan en bicicleta, por eso
-- no se maneja ningún campo de placa/vehículo).
CREATE TABLE IF NOT EXISTS domiciliarios (
    idDomiciliario         INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único del domiciliario.',
    estadoDisponibilidad   ENUM('Libre','Ocupado','Inactivo') NOT NULL
        COMMENT 'Disponibilidad actual del domiciliario para recibir una nueva ruta asignada.',
    PRIMARY KEY (idDomiciliario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Subtipo de usuario. Regla de negocio: exactamente 2 filas (controlada por aplicación, no por el esquema).';


-- Tabla: usuarios
-- Entidad padre (superclase) de la jerarquía ISA. Cada fila puede
-- vincularse, como máximo, a UNO de los tres subtipos siguientes:
-- clientes, panaderos o domiciliarios. Esa exclusividad (que un mismo
-- usuario no sea cliente Y panadero a la vez) tampoco se fuerza con
-- un CHECK constraint por la misma razón explicada arriba: se
-- controla desde la aplicación al momento del registro.
CREATE TABLE IF NOT EXISTS usuarios (
    idUsuario                      INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único y autoincremental del usuario.',
    nombre                         VARCHAR(45) NOT NULL
        COMMENT 'Nombres completos del usuario.',
    apellido                       VARCHAR(45) NOT NULL
        COMMENT 'Apellidos completos del usuario.',
    correo                         VARCHAR(150) NOT NULL
        COMMENT 'Correo electrónico. Funciona como login único del sistema.',
    contrasena                     VARCHAR(255) NOT NULL
        COMMENT 'Contraseña ENCRIPTADA (hash bcrypt/argon2). El backend NUNCA debe guardar aquí texto plano. 255 caracteres da margen de sobra para cualquier algoritmo de hashing moderno.',
    telefono                       VARCHAR(15) NOT NULL
        COMMENT 'Número telefónico o celular de contacto.',
    estado                         ENUM('Activo','Inactivo') NOT NULL
        COMMENT 'Estado general de la cuenta del usuario.',
    Rol_idRol                      INT NOT NULL
        COMMENT 'FK obligatoria hacia roles. Define el rol general del usuario.',
    cliente_idCliente              INT NULL
        COMMENT 'FK opcional hacia clientes. Se llena SOLO si este usuario es un Cliente.',
    panadero_idPanadero            INT NULL
        COMMENT 'FK opcional hacia panaderos. Se llena SOLO si este usuario es el Panadero.',
    domiciliario_idDomiciliario    INT NULL
        COMMENT 'FK opcional hacia domiciliarios. Se llena SOLO si este usuario es un Domiciliario.',
    PRIMARY KEY (idUsuario),
    UNIQUE KEY correo_UNIQUE (correo),
    -- Estos UNIQUE garantizan que un mismo cliente/panadero/domiciliario
    -- no pueda quedar vinculado a más de un usuario distinto.
    UNIQUE KEY cliente_idCliente_UNIQUE (cliente_idCliente),
    UNIQUE KEY panadero_idPanadero_UNIQUE (panadero_idPanadero),
    UNIQUE KEY domiciliario_idDomiciliario_UNIQUE (domiciliario_idDomiciliario),
    KEY fk_usuarios_roles1_idx (Rol_idRol),
    KEY fk_usuarios_clientes1_idx (cliente_idCliente),
    KEY fk_usuarios_panaderos1_idx (panadero_idPanadero),
    KEY fk_usuarios_domiciliarios1_idx (domiciliario_idDomiciliario),
    CONSTRAINT fk_usuarios_roles1
        FOREIGN KEY (Rol_idRol) REFERENCES roles (idRol),
    CONSTRAINT fk_usuarios_clientes1
        FOREIGN KEY (cliente_idCliente) REFERENCES clientes (idCliente),
    CONSTRAINT fk_usuarios_panaderos1
        FOREIGN KEY (panadero_idPanadero) REFERENCES panaderos (idPanadero),
    CONSTRAINT fk_usuarios_domiciliarios1
        FOREIGN KEY (domiciliario_idDomiciliario) REFERENCES domiciliarios (idDomiciliario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Entidad padre de la jerarquía ISA. Un usuario debe vincularse a lo sumo a UN subtipo (regla controlada por aplicación).';


-- ---------------------------------------------------------------------
-- MÓDULO: GESTIÓN DE INVENTARIO
-- ---------------------------------------------------------------------

-- Tabla: productos
-- Catálogo de productos de la panadería.
CREATE TABLE IF NOT EXISTS productos (
    idProducto   INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único del artículo de panadería.',
    nombre       VARCHAR(45) NOT NULL
        COMMENT 'Nombre comercial del producto (ej. Pan Aliñado, Roscones).',
    precio       DECIMAL(10,2) NOT NULL
        COMMENT 'Precio de venta VIGENTE por unidad. OJO: este valor puede cambiar con el tiempo; para pedidos ya facturados, el precio histórico real se consulta en detalles_pedidos.precioFijo, NUNCA aquí.',
    estado       ENUM('Disponbile','Agotado') NOT NULL
        COMMENT 'ADVERTENCIA: el valor "Disponbile" está mal escrito (falta la "i" de "Disponible"). Se conserva INTENCIONALMENTE porque así está documentado en el Diccionario de Datos oficial. El backend debe usar EXACTAMENTE ese literal al insertar/consultar, o las comparaciones fallarán silenciosamente.',
    descripcion  VARCHAR(100) NULL DEFAULT NULL
        COMMENT 'Descripción opcional del producto.',
    PRIMARY KEY (idProducto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Catálogo de productos de la panadería.';


-- Tabla: movimientos
-- Bitácora de entradas, salidas y ajustes de inventario.
CREATE TABLE IF NOT EXISTS movimientos (
    idMovimiento         INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único del movimiento de inventario.',
    tipoMovimiento       ENUM('Entrada','Salida','Ajuste') NOT NULL
        COMMENT 'Naturaleza física del movimiento de stock.',
    cantidad             INT NOT NULL
        COMMENT 'Número de unidades físicas movidas en esta transacción.',
    fechaHora            DATETIME NOT NULL
        COMMENT 'Fecha y hora exacta en la que se ejecutó el movimiento.',
    panadero_idPanadero  INT NOT NULL
        COMMENT 'FK obligatoria. Operario responsable de registrar la producción/merma/ajuste.',
    producto_idProducto  INT NOT NULL
        COMMENT 'FK obligatoria. Producto afectado por el movimiento.',
    PRIMARY KEY (idMovimiento),
    KEY fk_movimientos_panaderos1_idx (panadero_idPanadero),
    KEY fk_movimientos_productos1_idx (producto_idProducto),
    CONSTRAINT fk_movimientos_panaderos1
        FOREIGN KEY (panadero_idPanadero) REFERENCES panaderos (idPanadero),
    CONSTRAINT fk_movimientos_productos1
        FOREIGN KEY (producto_idProducto) REFERENCES productos (idProducto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Bitácora de movimientos de inventario. IMPORTANTE: ver nota extendida al final del script sobre cómo debe sincronizarse con inventarios.stockActual.';


-- Tabla: inventarios
-- Control de stock actual por producto.
CREATE TABLE IF NOT EXISTS inventarios (
    idInventario         INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único del registro de inventario.',
    stockMinimo          INT NOT NULL
        COMMENT 'Umbral mínimo de stock. Si stockActual <= stockMinimo, el producto debe mostrarse con alerta visual de bajo inventario.',
    stockActual          INT NOT NULL
        COMMENT 'Cantidad actualmente disponible en existencia. NO se actualiza sola: ver nota extendida al final del script.',
    producto_idProducto  INT NOT NULL
        COMMENT 'FK obligatoria y única. Cada producto tiene exactamente un registro de inventario.',
    PRIMARY KEY (idInventario),
    UNIQUE KEY producto_idProducto_UNIQUE (producto_idProducto),
    KEY fk_inventarios_productos1_idx (producto_idProducto),
    CONSTRAINT fk_inventarios_productos1
        FOREIGN KEY (producto_idProducto) REFERENCES productos (idProducto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Control de stock por producto. Estado_Stock (Disponible/Agotado/Bajo) es un atributo DERIVADO: se calcula en consulta (CASE WHEN stockActual <= stockMinimo...), nunca se almacena como columna.';


-- ---------------------------------------------------------------------
-- MÓDULO: GESTIÓN DE PEDIDOS
-- ---------------------------------------------------------------------

-- Tabla: pedidos
-- Cabecera de la orden de compra.
CREATE TABLE IF NOT EXISTS pedidos (
    idPedido                      INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único de la orden de compra.',
    fechaHoraCreacion              DATETIME NOT NULL
        COMMENT 'Fecha y hora exacta en la que se registró el pedido.',
    fechaHoraEntregaEstimada       DATETIME NOT NULL
        COMMENT 'Fecha y hora proyectada para la entrega del pedido.',
    estadoPedido                   ENUM('Pendiente','En preparación','Listo','En camino','Entregado','Cancelado') NOT NULL
        COMMENT 'Etapa actual de la orden dentro del flujo operativo.',
    cliente_idCliente               INT NOT NULL
        COMMENT 'FK obligatoria. Cliente que solicitó el pedido.',
    domiciliario_idDomiciliario     INT NOT NULL
        COMMENT 'FK obligatoria. Domiciliario encargado del reparto de este pedido específico.',
    PRIMARY KEY (idPedido),
    KEY fk_pedidos_clientes1_idx (cliente_idCliente),
    KEY fk_pedidos_domiciliarios1_idx (domiciliario_idDomiciliario),
    CONSTRAINT fk_pedidos_clientes1
        FOREIGN KEY (cliente_idCliente) REFERENCES clientes (idCliente),
    CONSTRAINT fk_pedidos_domiciliarios1
        FOREIGN KEY (domiciliario_idDomiciliario) REFERENCES domiciliarios (idDomiciliario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Cabecera del pedido. OJO: esta tabla YA NO tiene FK directa hacia rutasEntrega. Esa relación fue desacoplada intencionalmente y ahora vive en rutasParada (ver más abajo), para poder registrar el orden de visita y permitir que un pedido cambie de ruta con el tiempo.';


-- Tabla: detalles_pedidos
-- Tabla asociativa: líneas de producto dentro de cada pedido.
CREATE TABLE IF NOT EXISTS detalles_pedidos (
    idDetalle_Pedido      INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único de la línea de detalle.',
    precioFijo            DECIMAL(10,2) NOT NULL
        COMMENT 'Precio unitario del producto CONGELADO al momento exacto de la compra. Es la razón por la que un cambio futuro en productos.precio NO afecta pedidos ya facturados. Regla de oro: el total del pedido SIEMPRE se calcula con este valor, nunca con productos.precio.',
    cantidad              INT NOT NULL
        COMMENT 'Número de unidades solicitadas de este producto dentro del pedido.',
    pedido_idPedido       INT NOT NULL
        COMMENT 'FK obligatoria hacia la cabecera del pedido (tabla pedidos).',
    producto_idProducto   INT NOT NULL
        COMMENT 'FK obligatoria hacia el producto solicitado.',
    PRIMARY KEY (idDetalle_Pedido),
    KEY fk_detalles_pedidos_pedidos1_idx (pedido_idPedido),
    KEY fk_detalles_pedidos_productos1_idx (producto_idProducto),
    CONSTRAINT fk_detalles_pedidos_pedidos1
        FOREIGN KEY (pedido_idPedido) REFERENCES pedidos (idPedido),
    CONSTRAINT fk_detalles_pedidos_productos1
        FOREIGN KEY (producto_idProducto) REFERENCES productos (idProducto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Líneas de producto de cada pedido (relación N:M entre pedidos y productos, con atributos propios: cantidad y precioFijo).';


-- ---------------------------------------------------------------------
-- MÓDULO: GESTIÓN DE RECIBOS
-- ---------------------------------------------------------------------

-- Tabla: recibos
-- Comprobante de pago generado por pedido.
CREATE TABLE IF NOT EXISTS recibos (
    idRecibo         INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único del comprobante de pago.',
    totalPagar       DECIMAL(10,2) NOT NULL
        COMMENT 'Monto total consolidado (SUM de cantidad * precioFijo de todas las líneas en detalles_pedidos del pedido correspondiente).',
    fechaEmision     DATETIME NOT NULL
        COMMENT 'Fecha y hora exacta en la que se generó y cobró el recibo.',
    pedido_idPedido  INT NOT NULL
        COMMENT 'FK obligatoria y única. Cada recibo pertenece a un único pedido.',
    PRIMARY KEY (idRecibo),
    UNIQUE KEY pedido_idPedido_UNIQUE (pedido_idPedido),
    KEY fk_recibos_pedidos1_idx (pedido_idPedido),
    CONSTRAINT fk_recibos_pedidos1
        FOREIGN KEY (pedido_idPedido) REFERENCES pedidos (idPedido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Comprobante de pago por pedido. Relación 1 a 1: un recibo siempre pertenece a un único pedido (recomendación: crear el recibo solo cuando el pedido se confirma/entrega, no en el momento de creación).';


-- ---------------------------------------------------------------------
-- MÓDULO: GESTIÓN DE ENTREGA
-- ---------------------------------------------------------------------

-- Tabla: rutasEntrega
-- Una ruta puede agrupar varios pedidos (ver rutasParada) que un
-- mismo domiciliario reparte en un solo recorrido.
CREATE TABLE IF NOT EXISTS rutasEntrega (
    idRutasEntrega                 INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único de la ruta de distribución.',
    estadoRuta                     ENUM('Pendiente','En Curso','Completada','Cancelada') NOT NULL
        COMMENT 'Estado logístico general de la ruta completa (no de un pedido individual; eso vive en rutasParada.estadoParada).',
    urlRutaGoogle                  VARCHAR(500) NOT NULL
        COMMENT 'Enlace de Google Maps con el recorrido optimizado. Se genera y actualiza desde el BACKEND mediante integración con Google Maps Directions API; la base de datos únicamente lo almacena como texto.',
    domiciliarios_idDomiciliario   INT NOT NULL
        COMMENT 'FK obligatoria. Domiciliario responsable de ejecutar esta ruta completa.',
    PRIMARY KEY (idRutasEntrega),
    KEY fk_rutasEntrega_domiciliarios1_idx (domiciliarios_idDomiciliario),
    CONSTRAINT fk_rutasEntrega_domiciliarios1
        FOREIGN KEY (domiciliarios_idDomiciliario) REFERENCES domiciliarios (idDomiciliario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Ruta de reparto asignada a un domiciliario. Puede agrupar varios pedidos mediante rutasParada.';


-- Tabla: rutasParada
-- Tabla intermedia que desacopla pedidos de rutasEntrega. Permite
-- ordenar las paradas dentro de una ruta y conservar historial
-- cuando un pedido cambia de ruta con el tiempo.
CREATE TABLE IF NOT EXISTS rutasParada (
    idRutasParada                  INT NOT NULL AUTO_INCREMENT
        COMMENT 'Clave primaria. Identificador único de la parada dentro de una ruta.',
    rutasEntrega_idRutasEntrega    INT NOT NULL
        COMMENT 'FK obligatoria. Ruta a la que pertenece esta parada.',
    pedidos_idPedido                INT NOT NULL
        COMMENT 'FK obligatoria. Pedido correspondiente a esta parada. A PROPÓSITO no tiene restricción UNIQUE: un mismo pedido puede tener varias filas históricas aquí si se reasigna de ruta con el tiempo. Ver nota extendida al final del script sobre cómo determinar la asignación VIGENTE.',
    ordenEntrega                    INT NOT NULL
        COMMENT 'Posición secuencial de visita dentro de la ruta (1 = primera parada, 2 = segunda parada, etc.). Es lo que alimenta el Panel de Prioridades.',
    estadoParada                    ENUM('Pendiente','Entregado','Fallido') NOT NULL DEFAULT 'Pendiente'
        COMMENT 'Estado individual de esta entrega puntual, independiente del estado general de la ruta (rutasEntrega.estadoRuta).',
    PRIMARY KEY (idRutasParada),
    KEY fk_rutasParada_rutasEntrega1_idx (rutasEntrega_idRutasEntrega),
    KEY fk_rutasParada_pedidos1_idx (pedidos_idPedido),
    CONSTRAINT fk_rutasParada_rutasEntrega1
        FOREIGN KEY (rutasEntrega_idRutasEntrega) REFERENCES rutasEntrega (idRutasEntrega),
    CONSTRAINT fk_rutasParada_pedidos1
        FOREIGN KEY (pedidos_idPedido) REFERENCES pedidos (idPedido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Detalle de cada parada dentro de una ruta: qué pedido, en qué orden, y con qué estado individual.';


-- =====================================================================
-- PASO 4: Volver a habilitar la verificación de llaves foráneas
-- =====================================================================
-- A partir de aquí, MySQL vuelve a exigir integridad referencial en
-- cada INSERT/UPDATE/DELETE. Es intencional que esto se reactive
-- SIEMPRE al final del script, incluso si algo falla arriba: nunca se
-- debe dejar una base de datos en producción con las FK desactivadas.
SET FOREIGN_KEY_CHECKS = 1;


-- =====================================================================
-- NOTAS EXTENDIDAS DE REGLAS DE NEGOCIO CONTROLADAS POR LA APLICACIÓN
-- (No se pueden forzar en el esquema con las sentencias SQL cubiertas
-- hasta ahora en la etapa formativa: sin TRIGGER, sin CHECK avanzado)
-- =====================================================================
--
-- 1) SINCRONIZACIÓN DE STOCK (movimientos -> inventarios.stockActual):
--    Cada vez que el backend registre un movimiento, debe envolver el
--    INSERT y el UPDATE correspondiente en una única transacción:
--
--        START TRANSACTION;
--        INSERT INTO movimientos (tipoMovimiento, cantidad, fechaHora,
--            panadero_idPanadero, producto_idProducto)
--            VALUES ('Salida', 5, NOW(), 1, 12);
--        UPDATE inventarios SET stockActual = stockActual - 5
--            WHERE producto_idProducto = 12;
--        COMMIT;
--
--    Esto evita que un movimiento quede registrado sin que el stock
--    se haya descontado (o viceversa) si algo falla a mitad de camino.
--
-- 2) VIGENCIA DE LA RUTA ACTUAL DE UN PEDIDO (rutasParada):
--    Como un pedido puede tener varias filas históricas en
--    rutasParada, la asignación VIGENTE se determina consultando la
--    parada cuya ruta asociada NO esté Completada ni Cancelada:
--
--        SELECT rp.*, re.estadoRuta
--        FROM rutasParada rp
--        INNER JOIN rutasEntrega re
--            ON rp.rutasEntrega_idRutasEntrega = re.idRutasEntrega
--        WHERE rp.pedidos_idPedido = 15
--          AND re.estadoRuta IN ('Pendiente', 'En Curso')
--        ORDER BY rp.idRutasParada DESC
--        LIMIT 1;
--
--    Antes de insertar una nueva parada para un pedido, el backend
--    debe verificar que no exista ya una parada vigente (con la
--    consulta anterior) para evitar que un mismo pedido quede
--    "activo" en dos rutas al mismo tiempo.
--
-- 3) CANTIDAD FIJA DE USUARIOS POR ROL:
--    - roles: exactamente 3 filas (Cliente, Panadero, Domiciliario).
--    - panaderos: exactamente 1 fila.
--    - domiciliarios: exactamente 2 filas.
--    Ninguna de estas reglas está forzada por el esquema; deben
--    validarse en el backend antes de permitir un nuevo registro.
--
-- 4) EXCLUSIVIDAD DE ROL EN "usuarios":
--    Un usuario debería tener SOLO UNO de los tres campos
--    (cliente_idCliente / panadero_idPanadero / domiciliario_idDomiciliario)
--    distinto de NULL. El esquema no lo impide (se descartó un CHECK
--    CONSTRAINT por estar fuera del alcance formativo actual); el
--    backend debe validarlo antes de cada INSERT/UPDATE en usuarios.
-- =====================================================================