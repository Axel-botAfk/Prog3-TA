package pe.edu.pucp.campusstorews;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import jakarta.xml.bind.annotation.XmlSeeAlso;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;
import java.util.ResourceBundle;
import pe.edu.pucp.campusstore.bo.OrdenCompraBO;
import pe.edu.pucp.campusstore.boimpl.OrdenCompraBOImpl;
import pe.edu.pucp.campusstore.modelo.OrdenCompra;
import pe.edu.pucp.campusstore.modelo.LineaCarrito;
import pe.edu.pucp.campusstore.modelo.Articulo;
import pe.edu.pucp.campusstore.modelo.Libro;
import pe.edu.pucp.campusstore.modelo.enums.Estado;

@WebService(
        serviceName = "OrdenCompraWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
@XmlSeeAlso({Articulo.class, Libro.class})
public class OrdenCompraWS {
    private final OrdenCompraBO ordenCompraBO;
    
    public OrdenCompraWS() {
        this.ordenCompraBO = new OrdenCompraBOImpl();
    }
    
    @WebMethod(operationName = "listarOrdenesCompra")
    public List<OrdenCompra> listarOrdenesCompra()throws IOException, InterruptedException{
        return this.ordenCompraBO.listar();
    }
    
    @WebMethod(operationName = "obtenerOrdenCompra")
    public OrdenCompra obtenerOrdenCompra(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        return this.ordenCompraBO.obtener(id);
    }
    
    @WebMethod(operationName = "eliminarOrdenCompra")
    public void eliminarOrdenCompra(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        this.ordenCompraBO.eliminar(id);
    }
    
    @WebMethod(operationName = "guardarOrdenCompra")
    public void guardarOrdenCompra(
        @WebParam(name = "ordenCompra") OrdenCompra modelo, 
        @WebParam(name = "estado") Estado estado
    ) throws IOException, InterruptedException {
        
        this.ordenCompraBO.guardar(modelo, estado);
    }
    
    @WebMethod(operationName = "listarOrdenesPorCliente")
    public List<OrdenCompra> listarOrdenesPorCliente(
        @WebParam(name = "idCliente") int idCliente
    ) {
        return this.ordenCompraBO.listarPorCliente(idCliente);
    }
    
    @WebMethod(operationName = "contarProductosCarrito")
    public int contarProductosCarrito(
        @WebParam(name = "idCarrito") int idCarrito
    ) {
        return this.ordenCompraBO.contarProductosCarrito(idCarrito);
    }
    
    @WebMethod(operationName = "listarArticulosCarrito")
    public List<LineaCarrito> listarArticulosCarrito(
        @WebParam(name = "idCarrito") int idCarrito
    ) {
        return this.ordenCompraBO.listarArticulosCarrito(idCarrito);
    }

    @WebMethod(operationName = "listarLibrosCarrito")
    public List<LineaCarrito> listarLibrosCarrito(
        @WebParam(name = "idCarrito") int idCarrito
    ) {
        return this.ordenCompraBO.listarLibrosCarrito(idCarrito);
    }

    @WebMethod(operationName = "cancelarOrdenesExpiradas")
    public int cancelarOrdenesExpiradas() {
        return this.ordenCompraBO.cancelarOrdenesExpiradas();
    }
}
