/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package pe.edu.pucp.campusstore.daoimpl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.logging.Level;
import java.util.logging.Logger;
import pe.edu.pucp.campusstore.bases.dao.BaseDAO;
import pe.edu.pucp.campusstore.dao.UsuarioDAO;
import pe.edu.pucp.campusstore.modelo.Usuario;
import utils.Crypto;

/**
 *
 * @author mibb8
 */
public class UsuarioDAOImpl extends BaseDAO<Usuario> implements UsuarioDAO{

    @Override
    protected PreparedStatement comandoCrear(Connection conn, Usuario modelo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected PreparedStatement comandoActualizar(Connection conn, Usuario modelo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected PreparedStatement comandoEliminar(Connection conn, Integer id) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected PreparedStatement comandoLeer(Connection conn, Integer id) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected PreparedStatement comandoLeerTodos(Connection conn) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected Usuario mapearModelo(ResultSet rs) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    protected PreparedStatement comandoLogin(Connection conn, String correo, 
            String contraseña) throws SQLException {
        String sql = "{call loginUsuario(?, ?, ?)}";
        
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setString("p_correo", correo);
        try {
            cmd.setString("p_contraseña", Crypto.encrypt(contraseña));
        } catch (Exception ex) {
            Logger.getLogger(UsuarioDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        cmd.registerOutParameter("p_tipoUsuario", Types.VARCHAR);
        
        return cmd;
    }

    @Override
    public String login(String correo, String contraseña) {
        return ejecutarComando(conn -> {
            try (PreparedStatement cmd = this.comandoLogin(conn, correo, contraseña)) {
                if (cmd instanceof CallableStatement callableCmd) {
                    callableCmd.execute();
                    String tipoUsuario = callableCmd.getString("p_tipoUsuario");
                    
                    if (tipoUsuario.contains("INVALIDO")) {
                        System.err.println("No se encontro el registro con "
                            + "correo: " + correo + ", password");
                    }
                    return tipoUsuario;
                }
                return "INVALIDO";
            }
        });
    }
    
}
