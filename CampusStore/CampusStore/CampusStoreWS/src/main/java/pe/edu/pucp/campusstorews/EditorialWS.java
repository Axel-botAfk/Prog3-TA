package pe.edu.pucp.campusstorews;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.util.List;
import pe.edu.pucp.campusstore.bo.EditorialBO;
import pe.edu.pucp.campusstore.boimpl.EditorialBOImpl;
import pe.edu.pucp.campusstore.modelo.Editorial;
import pe.edu.pucp.campusstore.modelo.enums.Estado;

@WebService(
        serviceName = "EditorialWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class EditorialWS {
    private final EditorialBO editorialBO;
    
    public EditorialWS() {
        this.editorialBO = new EditorialBOImpl();
    }
    
    @WebMethod(operationName = "listarEditoriales")
    public List<Editorial> listarEditoriales() {
        return this.editorialBO.listar();
    }
    
    @WebMethod(operationName = "obtenerEditorial")
    public Editorial obtenerEditorial(
        @WebParam(name = "id") int id
    ) {
        return this.editorialBO.obtener(id);
    }
    
    @WebMethod(operationName = "eliminarEditorial")
    public void eliminarEditorial(
        @WebParam(name = "id") int id
    ) {
        this.editorialBO.eliminar(id);
    }
    
    @WebMethod(operationName = "guardarEditorial")
    public void guardarEditorial(
        @WebParam(name = "editorial") Editorial modelo, 
        @WebParam(name = "estado") Estado estado
    ) {
        this.editorialBO.guardar(modelo, estado);
    }
}
