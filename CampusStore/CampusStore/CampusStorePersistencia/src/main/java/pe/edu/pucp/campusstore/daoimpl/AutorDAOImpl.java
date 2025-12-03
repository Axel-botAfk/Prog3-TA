package pe.edu.pucp.campusstore.daoimpl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import pe.edu.pucp.campusstore.bases.dao.TransaccionalBaseDAO;

import pe.edu.pucp.campusstore.modelo.Autor;
import pe.edu.pucp.campusstore.dao.AutorDAO;

public class AutorDAOImpl extends TransaccionalBaseDAO<Autor> implements AutorDAO {
    
    @Override
    protected PreparedStatement comandoCrear(Connection conn, 
            Autor modelo) throws SQLException {
        
        String sql = "{call insertarAutorSiNoExiste(?, ?, ?, ?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setString("p_nombre", modelo.getNombre());
        cmd.setString("p_apellidos", modelo.getApellidos());
        cmd.setString("p_alias", modelo.getAlias());
        cmd.registerOutParameter("p_id", Types.INTEGER);
        
        return cmd;
    }
    
    @Override
    protected PreparedStatement comandoActualizar(Connection conn, 
            Autor modelo) throws SQLException {
        
        String sql = "{call modificarAutor(?, ?, ?, ?)}";
        
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setString("p_nombre", modelo.getNombre());
        cmd.setString("p_apellidos", modelo.getApellidos());
        cmd.setString("p_alias", modelo.getAlias());
        cmd.setInt("p_id", modelo.getIdAutor());
        return cmd;
    }
    
    @Override
    protected PreparedStatement comandoEliminar(Connection conn, 
            Integer id) throws SQLException {
        
        String sql = "{call eliminarAutor(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", id);
        
        return cmd;
    }
    
    @Override
    protected PreparedStatement comandoLeer(Connection conn, 
            Integer id) throws SQLException {
        
        String sql = "{call buscarAutorPorId(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", id);
        
        return cmd;
    }
    
    @Override
    protected PreparedStatement comandoLeerTodos(
            Connection conn) throws SQLException {
        
        String sql = "{call listarAutores()}";
        CallableStatement cmd = conn.prepareCall(sql);
        
        return cmd;
    }
    
    @Override
    protected Autor mapearModelo(ResultSet rs) throws SQLException {
        Autor modelo = new Autor();
        
        modelo.setIdAutor(rs.getInt("idAutor"));
        modelo.setNombre(rs.getString("nombre"));
        modelo.setApellidos(rs.getString("apellidos"));
        modelo.setAlias(rs.getString("alias"));
        return modelo;
    }
}
