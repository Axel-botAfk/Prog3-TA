package pe.edu.pucp.campusstore.boimpl;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import pe.edu.pucp.campusstore.bo.LibroBO;
import pe.edu.pucp.campusstore.dao.AutorDAO;
import pe.edu.pucp.campusstore.dao.AutorLibroDAO;
import pe.edu.pucp.campusstore.dao.EditorialDAO;
import pe.edu.pucp.campusstore.dao.LibroDAO;
import pe.edu.pucp.campusstore.daoimpl.AutorDAOImpl;
import pe.edu.pucp.campusstore.daoimpl.AutorLibroDAOImpl;
import pe.edu.pucp.campusstore.daoimpl.EditorialDAOImpl;
import pe.edu.pucp.campusstore.daoimpl.LibroDAOImpl;
import pe.edu.pucp.campusstore.db.DBFactoryProvider;
import pe.edu.pucp.campusstore.db.DBManager;
import pe.edu.pucp.campusstore.modelo.Autor;
import pe.edu.pucp.campusstore.modelo.AutoresLibro;
import pe.edu.pucp.campusstore.modelo.Libro;
import pe.edu.pucp.campusstore.modelo.enums.Estado;

public class LibroBOImpl implements LibroBO {

    private final LibroDAO libroDAO;
    private final AutorDAO autorDAO;
    private final EditorialDAO editorialDAO;
    private final AutorLibroDAO autorLibroDAO;

    public LibroBOImpl() {
        this.libroDAO = new LibroDAOImpl();
        this.autorDAO = new AutorDAOImpl();
        this.editorialDAO = new EditorialDAOImpl();
        this.autorLibroDAO = new AutorLibroDAOImpl();
    }

    @Override
    public List<Libro> listar() {
        return libroDAO.leerTodos();
    }

    @Override
    public Libro obtener(int id) {
        Libro libro = this.libroDAO.leer(id);
        if (libro != null) {
            libro.setReseñas(libroDAO.obtenerReseñasPorLibro(id));
            libro.setAutores(libroDAO.leerAutoresPorLibro(id));
        }
        return libro;
    }

    @Override
    public void eliminar(int id) {
        libroDAO.eliminar(id);
    }

    @Override
    public void guardar(Libro modelo, Estado estado) {
        if (estado == Estado.Nuevo) {
            this.libroDAO.crear(modelo);
        } else {
            this.libroDAO.actualizar(modelo);
        }
    }

    @Override
    public Integer registrarLibro(Libro libro, List<Autor> autores) {
        DBManager dbManager = DBFactoryProvider.getManager();
        try (Connection conn = dbManager.getConnection()) {
            conn.setAutoCommit(false); // Iniciar transacción
            try {
                Integer idEditorial=this.editorialDAO.crear(libro.getEditorial(), conn);
                libro.getEditorial().setIdEditorial(idEditorial);
                Integer idLibro = libroDAO.crear(libro, conn); // INSERT libro
                if (idLibro == null) {
                    throw new RuntimeException("No se pudo crear libro");
                }
                libro.setIdLibro(idLibro);

                for (Autor autor : autores) {
                    
                    Integer idAutor=autorDAO.crear(autor, conn); // INSERT autor si es nuevo

                    if (idAutor == null) {
                        throw new RuntimeException("No se pudo crear autor");
                    }
                    autor.setIdAutor(idAutor);
                    AutoresLibro autoresLibroAux = new AutoresLibro();
                    autoresLibroAux.setAutor(autor);
                    autoresLibroAux.setLibro(libro);
                    autorLibroDAO.crear(autoresLibroAux, conn);// INSERT tabla intermedia
                }

                conn.commit(); // Confirmar transacción
                return idLibro;
            } catch (SQLException ex) {
                conn.rollback();
                throw new RuntimeException("Error registrando libro", ex);
            }
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Error de conexión al guardar Libro"
                    + "", e);
        }
    }

    @Override
    public List<Autor> leerAutoresPorLibro(int idLibro) {
        return this.libroDAO.leerAutoresPorLibro(idLibro);
    }
    
    @Override
    public void modificarConAutores(Libro libro, List<Autor> autores) {
        DBManager dbManager = DBFactoryProvider.getManager();
        try (Connection conn = dbManager.getConnection()) {
            conn.setAutoCommit(false); 
            try {
                if (libro.getEditorial() != null) {
                } else {
                    throw new RuntimeException("El objeto editorial no puede ser nulo.");
                }
                
                if (libro.getEditorial() != null && (libro.getEditorial().getIdEditorial() == 0 || libro.getEditorial().getIdEditorial() == null)) {
                    Integer idEditorial = this.editorialDAO.crear(libro.getEditorial(), conn);
                    if (idEditorial == null) {
                        throw new RuntimeException("No se pudo crear la editorial");
                    }
                    libro.getEditorial().setIdEditorial(idEditorial);
                }

                boolean libroActualizado = libroDAO.actualizar(libro, conn);
                if (!libroActualizado) {
                    throw new RuntimeException("No se pudo actualizar el libro");
                }

                libroDAO.eliminarAutoresPorLibro(libro.getIdLibro(), conn);

                if (autores != null && !autores.isEmpty()) {
                    for (Autor autor : autores) {
                        if (autor.getIdAutor() == 0) {
                            Integer idAutor = autorDAO.crear(autor, conn);
                            if (idAutor == null) {
                                throw new RuntimeException("No se pudo crear el autor: " + autor.getNombre());
                            }
                            autor.setIdAutor(idAutor);
                        }

                        boolean relacionCreada = libroDAO.crearRelacionLibroAutor(
                            libro.getIdLibro(), 
                            autor.getIdAutor(), 
                            conn
                        );

                        if (!relacionCreada) {
                            throw new RuntimeException("No se pudo crear la relación para el autor: " + autor.getNombre());
                        }
                    }
                }

                conn.commit();

            } catch (Exception ex) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    throw new RuntimeException("Error al hacer rollback", rollbackEx);
                }
                throw new RuntimeException("Error modificando libro con autores: " + ex.getMessage(), ex);
            }
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Error de conexión al modificar Libro", e);
        }
    }

}
