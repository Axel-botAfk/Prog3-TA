package pe.edu.pucp.campusstorews;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.util.List;
import pe.edu.pucp.campusstore.bo.DescuentoBO;
import pe.edu.pucp.campusstore.boimpl.DescuentoBOImpl;
import pe.edu.pucp.campusstore.modelo.Descuento;
import pe.edu.pucp.campusstore.modelo.enums.Estado;
import pe.edu.pucp.campusstore.modelo.enums.TipoProducto;

@WebService(
        serviceName = "DescuentoWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class DescuentoWS {    
    private final DescuentoBO descuentoBO;
    
    public DescuentoWS() {
        this.descuentoBO = new DescuentoBOImpl();
    }
    
    @WebMethod(operationName = "listarDescuentos")
    public List<Descuento> listarDescuentos(
            @WebParam(name = "descuento") Descuento descuento
    )  throws InterruptedException {
        return this.descuentoBO.listar(descuento);
    }
    
    @WebMethod(operationName = "obtenerDescuento")
    public Descuento obtenerDescuento(
        @WebParam(name = "descuento") Descuento descuento
    ) throws InterruptedException {
        return this.descuentoBO.obtener(descuento);
    }
    
    @WebMethod(operationName = "eliminarDescuento")
    public void eliminarDescuento(
        @WebParam(name = "descuento") Descuento descuento
    ) throws InterruptedException {
        this.descuentoBO.eliminar(descuento);
    }
    
    @WebMethod(operationName = "guardarDescuento")
    public void guardarDescuento(
        @WebParam(name = "descuento") Descuento modelo, 
        @WebParam(name = "estado") Estado estado
    ) throws InterruptedException {
        this.descuentoBO.guardar(modelo, estado);
    }
    
    @WebMethod(operationName = "obtenerDescuentoPorProducto")
    public Descuento obtenerDescuentoPorProducto(
        @WebParam(name = "idProducto") int idProducto,
        @WebParam(name= "tipoProducto") TipoProducto tipoProducto
    ) {
        return this.descuentoBO.obtenerDescuentoPorProducto(idProducto, tipoProducto);
    }
}
