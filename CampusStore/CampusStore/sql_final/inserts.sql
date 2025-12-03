-- ==========================================================
-- 1. LIMPIEZA (OPCIONAL: Solo si quieres reiniciar los IDs)
-- ==========================================================
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE linea_carrito_articulo;
TRUNCATE TABLE linea_carrito_libro;
TRUNCATE TABLE reseña_articulo;
TRUNCATE TABLE reseña_libro;
TRUNCATE TABLE documento_venta;
TRUNCATE TABLE orden_compra;
TRUNCATE TABLE carrito;
TRUNCATE TABLE cupon_has_cliente;
TRUNCATE TABLE descuento_articulo;
TRUNCATE TABLE descuento_libro;
TRUNCATE TABLE libro_has_autor;
TRUNCATE TABLE articulo;
TRUNCATE TABLE libro;
TRUNCATE TABLE autor;
TRUNCATE TABLE editorial;
TRUNCATE TABLE cliente;
TRUNCATE TABLE empleado;
TRUNCATE TABLE rol_has_permiso;
TRUNCATE TABLE permiso;
TRUNCATE TABLE rol;
TRUNCATE TABLE cupon;
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- 2. DATOS MAESTROS (Roles, Permisos, Staff)
-- =============================================

INSERT INTO rol (nombre, descripcion) VALUES 
('Administrador', 'Control total'), ('Vendedor', 'Atención al cliente'), ('Almacenero', 'Logística');

INSERT INTO permiso (nombre, descripcion) VALUES 
('CRUD Usuarios', 'Gestionar personal'), ('Ver Ventas', 'Reportes financieros'), ('Gestionar Stock', 'Movimientos de almacén');

INSERT INTO rol_has_permiso (ROL_idRol, PERMISO_idPermiso) VALUES 
(1,1), (1,2), (1,3), (2,2), (3,3);

INSERT INTO empleado (nombre, contraseña, nombreUsuario, correo, telefono, activo, sueldo, ROL_idRol) VALUES 
('Carlos Admin', 'PWhlGewFwcXhAMvTEq+bTQ==', 'admin', 'admin@lib.com', '999111001', 1, 3000, 1),
('Lucia Venta', 'PWhlGewFwcXhAMvTEq+bTQ==', 'lucia', 'lucia@lib.com', '999111002', 1, 1200, 2),
('Marcos Stock', 'PWhlGewFwcXhAMvTEq+bTQ==', 'marcos', 'marcos@lib.com', '999111003', 1, 1200, 3);

-- =============================================
-- 3. EDITORIALES Y AUTORES (Base para los 50 libros)
-- =============================================

INSERT INTO editorial (nombre, direccion, telefono, cif, email, sitioWeb) VALUES 
('Editorial Planeta', 'Av. A 1', '111', 'CIF1', 'c@planeta.com', 'planeta.com'),
('Penguin Random House', 'Av. B 2', '222', 'CIF2', 'c@penguin.com', 'penguin.com'),
('Alfaguara', 'Av. C 3', '333', 'CIF3', 'c@alfaguara.com', 'alfaguara.com'),
('Editorial Norma', 'Av. D 4', '444', 'CIF4', 'c@norma.com', 'norma.com'),
('Salamandra', 'Av. E 5', '555', 'CIF5', 'c@salamandra.com', 'salamandra.com'),
('Anagrama', 'Av. F 6', '666', 'CIF6', 'c@anagrama.com', 'anagrama.com');

INSERT INTO autor (nombre, apellidos, alias) VALUES 
('Gabriel', 'García Márquez', 'Gabo'), ('J.K.', 'Rowling', NULL), ('Stephen', 'King', NULL), 
('Isabel', 'Allende', NULL), ('Mario', 'Vargas Llosa', NULL), ('J.R.R.', 'Tolkien', NULL),
('George', 'Orwell', NULL), ('Isaac', 'Asimov', NULL), ('Agatha', 'Christie', 'Dama del Misterio'),
('Dan', 'Brown', NULL), ('Paulo', 'Coelho', NULL), ('Haruki', 'Murakami', NULL);

-- =============================================
-- 4. LIBROS (50+ Entradas)
-- =============================================
-- URLs rotativas: test1, test2, tes3, test4, test5
-- Generos: NOVELA, NARRATIVO, DRAMA, FANTASIA, AVENTURA, CIENCIA_FICCION
-- Formatos: TAPA_DURA, TAPA_BLANDA, COLECCIONISTA

INSERT INTO libro (precio, precioDescuento, stockReal, stockVirtual, nombre, descripcion, isbn, generoLibro, fechaPublicacion, formato, sinopsis, EDITORIAL_idEditorial, imagenURL) VALUES 
(59.90, NULL, 50, 50, 'Cien Años de Soledad', 'Clásico del realismo mágico.', '978-001', 'NOVELA', '1967-01-01', 'TAPA_BLANDA', 'Macondo y los Buendía.', 1, 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(45.00, 40.00, 30, 28, 'Crónica de una muerte anunciada', 'Novela corta.', '978-002', 'NARRATIVO', '1981-01-01', 'TAPA_BLANDA', 'La muerte de Santiago Nasar.', 1, 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(89.00, NULL, 100, 95, 'Harry Potter 1', 'El niño que vivió.', '978-003', 'FANTASIA', '1997-01-01', 'TAPA_DURA', 'Magia en Hogwarts.', 5, 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(95.00, 85.00, 60, 60, 'Harry Potter 2', 'La cámara secreta.', '978-004', 'FANTASIA', '1998-01-01', 'TAPA_DURA', 'El heredero de Slytherin.', 5, 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(95.00, NULL, 60, 60, 'Harry Potter 3', 'El prisionero de Azkaban.', '978-005', 'FANTASIA', '1999-01-01', 'TAPA_DURA', 'Sirius Black escapa.', 5, 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(95.00, NULL, 60, 60, 'Harry Potter 4', 'El cáliz de fuego.', '978-006', 'FANTASIA', '2000-01-01', 'TAPA_DURA', 'El torneo de los tres magos.', 5, 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(70.00, NULL, 40, 40, 'It (Eso)', 'Terror puro.', '978-007', 'DRAMA', '1986-01-01', 'TAPA_BLANDA', 'Pennywise el payaso.', 2, 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(65.00, NULL, 35, 35, 'El Resplandor', 'Terror psicológico.', '978-008', 'DRAMA', '1977-01-01', 'TAPA_BLANDA', 'Redrum.', 2, 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(60.00, 50.00, 45, 45, 'Misery', 'Obsesión fanática.', '978-009', 'DRAMA', '1987-01-01', 'TAPA_BLANDA', 'Un escritor secuestrado.', 2, 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(55.00, NULL, 50, 50, 'La Casa de los Espíritus', 'Saga familiar.', '978-010', 'NOVELA', '1982-01-01', 'TAPA_BLANDA', 'La familia Trueba.', 3, 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(55.00, NULL, 50, 50, 'Eva Luna', 'Realismo mágico.', '978-011', 'NOVELA', '1987-01-01', 'TAPA_BLANDA', 'Historias de Eva.', 3, 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(48.00, NULL, 30, 30, 'La Ciudad y los Perros', 'Novela realista.', '978-012', 'NOVELA', '1963-01-01', 'TAPA_BLANDA', 'Colegio Leoncio Prado.', 3, 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(48.00, NULL, 30, 30, 'La Fiesta del Chivo', 'Novela histórica.', '978-013', 'NOVELA', '2000-01-01', 'TAPA_BLANDA', 'Dictadura de Trujillo.', 3, 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(120.00, NULL, 20, 20, 'El Señor de los Anillos 1', 'La comunidad.', '978-014', 'FANTASIA', '1954-01-01', 'COLECCIONISTA', 'Frodo y el anillo.', 1, 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(120.00, NULL, 20, 20, 'El Señor de los Anillos 2', 'Las dos torres.', '978-015', 'FANTASIA', '1954-01-01', 'COLECCIONISTA', 'La guerra avanza.', 1, 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(120.00, NULL, 20, 20, 'El Señor de los Anillos 3', 'El retorno del rey.', '978-016', 'FANTASIA', '1955-01-01', 'COLECCIONISTA', 'El fin de Sauron.', 1, 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(40.00, NULL, 80, 80, '1984', 'Distopía.', '978-017', 'CIENCIA_FICCION', '1949-01-01', 'TAPA_BLANDA', 'El gran hermano vigila.', 2, 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(40.00, NULL, 80, 80, 'Rebelión en la granja', 'Sátira política.', '978-018', 'CIENCIA_FICCION', '1945-01-01', 'TAPA_BLANDA', 'Animales al poder.', 2, 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(65.00, NULL, 25, 25, 'Yo, Robot', 'Antología Sci-Fi.', '978-019', 'CIENCIA_FICCION', '1950-01-01', 'TAPA_DURA', 'Las tres leyes de la robótica.', 4, 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(65.00, NULL, 25, 25, 'Fundación', 'Saga Sci-Fi.', '978-020', 'CIENCIA_FICCION', '1951-01-01', 'TAPA_DURA', 'El futuro de la humanidad.', 4, 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(50.00, NULL, 40, 40, 'Asesinato en el Orient Express', 'Misterio clásico.', '978-021', 'AVENTURA', '1934-01-01', 'TAPA_BLANDA', 'Poirot investiga.', 5, 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(50.00, NULL, 40, 40, 'Diez negritos', 'Suspenso.', '978-022', 'AVENTURA', '1939-01-01', 'TAPA_BLANDA', 'Isla misteriosa.', 5, 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(75.00, 60.00, 55, 55, 'El Código Da Vinci', 'Thriller.', '978-023', 'AVENTURA', '2003-01-01', 'TAPA_BLANDA', 'Secretos religiosos.', 1, 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(75.00, NULL, 55, 55, 'Ángeles y Demonios', 'Thriller.', '978-024', 'AVENTURA', '2000-01-01', 'TAPA_BLANDA', 'Vaticano en peligro.', 1, 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(58.00, NULL, 60, 60, 'El Alquimista', 'Filosófico.', '978-025', 'NARRATIVO', '1988-01-01', 'TAPA_BLANDA', 'Busca tu tesoro.', 6, 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(62.00, NULL, 30, 30, 'Tokio Blues', 'Nostalgia japonesa.', '978-026', 'NOVELA', '1987-01-01', 'TAPA_BLANDA', 'Amor y pérdida.', 6, 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(62.00, NULL, 30, 30, 'Kafka en la orilla', 'Surrealismo.', '978-027', 'NOVELA', '2002-01-01', 'TAPA_BLANDA', 'Gatos y profecías.', 6, 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(150.00, NULL, 5, 5, 'Edición Coleccionista HP', 'Saga completa.', '978-028', 'FANTASIA', '2020-01-01', 'COLECCIONISTA', 'Boxset exclusivo.', 5, 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(150.00, NULL, 5, 5, 'Edición Coleccionista LOTR', 'Trilogía completa.', '978-029', 'FANTASIA', '2020-01-01', 'COLECCIONISTA', 'Boxset Tierra Media.', 1, 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(30.00, NULL, 100, 100, 'Relato de un náufrago', 'Periodismo.', '978-030', 'NARRATIVO', '1970-01-01', 'TAPA_BLANDA', 'Supervivencia en el mar.', 1, 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(45.00, NULL, 40, 40, 'Carrie', 'Terror.', '978-031', 'DRAMA', '1974-01-01', 'TAPA_BLANDA', 'Poderes telequinéticos.', 2, 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(90.00, NULL, 20, 20, 'Cementerio de animales', 'Terror.', '978-032', 'DRAMA', '1983-01-01', 'TAPA_DURA', 'La tierra está maldita.', 2, 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(35.00, NULL, 50, 50, 'El túnel', 'Existencialismo.', '978-033', 'NOVELA', '1948-01-01', 'TAPA_BLANDA', 'Obsesión de Castel.', 3, 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(100.00, 80.00, 15, 15, 'Dune', 'Sci-Fi Épico.', '978-034', 'CIENCIA_FICCION', '1965-01-01', 'TAPA_DURA', 'Arrakis y la especia.', 4, 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(100.00, NULL, 15, 15, 'El Mesías de Dune', 'Secuela Dune.', '978-035', 'CIENCIA_FICCION', '1969-01-01', 'TAPA_DURA', 'Paul Atreides emperador.', 4, 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(55.00, NULL, 25, 25, 'Inferno', 'Thriller.', '978-036', 'AVENTURA', '2013-01-01', 'TAPA_BLANDA', 'Dante y virus.', 1, 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(55.00, NULL, 25, 25, 'Origen', 'Thriller.', '978-037', 'AVENTURA', '2017-01-01', 'TAPA_BLANDA', 'IA y religión.', 1, 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(40.00, NULL, 60, 60, 'Verónika decide morir', 'Drama.', '978-038', 'DRAMA', '1998-01-01', 'TAPA_BLANDA', 'Locura y vida.', 6, 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(40.00, NULL, 60, 60, 'Once Minutos', 'Drama.', '978-039', 'DRAMA', '2003-01-01', 'TAPA_BLANDA', 'Busqueda del amor.', 6, 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(70.00, NULL, 30, 30, '1Q84 Libro 1', 'Distopía.', '978-040', 'CIENCIA_FICCION', '2009-01-01', 'TAPA_BLANDA', 'Mundos paralelos.', 6, 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(70.00, NULL, 30, 30, '1Q84 Libro 2', 'Distopía.', '978-041', 'CIENCIA_FICCION', '2009-01-01', 'TAPA_BLANDA', 'Aengo y Tengo.', 6, 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(45.00, NULL, 50, 50, 'La tía Julia y el escribidor', 'Humor.', '978-042', 'NOVELA', '1977-01-01', 'TAPA_BLANDA', 'Radionovelas.', 3, 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(45.00, NULL, 50, 50, 'Pantaleón y las visitadoras', 'Humor.', '978-043', 'NOVELA', '1973-01-01', 'TAPA_BLANDA', 'Servicio en la selva.', 3, 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(85.00, NULL, 20, 20, 'El Hobbit', 'Fantasía.', '978-044', 'FANTASIA', '1937-01-01', 'TAPA_DURA', 'Viaje de Bilbo.', 1, 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(85.00, NULL, 20, 20, 'El Silmarillion', 'Mitología.', '978-045', 'FANTASIA', '1977-01-01', 'TAPA_DURA', 'Creación de Arda.', 1, 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(30.00, NULL, 100, 100, 'Rebelión en la granja (Bolsillo)', 'Sátira.', '978-046', 'CIENCIA_FICCION', '1945-01-01', 'TAPA_BLANDA', 'Edición económica.', 2, 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(60.00, NULL, 40, 40, 'Muerte en el Nilo', 'Misterio.', '978-047', 'AVENTURA', '1937-01-01', 'TAPA_BLANDA', 'Crucero mortal.', 5, 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(55.00, NULL, 35, 35, 'Paula', 'Memoria.', '978-048', 'NARRATIVO', '1994-01-01', 'TAPA_BLANDA', 'Carta a su hija.', 3, 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(55.00, NULL, 35, 35, 'De amor y de sombra', 'Novela.', '978-049', 'NOVELA', '1984-01-01', 'TAPA_BLANDA', 'Dictadura chilena.', 3, 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(200.00, 150.00, 5, 5, 'La Torre Oscura (Saga)', 'Fantasía Oscura.', '978-050', 'FANTASIA', '1982-01-01', 'COLECCIONISTA', 'El pistolero busca la torre.', 2, 'https://i.ibb.co/20WZP5r7/test5.jpg');

-- =============================================
-- 5. RELACIÓN LIBRO-AUTOR
-- =============================================
-- Asignación rápida basada en los IDs generados arriba (1 al 50)
-- 1-2 Gabo(1), 3-6 Rowling(2), 7-9 King(3), 10-11 Allende(4), 12-13 Vargas(5)
-- 14-16 Tolkien(6), 17-18 Orwell(7), 19-20 Asimov(8), 21-22 Christie(9), 23-24 Brown(10)
-- 25-27 Coelho(11), 28 Rowling, 29 Tolkien, 30 Gabo, 31-32 King, 33 Vargas (Fake link for filler)
-- 34-35 Asimov (Actually Herbert but using Asimov ID for simplicity/consistency in fake data)
-- 36-37 Brown, 38-41 Murakami(12), 42-43 Vargas(5), 44-45 Tolkien(6), 46 Orwell, 47 Christie
-- 48-49 Allende, 50 King

INSERT INTO libro_has_autor (LIBRO_idLibro, AUTOR_idAutor) VALUES 
(1,1), (2,1), (3,2), (4,2), (5,2), (6,2), (7,3), (8,3), (9,3), (10,4),
(11,4), (12,5), (13,5), (14,6), (15,6), (16,6), (17,7), (18,7), (19,8), (20,8),
(21,9), (22,9), (23,10), (24,10), (25,11), (26,12), (27,12), (28,2), (29,6), (30,1),
(31,3), (32,3), (33,5), (34,8), (35,8), (36,10), (37,10), (38,12), (39,12), (40,12),
(41,12), (42,5), (43,5), (44,6), (45,6), (46,7), (47,9), (48,4), (49,4), (50,3);

-- =============================================
-- 6. ARTICULOS (50+ Entradas)
-- =============================================
-- Tipos: LAPICERO, CUADERNO, PELUCHE, TOMATODO

INSERT INTO articulo (precio, precioDescuento, stockReal, stockVirtual, nombre, descripcion, tipoArticulo, imagenURL) VALUES 
(5.00, NULL, 100, 100, 'Lapicero Azul', 'Tinta gel.', 'LAPICERO', 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(5.00, NULL, 100, 100, 'Lapicero Rojo', 'Tinta gel.', 'LAPICERO', 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(5.00, NULL, 100, 100, 'Lapicero Negro', 'Tinta gel.', 'LAPICERO', 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(15.00, 12.00, 50, 50, 'Cuaderno A4 Rayado', '100 hojas.', 'CUADERNO', 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(15.00, NULL, 50, 50, 'Cuaderno A4 Cuadriculado', '100 hojas.', 'CUADERNO', 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(15.00, NULL, 50, 50, 'Cuaderno A4 Blanco', '100 hojas.', 'CUADERNO', 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(35.00, 30.00, 20, 20, 'Oso Peluche Café', 'Suave 30cm.', 'PELUCHE', 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(35.00, NULL, 20, 20, 'Oso Peluche Blanco', 'Suave 30cm.', 'PELUCHE', 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(25.00, NULL, 40, 40, 'Tomatodo Acero 500ml', 'Térmico.', 'TOMATODO', 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(25.00, 20.00, 40, 40, 'Tomatodo Plástico 1L', 'Deportivo.', 'TOMATODO', 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(8.00, NULL, 80, 80, 'Set Lapiceros Neon', '5 colores.', 'LAPICERO', 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(8.00, NULL, 80, 80, 'Set Lapiceros Pastel', '5 colores.', 'LAPICERO', 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(20.00, NULL, 30, 30, 'Cuaderno Tapa Dura Gato', 'Diseño gato.', 'CUADERNO', 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(20.00, NULL, 30, 30, 'Cuaderno Tapa Dura Perro', 'Diseño perro.', 'CUADERNO', 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(20.00, NULL, 30, 30, 'Cuaderno Tapa Dura Paisaje', 'Diseño playa.', 'CUADERNO', 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(45.00, NULL, 15, 15, 'Peluche Panda', '40cm.', 'PELUCHE', 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(45.00, NULL, 15, 15, 'Peluche León', '40cm.', 'PELUCHE', 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(12.00, NULL, 60, 60, 'Tomatodo Niño', 'Con sorbete.', 'TOMATODO', 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(12.00, NULL, 60, 60, 'Tomatodo Niña', 'Con sorbete.', 'TOMATODO', 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(3.00, NULL, 200, 200, 'Lapicero Económico Azul', 'Simple.', 'LAPICERO', 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(3.00, NULL, 200, 200, 'Lapicero Económico Negro', 'Simple.', 'LAPICERO', 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(18.00, NULL, 40, 40, 'Cuaderno Anillado A5', 'Pequeño.', 'CUADERNO', 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(18.00, NULL, 40, 40, 'Cuaderno Anillado A4', 'Grande.', 'CUADERNO', 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(60.00, 50.00, 10, 10, 'Peluche Gigante Oso', '1 metro.', 'PELUCHE', 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(60.00, NULL, 10, 10, 'Peluche Gigante Unicornio', '1 metro.', 'PELUCHE', 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(30.00, NULL, 25, 25, 'Tomatodo Vidrio', 'Con funda.', 'TOMATODO', 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(30.00, NULL, 25, 25, 'Tomatodo Infusor', 'Para frutas.', 'TOMATODO', 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(10.00, NULL, 70, 70, 'Pluma Fuente', 'Clásica.', 'LAPICERO', 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(10.00, NULL, 70, 70, 'Bolígrafo Fino', 'Ejecutivo.', 'LAPICERO', 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(22.00, NULL, 35, 35, 'Cuaderno Puntos', 'Bullet Journal.', 'CUADERNO', 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(22.00, NULL, 35, 35, 'Cuaderno Dibujo', 'Hojas gruesas.', 'CUADERNO', 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(25.00, 20.00, 30, 30, 'Peluche Llavero', 'Pack x3.', 'PELUCHE', 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(28.00, NULL, 30, 30, 'Peluche Sonoro', 'Con música.', 'PELUCHE', 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(20.00, NULL, 45, 45, 'Tomatodo Shaker', 'Para gym.', 'TOMATODO', 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(20.00, NULL, 45, 45, 'Tomatodo Plegable', 'Silicona.', 'TOMATODO', 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(4.00, NULL, 150, 150, 'Lapicero Borrable', 'Azul.', 'LAPICERO', 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(4.00, NULL, 150, 150, 'Lapicero Borrable', 'Negro.', 'LAPICERO', 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(25.00, NULL, 25, 25, 'Agenda 2024', 'Diaria.', 'CUADERNO', 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(25.00, NULL, 25, 25, 'Agenda 2025', 'Semanal.', 'CUADERNO', 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(40.00, NULL, 15, 15, 'Peluche Anime', 'Personaje X.', 'PELUCHE', 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(40.00, NULL, 15, 15, 'Peluche Videojuego', 'Personaje Y.', 'PELUCHE', 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(18.00, NULL, 50, 50, 'Tomatodo Aluminio Rojo', '600ml.', 'TOMATODO', 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(18.00, NULL, 50, 50, 'Tomatodo Aluminio Azul', '600ml.', 'TOMATODO', 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(6.00, NULL, 90, 90, 'Resaltador Amarillo', 'Grueso.', 'LAPICERO', 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(6.00, NULL, 90, 90, 'Resaltador Verde', 'Grueso.', 'LAPICERO', 'https://i.ibb.co/20WZP5r7/test5.jpg'),
(14.00, NULL, 55, 55, 'Libreta de Notas', 'Bolsillo.', 'CUADERNO', 'https://i.ibb.co/hxVBLg16/test1.jpg'),
(14.00, NULL, 55, 55, 'Libreta de Apuntes', 'Tapa blanda.', 'CUADERNO', 'https://i.ibb.co/Fqk8bKBC/test2.jpg'),
(32.00, NULL, 22, 22, 'Peluche Interactivo', 'Habla.', 'PELUCHE', 'https://i.ibb.co/G40rLNMx/tes3.jpg'),
(32.00, NULL, 22, 22, 'Peluche Reversible', 'Feliz/Triste.', 'PELUCHE', 'https://i.ibb.co/1ttpRxB4/test4.jpg'),
(15.00, NULL, 60, 60, 'Tomatodo Básico', 'Plástico duro.', 'TOMATODO', 'https://i.ibb.co/20WZP5r7/test5.jpg');

-- =============================================
-- 7. CLIENTES (Aumentados a 10)
-- =============================================

INSERT INTO cliente (nombre, contraseña, nombreUsuario, correo, telefono) VALUES 
('Juan Perez', 'PWhlGewFwcXhAMvTEq+bTQ==', 'jperez', 'juan@test.com', '999000001'),
('Maria Lopez', 'PWhlGewFwcXhAMvTEq+bTQ==', 'mlopez', 'maria@test.com', '999000002'),
('Pedro Gomez', 'PWhlGewFwcXhAMvTEq+bTQ==', 'pgomez', 'pedro@test.com', '999000003'),
('Laura Diaz', 'PWhlGewFwcXhAMvTEq+bTQ==', 'ldiaz', 'laura@test.com', '999000004'),
('Carlos Ruiz', 'PWhlGewFwcXhAMvTEq+bTQ==', 'cruiz', 'carlos@test.com', '999000005'),
('Ana Torres', 'PWhlGewFwcXhAMvTEq+bTQ==', 'atorres', 'ana@test.com', '999000006'),
('Luis Silva', 'PWhlGewFwcXhAMvTEq+bTQ==', 'lsilva', 'luis@test.com', '999000007'),
('Sofia Vega', 'PWhlGewFwcXhAMvTEq+bTQ==', 'svega', 'sofia@test.com', '999000008'),
('Diego Rios', 'PWhlGewFwcXhAMvTEq+bTQ==', 'drios', 'diego@test.com', '999000009'),
('Elena Paz', 'PWhlGewFwcXhAMvTEq+bTQ==', 'epaz', 'elena@test.com', '999000010');

-- =============================================
-- 8. CUPONES Y TRANSACCIONES
-- =============================================

INSERT INTO cupon (codigo, descuento, fechaCaducidad, activo, usosRestantes) VALUES 
('HOLA2024', 20.00, '2025-12-31', 1, 100), ('LIBROS10', 10.00, '2025-12-31', 1, 50), ('VERANO5', 5.00, '2025-06-30', 1, 20);

-- Carrito 1: Completado (Juan)
INSERT INTO carrito (completado, CUPON_idCupon, CLIENTE_idCliente) VALUES (1, 1, 1);
INSERT INTO linea_carrito_libro (cantidad, precioUnitario, subtotal, CARRITO_idCarrito, libro_idLibro) VALUES (1, 89.00, 89.00, 1, 3);
INSERT INTO orden_compra (fechaLimitePago, total, totalConDescuento, estado, CLIENTE_idCliente, CARRITO_idCarrito) VALUES ('2025-01-01', 89.00, 69.00, 'ENTREGADO', 1, 1);
INSERT INTO documento_venta (ORDEN_COMPRA_idOrdenCompra) VALUES (1);

-- Carrito 2: En curso (Maria)
INSERT INTO carrito (completado, CUPON_idCupon, CLIENTE_idCliente) VALUES (0, NULL, 2);
INSERT INTO linea_carrito_articulo (cantidad, precioUnitario, subtotal, CARRITO_idCarrito, articulo_idArticulo) VALUES (2, 35.00, 70.00, 2, 7);

-- Carrito 3: Cancelado (Pedro)
INSERT INTO carrito (completado, CUPON_idCupon, CLIENTE_idCliente) VALUES (1, NULL, 3);
INSERT INTO linea_carrito_libro (cantidad, precioUnitario, subtotal, CARRITO_idCarrito, libro_idLibro) VALUES (1, 59.90, 59.90, 3, 1);
INSERT INTO orden_compra (fechaLimitePago, total, totalConDescuento, estado, CLIENTE_idCliente, CARRITO_idCarrito) VALUES ('2023-01-01', 59.90, NULL, 'CANCELADO', 3, 3);

-- Carrito 4: Completado (Laura)
INSERT INTO carrito (completado, CUPON_idCupon, CLIENTE_idCliente) VALUES (1, 2, 4);
INSERT INTO linea_carrito_libro (cantidad, precioUnitario, subtotal, CARRITO_idCarrito, libro_idLibro) VALUES (1, 200.00, 200.00, 4, 50); -- Torre Oscura
INSERT INTO orden_compra (fechaLimitePago, total, totalConDescuento, estado, CLIENTE_idCliente, CARRITO_idCarrito) VALUES ('2025-02-01', 200.00, 190.00, 'PAGADO', 4, 4);
INSERT INTO documento_venta (ORDEN_COMPRA_idOrdenCompra) VALUES (2);

-- Reseñas adicionales
INSERT INTO reseña_libro (calificacion, reseña, LIBRO_idLibro, cliente_idCliente) VALUES 
(5, 'Increíble.', 3, 1), (5, 'Me encantó.', 50, 4), (3, 'Muy largo.', 1, 3);

INSERT INTO reseña_articulo (calificacion, reseña, ARTICULO_idArticulo, cliente_idCliente) VALUES 
(5, 'Muy suave.', 7, 2), (4, 'Buen material.', 9, 1);