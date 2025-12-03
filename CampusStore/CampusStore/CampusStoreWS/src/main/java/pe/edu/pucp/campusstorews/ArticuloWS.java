package pe.edu.pucp.campusstorews;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.io.IOException;
import java.util.List;
import pe.edu.pucp.campusstore.bo.ArticuloBO;
import pe.edu.pucp.campusstore.boimpl.ArticuloBOImpl;
import pe.edu.pucp.campusstore.modelo.Articulo;
import pe.edu.pucp.campusstore.modelo.enums.Estado;

@WebService(
        serviceName = "ArticuloWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class ArticuloWS {
    private final ArticuloBO articuloBO;
    
    public ArticuloWS() {
        this.articuloBO = new ArticuloBOImpl();
    }
    
    @WebMethod(operationName = "listarArticulos")
    public List<Articulo> listarArticulos()
        throws IOException, InterruptedException{
        return this.articuloBO.listar();
    }
    
    @WebMethod(operationName = "obtenerArticulo")
    public Articulo obtenerArticulo(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        return this.articuloBO.obtener(id);
    }
    
    @WebMethod(operationName = "eliminarArticulo")
    public void eliminarArticulo(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        this.articuloBO.eliminar(id);
    }
    
    @WebMethod(operationName = "guardarArticulo")
    public void guardarArticulo(
        @WebParam(name = "articulo") Articulo modelo, 
        @WebParam(name = "estado") Estado estado
    ) throws IOException, InterruptedException {
        
        this.articuloBO.guardar(modelo, estado);
    }
}
