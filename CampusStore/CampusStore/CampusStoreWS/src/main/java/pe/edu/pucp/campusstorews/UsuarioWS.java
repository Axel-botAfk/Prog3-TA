package pe.edu.pucp.campusstorews;

import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import jakarta.jws.WebService;
import java.io.IOException;
import pe.edu.pucp.campusstore.bo.UsuarioBO;
import pe.edu.pucp.campusstore.boimpl.UsuarioBOImpl;
import pe.edu.pucp.campusstore.boimpl.utils.LoginResponse;

@WebService(
        serviceName = "UsuarioWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class UsuarioWS {
    private final UsuarioBO usuarioBO;
    
    public UsuarioWS(){
        this.usuarioBO = new UsuarioBOImpl();
    }
    
    @WebMethod(operationName = "loginUsuario")
    public LoginResponse login(
        @WebParam(name = "correo") String correo, 
        @WebParam(name = "contraseña") String contraseña
    ) throws IOException, InterruptedException {
        return this.usuarioBO.login(correo, contraseña);
    }
    
}
