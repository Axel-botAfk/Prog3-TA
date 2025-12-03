package pe.edu.pucp.campusstorews;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.util.List;
import pe.edu.pucp.campusstore.bo.CuponBO;
import pe.edu.pucp.campusstore.boimpl.CuponBOImpl;
import pe.edu.pucp.campusstore.modelo.Cupon;
import pe.edu.pucp.campusstore.modelo.enums.Estado;


@WebService(
        serviceName = "CuponWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class CuponWS {
    private final CuponBO cuponBO;
    
    public CuponWS() {
        this.cuponBO = new CuponBOImpl();
    }
    
    @WebMethod(operationName = "listarCupones")
    public List<Cupon> listarCupones() throws InterruptedException{
        return this.cuponBO.listar();
    }
    
    @WebMethod(operationName = "obtenerCupon")
    public Cupon obtenerCupon(
        @WebParam(name = "id") int id
    ) throws InterruptedException {
        return this.cuponBO.obtener(id);
    }
    
    @WebMethod(operationName = "eliminarCupon")
    public void eliminarCupon(
        @WebParam(name = "id") int id
    ) throws InterruptedException {
        this.cuponBO.obtener(id);
    }
    
    @WebMethod(operationName = "guardarCupon")
    public void guardarCupon(
        @WebParam(name = "cupon") Cupon modelo, 
        @WebParam(name = "estado") Estado estado
    ) throws InterruptedException {
        this.cuponBO.guardar(modelo, Estado.Nuevo);
    }
    
    @WebMethod(operationName = "buscarCuponPorCodigo")
    public Cupon buscarCuponPorCodigo(
        @WebParam(name = "codigo") String codigo
    ) {
        return this.cuponBO.buscarPorCodigo(codigo);
    }
    
    @WebMethod(operationName = "verificarCuponUsado")
    public boolean verificarCuponUsado(
        @WebParam(name = "idCupon") int idCupon,
        @WebParam(name = "idCliente") int idCliente
    ) {
        return this.cuponBO.verificarCuponUsado(idCupon, idCliente);
    }
}
