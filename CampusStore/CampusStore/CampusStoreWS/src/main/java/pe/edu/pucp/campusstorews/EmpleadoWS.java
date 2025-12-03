package pe.edu.pucp.campusstorews;


import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.util.List;
import pe.edu.pucp.campusstore.bo.EmpleadoBO;
import pe.edu.pucp.campusstore.boimpl.EmpleadoBOImpl;
import pe.edu.pucp.campusstore.modelo.Empleado;
import pe.edu.pucp.campusstore.modelo.enums.Estado;

@WebService(
        serviceName = "EmpleadoWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class EmpleadoWS {
    private final EmpleadoBO empleadoBO;
    
    public EmpleadoWS(){
        this.empleadoBO = new EmpleadoBOImpl();
    }
    
    @WebMethod(operationName = "listarEmpleados")
    public List<Empleado> listarEmpleados(){
        return this.empleadoBO.listar();
    }
    
    @WebMethod(operationName = "obtenerEmpleado")
    public Empleado obtenerEmpleado(
        @WebParam(name = "id") int id
    )  {
        return this.empleadoBO.obtener(id);
    }
    
    @WebMethod(operationName = "eliminarEmpleado")
    public void eliminarEmpleado(
        @WebParam(name = "id") int id
    ){
        this.empleadoBO.eliminar(id);
    }
    
    @WebMethod(operationName = "guardarEmpleado")
    public void guardarEmpleado(
        @WebParam(name = "empleado") Empleado modelo, 
        @WebParam(name = "estado") Estado estado
    )  {
        
        this.empleadoBO.guardar(modelo, estado);
    }
}
