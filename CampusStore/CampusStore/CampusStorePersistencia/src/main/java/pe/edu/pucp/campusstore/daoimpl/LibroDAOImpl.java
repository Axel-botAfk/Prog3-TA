package pe.edu.pucp.campusstore.daoimpl;

import pe.edu.pucp.campusstore.bases.dao.BaseDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import pe.edu.pucp.campusstore.bases.dao.TransaccionalBaseDAO;
import pe.edu.pucp.campusstore.dao.LibroDAO;
import pe.edu.pucp.campusstore.modelo.Autor;
import pe.edu.pucp.campusstore.modelo.Cliente;
import pe.edu.pucp.campusstore.modelo.Descuento;
import pe.edu.pucp.campusstore.modelo.Editorial;
import pe.edu.pucp.campusstore.modelo.enums.Formato;
import pe.edu.pucp.campusstore.modelo.enums.GeneroLibro;
import pe.edu.pucp.campusstore.modelo.Libro;
import pe.edu.pucp.campusstore.modelo.Reseña;
import pe.edu.pucp.campusstore.modelo.enums.TipoProducto;

public class LibroDAOImpl extends TransaccionalBaseDAO<Libro> implements LibroDAO {
    @Override
    protected PreparedStatement comandoCrear(Connection conn, 
            Libro modelo) throws SQLException {
        
        String sql = "{call insertarLibro(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        
        cmd.setDouble("p_precio", modelo.getPrecio());
        cmd.setDouble("p_precioDescuento", modelo.getPrecioDescuento());
        cmd.setInt("p_stockReal", modelo.getStockReal());
        cmd.setInt("p_stockVirtual", modelo.getStockVirtual());
        cmd.setString("p_nombre", modelo.getNombre());
        cmd.setString("p_descripcion", modelo.getDescripcion());
        cmd.setString("p_isbn", modelo.getIsbn());
        cmd.setString("p_generoLibro", modelo.getGenero().toString());
        cmd.setDate("p_fechaPublicacion", new Date(modelo.getFechaPublicacion().getTime()));
        cmd.setString("p_formato", modelo.getFormato().toString());
        cmd.setString("p_sinopsis", modelo.getSinopsis());
        cmd.setInt("p_idEditorial", modelo.getEditorial().getIdEditorial());
        cmd.setString("p_imagenURL", modelo.getImagenURL());
        //cmd.setInt("p_idDescuento", modelo.getDescuento().getIdDescuento());
        cmd.registerOutParameter("p_id", Types.INTEGER);
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoActualizar(Connection conn, 
            Libro modelo) throws SQLException {
        
        String sql = "{call modificarLibro(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", modelo.getIdLibro());
        cmd.setDouble("p_precio", modelo.getPrecio());
        cmd.setDouble("p_precioDescuento", modelo.getPrecioDescuento());
        cmd.setInt("p_stockReal", modelo.getStockReal());
        cmd.setInt("p_stockVirtual", modelo.getStockVirtual());
        cmd.setString("p_nombre", modelo.getNombre());
        cmd.setString("p_descripcion", modelo.getDescripcion());
        cmd.setString("p_isbn", modelo.getIsbn());
        cmd.setString("p_generoLibro", modelo.getGenero().toString());
        cmd.setDate("p_fechaPublicacion", new Date(modelo.getFechaPublicacion().getTime()));
        cmd.setString("p_formato", modelo.getFormato().toString());
        cmd.setString("p_sinopsis", modelo.getSinopsis());
        cmd.setInt("p_idEditorial", modelo.getEditorial().getIdEditorial());
        cmd.setString("p_imagenURL", modelo.getImagenURL());
        //cmd.setInt("p_idDescuento", modelo.getDescuento().getIdDescuento());
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoEliminar(Connection conn, 
            Integer id) throws SQLException {
        
        String sql = "{call eliminarLibro(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", id);
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoLeer(Connection conn, 
            Integer id) throws SQLException {
        
        String sql = "{call buscarLibroPorId(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", id);
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoLeerTodos(
            Connection conn) throws SQLException {
        
        String sql = "{call listarLibros()}";
        CallableStatement cmd = conn.prepareCall(sql);
        
        return cmd;
    }

    @Override
    protected Libro mapearModelo(ResultSet rs) throws SQLException {
        Libro modelo = new Libro();
        
        modelo.setIdLibro(rs.getInt("idLibro"));
        modelo.setPrecio(rs.getDouble("precio"));
        modelo.setPrecioDescuento(rs.getDouble("precioDescuento"));
        modelo.setStockReal(rs.getInt("stockReal"));
        modelo.setStockVirtual(rs.getInt("stockVirtual"));
        modelo.setNombre(rs.getString("nombre"));
        modelo.setDescripcion(rs.getString("descripcion"));
        modelo.setIsbn(rs.getString("isbn"));
        modelo.setGenero(GeneroLibro.valueOf(rs.getString("generoLibro")));
        modelo.setFechaPublicacion(rs.getDate("fechaPublicacion"));
        modelo.setFormato(Formato.valueOf(rs.getString("formato")));
        modelo.setSinopsis(rs.getString("sinopsis"));
        
        Integer idEditorial = rs.getInt("EDITORIAL_idEditorial");
        if(!rs.wasNull()){
            modelo.setEditorial(new EditorialDAOImpl().leer(idEditorial));
        }
        modelo.setImagenURL(rs.getString("imagenURL"));
        return modelo;
    }
    
    protected Autor mapearModeloPorAutor(ResultSet rs) throws SQLException {
        Autor modelo = new Autor();
        
        modelo.setIdAutor(rs.getInt("idAutor"));
        modelo.setNombre(rs.getString("nombre"));
        modelo.setApellidos(rs.getString("apellidos"));
        modelo.setAlias(rs.getString("alias"));
        return modelo;
    }
    
    private Reseña mapearReseñaPorLibro(ResultSet rs) throws SQLException {
        Reseña reseña = new Reseña();

        reseña.setIdReseña(rs.getInt("idReseña"));
        reseña.setCalificacion(rs.getDouble("calificacion"));
        reseña.setReseña(rs.getString("reseña"));
        reseña.setTipoProducto(TipoProducto.LIBRO);

        // Libro (solo ID)
        int idLibro = rs.getInt("idLibro");
        if(!rs.wasNull()){
            reseña.setIdProducto(idLibro);
        }

        // Cliente
        Cliente cliente = new Cliente();
        cliente.setIdCliente(rs.getInt("idCliente"));
        cliente.setNombre(rs.getString("clienteNombre"));
        cliente.setNombreUsuario(rs.getString("clienteUsuario"));
        cliente.setCorreo(rs.getString("clienteCorreo"));
        cliente.setTelefono(rs.getString("clienteTelefono"));

        reseña.setCliente(cliente);

        return reseña;
    }
    
    protected PreparedStatement comandoLeerAutoresPorLibro(Connection conn, 
            int idLibro) throws SQLException {
        
        String sql = "{call listarAutoresPorLibro(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_idLibro", idLibro);
        return cmd;
    }
    
    protected PreparedStatement comandoObtenerReseñasPorLibro(Connection conn, int idLibro)
            throws SQLException {
        String sql = "{call obtenerReseñasPorLibro(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_idLibro", idLibro);
        return cmd;
    }

    public List<Autor> leerAutoresPorLibro(int idLibro) {
        return ejecutarComando(conn -> {
            try (PreparedStatement cmd = this.comandoLeerAutoresPorLibro(conn, idLibro)){
                ResultSet rs = cmd.executeQuery();
                
                List<Autor> modelos = new ArrayList<>();
                
                while (rs.next()) {
                    modelos.add(this.mapearModeloPorAutor(rs));
                }
                
                return modelos;
            }
        });
    }
    
    @Override
    public List<Reseña> obtenerReseñasPorLibro(int idLibro) {
        return ejecutarComando(conn -> {
            try (PreparedStatement cmd = this.comandoObtenerReseñasPorLibro(conn, idLibro)) {
                ResultSet rs = cmd.executeQuery();
                List<Reseña> lista = new ArrayList<>();

                while (rs.next()) {
                    lista.add(mapearReseñaPorLibro(rs));
                }

                return lista;
            }
        });
    }
    
    @Override
    public boolean actualizar(Libro modelo) {
        return ejecutarComando(conn -> {
            boolean resultado = ejecutarComandoActualizar(conn, modelo);
            if (resultado) {
                actualizarAutores(conn, modelo);
            }
            return resultado;
        });
    }
    
    private void actualizarAutores(Connection conn, Libro modelo) throws SQLException {
        if (modelo.getAutores() == null || modelo.getAutores().isEmpty()) {
            return;
        }

        // Eliminar relaciones existentes
        try (CallableStatement cmdEliminar = conn.prepareCall("{call eliminarAutoresLibro(?)}")) {
            cmdEliminar.setInt(1, modelo.getIdLibro());
            cmdEliminar.executeUpdate();
        }

        // Insertar nuevas relaciones
        try (CallableStatement cmdInsertar = conn.prepareCall("{call actualizarAutoresLibro(?, ?)}")) {
            for (Autor autor : modelo.getAutores()) {
                cmdInsertar.setInt(1, modelo.getIdLibro());
                cmdInsertar.setInt(2, autor.getIdAutor());
                cmdInsertar.executeUpdate();
            }
        }
    }
    
    @Override
    public boolean eliminarAutoresPorLibro(Integer idLibro, Connection conn) {
        String sql = "{call eliminarAutoresLibro(?)}";
        
        try (CallableStatement cmd = conn.prepareCall(sql)) {
            cmd.setInt(1, idLibro);
            cmd.executeUpdate();
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(LibroDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    @Override
    public boolean crearRelacionLibroAutor(Integer idLibro, Integer idAutor, Connection conn) {
        String sql = "{call actualizarAutoresLibro(?, ?)}";
        
        try (CallableStatement cmd = conn.prepareCall(sql)) {
            cmd.setInt(1, idLibro);
            cmd.setInt(2, idAutor);
            cmd.executeUpdate();
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(LibroDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
}
