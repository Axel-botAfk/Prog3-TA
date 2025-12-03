CREATE SCHEMA IF NOT EXISTS libreriaCampusStore2;
USE libreriaCampusStore2;
-- MySQL Workbench Forward Engineering
-- SET GLOBAL event_scheduler = ON;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema libreria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `articulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `articulo` (
  `idArticulo` INT NOT NULL AUTO_INCREMENT,
  `precio` DECIMAL(10,2) NOT NULL,
  `precioDescuento` DECIMAL(10,2) NULL DEFAULT NULL,
  `stockReal` INT NOT NULL,
  `stockVirtual` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(500) NULL DEFAULT NULL,
  `tipoArticulo` ENUM('LAPICERO', 'CUADERNO', 'PELUCHE', 'TOMATODO') NOT NULL,
  `imagenURL` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`idArticulo`))
ENGINE = InnoDB
AUTO_INCREMENT = 183
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `autor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `autor` (
  `idAutor` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `apellidos` VARCHAR(100) NULL DEFAULT NULL,
  `alias` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idAutor`))
ENGINE = InnoDB
AUTO_INCREMENT = 77
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `contraseña` VARCHAR(200) NOT NULL,
  `nombreUsuario` VARCHAR(100) NOT NULL,
  `correo` VARCHAR(254) NOT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `correo` (`correo` ASC) VISIBLE,
  UNIQUE INDEX `nombreUsuario_UNIQUE` (`nombreUsuario` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 345
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cupon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cupon` (
  `idCupon` INT NOT NULL AUTO_INCREMENT,
  `codigo` VARCHAR(50) NOT NULL,
  `descuento` DECIMAL(5,2) NOT NULL,
  `fechaCaducidad` DATETIME NOT NULL,
  `activo` TINYINT NOT NULL DEFAULT '1',
  `usosRestantes` INT NULL DEFAULT NULL,
  PRIMARY KEY (`idCupon`),
  UNIQUE INDEX `codigo` (`codigo` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 255
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `carrito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `carrito` (
  `idCarrito` INT NOT NULL AUTO_INCREMENT,
  `completado` TINYINT NOT NULL DEFAULT '0',
  `fechaCreacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CUPON_idCupon` INT NULL DEFAULT NULL,
  `CLIENTE_idCliente` INT NOT NULL,
  PRIMARY KEY (`idCarrito`),
  INDEX `fk_CARRITO_CUPON1_idx` (`CUPON_idCupon` ASC) VISIBLE,
  INDEX `fk_CARRITO_CLIENTE1_idx` (`CLIENTE_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_CARRITO_CLIENTE1`
    FOREIGN KEY (`CLIENTE_idCliente`)
    REFERENCES `cliente` (`idCliente`),
  CONSTRAINT `fk_CARRITO_CUPON1`
    FOREIGN KEY (`CUPON_idCupon`)
    REFERENCES `cupon` (`idCupon`))
ENGINE = InnoDB
AUTO_INCREMENT = 188
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cupon_has_cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cupon_has_cliente` (
  `cupon_idCupon` INT NOT NULL,
  `cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`cupon_idCupon`, `cliente_idCliente`),
  INDEX `fk_cupon_has_cliente_cliente1_idx` (`cliente_idCliente` ASC) VISIBLE,
  INDEX `fk_cupon_has_cliente_cupon1_idx` (`cupon_idCupon` ASC) VISIBLE,
  CONSTRAINT `fk_cupon_has_cliente_cliente1`
    FOREIGN KEY (`cliente_idCliente`)
    REFERENCES `cliente` (`idCliente`),
  CONSTRAINT `fk_cupon_has_cliente_cupon1`
    FOREIGN KEY (`cupon_idCupon`)
    REFERENCES `cupon` (`idCupon`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `descuento_articulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `descuento_articulo` (
  `idDescuentoArticulo` INT NOT NULL AUTO_INCREMENT,
  `valorDescuento` DECIMAL(10,2) NOT NULL,
  `fechaCaducidad` DATETIME NOT NULL,
  `activo` TINYINT NOT NULL DEFAULT '1',
  `ARTICULO_idArticulo` INT NOT NULL,
  PRIMARY KEY (`idDescuentoArticulo`),
  INDEX `fk_DESCUENTO_ARTICULO1_idx` (`ARTICULO_idArticulo` ASC) VISIBLE,
  CONSTRAINT `fk_DESCUENTO_ARTICULO1`
    FOREIGN KEY (`ARTICULO_idArticulo`)
    REFERENCES `articulo` (`idArticulo`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `editorial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `editorial` (
  `idEditorial` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `direccion` VARCHAR(255) NULL DEFAULT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `cif` VARCHAR(20) NOT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `sitioWeb` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`idEditorial`))
ENGINE = InnoDB
AUTO_INCREMENT = 137
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `libro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `libro` (
  `idLibro` INT NOT NULL AUTO_INCREMENT,
  `precio` DECIMAL(10,2) NOT NULL,
  `precioDescuento` DECIMAL(10,2) NULL DEFAULT NULL,
  `stockReal` INT NOT NULL,
  `stockVirtual` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(500) NULL DEFAULT NULL,
  `isbn` VARCHAR(13) NOT NULL,
  `generoLibro` ENUM('NOVELA', 'NARRATIVO', 'DRAMA', 'FANTASIA', 'AVENTURA', 'CIENCIA_FICCION') NOT NULL,
  `fechaPublicacion` DATETIME NOT NULL,
  `formato` ENUM('TAPA_DURA', 'TAPA_BLANDA', 'COLECCIONISTA') NOT NULL,
  `sinopsis` VARCHAR(1000) NOT NULL,
  `EDITORIAL_idEditorial` INT NOT NULL,
  `imagenURL` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`idLibro`),
  INDEX `fk_LIBRO_EDITORIAL1_idx` (`EDITORIAL_idEditorial` ASC) VISIBLE,
  CONSTRAINT `fk_LIBRO_EDITORIAL1`
    FOREIGN KEY (`EDITORIAL_idEditorial`)
    REFERENCES `editorial` (`idEditorial`))
ENGINE = InnoDB
AUTO_INCREMENT = 116
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `descuento_libro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `descuento_libro` (
  `idDescuentoLibro` INT NOT NULL AUTO_INCREMENT,
  `valorDescuento` DECIMAL(10,2) NOT NULL,
  `fechaCaducidad` DATETIME NOT NULL,
  `activo` TINYINT NOT NULL DEFAULT '1',
  `LIBRO_idLibro` INT NOT NULL,
  PRIMARY KEY (`idDescuentoLibro`),
  INDEX `fk_DESCUENTO_copy1_LIBRO1_idx` (`LIBRO_idLibro` ASC) VISIBLE,
  CONSTRAINT `fk_DESCUENTO_copy1_LIBRO1`
    FOREIGN KEY (`LIBRO_idLibro`)
    REFERENCES `libro` (`idLibro`))
ENGINE = InnoDB
AUTO_INCREMENT = 53
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `orden_compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `orden_compra` (
  `idOrdenCompra` INT NOT NULL AUTO_INCREMENT,
  `fechaCreacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaLimitePago` DATETIME NOT NULL,
  `total` DECIMAL(10,2) NOT NULL,
  `totalConDescuento` DECIMAL(10,2) NULL DEFAULT NULL,
  `estado` ENUM('NO_PAGADO', 'PAGADO', 'ENTREGADO', 'CANCELADO') NOT NULL DEFAULT 'NO_PAGADO',
  `CLIENTE_idCliente` INT NOT NULL,
  `CARRITO_idCarrito` INT NOT NULL,
  PRIMARY KEY (`idOrdenCompra`),
  UNIQUE INDEX `CARRITO_idCarrito` (`CARRITO_idCarrito` ASC) VISIBLE,
  INDEX `fk_ORDEN_COMPRA_CLIENTE1_idx` (`CLIENTE_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_ORDEN_COMPRA_CARRITO1`
    FOREIGN KEY (`CARRITO_idCarrito`)
    REFERENCES `carrito` (`idCarrito`),
  CONSTRAINT `fk_ORDEN_COMPRA_CLIENTE1`
    FOREIGN KEY (`CLIENTE_idCliente`)
    REFERENCES `cliente` (`idCliente`))
ENGINE = InnoDB
AUTO_INCREMENT = 98
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `documento_venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `documento_venta` (
  `idDocumentoVenta` INT NOT NULL AUTO_INCREMENT,
  `fechaEmision` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ORDEN_COMPRA_idOrdenCompra` INT NOT NULL,
  PRIMARY KEY (`idDocumentoVenta`),
  INDEX `fk_DOCUMENTO_VENTA_ORDEN_COMPRA1_idx` (`ORDEN_COMPRA_idOrdenCompra` ASC) VISIBLE,
  CONSTRAINT `fk_DOCUMENTO_VENTA_ORDEN_COMPRA1`
    FOREIGN KEY (`ORDEN_COMPRA_idOrdenCompra`)
    REFERENCES `orden_compra` (`idOrdenCompra`))
ENGINE = InnoDB
AUTO_INCREMENT = 43
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `rol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rol` (
  `idRol` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idRol`))
ENGINE = InnoDB
AUTO_INCREMENT = 100
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `empleado` (
  `idEmpleado` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `contraseña` VARCHAR(200) NOT NULL,
  `nombreUsuario` VARCHAR(100) NOT NULL,
  `correo` VARCHAR(254) NOT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `activo` TINYINT NOT NULL DEFAULT '1',
  `sueldo` DECIMAL(10,2) NOT NULL,
  `ROL_idRol` INT NOT NULL,
  PRIMARY KEY (`idEmpleado`),
  UNIQUE INDEX `correo` (`correo` ASC) VISIBLE,
  UNIQUE INDEX `nombreUsuario_UNIQUE` (`nombreUsuario` ASC) VISIBLE,
  INDEX `fk_EMPLEADO_ROL1_idx` (`ROL_idRol` ASC) VISIBLE,
  CONSTRAINT `fk_EMPLEADO_ROL1`
    FOREIGN KEY (`ROL_idRol`)
    REFERENCES `rol` (`idRol`))
ENGINE = InnoDB
AUTO_INCREMENT = 51
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `libro_has_autor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `libro_has_autor` (
  `LIBRO_idLibro` INT NOT NULL,
  `AUTOR_idAutor` INT NOT NULL,
  PRIMARY KEY (`LIBRO_idLibro`, `AUTOR_idAutor`),
  INDEX `fk_LIBRO_has_AUTOR_AUTOR1_idx` (`AUTOR_idAutor` ASC) VISIBLE,
  INDEX `fk_LIBRO_has_AUTOR_LIBRO1_idx` (`LIBRO_idLibro` ASC) VISIBLE,
  CONSTRAINT `fk_LIBRO_has_AUTOR_AUTOR1`
    FOREIGN KEY (`AUTOR_idAutor`)
    REFERENCES `autor` (`idAutor`),
  CONSTRAINT `fk_LIBRO_has_AUTOR_LIBRO1`
    FOREIGN KEY (`LIBRO_idLibro`)
    REFERENCES `libro` (`idLibro`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `linea_carrito_articulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `linea_carrito_articulo` (
  `idLineaCarrito` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `precioUnitario` DECIMAL(10,2) NOT NULL,
  `subtotal` DECIMAL(10,2) NOT NULL,
  `precioConDescuento` DECIMAL(10,2) NULL DEFAULT NULL,
  `subtotalConDescuento` DECIMAL(10,2) NULL DEFAULT NULL,
  `CARRITO_idCarrito` INT NOT NULL,
  `articulo_idArticulo` INT NOT NULL,
  PRIMARY KEY (`idLineaCarrito`),
  INDEX `fk_LINEA_CARRITO_CARRITO1_idx` (`CARRITO_idCarrito` ASC) VISIBLE,
  INDEX `fk_linea_carrito_articulo_articulo1_idx` (`articulo_idArticulo` ASC) VISIBLE,
  CONSTRAINT `fk_linea_carrito_articulo_articulo1`
    FOREIGN KEY (`articulo_idArticulo`)
    REFERENCES `articulo` (`idArticulo`),
  CONSTRAINT `fk_LINEA_CARRITO_CARRITO1`
    FOREIGN KEY (`CARRITO_idCarrito`)
    REFERENCES `carrito` (`idCarrito`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 52
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `linea_carrito_libro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `linea_carrito_libro` (
  `idLineaCarrito` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `precioUnitario` DECIMAL(10,2) NOT NULL,
  `subtotal` DECIMAL(10,2) NOT NULL,
  `precioConDescuento` DECIMAL(10,2) NULL DEFAULT NULL,
  `subtotalConDescuento` DECIMAL(10,2) NULL DEFAULT NULL,
  `CARRITO_idCarrito` INT NOT NULL,
  `libro_idLibro` INT NOT NULL,
  PRIMARY KEY (`idLineaCarrito`),
  INDEX `fk_LINEA_CARRITO_CARRITO1_idx` (`CARRITO_idCarrito` ASC) VISIBLE,
  INDEX `fk_linea_carrito_libro_libro1_idx` (`libro_idLibro` ASC) VISIBLE,
  CONSTRAINT `fk_LINEA_CARRITO_CARRITO10`
    FOREIGN KEY (`CARRITO_idCarrito`)
    REFERENCES `carrito` (`idCarrito`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_linea_carrito_libro_libro1`
    FOREIGN KEY (`libro_idLibro`)
    REFERENCES `libro` (`idLibro`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `permiso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `permiso` (
  `idPermiso` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idPermiso`))
ENGINE = InnoDB
AUTO_INCREMENT = 43
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `reseña_articulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reseña_articulo` (
  `idReseñaArticulo` INT NOT NULL AUTO_INCREMENT,
  `calificacion` INT NOT NULL,
  `reseña` VARCHAR(500) NULL DEFAULT NULL,
  `ARTICULO_idArticulo` INT NOT NULL,
  `cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idReseñaArticulo`),
  INDEX `fk_RESEÑA_ARTICULO1_idx` (`ARTICULO_idArticulo` ASC) VISIBLE,
  INDEX `fk_reseña_articulo_cliente1_idx` (`cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_RESEÑA_ARTICULO1`
    FOREIGN KEY (`ARTICULO_idArticulo`)
    REFERENCES `articulo` (`idArticulo`),
  CONSTRAINT `fk_reseña_articulo_cliente1`
    FOREIGN KEY (`cliente_idCliente`)
    REFERENCES `cliente` (`idCliente`))
ENGINE = InnoDB
AUTO_INCREMENT = 50
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `reseña_libro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reseña_libro` (
  `idReseñaLibro` INT NOT NULL AUTO_INCREMENT,
  `calificacion` INT NOT NULL,
  `reseña` VARCHAR(500) NULL DEFAULT NULL,
  `LIBRO_idLibro` INT NOT NULL,
  `cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idReseñaLibro`),
  INDEX `fk_RESEÑA_copy1_LIBRO1_idx` (`LIBRO_idLibro` ASC) VISIBLE,
  INDEX `fk_reseña_libro_cliente1_idx` (`cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_RESEÑA_copy1_LIBRO1`
    FOREIGN KEY (`LIBRO_idLibro`)
    REFERENCES `libro` (`idLibro`),
  CONSTRAINT `fk_reseña_libro_cliente1`
    FOREIGN KEY (`cliente_idCliente`)
    REFERENCES `cliente` (`idCliente`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `rol_has_permiso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `rol_has_permiso` (
  `ROL_idRol` INT NOT NULL,
  `PERMISO_idPermiso` INT NOT NULL,
  PRIMARY KEY (`ROL_idRol`, `PERMISO_idPermiso`),
  INDEX `fk_ROL_has_PERMISO_PERMISO1_idx` (`PERMISO_idPermiso` ASC) VISIBLE,
  INDEX `fk_ROL_has_PERMISO_ROL1_idx` (`ROL_idRol` ASC) VISIBLE,
  CONSTRAINT `fk_ROL_has_PERMISO_PERMISO1`
    FOREIGN KEY (`PERMISO_idPermiso`)
    REFERENCES `permiso` (`idPermiso`),
  CONSTRAINT `fk_ROL_has_PERMISO_ROL1`
    FOREIGN KEY (`ROL_idRol`)
    REFERENCES `rol` (`idRol`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- procedure buscarArticuloPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarArticuloPorId`(IN p_id INT)
BEGIN
    SELECT * FROM articulo WHERE idArticulo = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarAutorPorAtributos
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarAutorPorAtributos`(
    IN p_nombre VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_alias VARCHAR(45)
)
BEGIN
    SELECT 
        idAutor,
        nombre,
        apellidos,
        alias
    FROM autor
    WHERE (p_nombre IS NULL OR nombre LIKE CONCAT('%', p_nombre, '%'))
      AND (p_apellidos IS NULL OR apellidos LIKE CONCAT('%', p_apellidos, '%'))
      AND (p_alias IS NULL OR alias LIKE CONCAT('%', p_alias, '%'))
    ORDER BY nombre ASC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarAutorPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarAutorPorId`(IN p_id INT)
BEGIN
    SELECT * FROM autor WHERE idAutor = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarCarritoPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarCarritoPorId`(IN p_id INT)
BEGIN
    SELECT * FROM carrito WHERE idCarrito = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarClientePorCorreo
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarClientePorCorreo`(IN p_correo VARCHAR(254))
BEGIN
	SELECT * FROM cliente WHERE correo = p_correo;
END$$

DELIMITER ;


-- -----------------------------------------------------
-- procedure buscarEmpleadoPorCorreo
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarEmpleadoPorCorreo`(IN p_correo VARCHAR(254))
BEGIN
  SELECT * FROM empleado WHERE correo = p_correo;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarClienteIdPorCorreo
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarClienteIdPorCorreo`(IN p_correo VARCHAR(254))
BEGIN
  SELECT idCliente FROM cliente WHERE correo = p_correo;
END$$

DELIMITER ;


-- -----------------------------------------------------
-- procedure buscarEmpleadoIdPorCorreo
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarEmpleadoIdPorCorreo`(IN p_correo VARCHAR(254))
BEGIN
  SELECT idEmpleado FROM empleado WHERE correo = p_correo;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarClientePorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarClientePorId`(IN p_id INT)
BEGIN
    SELECT * FROM cliente WHERE idCliente = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarCuponPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarCuponPorId`(IN p_id INT)
BEGIN
    SELECT * FROM cupon WHERE idCupon = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarDescuentoPorIdModelo
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarDescuentoPorIdModelo`(
    IN p_tipo VARCHAR(10),
    IN p_id INT
)
BEGIN
    IF p_tipo = 'ARTICULO' THEN
        SELECT 
            da.idDescuentoArticulo AS idDescuento,
            da.valorDescuento,
            da.fechaCaducidad,
            da.activo,
            'ARTICULO' AS tipoProducto,
            a.idArticulo
        FROM descuento_articulo da
        INNER JOIN articulo a ON da.ARTICULO_idArticulo = a.idArticulo
        WHERE da.idDescuentoArticulo = p_id;
        
    ELSEIF p_tipo = 'LIBRO' THEN
        SELECT 
            dl.idDescuentoLibro AS idDescuento,
            dl.valorDescuento,
            dl.fechaCaducidad,
            dl.activo,
            'LIBRO' AS tipoProducto,
            l.idLibro
        FROM descuento_libro dl
        INNER JOIN libro l ON dl.LIBRO_idLibro = l.idLibro
        WHERE dl.idDescuentoLibro = p_id;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser ARTICULO o LIBRO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarDocumentoVentaPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarDocumentoVentaPorId`(
    IN p_id INT
)
BEGIN
    SELECT idDocumentoVenta,
           fechaEmision,
           ORDEN_COMPRA_idOrdenCompra
    FROM documento_venta
    WHERE idDocumentoVenta = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarEditorialPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarEditorialPorId`(IN p_id INT)
BEGIN
    SELECT * FROM editorial WHERE idEditorial = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarEmpleadoPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarEmpleadoPorId`(IN p_id INT)
BEGIN
    SELECT * FROM empleado WHERE idEmpleado = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarLibroPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarLibroPorId`(IN p_id INT)
BEGIN
    SELECT * FROM libro WHERE idLibro = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarLineaCarritoPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarLineaCarritoPorId`(
    IN p_tipo VARCHAR(10),
    IN p_id INT
)
BEGIN
    IF p_tipo = 'ARTICULO' THEN
        SELECT 
            lca.idLineaCarrito,
            lca.cantidad,
            lca.precioUnitario,
            lca.subtotal,
            lca.precioConDescuento,
            lca.subtotalConDescuento,
            lca.CARRITO_idCarrito,
            'ARTICULO' AS tipoProducto,
            lca.articulo_idArticulo AS idArticulo
        FROM linea_carrito_articulo lca
        WHERE lca.idLineaCarrito = p_id;
        
    ELSEIF p_tipo = 'LIBRO' THEN
        SELECT 
            lcl.idLineaCarrito,
            lcl.cantidad,
            lcl.precioUnitario,
            lcl.subtotal,
            lcl.precioConDescuento,
            lcl.subtotalConDescuento,
            lcl.CARRITO_idCarrito,
            'LIBRO' AS tipoProducto,
            lcl.libro_idLibro AS idLibro
        FROM linea_carrito_libro lcl
        WHERE lcl.idLineaCarrito = p_id;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser ARTICULO o LIBRO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarOrdenCompraPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarOrdenCompraPorId`(IN p_id INT)
BEGIN
    SELECT * FROM orden_compra WHERE idOrdenCompra = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarPermisoPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarPermisoPorId`(IN p_id INT)
BEGIN
    SELECT * FROM permiso WHERE idPermiso = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarReseñaPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarReseñaPorId`(
    IN p_tipo VARCHAR(10),
    IN p_id INT
)
BEGIN
    IF p_tipo = 'LIBRO' THEN
        SELECT 
            rl.idReseñaLibro AS idReseña,
            rl.calificacion,
            rl.reseña,
            'LIBRO' AS tipoProducto,
            rl.LIBRO_idLibro AS idLibro,
            rl.cliente_idCliente AS idCliente
        FROM reseña_libro rl
        WHERE rl.idReseñaLibro = p_id;
        
    ELSEIF p_tipo = 'ARTICULO' THEN
        SELECT 
            ra.idReseñaArticulo AS idReseña,
            ra.calificacion,
            ra.reseña,
            'ARTICULO' AS tipoProducto,
            ra.ARTICULO_idArticulo AS idArticulo,
            ra.cliente_idCliente AS idCliente
        FROM reseña_articulo ra
        WHERE ra.idReseñaArticulo = p_id;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser LIBRO o ARTICULO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure buscarRolPorId
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarRolPorId`(IN p_id INT)
BEGIN
    SELECT * FROM rol WHERE idRol = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarArticulo
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarArticulo`(IN p_id INT)
BEGIN
    DELETE FROM articulo WHERE idArticulo = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarAutor
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarAutor`(IN p_id INT)
BEGIN
    DELETE FROM autor WHERE idAutor = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarAutorLibro
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarAutorLibro`(IN p_idLibro INT, IN p_idAutor INT)
BEGIN
    DELETE FROM libro_has_autor WHERE LIBRO_idLibro = p_idLibro and AUTOR_idAutor=p_idAutor;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarCarrito
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarCarrito`(IN p_id INT)
BEGIN
    DELETE FROM carrito WHERE idCarrito = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarCliente
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarCliente`(IN p_id INT)
BEGIN
    DELETE FROM cliente WHERE idCliente = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarCupon
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarCupon`(IN p_id INT)
BEGIN
    DELETE FROM cupon WHERE idCupon = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarDescuento
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarDescuento`(
    IN p_tipo VARCHAR(10),
    IN p_id INT
)
BEGIN
    IF p_tipo = 'ARTICULO' THEN
        DELETE FROM descuento_articulo
        WHERE idDescuentoArticulo = p_id;
    ELSEIF p_tipo = 'LIBRO' THEN
        DELETE FROM descuento_libro
        WHERE idDescuentoLibro = p_id;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser ARTICULO o LIBRO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarDocumentoVenta
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarDocumentoVenta`(
    IN p_id INT
)
BEGIN
    DELETE FROM documento_venta
    WHERE idDocumentoVenta = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarEditorial
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarEditorial`(IN p_id INT)
BEGIN
    DELETE FROM editorial WHERE idEditorial = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarEmpleado
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarEmpleado`(IN p_id INT)
BEGIN
    DELETE FROM empleado WHERE idEmpleado = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarLibro
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarLibro`(IN p_id INT)
BEGIN
    DELETE FROM libro WHERE idLibro = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarLineaCarrito
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarLineaCarrito`(
    IN p_tipo VARCHAR(10),
    IN p_id INT
)
BEGIN
    IF p_tipo = 'ARTICULO' THEN
        DELETE FROM linea_carrito_articulo
        WHERE idLineaCarrito = p_id;
        
    ELSEIF p_tipo = 'LIBRO' THEN
        DELETE FROM linea_carrito_libro
        WHERE idLineaCarrito = p_id;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser ARTICULO o LIBRO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarOrdenCompra
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarOrdenCompra`(IN p_id INT)
BEGIN
    DELETE FROM orden_compra WHERE idOrdenCompra = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarPermiso
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarPermiso`(IN p_id INT)
BEGIN
    DELETE FROM permiso WHERE idPermiso = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarReseña
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarReseña`(
    IN p_tipo VARCHAR(10),
    IN p_id INT
)
BEGIN
    IF p_tipo = 'LIBRO' THEN
        DELETE FROM reseña_libro
        WHERE idReseñaLibro = p_id;

    ELSEIF p_tipo = 'ARTICULO' THEN
        DELETE FROM reseña_articulo
        WHERE idReseñaArticulo = p_id;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser LIBRO o ARTICULO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure eliminarRol
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `eliminarRol`(IN p_id INT)
BEGIN
    DELETE FROM rol WHERE idRol = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarArticulo
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarArticulo`(
    IN p_nombre           VARCHAR(100),
    IN p_descripcion      VARCHAR(500),
    IN p_precio           DECIMAL(10,2),
    IN p_precioDescuento  DECIMAL(10,2),
    IN p_stockReal        INT,
    IN p_stockVirtual     INT,
    IN p_tipoArticulo     VARCHAR(45),
    IN p_imagenURL        VARCHAR(500),
    OUT p_id      INT
)
BEGIN
    INSERT INTO articulo (
        nombre,
        descripcion,
        precio,
        precioDescuento,
        stockReal,
        stockVirtual,
        tipoArticulo,
        imagenURL
    ) VALUES (
        p_nombre,
        p_descripcion,
        p_precio,
        p_precioDescuento,
        p_stockReal,
        p_stockVirtual,
        p_tipoArticulo,
        p_imagenURL
    );

    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarAutor
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarAutor`(
    IN p_nombre VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_alias VARCHAR(45),
    OUT p_id INT
)
BEGIN
    INSERT INTO autor (
        nombre,
        apellidos,
        alias
    ) VALUES (
        p_nombre,
        p_apellidos,
        p_alias
    );
    
    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarAutorLibro
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarAutorLibro`(
    IN p_idLibro INT,
    IN p_idAutor INT,
    OUT p_id INT
)
BEGIN
    INSERT INTO libro_has_autor (LIBRO_idLibro, AUTOR_idAutor)
    VALUES (p_idLibro, p_idAutor);
    SET p_id = 1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarAutorSiNoExiste
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarAutorSiNoExiste`(
    IN p_nombre VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_alias VARCHAR(45),
    OUT p_id INT
)
BEGIN
    -- Buscar autor duplicado
    SELECT idAutor INTO p_id
    FROM autor
    WHERE nombre = p_nombre
      AND (apellidos = p_apellidos OR (apellidos IS NULL AND p_apellidos IS NULL))
    LIMIT 1;

    -- Si no existe, insertarlo
    IF p_id IS NULL THEN
        INSERT INTO autor(nombre, apellidos, alias)
        VALUES (p_nombre, p_apellidos, p_alias);
        SET p_id = LAST_INSERT_ID();
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarCarrito
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarCarrito`(
    IN p_idCupon INT,
    IN p_idCliente INT,
    OUT p_id INT
)
BEGIN
    INSERT INTO carrito (
        completado,
        CUPON_idCupon,
        CLIENTE_idCliente
    ) VALUES (
        0,                 -- Por defecto, un carrito nuevo no está completado
        p_idCupon,
        p_idCliente
    );
    
    -- Se asigna el ID generado automáticamente al parámetro de salida
    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarCliente
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarCliente`(
    IN p_nombre VARCHAR(100),
    IN p_contraseña VARCHAR(200),
    IN p_nombreUsuario VARCHAR(100),
    IN p_correo VARCHAR(254),
    IN p_telefono VARCHAR(20),
    OUT p_id INT
)
BEGIN
    INSERT INTO cliente (
        nombre,
        contraseña,
        nombreUsuario,
        correo,
        telefono
    ) VALUES (
        
        p_nombre,
        p_contraseña,
        p_nombreUsuario,
        p_correo,
        p_telefono
    );
    
    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarCupon
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarCupon`(
    IN p_codigo VARCHAR(50),
    IN p_descuento DECIMAL(5,2),
    IN p_fechaCaducidad DATETIME,
    IN p_activo TINYINT,
    IN p_usosRestantes INT,
    OUT p_id INT
)
BEGIN
    INSERT INTO cupon (
        codigo,
        descuento,
        fechaCaducidad,
        activo,
        usosRestantes
    ) VALUES (
        p_codigo,
        p_descuento,
        p_fechaCaducidad,
        p_activo,
        p_usosRestantes
    );
    
    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarDescuento
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarDescuento`(
    IN p_tipo VARCHAR(10),           -- 'ARTICULO' o 'LIBRO'
    IN p_idReferencia INT,           -- idArticulo o idLibro según corresponda
    IN p_valorDescuento DECIMAL(10,2),
    IN p_fechaCaducidad DATETIME,
    IN p_activo TINYINT,
    OUT p_id INT
)
BEGIN
    IF p_tipo = 'ARTICULO' THEN
        INSERT INTO descuento_articulo (valorDescuento, fechaCaducidad, activo, ARTICULO_idArticulo)
        VALUES (p_valorDescuento, p_fechaCaducidad, p_activo, p_idReferencia);
        SET p_id = LAST_INSERT_ID();
    ELSEIF p_tipo = 'LIBRO' THEN
        INSERT INTO descuento_libro (valorDescuento, fechaCaducidad, activo, LIBRO_idLibro)
        VALUES (p_valorDescuento, p_fechaCaducidad, p_activo, p_idReferencia);
        SET p_id = LAST_INSERT_ID();
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser ARTICULO o LIBRO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarDocumentoVenta
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarDocumentoVenta`(
    IN p_idOrdenCompra INT,
    OUT p_id INT
)
BEGIN
    INSERT INTO documento_venta (
        ORDEN_COMPRA_idOrdenCompra
    ) VALUES (
        p_idOrdenCompra
    );
    
    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarEditorial
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarEditorial`(
    IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(255),
    IN p_telefono VARCHAR(20),
    IN p_cif VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_sitioWeb VARCHAR(100),
    OUT p_id INT
)
BEGIN
    INSERT INTO editorial (
        nombre,
        direccion,
        telefono,
        cif,
        email,
        sitioWeb
    ) VALUES (
        p_nombre,
        p_direccion,
        p_telefono,
        p_cif,
        p_email,
        p_sitioWeb
    );
    
    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarEditorialSiNoExiste
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarEditorialSiNoExiste`(
    IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(255),
    IN p_telefono VARCHAR(20),
    IN p_cif VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_sitioWeb VARCHAR(100),
    OUT p_id INT
)
BEGIN
    DECLARE v_idExistente INT;

    -- Buscar si ya existe una editorial con los mismos datos
    SELECT idEditorial INTO v_idExistente
    FROM editorial
    WHERE cif = p_cif
    LIMIT 1;

    -- Si existe, devolver su id
    IF v_idExistente IS NOT NULL THEN
        SET p_id = v_idExistente;
    ELSE
        -- Si no existe, insertar nueva editorial
        INSERT INTO editorial (
            nombre,
            direccion,
            telefono,
            cif,
            email,
            sitioWeb
        ) VALUES (
            p_nombre,
            p_direccion,
            p_telefono,
            p_cif,
            p_email,
            p_sitioWeb
        );

        -- Devolver el id generado
        SET p_id = LAST_INSERT_ID();
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarEmpleado
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarEmpleado`(
    
    IN  p_nombre        VARCHAR(100),
    IN  p_contraseña    VARCHAR(200),
    IN  p_nombreUsuario VARCHAR(100),
    IN  p_correo        VARCHAR(254),
    IN  p_telefono      VARCHAR(20),
    IN  p_activo        TINYINT,
    IN  p_sueldo        DECIMAL(10,2),
    IN  p_idRol         INT,
    OUT p_id    INT
)
BEGIN
    INSERT INTO empleado (
		nombre, 
		contraseña, 
		nombreUsuario, 
		correo, 
		telefono, 
		activo, 
		sueldo, 
		ROL_idRol
    ) VALUES (
		p_nombre, 
		p_contraseña, 
		p_nombreUsuario, 
		p_correo, 
		p_telefono, 
		p_activo, 
		p_sueldo, 
		p_idRol
    );

    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarLibro
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarLibro`(
    IN p_precio DECIMAL(10,2),
    IN p_precioDescuento DECIMAL(10,2),
    IN p_stockReal INT,
    IN p_stockVirtual INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(500),
    IN p_isbn VARCHAR(13),
    IN p_generoLibro ENUM('NOVELA', 'NARRATIVO', 'DRAMA', 'FANTASIA', 'AVENTURA', 'CIENCIA_FICCION'),
    IN p_fechaPublicacion DATETIME,
    IN p_formato ENUM('TAPA_DURA', 'TAPA_BLANDA', 'COLECCIONISTA'),
    IN p_sinopsis VARCHAR(1000),
    IN p_idEditorial INT,
    IN p_imagenURL VARCHAR(500),
    OUT p_id INT
)
BEGIN
    INSERT INTO libro (
        precio,
        precioDescuento,
        stockReal,
        stockVirtual,
        nombre,
        descripcion,
        isbn,
        generoLibro,
        fechaPublicacion,
        formato,
        sinopsis,
        EDITORIAL_idEditorial,
        imagenURL
    ) VALUES (
        p_precio,
        p_precioDescuento,
        p_stockReal,
        p_stockVirtual,
        p_nombre,
        p_descripcion,
        p_isbn,
        p_generoLibro,
        p_fechaPublicacion,
        p_formato,
        p_sinopsis,
        p_idEditorial,
        p_imagenURL
    );
    
    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarLineaCarrito
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarLineaCarrito`(
    IN p_tipo VARCHAR(10),           -- 'ARTICULO' o 'LIBRO'
    IN p_cantidad INT,
    IN p_precioUnitario DECIMAL(10,2),
    IN p_subtotal DECIMAL(10,2),
    IN p_precioConDescuento DECIMAL(10,2),
    IN p_subtotalConDescuento DECIMAL(10,2),
    IN p_idCarrito INT,
    IN p_idReferencia INT,           -- idArticulo o idLibro según corresponda
    OUT p_id INT
)
BEGIN
    IF p_tipo = 'ARTICULO' THEN
        INSERT INTO linea_carrito_articulo(
            cantidad,
            precioUnitario,
            subtotal,
            precioConDescuento,
            subtotalConDescuento,
            CARRITO_idCarrito,
            articulo_idArticulo
        )
        VALUES (
            p_cantidad,
            p_precioUnitario,
            p_subtotal,
            p_precioConDescuento,
            p_subtotalConDescuento,
            p_idCarrito,
            p_idReferencia
        );
        SET p_id = LAST_INSERT_ID();
        
    ELSEIF p_tipo = 'LIBRO' THEN
        INSERT INTO linea_carrito_libro(
            cantidad,
            precioUnitario,
            subtotal,
            precioConDescuento,
            subtotalConDescuento,
            CARRITO_idCarrito,
            libro_idLibro
        )
        VALUES (
            p_cantidad,
            p_precioUnitario,
            p_subtotal,
            p_precioConDescuento,
            p_subtotalConDescuento,
            p_idCarrito,
            p_idReferencia
        );
        SET p_id = LAST_INSERT_ID();
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser ARTICULO o LIBRO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarOrdenCompra
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarOrdenCompra`(
    IN p_fechaLimitePago DATETIME,
    IN p_total DECIMAL(10,2),
    IN p_totalConDescuento DECIMAL(10,2),
    IN p_estado VARCHAR(20),
    IN p_idCarrito INT,
    IN p_idCliente INT,
    OUT p_id INT
)
BEGIN
    -- Validar estado
    IF p_estado NOT IN ('NO_PAGADO', 'PAGADO', 'ENTREGADO') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estado inválido. Valores permitidos: NO_PAGADO, PAGADO, ENTREGADO';
    END IF;

    -- Verificar que no exista ya una orden para el carrito
    IF EXISTS (SELECT 1 FROM orden_compra WHERE CARRITO_idCarrito = p_idCarrito) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El carrito ya tiene una orden asociada';
    END IF;

    INSERT INTO orden_compra (
        fechaLimitePago,
        total,
        totalConDescuento,
        estado,
        CARRITO_idCarrito,
        CLIENTE_idCliente
    ) VALUES (
        p_fechaLimitePago,
        p_total,
        p_totalConDescuento,
        p_estado,
        p_idCarrito,
        p_idCliente
    );

    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarPermiso
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarPermiso`(
    IN p_nombre VARCHAR(45),
    IN p_descripcion VARCHAR(255),
    OUT p_id INT
)
BEGIN
    INSERT INTO permiso (
        nombre,
        descripcion
    ) VALUES (
        p_nombre,
        p_descripcion
    );
    
    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarReseña
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarReseña`(
    IN p_tipo VARCHAR(10),
    IN p_calificacion INT,
    IN p_reseña VARCHAR(500),
    IN p_idReferencia INT,
    IN p_idCliente INT,
    OUT p_id INT
)
BEGIN
    IF p_tipo = 'LIBRO' THEN
        INSERT INTO reseña_libro (calificacion, reseña, LIBRO_idLibro, cliente_idCliente)
        VALUES (p_calificacion, p_reseña, p_idReferencia, p_idCliente);
        SET p_id = LAST_INSERT_ID();
        
    ELSEIF p_tipo = 'ARTICULO' THEN
        INSERT INTO reseña_articulo (calificacion, reseña, ARTICULO_idArticulo, cliente_idCliente)
        VALUES (p_calificacion, p_reseña, p_idReferencia, p_idCliente);
        SET p_id = LAST_INSERT_ID();
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser LIBRO o ARTICULO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insertarRol
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `insertarRol`(
    IN p_nombre VARCHAR(45),
    IN p_descripcion VARCHAR(255),
    OUT p_id INT
)
BEGIN
    INSERT INTO rol (
        nombre,
        descripcion
    ) VALUES (
        p_nombre,
        p_descripcion
    );
    
    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarArticulos
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarArticulos`()
BEGIN
    SELECT * FROM articulo;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarAutores
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarAutores`()
BEGIN
    SELECT * FROM autor;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarCarritos
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarCarritos`()
BEGIN
    SELECT * FROM carrito;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarClientes
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarClientes`()
BEGIN
    SELECT * FROM cliente;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarCupones
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarCupones`()
BEGIN
    SELECT * FROM cupon;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarDescuentos
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarDescuentos`(
    IN p_tipo VARCHAR(10)
)
BEGIN
    IF p_tipo = 'ARTICULO' THEN
        SELECT 
            da.idDescuentoArticulo AS idDescuento,
            da.valorDescuento,
            da.fechaCaducidad,
            da.activo,
            'ARTICULO' AS tipoProducto,
            a.idArticulo
        FROM descuento_articulo da
        INNER JOIN articulo a ON da.ARTICULO_idArticulo = a.idArticulo;
        
    ELSEIF p_tipo = 'LIBRO' THEN
        SELECT 
            dl.idDescuentoLibro AS idDescuento,
            dl.valorDescuento,
            dl.fechaCaducidad,
            dl.activo,
            'LIBRO' AS tipoProducto,
            l.idLibro
        FROM descuento_libro dl
        INNER JOIN libro l ON dl.LIBRO_idLibro = l.idLibro;
        
    ELSEIF p_tipo IS NULL OR p_tipo = 'TODOS' THEN
        SELECT 
            da.idDescuentoArticulo AS idDescuento,
            da.valorDescuento,
            da.fechaCaducidad,
            da.activo,
            'ARTICULO' AS tipoProducto,
            a.idArticulo
        FROM descuento_articulo da
        INNER JOIN articulo a ON da.ARTICULO_idArticulo = a.idArticulo
        
        UNION ALL
        
        SELECT 
            dl.idDescuentoLibro AS idDescuento,
            dl.valorDescuento,
            dl.fechaCaducidad,
            dl.activo,
            'LIBRO' AS tipoProducto,
            l.idLibro
        FROM descuento_libro dl
        INNER JOIN libro l ON dl.LIBRO_idLibro = l.idLibro;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser ARTICULO, LIBRO o NULL/TODOS';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarDocumentosVenta
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarDocumentosVenta`()
BEGIN
    SELECT 
        idDocumentoVenta,
        fechaEmision,
        ORDEN_COMPRA_idOrdenCompra
    FROM documento_venta;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarEditoriales
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarEditoriales`()
BEGIN
    SELECT * FROM editorial;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarEmpleados
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarEmpleados`()
BEGIN
    SELECT * FROM empleado;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarLibros
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarLibros`()
BEGIN
    SELECT * FROM libro;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarLineasCarrito
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarLineasCarrito`(
    IN p_tipo VARCHAR(10)
)
BEGIN
    IF p_tipo = 'ARTICULO' THEN
        SELECT 
            lca.idLineaCarrito,
            lca.cantidad,
            lca.precioUnitario,
            lca.subtotal,
            lca.precioConDescuento,
            lca.subtotalConDescuento,
            lca.CARRITO_idCarrito,
            'ARTICULO' AS tipoProducto,
            lca.articulo_idArticulo AS idArticulo
        FROM linea_carrito_articulo lca;
        
    ELSEIF p_tipo = 'LIBRO' THEN
        SELECT 
            lcl.idLineaCarrito,
            lcl.cantidad,
            lcl.precioUnitario,
            lcl.subtotal,
            lcl.precioConDescuento,
            lcl.subtotalConDescuento,
            lcl.CARRITO_idCarrito,
            'LIBRO' AS tipoProducto,
            lcl.libro_idLibro AS idLibro
        FROM linea_carrito_libro lcl;
        
    ELSEIF p_tipo IS NULL OR p_tipo = 'TODOS' THEN
        -- Todas las líneas (artículos y libros)
        SELECT 
            lca.idLineaCarrito,
            lca.cantidad,
            lca.precioUnitario,
            lca.subtotal,
            lca.precioConDescuento,
            lca.subtotalConDescuento,
            lca.CARRITO_idCarrito,
            'ARTICULO' AS tipoProducto,
            lca.articulo_idArticulo AS idArticulo,
            NULL AS idLibro
        FROM linea_carrito_articulo lca
        
        UNION ALL
        
        SELECT 
            lcl.idLineaCarrito,
            lcl.cantidad,
            lcl.precioUnitario,
            lcl.subtotal,
            lcl.precioConDescuento,
            lcl.subtotalConDescuento,
            lcl.CARRITO_idCarrito,
            'LIBRO' AS tipoProducto,
            NULL AS idArticulo,
            lcl.libro_idLibro AS idLibro
        FROM linea_carrito_libro lcl;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser ARTICULO, LIBRO o NULL/TODOS';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarLineasPorCarrito
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarLineasPorCarrito`(IN p_idCarrito INT)
BEGIN
    SELECT 
        idLineaCarrito,
        cantidad,
        precioUnitario,
        subtotal,
        precioConDescuento,
        subtotalConDescuento,
        CARRITO_idCarrito,
        articulo_idArticulo AS producto,
        'ARTICULO' AS tipo
    FROM linea_carrito_articulo
    WHERE CARRITO_idCarrito = p_idCarrito

    UNION ALL

    SELECT 
        idLineaCarrito,
        cantidad,
        precioUnitario,
        subtotal,
        precioConDescuento,
        subtotalConDescuento,
        CARRITO_idCarrito,
        libro_idLibro AS producto,
        'LIBRO' AS tipo
    FROM linea_carrito_libro
    WHERE CARRITO_idCarrito = p_idCarrito;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarOrdenesCompra
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarOrdenesCompra`()
BEGIN
    SELECT * FROM orden_compra;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarOrdenesPorCliente
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarOrdenesPorCliente`(IN p_idCliente INT)
BEGIN
    SELECT * FROM orden_compra 
    WHERE CLIENTE_idCliente = p_idCliente
    ORDER BY fechaCreacion DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarPermisos
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarPermisos`()
BEGIN
    SELECT * FROM permiso;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarReseñas
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarReseñas`(
    IN p_tipo VARCHAR(10)
)
BEGIN
    IF p_tipo = 'LIBRO' THEN
        SELECT 
            rl.idReseñaLibro AS idReseña,
            rl.calificacion,
            rl.reseña,
            'LIBRO' AS tipoProducto,
            rl.LIBRO_idLibro AS idLibro,
            rl.cliente_idCliente AS idCliente
        FROM reseña_libro rl;
        
    ELSEIF p_tipo = 'ARTICULO' THEN
        SELECT 
            ra.idReseñaArticulo AS idReseña,
            ra.calificacion,
            ra.reseña,
            'ARTICULO' AS tipoProducto,
            ra.ARTICULO_idArticulo AS idArticulo,
            ra.cliente_idCliente AS idCliente
        FROM reseña_articulo ra;
        
    ELSEIF p_tipo IS NULL OR p_tipo = 'TODOS' THEN
        SELECT 
            rl.idReseñaLibro AS idReseña,
            rl.calificacion,
            rl.reseña,
            'LIBRO' AS tipoProducto,
            rl.LIBRO_idLibro AS idLibro,
            NULL AS idArticulo,
            rl.cliente_idCliente AS idCliente
        FROM reseña_libro rl
        
        UNION ALL
        
        SELECT 
            ra.idReseñaArticulo AS idReseña,
            ra.calificacion,
            ra.reseña,
            'ARTICULO' AS tipoProducto,
            NULL AS idLibro,
            ra.ARTICULO_idArticulo AS idArticulo,
            ra.cliente_idCliente AS idCliente
        FROM reseña_articulo ra;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser LIBRO, ARTICULO o NULL/TODOS';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarRoles
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarRoles`()
BEGIN
    SELECT * FROM rol;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure loginCliente
-- -----------------------------------------------------
/*
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `loginCliente`(
    IN p_correo VARCHAR(254),
    IN p_contraseña VARCHAR(200),
    OUT p_valido BOOLEAN
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_count
    FROM cliente
    WHERE correo = p_correo
      AND contraseña = p_contraseña;

    IF v_count > 0 THEN
        SET p_valido = TRUE;
    ELSE
        SET p_valido = FALSE;
    END IF;

    IF p_valido = FALSE THEN


END$$

DELIMITER ;
*/

DELIMITER $$

CREATE DEFINER=`root`@`%` PROCEDURE `loginUsuario`(
    IN p_correo VARCHAR(254),
    IN p_contraseña VARCHAR(200),
    OUT p_tipoUsuario VARCHAR(20)
)
proc:BEGIN
    DECLARE v_count INT DEFAULT 0;

    -- ==============================
    -- 1. BUSCAR EN CLIENTE
    -- ==============================
    SELECT COUNT(*) INTO v_count
    FROM cliente
    WHERE correo = p_correo
      AND contraseña = p_contraseña;

    IF v_count = 1 THEN
        SET p_tipoUsuario = 'CLIENTE';
        LEAVE proc;
    END IF;


    -- ==============================
    -- 2. BUSCAR EN EMPLEADO
    -- ==============================
    SELECT COUNT(*) INTO v_count
    FROM empleado
    WHERE correo = p_correo
      AND contraseña = p_contraseña;

    IF v_count = 1 THEN
        SET p_tipoUsuario = 'EMPLEADO';
        LEAVE proc;
    END IF;


    -- ==============================
    -- 3. USUARIO NO ENCONTRADO
    -- ==============================
    SET p_tipoUsuario = 'INVALIDO';

END proc $$

DELIMITER ;


-- -----------------------------------------------------
-- procedure modificarArticulo
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarArticulo`(
    IN p_nombre           VARCHAR(100),
    IN p_descripcion      VARCHAR(500),
    IN p_precio           DECIMAL(10,2),
    IN p_precioDescuento  DECIMAL(10,2),
    IN p_stockReal        INT,
    IN p_stockVirtual     INT,
    IN p_tipoArticulo     VARCHAR(45),
    IN p_imagenURL        VARCHAR(500),
    IN p_id       INT
)
BEGIN
    UPDATE articulo
       SET nombre          = p_nombre,
           descripcion     = p_descripcion,
           precio          = p_precio,
           precioDescuento = p_precioDescuento,
           stockReal       = p_stockReal,
           stockVirtual    = p_stockVirtual,
           tipoArticulo    = p_tipoArticulo,
           imagenURL    = p_imagenURL
     WHERE idArticulo = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarAutor
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarAutor`(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_alias VARCHAR(45)
)
BEGIN
    UPDATE autor
    SET 
        nombre = p_nombre,
        apellidos = p_apellidos,
        alias = p_alias
    WHERE idAutor = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarCarrito
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarCarrito`(
    IN p_id INT,
    IN p_completado TINYINT,
    IN p_idCupon INT,
    IN p_idCliente INT
)
BEGIN
    UPDATE carrito
    SET 
        completado = p_completado,
        CUPON_idCupon = p_idCupon,
        CLIENTE_idCliente = p_idCliente
    WHERE idCarrito = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarCliente
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarCliente`(
   
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_contraseña VARCHAR(200),
    IN p_nombreUsuario VARCHAR(100),
    IN p_correo VARCHAR(254),
    IN p_telefono VARCHAR(20)
)
BEGIN
    UPDATE cliente
    SET 
        nombre = p_nombre,
        contraseña = p_contraseña,
        nombreUsuario = p_nombreUsuario,
        correo = p_correo,
        telefono = p_telefono
    WHERE idCliente = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarCupon
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarCupon`(
    IN p_id INT,
    IN p_codigo VARCHAR(50),
    IN p_descuento DECIMAL(5,2),
    IN p_fechaCaducidad DATETIME,
    IN p_activo TINYINT,
    IN p_usosRestantes INT
)
BEGIN
    UPDATE cupon
    SET 
        codigo = p_codigo,
        descuento = p_descuento,
        fechaCaducidad = p_fechaCaducidad,
        activo = p_activo,
        usosRestantes = p_usosRestantes
    WHERE idCupon = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarDescuento
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarDescuento`(
    IN p_tipo VARCHAR(10),
    IN p_id INT,
    IN p_valorDescuento DECIMAL(10,2),
    IN p_fechaCaducidad DATETIME,
    IN p_activo TINYINT
)
BEGIN
    IF p_tipo = 'ARTICULO' THEN
        UPDATE descuento_articulo
        SET valorDescuento = p_valorDescuento,
            fechaCaducidad = p_fechaCaducidad,
            activo = p_activo
        WHERE idDescuentoArticulo = p_id;
    ELSEIF p_tipo = 'LIBRO' THEN
        UPDATE descuento_libro
        SET valorDescuento = p_valorDescuento,
            fechaCaducidad = p_fechaCaducidad,
            activo = p_activo
        WHERE idDescuentoLibro = p_id;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser ARTICULO o LIBRO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarDocumentoVenta
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarDocumentoVenta`(
    IN p_id INT,
    IN p_idOrdenCompra INT
)
BEGIN
    UPDATE documento_venta
    SET 
        ORDEN_COMPRA_idOrdenCompra = p_idOrdenCompra
    WHERE idDocumentoVenta = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarEditorial
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarEditorial`(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(255),
    IN p_telefono VARCHAR(20),
    IN p_cif VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_sitioWeb VARCHAR(100)
)
BEGIN
    UPDATE editorial
    SET 
        nombre = p_nombre,
        direccion = p_direccion,
        telefono = p_telefono,
        cif = p_cif,
        email = p_email,
        sitioWeb = p_sitioWeb
    WHERE idEditorial = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarEmpleado
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarEmpleado`(
    IN p_id    INT,
    IN p_nombre        VARCHAR(100),
    IN p_contraseña    VARCHAR(200),
    IN p_nombreUsuario VARCHAR(100),
    IN p_correo        VARCHAR(254),
    IN p_telefono      VARCHAR(20),
    IN p_activo        TINYINT,
    IN p_sueldo        DECIMAL(10,2),
    IN p_idRol         INT
)
BEGIN
    UPDATE empleado
       SET nombre        = p_nombre,
           contraseña    = p_contraseña,
           nombreUsuario = p_nombreUsuario,
           correo        = p_correo,
           telefono      = p_telefono,
           activo        = p_activo,
           sueldo        = p_sueldo,
           ROL_idRol     = p_idRol
     WHERE idEmpleado    = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarLibro
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarLibro`(
    IN p_id INT,
    IN p_precio DECIMAL(10,2),
    IN p_precioDescuento DECIMAL(10,2),
    IN p_stockReal INT,
    IN p_stockVirtual INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(500),
    IN p_isbn VARCHAR(13),
    IN p_generoLibro ENUM('NOVELA', 'NARRATIVO', 'DRAMA', 'FANTASIA', 'AVENTURA', 'CIENCIA_FICCION'),
    IN p_fechaPublicacion DATETIME,
    IN p_formato ENUM('TAPA_DURA', 'TAPA_BLANDA', 'COLECCIONISTA'),
    IN p_sinopsis VARCHAR(1000),
    IN p_idEditorial INT,
    IN p_imagenURL VARCHAR(500)
)
BEGIN
    UPDATE libro
    SET 
        precio = p_precio,
        precioDescuento = p_precioDescuento,
        stockReal = p_stockReal,
        stockVirtual = p_stockVirtual,
        nombre = p_nombre,
        descripcion = p_descripcion,
        isbn = p_isbn,
        generoLibro = p_generoLibro,
        fechaPublicacion = p_fechaPublicacion,
        formato = p_formato,
        sinopsis = p_sinopsis,
        EDITORIAL_idEditorial = p_idEditorial,
        imagenURL = p_imagenURL
    WHERE idLibro = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarLineaCarrito
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarLineaCarrito`(
    IN p_tipo VARCHAR(10),
    IN p_id INT,
    IN p_cantidad INT,
    IN p_precioUnitario DECIMAL(10,2),
    IN p_subtotal DECIMAL(10,2),
    IN p_precioConDescuento DECIMAL(10,2),
    IN p_subtotalConDescuento DECIMAL(10,2)
)
BEGIN
    IF p_tipo = 'ARTICULO' THEN
        UPDATE linea_carrito_articulo
        SET 
            cantidad = p_cantidad,
            precioUnitario = p_precioUnitario,
            subtotal = p_subtotal,
            precioConDescuento = p_precioConDescuento,
            subtotalConDescuento = p_subtotalConDescuento
        WHERE idLineaCarrito = p_id;
        
    ELSEIF p_tipo = 'LIBRO' THEN
        UPDATE linea_carrito_libro
        SET 
            cantidad = p_cantidad,
            precioUnitario = p_precioUnitario,
            subtotal = p_subtotal,
            precioConDescuento = p_precioConDescuento,
            subtotalConDescuento = p_subtotalConDescuento
        WHERE idLineaCarrito = p_id;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser ARTICULO o LIBRO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarOrdenCompra
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarOrdenCompra`(
    IN p_id INT,
    IN p_fechaLimitePago DATETIME,
    IN p_total DECIMAL(10,2),
    IN p_totalConDescuento DECIMAL(10,2),
    IN p_estado VARCHAR(20),
    IN p_idCliente INT
)
BEGIN
    -- Validar estado
    IF p_estado NOT IN ('NO_PAGADO', 'PAGADO', 'ENTREGADO', 'CANCELADO') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estado inválido. Valores permitidos: NO_PAGADO, PAGADO, ENTREGADO, CANCELADO';
    END IF;

    UPDATE orden_compra
    SET 
        fechaLimitePago = p_fechaLimitePago,
        total = p_total,
        totalConDescuento = p_totalConDescuento,
        estado = p_estado,
        CLIENTE_idCliente = p_idCliente
    WHERE idOrdenCompra = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarPermiso
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarPermiso`(
    IN p_id INT,
    IN p_nombre VARCHAR(45),
    IN p_descripcion VARCHAR(255)
)
BEGIN
    UPDATE permiso
    SET 
        nombre = p_nombre,
        descripcion = p_descripcion
    WHERE idPermiso = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarReseña
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarReseña`(
    IN p_tipo VARCHAR(10),
    IN p_id INT,
    IN p_calificacion INT,
    IN p_reseña VARCHAR(500)
)
BEGIN
    IF p_tipo = 'LIBRO' THEN
        UPDATE reseña_libro
        SET calificacion = p_calificacion,
            reseña = p_reseña
        WHERE idReseñaLibro = p_id;

    ELSEIF p_tipo = 'ARTICULO' THEN
        UPDATE reseña_articulo
        SET calificacion = p_calificacion,
            reseña = p_reseña
        WHERE idReseñaArticulo = p_id;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser LIBRO o ARTICULO';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarRol
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `modificarRol`(
    IN p_id INT,
    IN p_nombre VARCHAR(45),
    IN p_descripcion VARCHAR(255)
)
BEGIN
    UPDATE rol
    SET 
        nombre = p_nombre,
        descripcion = p_descripcion
    WHERE idRol = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure obtenerDescuentoPorProducto
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `obtenerDescuentoPorProducto`(
    IN p_idProducto INT,
    IN p_tipo VARCHAR(10)
)
BEGIN
    IF p_tipo = 'ARTICULO' THEN
        SELECT 
            da.idDescuentoArticulo AS idDescuento,
            da.valorDescuento,
            da.fechaCaducidad,
            da.activo,
            'ARTICULO' AS tipoProducto,
            da.ARTICULO_idArticulo AS idArticulo
        FROM descuento_articulo da
        WHERE da.ARTICULO_idArticulo = p_idProducto
          AND da.activo = TRUE
          AND da.fechaCaducidad >= NOW();

    ELSEIF p_tipo = 'LIBRO' THEN
        SELECT 
            dl.idDescuentoLibro AS idDescuento,
            dl.valorDescuento,
            dl.fechaCaducidad,
            dl.activo,
            'LIBRO' AS tipoProducto,
            dl.LIBRO_idLibro AS idLibro
        FROM descuento_libro dl
        WHERE dl.LIBRO_idLibro = p_idProducto
          AND dl.activo = TRUE
          AND dl.fechaCaducidad >= NOW();

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser ARTICULO o LIBRO';
    END IF;
END$$

DELIMITER ;



-- -----------------------------------------------------
-- procedure contarProductosCarrito
-- -----------------------------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `contarProductosCarrito`(
    IN p_idCarrito INT
)
BEGIN
    SELECT 
        IFNULL(
            (SELECT SUM(cantidad) FROM linea_carrito_articulo WHERE CARRITO_idCarrito = p_idCarrito), 0
        ) + 
        IFNULL(
            (SELECT SUM(cantidad) FROM linea_carrito_libro WHERE CARRITO_idCarrito = p_idCarrito), 0
        ) AS totalProductos;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarArticulosCarrito
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarArticulosCarrito`(
    IN p_idCarrito INT
)
BEGIN
    SELECT 
        lca.idLineaCarrito,
        lca.cantidad,
        lca.precioUnitario,
        lca.subtotal,
        lca.precioConDescuento,
        lca.subtotalConDescuento,
        lca.CARRITO_idCarrito,
        lca.articulo_idArticulo,
        a.nombre AS nombreArticulo,
        a.tipoArticulo,
        a.imagenURL,
        a.stock,
        a.precio AS precioActual
    FROM linea_carrito_articulo lca
    INNER JOIN articulo a ON lca.articulo_idArticulo = a.idArticulo
    WHERE lca.CARRITO_idCarrito = p_idCarrito;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarLibrosCarrito
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarLibrosCarrito`(
    IN p_idCarrito INT
)
BEGIN
    SELECT 
        lcl.idLineaCarrito,
        lcl.cantidad,
        lcl.precioUnitario,
        lcl.subtotal,
        lcl.precioConDescuento,
        lcl.subtotalConDescuento,
        lcl.CARRITO_idCarrito,
        lcl.libro_idLibro,
        l.nombre AS nombreLibro,
        l.sinopsis,
        l.fechaPublicacion,
        l.generoLibro,
        l.numeroPaginas,
        l.imagenURL,
        l.stock,
        l.precio AS precioActual
    FROM linea_carrito_libro lcl
    INNER JOIN libro l ON lcl.libro_idLibro = l.idLibro
    WHERE lcl.CARRITO_idCarrito = p_idCarrito;
END$$

DELIMITER ;
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- procedure obtenerCarritoPorCliente
-- -----------------------------------------------------

DELIMITER $$
CREATE PROCEDURE obtenerCarritoPorCliente(
	IN p_idCliente INT
)
BEGIN
    SELECT *
    FROM carrito 
    WHERE CLIENTE_idCliente = p_idCliente
    ORDER BY completado ASC, fechaCreacion DESC, idCarrito DESC
    LIMIT 1;
END$$

DELIMITER ;
-- ============================================================
-- PASO 1 Crear el procedimiento almacenado (si no existe)
-- ============================================================

DROP PROCEDURE IF EXISTS `cancelarOrdenesExpiradas`;

DELIMITER $$

CREATE PROCEDURE `cancelarOrdenesExpiradas`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_idOrden INT;
    DECLARE v_idCarrito INT;
    DECLARE v_idArticulo INT;
    DECLARE v_idLibro INT;
    DECLARE v_cantidad INT;
    
    -- Cursor para obtener las órdenes que se van a cancelar
    DECLARE cur_ordenes CURSOR FOR
        SELECT oc.idOrdenCompra, oc.CARRITO_idCarrito
        FROM orden_compra oc
        WHERE oc.estado = 'NO_PAGADO'
          AND oc.fechaLimitePago < NOW();
    
    -- Cursor para obtener las líneas de artículos del carrito
    DECLARE cur_articulos CURSOR FOR
        SELECT lca.articulo_idArticulo, lca.cantidad
        FROM linea_carrito_articulo lca
        WHERE lca.CARRITO_idCarrito = v_idCarrito;
    
    -- Cursor para obtener las líneas de libros del carrito
    DECLARE cur_libros CURSOR FOR
        SELECT lcl.libro_idLibro, lcl.cantidad
        FROM linea_carrito_libro lcl
        WHERE lcl.CARRITO_idCarrito = v_idCarrito;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Iniciar transacción
    START TRANSACTION;
    
    -- Abrir cursor de órdenes
    OPEN cur_ordenes;
    
    read_ordenes: LOOP
        FETCH cur_ordenes INTO v_idOrden, v_idCarrito;
        IF done THEN
            LEAVE read_ordenes;
        END IF;
        
        -- Restaurar stock virtual de ARTÍCULOS
        SET done = FALSE;
        OPEN cur_articulos;
        
        read_articulos: LOOP
            FETCH cur_articulos INTO v_idArticulo, v_cantidad;
            IF done THEN
                LEAVE read_articulos;
            END IF;
            
            -- Restaurar el stock virtual del artículo
            UPDATE articulo
            SET stockVirtual = stockVirtual + v_cantidad
            WHERE idArticulo = v_idArticulo;
        END LOOP;
        
        CLOSE cur_articulos;
        SET done = FALSE;
        
        -- Restaurar stock virtual de LIBROS
        OPEN cur_libros;
        
        read_libros: LOOP
            FETCH cur_libros INTO v_idLibro, v_cantidad;
            IF done THEN
                LEAVE read_libros;
            END IF;
            
            -- Restaurar el stock virtual del libro
            UPDATE libro
            SET stockVirtual = stockVirtual + v_cantidad
            WHERE idLibro = v_idLibro;
        END LOOP;
        
        CLOSE cur_libros;
        SET done = FALSE;
        
    END LOOP;
    
    CLOSE cur_ordenes;
    
    -- Contar cuántas órdenes se van a cancelar antes de actualizarlas
    SELECT COUNT(*) INTO @ordenes_canceladas
    FROM orden_compra
    WHERE estado = 'NO_PAGADO'
      AND fechaLimitePago < NOW();
    
    -- Ahora sí, cancelar las órdenes
    UPDATE orden_compra
    SET estado = 'CANCELADO'
    WHERE estado = 'NO_PAGADO'
      AND fechaLimitePago < NOW();
    
    -- Confirmar transacción
    COMMIT;
    
    -- Retornar cantidad de órdenes canceladas
    SELECT @ordenes_canceladas AS ordenesCanceladas;
END$$

DELIMITER ;

-- ============================================================
-- PASO 2: Crear el evento programado
-- ============================================================

-- Eliminar el evento si ya existe
DROP EVENT IF EXISTS `event_cancelar_ordenes_expiradas`;

DELIMITER $$

CREATE EVENT `event_cancelar_ordenes_expiradas`
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Cancela automáticamente las órdenes expiradas cada hora'
DO
BEGIN
    -- Llamar al procedimiento almacenado que cancela las órdenes expiradas
    CALL cancelarOrdenesExpiradas();
END$$

DELIMITER ;



-- -----------------------------------------------------
-- procedure buscarCuponPorCodigo
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS `buscarCuponPorCodigo`;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `buscarCuponPorCodigo`(
    IN p_codigo VARCHAR(50)
)
BEGIN
    SELECT * 
    FROM cupon 
    WHERE codigo = p_codigo 
      AND activo = 1 
      AND fechaCaducidad >= NOW()
      AND (usosRestantes IS NULL OR usosRestantes > 0);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure verificarCuponUsado
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS `verificarCuponUsado`;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `verificarCuponUsado`(
    IN p_idCupon INT,
    IN p_idCliente INT,
    OUT p_yaUsado TINYINT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_count
    FROM cupon_has_cliente
    WHERE cupon_idCupon = p_idCupon
      AND cliente_idCliente = p_idCliente;
    
    IF v_count > 0 THEN
        SET p_yaUsado = 1;
    ELSE
        SET p_yaUsado = 0;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aplicarCuponACarrito
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS `aplicarCuponACarrito`;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `aplicarCuponACarrito`(
    IN p_idCupon INT,
    IN p_idCliente INT,
    IN p_idCarrito INT,
    OUT p_resultado TINYINT,
    OUT p_mensaje VARCHAR(255)
)
proc:BEGIN
    DECLARE v_cuponExiste INT DEFAULT 0;
    DECLARE v_yaUsado INT DEFAULT 0;
    DECLARE v_cuponActivo TINYINT DEFAULT 0;
    DECLARE v_fechaValida TINYINT DEFAULT 0;
    DECLARE v_usosDisponibles INT DEFAULT 0;
    
    -- Verificar que el cupón existe y es válido
    SELECT COUNT(*), activo, 
           CASE WHEN fechaCaducidad >= NOW() THEN 1 ELSE 0 END,
           COALESCE(usosRestantes, -1)
    INTO v_cuponExiste, v_cuponActivo, v_fechaValida, v_usosDisponibles
    FROM cupon
    WHERE idCupon = p_idCupon;
    
    IF v_cuponExiste = 0 THEN
        SET p_resultado = 0;
        SET p_mensaje = 'El cupón no existe';
        LEAVE proc;
    END IF;
    
    IF v_cuponActivo = 0 THEN
        SET p_resultado = 0;
        SET p_mensaje = 'El cupón no está activo';
        LEAVE proc;
    END IF;
    
    IF v_fechaValida = 0 THEN
        SET p_resultado = 0;
        SET p_mensaje = 'El cupón ha expirado';
        LEAVE proc;
    END IF;
    
    IF v_usosDisponibles IS NOT NULL AND v_usosDisponibles = 0 THEN
        SET p_resultado = 0;
        SET p_mensaje = 'El cupón no tiene usos restantes';
        LEAVE proc;
    END IF;
    
    -- Verificar si el cliente ya usó este cupón
    SELECT COUNT(*) INTO v_yaUsado
    FROM cupon_has_cliente
    WHERE cupon_idCupon = p_idCupon
      AND cliente_idCliente = p_idCliente;
    
    IF v_yaUsado > 0 THEN
        SET p_resultado = 0;
        SET p_mensaje = 'Ya has usado este cupón anteriormente';
        LEAVE proc;
    END IF;
    
    -- Aplicar el cupón: insertar en cupon_has_cliente y actualizar el carrito
    START TRANSACTION;
    
    -- Insertar en cupon_has_cliente (marcar como usado)
    INSERT INTO cupon_has_cliente (cupon_idCupon, cliente_idCliente)
    VALUES (p_idCupon, p_idCliente)
    ON DUPLICATE KEY UPDATE cupon_idCupon = cupon_idCupon;
    
    -- Actualizar el carrito con el cupón
    UPDATE carrito
    SET CUPON_idCupon = p_idCupon
    WHERE idCarrito = p_idCarrito;
    
    -- Decrementar usos restantes si es necesario (solo si no es NULL)
    IF v_usosDisponibles > 0 AND v_usosDisponibles IS NOT NULL THEN
        UPDATE cupon
        SET usosRestantes = usosRestantes - 1
        WHERE idCupon = p_idCupon;
    END IF;
    
    COMMIT;
    
    SET p_resultado = 1;
    SET p_mensaje = 'Cupón aplicado correctamente';
    
END proc$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure listarReseñasPorProducto
-- Obtiene todas las reseñas de un producto específico (libro o artículo)
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS `listarReseñasPorProducto`;
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `listarReseñasPorProducto`(
    IN p_tipo VARCHAR(10),
    IN p_idProducto INT
)
BEGIN
    IF p_tipo = 'LIBRO' THEN
        SELECT 
            rl.idReseñaLibro AS idReseña,
            rl.calificacion,
            rl.reseña,
            'LIBRO' AS tipoProducto,
            rl.LIBRO_idLibro AS idLibro,
            NULL AS idArticulo,
            rl.cliente_idCliente AS idCliente,
            c.nombre AS nombreCliente,
            c.nombreUsuario AS nombreUsuarioCliente
        FROM reseña_libro rl
        INNER JOIN cliente c ON rl.cliente_idCliente = c.idCliente
        WHERE rl.LIBRO_idLibro = p_idProducto
        ORDER BY rl.idReseñaLibro DESC;
        
    ELSEIF p_tipo = 'ARTICULO' THEN
        SELECT 
            ra.idReseñaArticulo AS idReseña,
            ra.calificacion,
            ra.reseña,
            'ARTICULO' AS tipoProducto,
            NULL AS idLibro,
            ra.ARTICULO_idArticulo AS idArticulo,
            ra.cliente_idCliente AS idCliente,
            c.nombre AS nombreCliente,
            c.nombreUsuario AS nombreUsuarioCliente
        FROM reseña_articulo ra
        INNER JOIN cliente c ON ra.cliente_idCliente = c.idCliente
        WHERE ra.ARTICULO_idArticulo = p_idProducto
        ORDER BY ra.idReseñaArticulo DESC;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser LIBRO o ARTICULO';
    END IF;
END$$
DELIMITER ;
-- -----------------------------------------------------
-- procedure obtenerPromedioCalificacionProducto
-- Obtiene el promedio de calificaciones de un producto específico (libro o artículo)
-- Retorna el promedio (0-5) y el total de reseñas
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS `obtenerPromedioCalificacionProducto`;
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `obtenerPromedioCalificacionProducto`(
    IN p_tipo VARCHAR(10),
    IN p_idProducto INT,
    OUT p_promedio DECIMAL(3,2),
    OUT p_totalResenas INT
)
BEGIN
    IF p_tipo = 'LIBRO' THEN
        SELECT 
            COALESCE(AVG(rl.calificacion), 0) AS promedio,
            COUNT(rl.idReseñaLibro) AS totalResenas
        INTO p_promedio, p_totalResenas
        FROM reseña_libro rl
        WHERE rl.LIBRO_idLibro = p_idProducto;
        
    ELSEIF p_tipo = 'ARTICULO' THEN
        SELECT 
            COALESCE(AVG(ra.calificacion), 0) AS promedio,
            COUNT(ra.idReseñaArticulo) AS totalResenas
        INTO p_promedio, p_totalResenas
        FROM reseña_articulo ra
        WHERE ra.ARTICULO_idArticulo = p_idProducto;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo no válido: debe ser LIBRO o ARTICULO';
    END IF;
END$$
DELIMITER ;



-- Para verificar que el evento está activo:
-- SHOW EVENTS;

-- Para deshabilitar temporalmente el evento:
-- ALTER EVENT event_cancelar_ordenes_expiradas DISABLE;

-- Para habilitar el evento:
-- ALTER EVENT event_cancelar_ordenes_expiradas ENABLE;

-- Para eliminar el evento:
-- DROP EVENT IF EXISTS event_cancelar_ordenes_expiradas;

-- -----------------------------------------------------
-- procedure obtenerReseñasPorArticulo
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS `obtenerReseñasPorArticulo`;

DELIMITER //
CREATE PROCEDURE `obtenerReseñasPorArticulo`(
    IN p_idArticulo INT
)
BEGIN
    SELECT 
        ra.idReseñaArticulo AS idReseña,
        ra.calificacion,
        ra.reseña,
        ra.ARTICULO_idArticulo as idArticulo,
        c.idCliente,
		c.nombre AS clienteNombre,
		c.nombreUsuario AS clienteUsuario,
		c.correo AS clienteCorreo,
		c.telefono AS clienteTelefono
        
    FROM reseña_articulo ra
    INNER JOIN cliente c 
        ON ra.cliente_idCliente = c.idCliente
    WHERE ra.ARTICULO_idArticulo = p_idArticulo;
END//
DELIMITER ;

-- -----------------------------------------------------
-- procedure listarAutoresPorLibro
-- -----------------------------------------------------

DROP procedure IF EXISTS `listarAutoresPorLibro`;

DELIMITER $$

CREATE PROCEDURE listarAutoresPorLibro(
    IN p_idLibro INT
)
BEGIN
    SELECT 
        a.idAutor,
        a.nombre,
        a.apellidos,
        a.alias
    FROM autor a
    INNER JOIN libro_has_autor la 
        ON la.AUTOR_idAutor = a.idAutor
    WHERE la.LIBRO_idLibro = p_idLibro;
END $$

DELIMITER ;

-- -----------------------------------------------------
-- procedure obtenerReseñasPorLibro
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS `obtenerReseñasPorLibro`;

DELIMITER //
CREATE PROCEDURE `obtenerReseñasPorLibro`(
    IN p_idLibro INT
)
BEGIN
    SELECT 
        rl.idReseñaLibro AS idReseña,
        rl.calificacion,
        rl.reseña,
        rl.LIBRO_idLibro as idLibro,
        c.idCliente,
		c.nombre AS clienteNombre,
		c.nombreUsuario AS clienteUsuario,
		c.correo AS clienteCorreo,
		c.telefono AS clienteTelefono
        
    FROM reseña_libro rl
    INNER JOIN cliente c 
        ON rl.cliente_idCliente = c.idCliente
    WHERE rl.LIBRO_idLibro = p_idLibro;
END//
DELIMITER ;

-- -----------------------------------------------------
-- procedure obtenerCuponesPorCliente
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS `obtenerCuponesPorCliente`;

DELIMITER //
CREATE PROCEDURE `obtenerCuponesPorCliente`(
    IN p_idCliente INT
)
BEGIN
    SELECT 
        c.idCupon,
        c.codigo,
        c.descuento,
        c.fechaCaducidad,
        c.activo,
        c.usosRestantes
    FROM cupon c
    INNER JOIN cupon_has_cliente chc
        ON c.idCupon = chc.cupon_idCupon
    WHERE chc.cliente_idCliente = p_idCliente;
END//
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `actualizarAutoresLibro`(
    IN p_idLibro INT,
    IN p_idAutor INT
)
BEGIN
    -- Insertar la relación libro-autor (si no existe ya)
    INSERT IGNORE INTO libro_has_autor (LIBRO_idLibro, AUTOR_idAutor)
    VALUES (p_idLibro, p_idAutor);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `eliminarAutoresLibro`(
    IN p_idLibro INT
)
BEGIN
    -- Eliminar todas las relaciones de autores para este libro
    DELETE FROM libro_has_autor 
    WHERE LIBRO_idLibro = p_idLibro;
END$$
DELIMITER ;