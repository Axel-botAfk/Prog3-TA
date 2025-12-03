package pe.edu.pucp.campusstorews;


import jakarta.jws.WebService;
import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import java.util.List;
import pe.edu.pucp.campusstore.modelo.Libro;
import pe.edu.pucp.campusstore.bo.LibroBO;
import pe.edu.pucp.campusstore.boimpl.LibroBOImpl;
import pe.edu.pucp.campusstore.modelo.Autor;
import pe.edu.pucp.campusstore.modelo.enums.Estado;

@WebService(
        serviceName = "LibroWS",
        targetNamespace = "http://services.campusstore.pucp.edu.pe/")
public class LibroWS {

    private final LibroBO libroBO;



    public LibroWS() {
        this.libroBO = new LibroBOImpl();
    }

    @WebMethod(operationName = "listarLibros")
    public List<Libro> listarLibros()  {
        return this.libroBO.listar();
    }

//    @WebMethod(operationName = "listarLibros")
//    public List<Libro> listarLibros() throws IOException, InterruptedException {
//        String url = this.urlBase + "/" + this.NOMBRE_RESOURCE;
//        HttpRequest request = HttpRequest.newBuilder()
//                .uri(URI.create(url))
//                .GET()
//                .build();
//
//        HttpResponse<String> response
//                = client.send(request, HttpResponse.BodyHandlers.ofString());
//
//        int status = response.statusCode();
//        String json = response.body();
//
//        if (status < 200 || status >= 300) {
//            // Manejo básico de error, puedes refinarlo
//            throw new RuntimeException("Error al llamar al API REST /libros. Status: "
//                    + status + " Body: " + json);
//        }
//
//        ObjectMapper mapper = crearMapperLibros();
//        List<Libro> modelo
//                = mapper.readValue(json, new TypeReference<List<Libro>>() {
//                });
//
//        return modelo;
//    }
    @WebMethod(operationName = "obtenerLibro")
    public Libro obtenerLibro(
            @WebParam(name = "id") int id
    )  {
        return this.libroBO.obtener(id);
    }

    @WebMethod(operationName = "eliminarLibro")
    public void eliminarLibro(
            @WebParam(name = "id") int id
    )  {
        this.libroBO.eliminar(id);
    }

    @WebMethod(operationName = "guardarLibro")
    public void guardarLibro(
            @WebParam(name = "libro") Libro modelo,
            @WebParam(name = "estado") Estado estado
    )  {
        this.libroBO.guardar(modelo, estado);
    }

    @WebMethod(operationName = "registrarLibro")
    public Integer registrarLibro(
            @WebParam(name = "libro") Libro libro,
            @WebParam(name = "autores") List<Autor> autores) {
        return this.libroBO.registrarLibro(libro, autores);
    }

    @WebMethod(operationName = "leerAutoresPorLibro")
    public List<Autor> leerAutoresPorLibro(
            @WebParam(name = "idLibro") int idLibro
    ) {
        return this.libroBO.leerAutoresPorLibro(idLibro);
    }

    @WebMethod(operationName = "modificarLibroConAutores")
    public void modificarLibroConAutores(
        @WebParam(name = "libro") Libro libro,
        @WebParam(name = "autores") List<Autor> autores
    ) {
        this.libroBO.modificarConAutores(libro, autores);
    }

}
