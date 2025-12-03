package pe.edu.pucp.campusstore.bo;

import java.util.List;
import pe.edu.pucp.campusstore.modelo.Autor;
import pe.edu.pucp.campusstore.modelo.Libro;

public interface LibroBO extends Gestionable<Libro>{
    Integer registrarLibro(Libro libro, List<Autor> autores);
    List<Autor> leerAutoresPorLibro(int idLibro);
    void modificarConAutores(Libro libro, List<Autor> autores);
}
