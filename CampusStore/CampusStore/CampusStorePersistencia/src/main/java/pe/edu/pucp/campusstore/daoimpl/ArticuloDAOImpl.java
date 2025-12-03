
package pe.edu.pucp.campusstore.daoimpl;
import pe.edu.pucp.campusstore.bases.dao.BaseDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import pe.edu.pucp.campusstore.dao.ArticuloDAO;
import pe.edu.pucp.campusstore.modelo.Articulo;
import pe.edu.pucp.campusstore.modelo.Cliente;
import pe.edu.pucp.campusstore.modelo.Reseña;
import pe.edu.pucp.campusstore.modelo.enums.TipoArticulo;
import pe.edu.pucp.campusstore.modelo.enums.TipoProducto;

public class ArticuloDAOImpl extends BaseDAO<Articulo> implements ArticuloDAO {
      @Override
    protected PreparedStatement comandoCrear(Connection conn, 
            Articulo modelo) throws SQLException {
        
        String sql = "{call insertarArticulo(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setString("p_nombre", modelo.getNombre());
        cmd.setString("p_descripcion", modelo.getDescripcion());
        cmd.setDouble("p_precio", modelo.getPrecio());
        cmd.setDouble("p_precioDescuento", modelo.getPrecioDescuento());
        cmd.setInt("p_stockReal", modelo.getStockReal());
        cmd.setInt("p_stockVirtual", modelo.getStockVirtual());
        cmd.setString("p_tipoArticulo", modelo.getTipoArticulo().toString());
        cmd.setString("p_imagenURL", modelo.getImagenURL());
        cmd.registerOutParameter("p_id", Types.INTEGER);

        return cmd;
    }

    @Override
    protected PreparedStatement comandoActualizar(Connection conn, 
            Articulo modelo) throws SQLException {
        
        String sql = "{call modificarArticulo(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setString("p_nombre", modelo.getNombre());
        cmd.setString("p_descripcion", modelo.getDescripcion());
        cmd.setDouble("p_precio", modelo.getPrecio());
        cmd.setDouble("p_precioDescuento", modelo.getPrecioDescuento());
        cmd.setInt("p_stockReal", modelo.getStockReal());
        cmd.setInt("p_stockVirtual", modelo.getStockVirtual());
        cmd.setString("p_tipoArticulo", modelo.getTipoArticulo().toString());
        cmd.setString("p_imagenURL", modelo.getImagenURL());
        cmd.setInt("p_id", modelo.getIdArticulo());
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoEliminar(Connection conn, 
            Integer id) throws SQLException {
        
        String sql = "{call eliminarArticulo(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", id);
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoLeer(Connection conn, 
            Integer id) throws SQLException {
        
        String sql = "{call buscarArticuloPorId(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", id);
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoLeerTodos(
            Connection conn) throws SQLException {
        
        String sql = "{call listarArticulos()}";
        CallableStatement cmd = conn.prepareCall(sql);
        
        return cmd;
    }

    @Override
    protected Articulo mapearModelo(ResultSet rs) throws SQLException {
        Articulo modelo = new Articulo();
        
        modelo.setIdArticulo(rs.getInt("idArticulo"));
        modelo.setPrecio(rs.getDouble("precio"));
        modelo.setPrecioDescuento(rs.getDouble("precioDescuento"));
        modelo.setStockReal(rs.getInt("stockReal"));
        modelo.setStockVirtual(rs.getInt("stockVirtual"));
        modelo.setNombre(rs.getString("nombre"));
        modelo.setDescripcion(rs.getString("descripcion"));
        modelo.setImagenURL(rs.getString("imagenURL"));
        
        modelo.setTipoArticulo(TipoArticulo.valueOf(rs.getString("tipoArticulo")));
        
        
        return modelo;
    }
    
    private Reseña mapearReseñaPorArticulo(ResultSet rs) throws SQLException {
        Reseña reseña = new Reseña();

        reseña.setIdReseña(rs.getInt("idReseña"));
        reseña.setCalificacion(rs.getDouble("calificacion"));
        reseña.setReseña(rs.getString("reseña"));
        reseña.setTipoProducto(TipoProducto.ARTICULO);
        
        // Articulo
        Integer idProducto = rs.getInt("idArticulo");
        if(!rs.wasNull()){
            reseña.setIdProducto(idProducto);
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
    
    protected PreparedStatement comandoObtenerReseñasPorArticulo(Connection conn, int idArticulo)
            throws SQLException {

        String sql = "{call obtenerReseñasPorArticulo(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_idArticulo", idArticulo);

        return cmd;
    }
    
    @Override
    public List<Reseña> obtenerReseñasPorArticulo(int idArticulo) {
        return ejecutarComando(conn -> {
            try (PreparedStatement cmd = this.comandoObtenerReseñasPorArticulo(conn, idArticulo)) {
                ResultSet rs = cmd.executeQuery();
                List<Reseña> lista = new ArrayList<>();
                while (rs.next()) {
                    lista.add(mapearReseñaPorArticulo(rs));
                }
                return lista;
            }
        });
    }
    
}
