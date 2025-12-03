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
    public class ProductoUnificado
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
    }

    public partial class Shop_Page : System.Web.UI.Page
    {
        private const int PRODUCTOS_POR_PAGINA = 12;
        private readonly CarritoWSClient carritoWS;
        private readonly ClienteWSClient clienteWS;

        public Shop_Page()
        {
            carritoWS = new CarritoWSClient();
            clienteWS = new ClienteWSClient();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool isAdmin = Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
            if (isAdmin)
            {
                Response.Redirect("GestionarEmpleados.aspx");
                return;
            }

            // 1. Manejo de alertas visuales (SweetAlert)
            if (Session["ShowAddToCartAlert"] != null && (bool)Session["ShowAddToCartAlert"])
            {
                string script = "Swal.fire({ icon: 'success', title: '¡Añadido!', text: 'Producto agregado al carrito.', showConfirmButton: false, timer: 1500 });";
                ClientScript.RegisterStartupScript(this.GetType(), "addToCartAlert", script, true);
                Session["ShowAddToCartAlert"] = false;
            }

            // 2. Manejo de postback desde el Modal (Añadir al carrito con cantidad)
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
                // 3. DETECTAR BÚSQUEDA GLOBAL (Desde MasterPage)
                string busquedaGlobal = Request.QueryString["busqueda"];

                if (!string.IsNullOrEmpty(busquedaGlobal))
                {
                    // Si hay búsqueda, guardamos el término en ViewState y limpiamos filtros visuales
                    ViewState["BusquedaActual"] = busquedaGlobal;

                    // Opcional: Desmarcar visualmente la categoría para indicar que es una búsqueda global
                    rblCategorias.ClearSelection();
                }
                else
                {
                    // Si NO hay búsqueda, limpiamos la variable de búsqueda
                    ViewState["BusquedaActual"] = null;

                    // Verificar si viene una categoría desde la URL (Menú Footer/Links)
                    string categoriaURL = Request.QueryString["categoria"];
                    if (!string.IsNullOrEmpty(categoriaURL))
                    {
                        ListItem item = rblCategorias.Items.FindByValue(categoriaURL);
                        if (item != null)
                        {
                            rblCategorias.ClearSelection();
                            item.Selected = true;
                        }
                    }
                }

                CargarFiltros();

                // Cargamos productos (La lógica interna decidirá si usa BusquedaActual o los Filtros)
                CargarProductos();
            }
        }

        private void CargarFiltros()
        {
            try
            {
                var autores = new AutorWSClient();
                var editoriales = new EditorialWSClient();

                // Cargar Editoriales
                editorial[] todasLasEditoriales = editoriales.listarEditoriales();
                if (todasLasEditoriales != null)
                {
                    cblEditoriales.DataSource = todasLasEditoriales.Take(5);
                    cblEditoriales.DataTextField = "nombre";
                    cblEditoriales.DataValueField = "idEditorial";
                    cblEditoriales.DataBind();
                }

                // Cargar Autores
                autor[] todosLosAutores = autores.listarAutores();
                if (todosLosAutores != null)
                {
                    cblAutores.DataSource = todosLosAutores.Take(5);
                    cblAutores.DataTextField = "nombre";
                    cblAutores.DataValueField = "idAutor";
                    cblAutores.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar filtros dinámicos: " + ex.Message);
            }
        }

        protected void btnAplicarFiltros_Click(object sender, EventArgs e)
        {
            // Si el usuario hace clic en "Aplicar Filtros", significa que quiere usar los filtros laterales,
            // por lo tanto, cancelamos la búsqueda global.
            ViewState["BusquedaActual"] = null;

            if (!ValidarFiltros())
            {
                return;
            }

            // Reseteamos a página 1 al cambiar filtros
            PaginaActual = 1;
            CargarProductos();
        }

        // =========================================================================
        // MÉTODO PRINCIPAL DE CARGA DE PRODUCTOS (MODIFICADO PARA BÚSQUEDA)
        // =========================================================================
        private void CargarProductos()
        {
            var productosUnificados = new List<ProductoUnificado>();
            string terminoBusqueda = ViewState["BusquedaActual"] as string;

            try
            {
                // ESCENARIO A: BÚSQUEDA GLOBAL ACTIVA
                if (!string.IsNullOrEmpty(terminoBusqueda))
                {
                    // 1. Instanciamos clientes
                    var libroWS = new LibroWSClient();
                    var articuloWS = new ArticuloWSClient();

                    // 2. Obtenemos todo (Idealmente el WS tendría buscarPorNombre, pero filtramos en memoria aquí)
                    var todosLibros = libroWS.listarLibros();
                    var todosArticulos = articuloWS.listarArticulos();

                    terminoBusqueda = terminoBusqueda.ToLower();

                    // 3. Filtrar y Agregar LIBROS que coincidan
                    if (todosLibros != null)
                    {
                        var librosEncontrados = todosLibros.Where(l => l.nombre != null && l.nombre.ToLower().Contains(terminoBusqueda));
                        foreach (var lib in librosEncontrados)
                        {
                            productosUnificados.Add(new ProductoUnificado
                            {
                                Id = lib.idLibro,
                                Nombre = lib.nombre,
                                Precio = (decimal)lib.precio,
                                TipoProducto = "libro",
                                UrlImagen = lib.imagenURL,
                                Stock = lib.stockReal,
                                Autor = (lib.autores != null && lib.autores.Length > 0) ? lib.autores[0].nombre : ""
                            });
                        }
                    }

                    // 4. Filtrar y Agregar ARTÍCULOS que coincidan
                    if (todosArticulos != null)
                    {
                        var articulosEncontrados = todosArticulos.Where(a => a.nombre != null && a.nombre.ToLower().Contains(terminoBusqueda));
                        foreach (var art in articulosEncontrados)
                        {
                            productosUnificados.Add(new ProductoUnificado
                            {
                                Id = art.idArticulo,
                                Nombre = art.nombre,
                                Precio = (decimal)art.precio,
                                TipoProducto = "articulo", // Usamos "articulo" genérico o art.tipoProducto.ToString()
                                UrlImagen = art.imagenURL,
                                Stock = art.stockReal
                            });
                        }
                    }
                }
                // ESCENARIO B: FILTROS LATERALES (Comportamiento Original)
                else
                {
                    var clienteFiltro = new FiltroWSClient();
                    string categoriaSeleccionada = rblCategorias.SelectedValue;

                    if (categoriaSeleccionada == "libro")
                    {
                        int[] idsEditoriales = GetSelectedIntValues(cblEditoriales);
                        int[] idsAutores = GetSelectedIntValues(cblAutores);
                        string[] generos = GetSelectedStringValues(cblGeneros);

                        libro[] librosResult = clienteFiltro.filtrarLibros(idsAutores, idsEditoriales, generos);

                        if (librosResult != null)
                        {
                            foreach (var lib in librosResult)
                            {
                                productosUnificados.Add(new ProductoUnificado
                                {
                                    Id = lib.idLibro,
                                    Nombre = lib.nombre,
                                    Precio = (decimal)lib.precio,
                                    TipoProducto = "libro",
                                    UrlImagen = lib.imagenURL,
                                    Stock = lib.stockReal,
                                    Autor = (lib.autores != null && lib.autores.Length > 0) ? lib.autores[0].nombre : ""
                                });
                            }
                        }
                    }
                    else
                    {
                        articulo[] articulosResult = clienteFiltro.filtrarPorTipoArticulo(categoriaSeleccionada);
                        if (articulosResult != null)
                        {
                            foreach (var art in articulosResult)
                            {
                                productosUnificados.Add(new ProductoUnificado
                                {
                                    Id = art.idArticulo,
                                    Nombre = art.nombre,
                                    Precio = (decimal)art.precio,
                                    TipoProducto = categoriaSeleccionada,
                                    UrlImagen = art.imagenURL,
                                    Stock = art.stockReal
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar productos: " + ex.Message);
                productosUnificados.Clear();
            }

            // =================================================================
            // LOGICA DE PAGINACIÓN (Común para Búsqueda y Filtros)
            // =================================================================

            // Cálculos de paginación
            int totalProductos = productosUnificados.Count;
            int totalPaginas = (int)Math.Ceiling((double)totalProductos / PRODUCTOS_POR_PAGINA);

            // Validación de seguridad
            if (totalPaginas > 0 && PaginaActual > totalPaginas) PaginaActual = totalPaginas;
            if (totalPaginas == 0) PaginaActual = 1;

            ViewState["TotalPaginas"] = totalPaginas;

            // Obtener recorte para la página actual
            int indiceInicio = (PaginaActual - 1) * PRODUCTOS_POR_PAGINA;
            var productosPagina = productosUnificados.Skip(indiceInicio).Take(PRODUCTOS_POR_PAGINA).ToList();

            // Mostrar productos
            if (productosPagina.Any())
            {
                rptProductos.DataSource = productosPagina;
                rptProductos.DataBind();
                rptProductos.Visible = true;
                pnlNoResults.Visible = false;
            }
            else
            {
                rptProductos.Visible = false;
                pnlNoResults.Visible = true;
            }

            // Actualizar botones de paginación
            ActualizarControlesPaginacion(totalPaginas);
        }

        private void ActualizarControlesPaginacion(int totalPaginas)
        {
            if (totalPaginas <= 1)
            {
                pnlPaginacion.Visible = false;
                return;
            }

            pnlPaginacion.Visible = true;
            List<int> paginas = new List<int>();

            int inicio = Math.Max(1, PaginaActual - 2);
            int fin = Math.Min(totalPaginas, PaginaActual + 2);

            if (fin - inicio < 4)
            {
                if (inicio == 1) fin = Math.Min(totalPaginas, inicio + 4);
                else if (fin == totalPaginas) inicio = Math.Max(1, fin - 4);
            }

            if (inicio > 1) paginas.Add(1);

            for (int i = inicio; i <= fin; i++)
            {
                if (!paginas.Contains(i)) paginas.Add(i);
            }

            if (fin < totalPaginas && !paginas.Contains(totalPaginas)) paginas.Add(totalPaginas);

            paginas = paginas.OrderBy(x => x).ToList();

            rptPaginacionNumeros.DataSource = paginas;
            rptPaginacionNumeros.DataBind();

            btnAnterior.Visible = (PaginaActual > 1);
            btnSiguiente.Visible = (PaginaActual < totalPaginas);
        }

        // --- MÉTODOS DE AYUDA Y VALIDACIÓN ---

        private bool ValidarFiltros()
        {
            string categoriaSeleccionada = rblCategorias.SelectedValue;

            if (categoriaSeleccionada != "libro")
            {
                bool hayEditoriales = cblEditoriales.Items.Cast<ListItem>().Any(li => li.Selected);
                bool hayAutores = cblAutores.Items.Cast<ListItem>().Any(li => li.Selected);
                bool hayGeneros = cblGeneros.Items.Cast<ListItem>().Any(li => li.Selected);

                if (hayEditoriales || hayAutores || hayGeneros)
                {
                    string mensaje = "No puedes aplicar filtros de LIBROS cuando la categoría seleccionada no es 'Libros'.\\n\\nDesmarca los filtros o selecciona categoría Libros.";
                    ScriptManager.RegisterStartupScript(this, GetType(), "valFiltros", $"alert('{mensaje}');", true);
                    return false;
                }
            }
            return true;
        }

        private int[] GetSelectedIntValues(CheckBoxList cbl)
        {
            return cbl.Items.Cast<ListItem>()
                      .Where(li => li.Selected)
                      .Select(li => int.Parse(li.Value))
                      .ToArray();
        }

        private string[] GetSelectedStringValues(CheckBoxList cbl)
        {
            return cbl.Items.Cast<ListItem>()
                      .Where(li => li.Selected)
                      .Select(li => li.Value)
                      .ToArray();
        }

        // --- PROPIEDAD PARA PAGINACIÓN ---
        public int PaginaActual
        {
            get
            {
                if (ViewState["PaginaActual"] == null) return 1;
                return (int)ViewState["PaginaActual"];
            }
            set
            {
                ViewState["PaginaActual"] = value;
            }
        }

        // --- EVENTOS REPEATER ---
        protected void rptProductos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                string[] args = e.CommandArgument.ToString().Split(',');
                if (args.Length == 2)
                {
                    int productoId = int.Parse(args[0]);
                    string productoTipo = args[1];
                    AgregarAlCarrito(productoId, productoTipo, 1);
                }
            }
        }

        protected void rptPaginacionNumeros_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "IrPagina")
            {
                PaginaActual = Convert.ToInt32(e.CommandArgument);
                CargarProductos();
            }
        }

        protected void btnAnterior_Click(object sender, EventArgs e)
        {
            if (PaginaActual > 1)
            {
                PaginaActual--;
                CargarProductos();
            }
        }

        protected void btnSiguiente_Click(object sender, EventArgs e)
        {
            int totalPaginas = (int)(ViewState["TotalPaginas"] ?? 1);
            if (PaginaActual < totalPaginas)
            {
                PaginaActual++;
                CargarProductos();
            }
        }

        // --- LÓGICA DE CARRITO (Igual que antes) ---
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
                if (clienteActual == null || clienteActual.idCliente <= 0) return;

                clienteActual.idClienteSpecified = true;
                var carritoActual = carritoWS.obtenerCarritoPorCliente(clienteActual.idCliente);
                bool crearNuevoCarrito = carritoActual == null || carritoActual.completado;

                ProductoUnificado producto = null;

                // Obtener datos del producto según tipo
                if (tipoProducto.ToLower() == "libro")
                {
                    var libroWS = new LibroWSClient();
                    libro libroResult = libroWS.obtenerLibro(productoId);
                    if (libroResult != null)
                    {
                        producto = new ProductoUnificado
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
                        producto = new ProductoUnificado
                        {
                            Id = articuloResult.idArticulo,
                            Nombre = articuloResult.nombre,
                            Precio = (decimal)articuloResult.precio,
                            TipoProducto = tipoProducto,
                            Stock = articuloResult.stockReal
                        };
                    }
                }

                if (producto == null || producto.Stock <= 0) return;

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

        private lineaCarrito CrearLineaCarrito(ProductoUnificado producto, int cantidad)
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
                linea.producto = new libro { idLibro = producto.Id, idLibroSpecified = true };
            }
            else
            {
                linea.producto = new articulo { idArticulo = producto.Id, idArticuloSpecified = true };
            }

            return linea;
        }

        private bool EsMismoProducto(lineaCarrito linea, CampusStoreWS.tipoProducto tipoEnum, int idProducto)
        {
            if (linea == null || linea.tipoProducto != tipoEnum) return false;
            if (tipoEnum == CampusStoreWS.tipoProducto.LIBRO && linea.producto is libro libroProd)
                return libroProd.idLibroSpecified && libroProd.idLibro == idProducto;
            if (tipoEnum == CampusStoreWS.tipoProducto.ARTICULO && linea.producto is articulo articuloProd)
                return articuloProd.idArticuloSpecified && articuloProd.idArticulo == idProducto;
            return false;
        }

        // --- WEBMETHODS PARA EL MODAL ---
        [WebMethod]
        public static ProductoUnificado GetProductDetails(string tipo, int id)
        {
            try
            {
                if (tipo.ToLower() == "libro")
                {
                    var cliente = new LibroWSClient();
                    libro libroResult = cliente.obtenerLibro(id);
                    if (libroResult == null) return null;

                    return new ProductoUnificado
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

                    return new ProductoUnificado
                    {
                        Id = articuloResult.idArticulo,
                        Nombre = articuloResult.nombre,
                        Descripcion = articuloResult.descripcion,
                        Precio = (decimal)articuloResult.precio,
                        Stock = articuloResult.stockReal,
                        UrlImagen = articuloResult.imagenURL,
                        TipoProducto = tipo, // Importante: Mantener el tipo original (PELUCHE, etc)
                        TipoDeProducto = "Artículo"
                    };
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error GetProductDetails: {ex.Message}");
                return null;
            }
        }

        [WebMethod]
        public static bool AddItemToCart(string tipo, int id, int cantidad)
        {
            // Este método solo se usa para validar conexión en el AJAX, la lógica real está en el evento postback
            return true;
        }
    }
}