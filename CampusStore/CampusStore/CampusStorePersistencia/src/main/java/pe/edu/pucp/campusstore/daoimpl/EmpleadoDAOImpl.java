
package pe.edu.pucp.campusstore.daoimpl;
import pe.edu.pucp.campusstore.bases.dao.BaseDAO;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.logging.Level;
import java.util.logging.Logger;
import pe.edu.pucp.campusstore.dao.EmpleadoDAO;
import pe.edu.pucp.campusstore.modelo.Empleado;
import utils.Crypto;

public class EmpleadoDAOImpl extends BaseDAO<Empleado> implements EmpleadoDAO {
      @Override
    protected PreparedStatement comandoCrear(Connection conn, 
            Empleado modelo) throws SQLException {
        
        String sql = "{call insertarEmpleado(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setString("p_nombre", modelo.getNombre());
          try {
              cmd.setString("p_contraseña", Crypto.encrypt(modelo.getContraseña()));
          } catch (Exception ex) {
              Logger.getLogger(EmpleadoDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
          }
        cmd.setString("p_nombreUsuario", modelo.getNombreUsuario());
        cmd.setString("p_correo", modelo.getCorreo());
        cmd.setString("p_telefono", modelo.getTelefono());
        cmd.setBoolean("p_activo", modelo.getActivo());
        cmd.setDouble("p_sueldo",modelo.getSueldo());
        cmd.setInt("p_idRol", modelo.getRol().getIdRol());
        cmd.registerOutParameter("p_id", Types.INTEGER);
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoActualizar(Connection conn, 
            Empleado modelo) throws SQLException {
        
        String sql = "{call modificarEmpleado(?, ?, ?, ? ,?, ?, ?, ?, ?)}";
        
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", modelo.getIdEmpleado());
        cmd.setString("p_nombre", modelo.getNombre());
        try {
              cmd.setString("p_contraseña", Crypto.encrypt(modelo.getContraseña()));
          } catch (Exception ex) {
              Logger.getLogger(EmpleadoDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
          }
        cmd.setString("p_nombreUsuario", modelo.getNombreUsuario());
        cmd.setString("p_correo", modelo.getCorreo());
        cmd.setString("p_telefono", modelo.getTelefono());
        cmd.setBoolean("p_activo", modelo.getActivo());
        cmd.setDouble("p_sueldo",modelo.getSueldo());
        cmd.setInt("p_idRol", modelo.getRol().getIdRol());

        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoEliminar(Connection conn, 
            Integer id) throws SQLException {
        
        String sql = "{call eliminarEmpleado(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", id);
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoLeer(Connection conn, 
            Integer id) throws SQLException {
        
        String sql = "{call buscarEmpleadoPorId(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", id);
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoLeerTodos(
            Connection conn) throws SQLException {
        
        String sql = "{call listarEmpleados()}";
        CallableStatement cmd = conn.prepareCall(sql);
        
        return cmd;
    }

    @Override
    protected Empleado mapearModelo(ResultSet rs) throws SQLException {
        Empleado modelo = new Empleado();
        modelo.setIdEmpleado(rs.getInt("idEmpleado"));
        modelo.setNombre(rs.getString("nombre"));
          try {
              modelo.setContraseña(Crypto.decrypt(rs.getString("contraseña")));
          } catch (Exception ex) {
              Logger.getLogger(EmpleadoDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
          }
        modelo.setNombreUsuario(rs.getString("nombreUsuario"));
        modelo.setCorreo(rs.getString("correo"));
        modelo.setTelefono(rs.getString("telefono"));
        modelo.setActivo(rs.getBoolean("activo"));
        modelo.setSueldo(rs.getDouble("sueldo"));
        
        Integer idRol = rs.getInt("ROL_idRol");
        if(!rs.wasNull()){
            modelo.setRol(new RolDAOImpl().leer(idRol));
        }
        
        return modelo;
    }

    protected PreparedStatement comandoBuscarPorCorreo(
            Connection conn, String correo) 
            throws SQLException {
        
        String sql = "{call buscarEmpleadoPorCorreo(?)}";
        
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setString("p_correo", correo);
        
        return cmd;
    }
    
    @Override
    public Empleado buscarEmpleadoPorCorreo(String correo) {
        return ejecutarComando(conn -> {
            try (PreparedStatement cmd = this.comandoBuscarPorCorreo(conn, correo)) {
                ResultSet rs = cmd.executeQuery();

                if (!rs.next()) {
                    System.err.println("No se encontro el registro con "
                            + "correo: " + correo);
                    return null;
                }

                return this.mapearModelo(rs);
            }
        });
    }
    
    protected PreparedStatement comandoBuscarIdPorCorreo(
            Connection conn, String correo) 
            throws SQLException {
        
        String sql = "{call buscarEmpleadoIdPorCorreo(?)}";
        
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setString("p_correo", correo);
        
        return cmd;
    }

    @Override
    public Integer buscarEmpleadoIdPorCorreo(String correo) {
        return ejecutarComando(conn -> {
            try (PreparedStatement cmd = this.comandoBuscarIdPorCorreo(conn, correo)) {
                ResultSet rs = cmd.executeQuery();

                if (!rs.next()) {
                    System.err.println("No se encontro el registro con "
                            + "correo: " + correo);
                    return null;
                }

                return rs.getInt(1);
            }
        });
    }
    
}
