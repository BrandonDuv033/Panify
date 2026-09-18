DELIMITER \$\$

CREATE FUNCTION `encriptar`(texto VARCHAR(60))
RETURNS VARBINARY(200)
DETERMINISTIC
BEGIN
    DECLARE datoC VARBINARY(200);
    SET datoC = AES_ENCRYPT(texto, 'SENA');
    RETURN datoC;
END \$\$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE `registro`(
    IN nom        VARCHAR(45),
    IN ape        VARCHAR(45),
    IN corr       VARCHAR(100),
    IN pass       VARCHAR(100),
    IN tel        VARCHAR(20),
    IN estCuenta  VARCHAR(20),
    IN idR        INT,
    IN idCli      INT,
    IN idPan      INT,
    IN idDom      INT
)
BEGIN
    DECLARE saltDerivado VARCHAR(10);
    DECLARE hashFinal    VARCHAR(64);

    -- Salt determinístico: primeras 3 letras del correo + últimas 3 del teléfono
    SET saltDerivado = CONCAT(LEFT(corr, 3), RIGHT(tel, 3));

    -- Hash final combinando la contraseña en texto plano con el salt
    SET hashFinal = SHA2(CONCAT(pass, saltDerivado), 256);

    INSERT INTO usuarios (
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
    VALUES (
        nom,
        ape,
        corr,
        hashFinal,
        tel,
        estCuenta,
        idR,
        idCli,
        idPan,
        idDom
    );
END $$

DELIMITER ;

-- PENDIENTE: clientes.idCliente tiene AUTO_INCREMENT propio en vez de
-- heredar idUsuario (patrón ISA roto). Por ahora el procedure 'registro'
-- se prueba con idCli = NULL para evitar inconsistencias en las FKs.
-- Fix pendiente: quitar AUTO_INCREMENT y asignar idCliente = idUsuario
-- explícitamente al insertar en clientes.

-- CALL registro(
--    'Juan',
--    'Pérez',
--    'juanperez@example.com',
--    'MiClave123',
--    '3001234567',
--    'Activo',
--    2,      -- idR
--    NULL,   -- idCli
--    NULL,   -- idPan
--    NULL    -- idDom
-- );