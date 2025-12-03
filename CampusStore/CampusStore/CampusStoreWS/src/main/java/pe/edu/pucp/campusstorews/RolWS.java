package pe.edu.pucp.campusstorews;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.io.IOException;
import java.util.List;
import pe.edu.pucp.campusstore.bo.RolBO;
import pe.edu.pucp.campusstore.boimpl.RolBOImpl;
import pe.edu.pucp.campusstore.modelo.Rol;
import pe.edu.pucp.campusstore.modelo.enums.Estado;


@WebService(
        serviceName = "RolWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class RolWS {
    private final RolBO rolBO;
    
    public RolWS() {
        this.rolBO = new RolBOImpl();
    }

    @WebMethod(operationName = "listarRoles")
    public List<Rol> listarRoles()throws IOException, InterruptedException{
        return this.rolBO.listar();
    }
    
    @WebMethod(operationName = "obtenerRol")
    public Rol obtenerRol(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        return this.rolBO.obtener(id);
    }
    
    @WebMethod(operationName = "eliminarRol")
    public void eliminarRol(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        this.rolBO.eliminar(id);
    }
    
    @WebMethod(operationName = "guardarRol")
    public void guardarRol(
        @WebParam(name = "rol") Rol modelo, 
        @WebParam(name = "estado") Estado estado
    ) throws IOException, InterruptedException {
        
        this.rolBO.guardar(modelo, estado);
    }
    
    @WebMethod(operationName = "guardarNuevoRolRetornaId")
    public Integer guardarNuevoRolRetornaId(Rol modelo){
        return this.rolBO.guardarNuevoRetornaId(modelo);
    }
    
}
