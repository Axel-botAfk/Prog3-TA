package pe.edu.pucp.campusstore.daoimpl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import pe.edu.pucp.campusstore.bases.dao.TransaccionalBaseModeloDAO;
import pe.edu.pucp.campusstore.dao.AutorLibroDAO;
import pe.edu.pucp.campusstore.modelo.Autor;
import pe.edu.pucp.campusstore.modelo.AutoresLibro;
import pe.edu.pucp.campusstore.modelo.Libro;

public class AutorLibroDAOImpl extends TransaccionalBaseModeloDAO<AutoresLibro> implements AutorLibroDAO {

    @Override
    protected PreparedStatement comandoCrear(Connection conn, AutoresLibro modelo) throws SQLException {
        String sql = "{call insertarAutorLibro(?, ?, ?)}";
        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_idLibro", modelo.getLibro().getIdLibro());
        cmd.setInt("p_idAutor", modelo.getAutor().getIdAutor());
        cmd.registerOutParameter("p_id", Types.INTEGER);
        return cmd;
    }

    @Override
    protected PreparedStatement comandoActualizar(Connection conn, AutoresLibro modelo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected PreparedStatement comandoEliminar(Connection conn, AutoresLibro modelo) throws SQLException {
        String sql = "{call eliminarAutorLibro(?, ?)}";

        CallableStatement cmd = conn.prepareCall(sql);
        cmd.setInt("p_idLibro", modelo.getLibro().getIdLibro());
        cmd.setInt("p_idAutor", modelo.getAutor().getIdAutor());

        return cmd;
    }

    @Override
    protected PreparedStatement comandoLeer(Connection conn, AutoresLibro modelo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected PreparedStatement comandoLeerTodos(Connection conn, AutoresLibro modelo) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    protected AutoresLibro mapearModelo(ResultSet rs) throws SQLException {
        AutoresLibro autoresLibro = new AutoresLibro();
        Libro libroAux = new Libro();
        libroAux.setIdLibro(rs.getInt("LIBRO_idLibro"));
        autoresLibro.setLibro(libroAux);
        Autor autorAux = new Autor();
        autorAux.setIdAutor(rs.getInt("AUTOR_idAutor"));
        autoresLibro.setAutor(autorAux);

        return autoresLibro;
    }

}
