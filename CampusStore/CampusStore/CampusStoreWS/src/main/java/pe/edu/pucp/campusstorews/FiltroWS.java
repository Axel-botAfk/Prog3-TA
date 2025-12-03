
package pe.edu.pucp.campusstorews;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.util.List;
import pe.edu.pucp.campusstore.bo.FiltroBO;
import pe.edu.pucp.campusstore.boimpl.FiltroBOImpl;
import pe.edu.pucp.campusstore.modelo.Articulo;
import pe.edu.pucp.campusstore.modelo.Libro;

@WebService(serviceName = "FiltroWS",
            targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class FiltroWS {
    
    private final FiltroBO filtroBO;
    
    public FiltroWS(){
        this.filtroBO = new FiltroBOImpl();
    }
    @WebMethod(operationName = "filtrarPorTipoArticulo")
    public List<Articulo> filtrarPorTipoArticulo(@WebParam(name = "tipoArticulo") String tipoArticulo) {
        return this.filtroBO.filtrarPorTipoArticulo(tipoArticulo);
    }
    
    @WebMethod(operationName = "filtrarLibros")
    public List<Libro> filtrarLibros(@WebParam(name = "autores") List<Integer> autores,
            @WebParam(name = "editoriales") List<Integer> editoriales,
            @WebParam(name = "genero") List<String> genero) {
        return this.filtroBO.filtrarLibros(autores, editoriales, genero);
    }
}
