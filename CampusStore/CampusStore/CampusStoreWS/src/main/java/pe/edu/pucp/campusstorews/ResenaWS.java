package pe.edu.pucp.campusstorews;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.io.IOException;
import java.util.List;
import pe.edu.pucp.campusstore.modelo.Reseña;
import pe.edu.pucp.campusstore.bo.ReseñaBO;
import pe.edu.pucp.campusstore.boimpl.ReseñaBOImpl;
import pe.edu.pucp.campusstore.modelo.enums.Estado;
import pe.edu.pucp.campusstore.modelo.enums.TipoProducto;

@WebService(
        serviceName = "ResenaWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class ResenaWS {
    private final ReseñaBO reseñaBO;
    
    public ResenaWS() {
        this.reseñaBO = new ReseñaBOImpl();
    }
    
    @WebMethod(operationName = "listarResenas")
    public List<Reseña> listarResenas(
        @WebParam(name = "Reseña") Reseña modelo
    ) throws IOException, InterruptedException {

        return this.reseñaBO.listar(modelo);
    }
    
    @WebMethod(operationName = "listarResenasPorProducto")
    public List<Reseña> listarResenasPorProducto(
        @WebParam(name = "tipoProducto") TipoProducto tipoProducto,
        @WebParam(name = "idProducto") int idProducto
    ) {
        return this.reseñaBO.listarPorProducto(tipoProducto, idProducto);
    }
    
    @WebMethod(operationName = "obtenerResena")
    public Reseña obtenerResena(
        @WebParam(name = "Reseña") Reseña modelo
    ) throws IOException, InterruptedException {
        return this.reseñaBO.obtener(modelo);
    }
    
    @WebMethod(operationName = "eliminarResena")
    public void eliminarResena(
        @WebParam(name = "Reseña") Reseña modelo
    ) throws IOException, InterruptedException {
        this.reseñaBO.eliminar(modelo);
    }
    
    @WebMethod(operationName = "guardarResena")
    public void guardarResena(
        @WebParam(name = "resena") Reseña modelo, 
        @WebParam(name = "estado") Estado estado
    ) throws IOException, InterruptedException {
        this.reseñaBO.guardar(modelo, estado);
    }
    
    @WebMethod(operationName = "obtenerPromedioCalificacion")
    public Double obtenerPromedioCalificacion(
        @WebParam(name = "tipoProducto") TipoProducto tipoProducto,
        @WebParam(name = "idProducto") int idProducto
    ) {
        return this.reseñaBO.obtenerPromedioCalificacion(tipoProducto, idProducto);
    }
    
    @WebMethod(operationName = "obtenerTotalResenas")
    public int obtenerTotalResenas(
        @WebParam(name = "tipoProducto") TipoProducto tipoProducto,
        @WebParam(name = "idProducto") int idProducto
    ) {
        Integer total = this.reseñaBO.obtenerTotalResenas(tipoProducto, idProducto);
        return total != null ? total : 0;
    }
}

