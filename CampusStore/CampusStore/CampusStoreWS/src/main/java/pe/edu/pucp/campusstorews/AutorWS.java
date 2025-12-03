package pe.edu.pucp.campusstorews;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.io.IOException;
import java.util.List;
import pe.edu.pucp.campusstore.bo.AutorBO;
import pe.edu.pucp.campusstore.boimpl.AutorBOImpl;
import pe.edu.pucp.campusstore.modelo.Autor;
import pe.edu.pucp.campusstore.modelo.enums.Estado;

@WebService(
        serviceName = "AutorWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class AutorWS {
    private final AutorBO autorBO;
    
    public AutorWS() {
        this.autorBO = new AutorBOImpl();
    }
    
    @WebMethod(operationName = "listarAutores")
    public List<Autor> listarAutores() 
            throws IOException, InterruptedException{
        return this.autorBO.listar();
    }
    
    @WebMethod(operationName = "obtenerAutor")
    public Autor obtenerAutor(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        return this.autorBO.obtener(id);
    }
    
    @WebMethod(operationName = "eliminarAutor")
    public void eliminarAutor(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        this.autorBO.eliminar(id);
    }
    
    @WebMethod(operationName = "guardarAutor")
    public void guardarAutor(
        @WebParam(name = "autor") Autor modelo, 
        @WebParam(name = "estado") Estado estado
    ) throws IOException, InterruptedException {
        
        this.autorBO.guardar(modelo, estado);
    }
}
