using CampusStoreWeb.CampusStoreWS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CampusStoreWeb
{
    public class ProductoDestacado
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public decimal Precio { get; set; }
        public string TipoProducto { get; set; }
        public string UrlImagen { get; set; }
        public int Stock { get; set; }
        public string Autor { get; set; }
        public string Descripcion { get; set; }
        public string TipoDeProducto { get; set; }
        public double PromedioCalificacion { get; set; }
        public int TotalResenas { get; set; }
    }

    public partial class Catalogo : System.Web.UI.Page
    {
       
        private string categoriaActual = "articulo"; // Por defecto muestra todos
        private static Random random = new Random();
        private readonly CarritoWSClient carritoWS;
        private readonly ClienteWSClient clienteWS;
        private readonly ResenaWSClient resenaWS;

        public Catalogo()
        {
            carritoWS = new CarritoWSClient();
            clienteWS = new ClienteWSClient();
            resenaWS = new ResenaWSClient();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool isAdmin = Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
            if (isAdmin)
            {
                Response.Redirect("GestionarEmpleados.aspx");
                return;
            }

            if (Session["ShowAddToCartAlert"] != null && (bool)Session["ShowAddToCartAlert"])
            {
                string script = "Swal.fire({ icon: 'success', title: '¡Añadido!', text: 'Producto agregado al carrito.', showConfirmButton: false, timer: 1500 });";
                ClientScript.RegisterStartupScript(this.GetType(), "addToCartAlert", script, true);
                Session["ShowAddToCartAlert"] = false;
            }

            // Manejar postback desde el modal
            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];
            
            if (eventTarget == "AddToCartFromModal" && !string.IsNullOrEmpty(eventArgument))
            {
                string[] args = eventArgument.Split(',');
                if (args.Length == 3)
                {
                    int productoId = int.Parse(args[0]);
                    string productoTipo = args[1];
                    int cantidad = int.Parse(args[2]);
                    AgregarAlCarrito(productoId, productoTipo, cantidad);
                }
            }

            if (!IsPostBack)
            {
                CargarProductosDestacados();
            }
        }

        // Método para obtener el total de reseñas del producto
        protected int GetTotalResenas()
        {
            if (rptProductosDestacados.Items.Count > 0)
            {
                RepeaterItem item = rptProductosDestacados.Items[rptProductosDestacados.Items.Count - 1];
                ProductoDestacado producto = item.DataItem as ProductoDestacado;
                if (producto != null)
                {
                    return producto.TotalResenas;
                }
            }
            return 0;
        }

        // Método para obtener el promedio de calificación del producto
        protected double GetPromedioCalificacion()
        {
            if (rptProductosDestacados.Items.Count > 0)
            {
                RepeaterItem item = rptProductosDestacados.Items[rptProductosDestacados.Items.Count - 1];
                ProductoDestacado producto = item.DataItem as ProductoDestacado;
                if (producto != null)
                {
                    return producto.PromedioCalificacion;
                }
            }
            return 0;
        }

        // Método para generar HTML de estrellas según la calificación
        protected string GetEstrellasCalificacion(double promedio, int totalResenas)
        {
            // Solo mostrar calificación si hay al menos 3 reseñas
            if (totalResenas < 3 || promedio <= 0)
            {
                return "<i class=\"bi bi-star\"></i><i class=\"bi bi-star\"></i><i class=\"bi bi-star\"></i><i class=\"bi bi-star\"></i><i class=\"bi bi-star\"></i>";
            }

            int estrellasLlenas = (int)Math.Floor(promedio);
            double decimalPart = promedio - estrellasLlenas;
            bool tieneMediaEstrella = decimalPart >= 0.25 && decimalPart < 0.75;

            System.Text.StringBuilder html = new System.Text.StringBuilder();

            // Estrellas llenas
            for (int i = 0; i < estrellasLlenas; i++)
            {
                html.Append("<i class=\"bi bi-star-fill\"></i>");
            }

            // Media estrella si aplica
            if (tieneMediaEstrella && estrellasLlenas < 5)
            {
                html.Append("<i class=\"bi bi-star-half\"></i>");
                estrellasLlenas++;
            }
            else if (decimalPart >= 0.75 && estrellasLlenas < 5)
            {
                // Si es >= 0.75, redondear hacia arriba
                html.Append("<i class=\"bi bi-star-fill\"></i>");
                estrellasLlenas++;
            }

            // Estrellas vacías
            for (int i = estrellasLlenas; i < 5; i++)
            {
                html.Append("<i class=\"bi bi-star\"></i>");
            }

            return html.ToString();
        }

        protected void FiltrarProductos_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            categoriaActual = btn.CommandArgument;

            // Actualizar clase activa
            lnkFiltroTodos.CssClass = "";
            lnkFiltroLibros.CssClass = "";
            lnkFiltroLapiceros.CssClass = "";
            lnkFiltroCuadernos.CssClass = "";
            lnkFiltroPeluches.CssClass = "";
            lnkFiltroTomatodos.CssClass = "";

            btn.CssClass = "active";

            CargarProductosDestacados();
        }

        private void CargarProductosDestacados()
        {
            var productosDestacados = new List<ProductoDestacado>();
            var cliente = new FiltroWSClient();

            try
            {
                if (categoriaActual == "articulo") // "Todos" - Combinar libros y artículos
                {
                    // Cargar libros
                    libro[] librosResult = cliente.filtrarLibros(new int[0], new int[0], new string[0]);
                    if (librosResult != null)
                    {
                        foreach (var lib in librosResult.OrderBy(l => l.idLibro))
                        {
                            var producto = new ProductoDestacado
                            {
                                Id = lib.idLibro,
                                Nombre = lib.nombre,
                                Precio = (decimal)lib.precio,
                                TipoProducto = "libro",
                                UrlImagen = lib.imagenURL
                            };
                            ObtenerCalificacionProducto(producto);
                            productosDestacados.Add(producto);
                        }
                    }

                    // Cargar artículos
                    articulo[] articulosResult = cliente.filtrarPorTipoArticulo(categoriaActual);
                    if (articulosResult != null)
                    {
                        foreach (var art in articulosResult.OrderBy(a => a.idArticulo))
                        {
                            var producto = new ProductoDestacado
                            {
                                Id = art.idArticulo,
                                Nombre = art.nombre,
                                Precio = (decimal)art.precio,
                                TipoProducto = art.tipoArticulo.ToString(),
                                UrlImagen = art.imagenURL
                            };
                            ObtenerCalificacionProducto(producto);
                            productosDestacados.Add(producto);
                        }
                    }

                    // Mezclar y tomar los primeros 5
                    productosDestacados = productosDestacados.OrderBy(x => random.Next()).Take(8).ToList();
                }
                else if (categoriaActual == "libro")
                {
                    // Cargar Top 5 de libros solamente
                    libro[] librosResult = cliente.filtrarLibros(new int[0], new int[0], new string[0]);

                    if (librosResult != null)
                    {
                        foreach (var lib in librosResult.OrderBy(l => l.idLibro).Take(5))
                        {
                            var producto = new ProductoDestacado
                            {
                                Id = lib.idLibro,
                                Nombre = lib.nombre,
                                Precio = (decimal)lib.precio,
                                TipoProducto = "libro",
                                UrlImagen = lib.imagenURL
                            };
                            ObtenerCalificacionProducto(producto);
                            productosDestacados.Add(producto);
                        }
                    }
                }
                else
                {
                    // Cargar Top 5 de artículos por tipo específico (LAPICERO, CUADERNO, etc.)
                    articulo[] articulosResult = cliente.filtrarPorTipoArticulo(categoriaActual);

                    if (articulosResult != null)
                    {
                        foreach (var art in articulosResult.OrderBy(a => a.idArticulo).Take(5))
                        {
                            var producto = new ProductoDestacado
                            {
                                Id = art.idArticulo,
                                Nombre = art.nombre,
                                Precio = (decimal)art.precio,
                                TipoProducto = categoriaActual,
                                UrlImagen = art.imagenURL
                            };
                            ObtenerCalificacionProducto(producto);
                            productosDestacados.Add(producto);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar productos destacados: " + ex.Message);
                productosDestacados.Clear();
            }

            rptProductosDestacados.DataSource = productosDestacados;
            rptProductosDestacados.DataBind();
        }

        private void ObtenerCalificacionProducto(ProductoDestacado producto)
        {
            try
            {
                CampusStoreWS.tipoProducto tipoEnum = producto.TipoProducto.ToLower() == "libro" 
                    ? CampusStoreWS.tipoProducto.LIBRO 
                    : CampusStoreWS.tipoProducto.ARTICULO;

                double promedio = resenaWS.obtenerPromedioCalificacion(tipoEnum, producto.Id);
                int total = resenaWS.obtenerTotalResenas(tipoEnum, producto.Id);

                producto.PromedioCalificacion = promedio;
                producto.TotalResenas = total;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error al obtener calificación para producto {producto.Id}: {ex.Message}");
                producto.PromedioCalificacion = 0;
                producto.TotalResenas = 0;
            }
        }

        protected void rptProductosDestacados_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                // El CommandArgument contiene "ID,TIPO" (ej: "123,libro")
                string[] args = e.CommandArgument.ToString().Split(',');
                if (args.Length == 2)
                {
                    int productoId = int.Parse(args[0]);
                    string productoTipo = args[1];

                    AgregarAlCarrito(productoId, productoTipo, 1);
                }
            }
        }

        [WebMethod]
        public static ProductoDestacado GetProductDetails(string tipo, int id)
        {
            try
            {
                if (tipo.ToLower() == "libro")
                {
                    var cliente = new LibroWSClient();
                    libro libroResult = cliente.obtenerLibro(id);
                    if (libroResult == null) return null;

                    return new ProductoDestacado
                    {
                        Id = libroResult.idLibro,
                        Nombre = libroResult.nombre,
                        Autor = (libroResult.autores != null && libroResult.autores.Length > 0) ? libroResult.autores[0].nombre : null,
                        Descripcion = libroResult.descripcion,
                        Precio = (decimal)libroResult.precio,
                        Stock = libroResult.stockReal,
                        UrlImagen = libroResult.imagenURL,
                        TipoProducto = "libro",
                        TipoDeProducto = "Libro"
                    };
                }
                else
                {
                    var cliente = new ArticuloWSClient();
                    articulo articuloResult = cliente.obtenerArticulo(id);
                    if (articuloResult == null) return null;

                    return new ProductoDestacado
                    {
                        Id = articuloResult.idArticulo,
                        Nombre = articuloResult.nombre,
                        Autor = null,
                        Descripcion = articuloResult.descripcion,
                        Precio = (decimal)articuloResult.precio,
                        Stock = articuloResult.stockReal,
                        UrlImagen = articuloResult.imagenURL,
                        TipoProducto = tipo,
                        TipoDeProducto = "Artículo"
                    };
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en WebMethod GetProductDetails: {ex.Message}");
                return null;
            }
        }

        private void AgregarAlCarrito(int productoId, string tipoProducto, int cantidad)
        {
            if (!Page.User.Identity.IsAuthenticated)
            {
                Response.Redirect($"SignIn.aspx?returnUrl={Server.UrlEncode(Request.RawUrl)}");
                return;
            }

            try
            {
                var clienteActual = clienteWS.buscarClientePorCuenta(Page.User.Identity.Name);
                if (clienteActual == null || clienteActual.idCliente <= 0)
                {
                    return;
                }
                clienteActual.idClienteSpecified = true;

                var carritoActual = carritoWS.obtenerCarritoPorCliente(clienteActual.idCliente);
                bool crearNuevoCarrito = carritoActual == null || carritoActual.completado;

                // Obtener datos del producto
                ProductoDestacado producto = null;
                if (tipoProducto.ToLower() == "libro")
                {
                    var libroWS = new LibroWSClient();
                    libro libroResult = libroWS.obtenerLibro(productoId);
                    if (libroResult != null)
                    {
                        producto = new ProductoDestacado
                        {
                            Id = libroResult.idLibro,
                            Nombre = libroResult.nombre,
                            Precio = (decimal)libroResult.precio,
                            TipoProducto = "libro",
                            Stock = libroResult.stockReal
                        };
                    }
                }
                else
                {
                    var articuloWS = new ArticuloWSClient();
                    articulo articuloResult = articuloWS.obtenerArticulo(productoId);
                    if (articuloResult != null)
                    {
                        producto = new ProductoDestacado
                        {
                            Id = articuloResult.idArticulo,
                            Nombre = articuloResult.nombre,
                            Precio = (decimal)articuloResult.precio,
                            TipoProducto = tipoProducto,
                            Stock = articuloResult.stockReal
                        };
                    }
                }

                if (producto == null || producto.Stock <= 0)
                {
                    return;
                }

                cantidad = Math.Max(1, cantidad);
                cantidad = Math.Min(cantidad, producto.Stock);

                if (crearNuevoCarrito)
                {
                    carritoActual = new carrito
                    {
                        cliente = clienteActual,
                        completado = false,
                        completadoSpecified = true,
                        fechaCreacion = DateTime.Now,
                        fechaCreacionSpecified = true,
                        lineas = Array.Empty<lineaCarrito>()
                    };
                    var nuevaLinea = CrearLineaCarrito(producto, cantidad);
                    carritoActual.lineas = new[] { nuevaLinea };
                    carritoWS.guardarCarrito(carritoActual, estado.Nuevo);
                }
                else
                {
                    var lineas = (carritoActual.lineas ?? Array.Empty<lineaCarrito>()).Where(l => l != null).ToList();
                    tipoProducto tipoEnum = tipoProducto.ToLower() == "libro" ? CampusStoreWS.tipoProducto.LIBRO : CampusStoreWS.tipoProducto.ARTICULO;
                    var lineaExistente = lineas.FirstOrDefault(l => EsMismoProducto(l, tipoEnum, productoId));

                    if (lineaExistente != null)
                    {
                        int nuevaCantidad = lineaExistente.cantidad + cantidad;
                        nuevaCantidad = Math.Min(nuevaCantidad, producto.Stock);
                        lineaExistente.cantidad = nuevaCantidad;
                        lineaExistente.cantidadSpecified = true;
                        lineaExistente.subtotal = lineaExistente.cantidad * lineaExistente.precioUnitario;
                        lineaExistente.subtotalSpecified = true;

                        if (lineaExistente.precioConDescuentoSpecified && lineaExistente.precioConDescuento > 0)
                        {
                            lineaExistente.subTotalConDescuento = lineaExistente.cantidad * lineaExistente.precioConDescuento;
                            lineaExistente.subTotalConDescuentoSpecified = true;
                        }
                    }
                    else
                    {
                        var nuevaLinea = CrearLineaCarrito(producto, cantidad);
                        lineas.Add(nuevaLinea);
                    }

                    carritoActual.lineas = lineas.ToArray();
                    carritoWS.guardarCarrito(carritoActual, estado.Modificado);
                }

                Session["ShowAddToCartAlert"] = true;
                Response.Redirect(Request.RawUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error al agregar al carrito: {ex.Message}");
            }
        }

        private lineaCarrito CrearLineaCarrito(ProductoDestacado producto, int cantidad)
        {
            var linea = new lineaCarrito
            {
                idLineaCarrito = 0,
                idLineaCarritoSpecified = true,
                cantidad = cantidad,
                cantidadSpecified = true,
                precioUnitario = (double)producto.Precio,
                precioUnitarioSpecified = true,
                subtotal = (double)producto.Precio * cantidad,
                subtotalSpecified = true,
                precioConDescuento = (double)producto.Precio,
                precioConDescuentoSpecified = true,
                subTotalConDescuento = (double)producto.Precio * cantidad,
                subTotalConDescuentoSpecified = true,
                tipoProducto = producto.TipoProducto.ToLower() == "libro" ? CampusStoreWS.tipoProducto.LIBRO : CampusStoreWS.tipoProducto.ARTICULO,
                tipoProductoSpecified = true
            };

            if (linea.tipoProducto == CampusStoreWS.tipoProducto.LIBRO)
            {
                linea.producto = new libro
                {
                    idLibro = producto.Id,
                    idLibroSpecified = true
                };
            }
            else
            {
                linea.producto = new articulo
                {
                    idArticulo = producto.Id,
                    idArticuloSpecified = true
                };
            }

            return linea;
        }

        private bool EsMismoProducto(lineaCarrito linea, CampusStoreWS.tipoProducto tipoEnum, int idProducto)
        {
            if (linea == null || linea.tipoProducto != tipoEnum)
            {
                return false;
            }

            if (tipoEnum == CampusStoreWS.tipoProducto.LIBRO && linea.producto is libro libroProd)
            {
                return libroProd.idLibroSpecified && libroProd.idLibro == idProducto;
            }

            if (tipoEnum == CampusStoreWS.tipoProducto.ARTICULO && linea.producto is articulo articuloProd)
            {
                return articuloProd.idArticuloSpecified && articuloProd.idArticulo == idProducto;
            }

            return false;
        }

    }
}