package pe.edu.pucp.campusstorews;

import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.io.IOException;
import java.util.List;
import pe.edu.pucp.campusstore.modelo.Cliente;
import pe.edu.pucp.campusstore.bo.ClienteBO;
import pe.edu.pucp.campusstore.boimpl.ClienteBOImpl;
import pe.edu.pucp.campusstore.modelo.enums.Estado;

@WebService(
        serviceName = "ClienteWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class ClienteWS {

    private final ClienteBO clienteBO;
    
    public ClienteWS() {
        this.clienteBO = new ClienteBOImpl();
    }
    
    @WebMethod(operationName = "listarClientes")
    public List<Cliente> listarClientes()throws IOException, InterruptedException{
        return this.clienteBO.listar();
    }
    
    @WebMethod(operationName = "obtenerCliente")
    public Cliente obtenerCliente(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        return this.clienteBO.obtener(id);
    }
    
    @WebMethod(operationName = "eliminarCliente")
    public void eliminarCliente(
        @WebParam(name = "id") int id
    ) throws IOException, InterruptedException {
        this.clienteBO.eliminar(id);
    }
    
    @WebMethod(operationName = "guardarCliente")
    public void guardarCliente(
        @WebParam(name = "cliente") Cliente modelo, 
        @WebParam(name = "estado") Estado estado
    ) throws IOException, InterruptedException {
        this.clienteBO.guardar(modelo, estado);
    }
    
    @WebMethod(operationName = "buscarClientePorCuenta")
    public Cliente buscarClientePorCuenta(@WebParam(name = "cuenta") String cuenta) {
        return this.clienteBO.buscarPorCuenta(cuenta);
    }
}

