DELIMITER $$

DROP PROCEDURE IF EXISTS registro $$

CREATE PROCEDURE `registro`(
    IN nom              VARCHAR(45),
    IN ape              VARCHAR(45),
    IN corr             VARCHAR(150),
    IN pass             VARCHAR(100),
    IN tel              VARCHAR(15),
    IN estCuenta        VARCHAR(20),
    IN idR              INT,
    IN direccionCliente VARCHAR(150)  -- solo aplica si idR = 1 (Cliente)
)
BEGIN
    DECLARE idNuevo      INT;
    DECLARE saltDerivado VARCHAR(10);
    DECLARE hashFinal    VARCHAR(64);

    SET saltDerivado = CONCAT(LEFT(corr, 3), RIGHT(tel, 3));
    SET hashFinal    = SHA2(CONCAT(pass, saltDerivado), 256);

    -- 1. Insertar usuario base (las FKs a tablas hijas quedan NULL por ahora)
    INSERT INTO usuarios (nombre, apellido, correo, contrasena, telefono, estado, Rol_idRol)
    VALUES (nom, ape, corr, hashFinal, tel, estCuenta, idR);

    SET idNuevo = LAST_INSERT_ID();

    -- 2. Insertar en la tabla hija correspondiente, usando el mismo ID
    IF idR = 1 THEN
        INSERT INTO clientes (idCliente, tipoCliente, direccion)
        VALUES (idNuevo, 'Nuevo', direccionCliente);

        UPDATE usuarios SET cliente_idCliente = idNuevo WHERE idUsuario = idNuevo;

    ELSEIF idR = 2 THEN
        INSERT INTO domiciliarios (idDomiciliario, estadoDisponibilidad)
        VALUES (idNuevo, 'Inactivo');

        UPDATE usuarios SET domiciliario_idDomiciliario = idNuevo WHERE idUsuario = idNuevo;

    ELSEIF idR = 3 THEN
        INSERT INTO panaderos (idPanadero, estadoActivdad)
        VALUES (idNuevo, 'Inactivo');

        UPDATE usuarios SET panadero_idPanadero = idNuevo WHERE idUsuario = idNuevo;
    END IF;

END $$

DELIMITER ;

-- Cliente
CALL registro('Ana', 'Gómez', 'ana@example.com', 'Clave123', '3009998888', 'Activo', 1, 'Calle 10 #5-20');

-- Domiciliario (direccionCliente en NULL, no aplica)
CALL registro('Luis', 'Ramírez', 'luis@example.com', 'Clave456', '3007776666', 'Activo', 2, NULL);

-- Panadero
CALL registro('Marta', 'Ríos', 'marta@example.com', 'Clave789', '3005554444', 'Activo', 3, NULL);