package pe.edu.pucp.campusstorews;

import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import jakarta.jws.WebService;
import java.io.IOException;
import java.util.List;
import pe.edu.pucp.campusstore.bo.CarritoBO;
import pe.edu.pucp.campusstore.boimpl.CarritoBOImpl;
import pe.edu.pucp.campusstore.modelo.Carrito;
import pe.edu.pucp.campusstore.modelo.LineaCarrito;
import pe.edu.pucp.campusstore.modelo.enums.Estado;

@WebService(
        serviceName = "CarritoWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class CarritoWS {
    private final CarritoBO carritoBO;
    
    public CarritoWS() {
        this.carritoBO = new CarritoBOImpl();
    }
    
    @WebMethod(operationName = "listarCarritos")
    public List<Carrito> listarCarritos()
        throws IOException, InterruptedException{
        return this.carritoBO.listar();
    }
    
    @WebMethod(operationName = "obtenerCarrito")
    public Carrito obtenerCarrito(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        return this.carritoBO.obtener(id);
    }
    
    @WebMethod(operationName = "eliminarCarrito")
    public void eliminarCarrito(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        this.carritoBO.eliminar(id);
    }
    
    @WebMethod(operationName = "eliminarLineaDelCarrito")
    public boolean eliminarLineaDelCarrito(
        @WebParam(name = "lineaCarrito") LineaCarrito lineaCarrito
    ) {
        return this.carritoBO.eliminarLineaCarrito(lineaCarrito);
    }
    
    @WebMethod(operationName = "guardarCarrito")
    public void guardarCarrito(
        @WebParam(name = "carrito") Carrito modelo, 
        @WebParam(name = "estado") Estado estado
    ) throws IOException, InterruptedException {
        
        this.carritoBO.guardar(modelo, estado);
    }
    
    @WebMethod(operationName = "obtenerCarritoPorCliente")
    public Carrito obtenerCarritoPorCliente(
        @WebParam(name = "id") int id
    ) {
        return this.carritoBO.obtenerCarritoPorCliente(id);
    }
    
    @WebMethod(operationName = "aplicarCuponACarrito")
    public boolean aplicarCuponACarrito(
        @WebParam(name = "idCupon") int idCupon,
        @WebParam(name = "idCliente") int idCliente,
        @WebParam(name = "idCarrito") int idCarrito
    ) {
        return this.carritoBO.aplicarCuponACarrito(idCupon, idCliente, idCarrito);
    }
}
