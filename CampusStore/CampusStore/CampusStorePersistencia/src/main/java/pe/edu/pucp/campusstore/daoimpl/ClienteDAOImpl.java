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
import java.util.logging.Level;
import java.util.logging.Logger;
import pe.edu.pucp.campusstore.dao.ClienteDAO;
import pe.edu.pucp.campusstore.modelo.Cliente;
import pe.edu.pucp.campusstore.modelo.Cupon;
import utils.Crypto;

public class ClienteDAOImpl extends BaseDAO<Cliente> implements ClienteDAO {

    @Override
    protected PreparedStatement comandoCrear(Connection conn, Cliente modelo) throws SQLException {
        String sql = "{call insertarCliente(?, ?, ?, ?, ?, ?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        
        cmd.setString("p_nombre", modelo.getNombre());
        try {
            cmd.setString("p_contraseña", Crypto.encrypt(modelo.getContraseña()));
        } catch (Exception ex) {
            Logger.getLogger(ClienteDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        cmd.setString("p_nombreUsuario", modelo.getNombreUsuario());
        cmd.setString("p_correo", modelo.getCorreo());
        cmd.setString("p_telefono", modelo.getTelefono());
        cmd.registerOutParameter("p_id", Types.INTEGER);
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoActualizar(Connection conn, Cliente modelo) throws SQLException {
        String sql = "{call modificarCliente(?, ?, ?, ?, ?, ?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        
        cmd.setInt("p_id", modelo.getIdCliente());
        cmd.setString("p_nombre", modelo.getNombre());
        try {
            cmd.setString("p_contraseña", Crypto.encrypt(modelo.getContraseña()));
        } catch (Exception ex) {
            Logger.getLogger(ClienteDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        cmd.setString("p_nombreUsuario", modelo.getNombreUsuario());
        cmd.setString("p_correo", modelo.getCorreo());
        cmd.setString("p_telefono", modelo.getTelefono());
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoEliminar(Connection conn, Integer id) throws SQLException {
        String sql = "{call eliminarCliente(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", id);
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoLeer(Connection conn, Integer id) throws SQLException {
        String sql = "{call buscarClientePorId(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_id", id);
        
        return cmd;
    }

    @Override
    protected PreparedStatement comandoLeerTodos(Connection conn) throws SQLException {
        String sql = "{call listarClientes()}";
        CallableStatement cmd = conn.prepareCall(sql);
        
        return cmd;    
    }

    @Override
    protected Cliente mapearModelo(ResultSet rs) throws SQLException {
        Cliente modelo = new Cliente();
        
        modelo.setIdCliente(rs.getInt("idCliente"));
        modelo.setNombre(rs.getString("nombre"));
        try {
            modelo.setContraseña(Crypto.decrypt(rs.getString("contraseña")));
        } catch (Exception ex) {
            Logger.getLogger(ClienteDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        modelo.setNombreUsuario(rs.getString("nombreUsuario"));
        modelo.setCorreo(rs.getString("correo"));
        modelo.setTelefono(rs.getString("telefono"));
        
        return modelo;    
    }
    
    protected PreparedStatement comandoLogin(Connection conn, String correo, 
            String contraseña) throws SQLException {
        String sql = "{call loginCliente(?, ?, ?)}";
        
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setString("p_correo", correo);
        try {
            cmd.setString("p_contraseña", Crypto.encrypt(contraseña));
        } catch (Exception ex) {
            Logger.getLogger(ClienteDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        cmd.registerOutParameter("p_valido", Types.BOOLEAN);
        
        return cmd;
    }

    @Override
    public boolean login(String correo, String contraseña) {
        return ejecutarComando(conn -> {
            try (PreparedStatement cmd = this.comandoLogin(conn, correo, contraseña)) {
                if (cmd instanceof CallableStatement callableCmd) {
                    callableCmd.execute();
                    boolean valido = callableCmd.getBoolean("p_valido");
                    
                    if (!valido) {
                        System.err.println("No se encontro el registro con "
                            + "correo: " + correo + ", password");
                    }
                    return valido;
                }
                return false;
            }
        });
    }

    protected PreparedStatement comandoBuscarPorCorreo(
            Connection conn, String correo) 
            throws SQLException {
        
        String sql = "{call buscarClientePorCorreo(?)}";
        
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setString("p_correo", correo);
        
        return cmd;
    }
    
    @Override
    public Cliente buscarClientePorCorreo(String correo) {
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
        
        String sql = "{call buscarClienteIdPorCorreo(?)}";
        
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setString("p_correo", correo);
        
        return cmd;
    }

    @Override
    public Integer buscarClienteIdPorCorreo(String correo) {
        return ejecutarComando(conn -> {
            try (PreparedStatement cmd = this.comandoBuscarIdPorCorreo(conn, correo)) {
                ResultSet rs = cmd.executeQuery();

                if (!rs.next()) {
                    System.err.println("No se encontro el registro con "
                            + "correo: " + correo);
                    return 0;
                }

                return rs.getInt(1);
            }
        });
    }
    
    private Cupon mapearCupon(ResultSet rs) throws SQLException {
        Cupon cupon = new Cupon();

        cupon.setIdCupon(rs.getInt("idCupon"));
        cupon.setCodigo(rs.getString("codigo"));
        cupon.setDescuento(rs.getDouble("descuento"));
        cupon.setFechaCaducidad(rs.getTimestamp("fechaCaducidad")); 
        cupon.setActivo(rs.getBoolean("activo"));
        cupon.setUsosRestantes(rs.getInt("usosRestantes"));

        return cupon;
    }
    
    protected PreparedStatement comandoObtenerCuponesPorCliente(Connection conn, int idCliente)
        throws SQLException {

        String sql = "{call obtenerCuponesPorCliente(?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_idCliente", idCliente);
        return cmd;
    }
    
    @Override
    public List<Cupon> obtenerCuponesPorCliente(int idCliente) {
        return ejecutarComando(conn -> {
            try (PreparedStatement cmd = this.comandoObtenerCuponesPorCliente(conn, idCliente)) {
                ResultSet rs = cmd.executeQuery();

                List<Cupon> lista = new ArrayList<>();

                while (rs.next()) {
                    lista.add(mapearCupon(rs));
                }

                return lista;
            }
        });
    }
}
