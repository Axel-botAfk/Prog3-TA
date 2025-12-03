using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
//using CampusStoreWeb.ClienteWS;
//using CampusStoreWeb.OrdenCompraWS;
//using CampusStoreWeb.ArticuloWS;
//using CampusStoreWeb.LibroWS;

using CampusStoreWeb.CampusStoreWS;

namespace CampusStoreWeb
{
    public partial class OrderDetails : System.Web.UI.Page
    {
        private readonly ClienteWSClient clienteWS;
        private readonly OrdenCompraWSClient ordenCompraWS;
        private readonly ArticuloWSClient articuloWS;
        private readonly LibroWSClient libroWS;

        // Variable de clase para almacenar el ID de la orden
        private int? orderIdActual;
        
        // Variables de clase para almacenar el ID y tipo del producto seleccionado para reseña
        private int? productoIdSeleccionado;
        private string productoTipoSeleccionado;
        
        // Variable de clase para almacenar el cliente actual (cargado una vez)
        private cliente clienteActual;

        public OrderDetails()
        {
            this.clienteWS = new ClienteWSClient();
            this.ordenCompraWS = new OrdenCompraWSClient();
            this.articuloWS = new ArticuloWSClient();
            this.libroWS = new LibroWSClient();
        }

        // Propiedad pública para acceder al ID de la orden desde otras funciones
        public int? OrderIdActual
        {
            get
            {
                // Primero intentar obtener de la variable de clase
                if (orderIdActual.HasValue)
                {
                    return orderIdActual;
                }
                
                // Si no está en la variable, intentar obtener de ViewState
                if (ViewState["OrderId"] != null)
                {
                    orderIdActual = (int)ViewState["OrderId"];
                    return orderIdActual;
                }
                
                // Si no está en ViewState, intentar obtener de QueryString
                return ObtenerOrderIdDesdeQueryString();
            }
        }

        // Propiedades públicas para acceder al ID y tipo del producto seleccionado
        public int? ProductoIdSeleccionado
        {
            get
            {
                if (productoIdSeleccionado.HasValue)
                {
                    return productoIdSeleccionado;
                }
                
                if (ViewState["ProductoIdSeleccionado"] != null)
                {
                    productoIdSeleccionado = (int)ViewState["ProductoIdSeleccionado"];
                    return productoIdSeleccionado;
                }
                
                return null;
            }
        }

        public string ProductoTipoSeleccionado
        {
            get
            {
                if (!string.IsNullOrEmpty(productoTipoSeleccionado))
                {
                    return productoTipoSeleccionado;
                }
                
                if (ViewState["ProductoTipoSeleccionado"] != null)
                {
                    productoTipoSeleccionado = ViewState["ProductoTipoSeleccionado"].ToString();
                    return productoTipoSeleccionado;
                }
                
                return null;
            }
        }

        // Propiedad para obtener el cliente actual (cargado una vez y reutilizable)
        public cliente ClienteActual
        {
            get
            {
                // Si ya está cargado en la variable de clase, devolverlo
                if (clienteActual != null)
                {
                    return clienteActual;
                }
                
                // Si está en ViewState, cargarlo desde ahí
                if (ViewState["ClienteActual"] != null)
                {
                    clienteActual = (cliente)ViewState["ClienteActual"];
                    return clienteActual;
                }
                
                // Si no está cargado, cargarlo ahora
                return CargarClienteActual();
            }
        }

        // Método privado para cargar el cliente actual (solo se ejecuta una vez)
        private cliente CargarClienteActual()
        {
            try
            {
                string userEmail = User.Identity.Name;
                cliente cliente = clienteWS.buscarClientePorCuenta(userEmail);
                
                if (cliente != null)
                {
                    // Guardar en variable de clase y ViewState para reutilización
                    clienteActual = cliente;
                    ViewState["ClienteActual"] = cliente;
                    System.Diagnostics.Debug.WriteLine($"DEBUG: Cliente cargado - ID: {cliente.idCliente}, Email: {cliente.correo}");
                }
                
                return cliente;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ERROR al cargar cliente: {ex.Message}");
                return null;
            }
        }

        // Método privado para obtener el ID desde QueryString
        private int? ObtenerOrderIdDesdeQueryString()
        {
            string rawId = Request.QueryString["id"];
            
            if (!string.IsNullOrEmpty(rawId))
            {
                // Remover el # si viene con él
                string orderIdParam = rawId.Trim().TrimStart('#').Trim();
                
                if (!string.IsNullOrEmpty(orderIdParam) && int.TryParse(orderIdParam, out int orderId))
                {
                    // Guardar en ViewState y variable de clase
                    ViewState["OrderId"] = orderId;
                    orderIdActual = orderId;
                    return orderId;
                }
            }
            
            return null;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar autenticación
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("SignIn.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrderDetails();
            }
        }

        private void LoadOrderDetails()
        {
            // Obtener el ID de la orden usando el método centralizado
            int? orderIdNullable = ObtenerOrderIdDesdeQueryString();
            
            if (!orderIdNullable.HasValue)
            {
                MostrarError("No se especificó una orden para mostrar.");
                return;
            }
            
            int orderId = orderIdNullable.Value;
            System.Diagnostics.Debug.WriteLine($"DEBUG: OrderId obtenido = {orderId}");
            
            // Guardar el ID en la variable de clase para uso posterior
            orderIdActual = orderId;
            
            try
            {
                // Obtener el cliente actual (ya está cargado y guardado, solo lo obtenemos)
                cliente clienteActual = ClienteActual;

                if (clienteActual == null)
                {
                    MostrarError("No se encontró el cliente.");
                    return;
                }

                // Obtener la orden
                ordenCompra orden = ordenCompraWS.obtenerOrdenCompra(orderId);
                
                if (orden == null)
                {
                    MostrarError("No se encontró la orden solicitada.");
                    return;
                }

                // El botón de proceder al pago solo se muestra si la orden no está cancelada
                if (orden.estado == estadoOrden.NO_PAGADO)
                {
                    btnProcederPago.Visible = true;
                }
                else
                {
                    btnProcederPago.Visible = false;
                }

                // SEGURIDAD: Verificar que la orden pertenece al cliente actual
                // Usar reflection por compatibilidad entre namespaces
                int clienteOrdenId = 0;
                if (orden.cliente != null)
                {
                    var idProp = orden.cliente.GetType().GetProperty("idCliente") ?? 
                                orden.cliente.GetType().GetProperty("idcliente");
                    if (idProp != null)
                    {
                        clienteOrdenId = (int)idProp.GetValue(orden.cliente);
                    }
                }
                
                if (clienteOrdenId != clienteActual.idCliente)
                {
                    MostrarError("La orden no pertenece a tu cuenta.");
                    return;
                }

                // Mostrar información de la orden
                lblOrderId.Text = "#" + orden.idOrdenCompra.ToString();
                
                // Formatear fecha en español sin hora
                System.Globalization.CultureInfo cultureEs = new System.Globalization.CultureInfo("es-ES");
                lblOrderDate.Text = orden.fechaCreacion.ToString("dd 'de' MMM 'de' yyyy", cultureEs);
                
                // Usar el total con descuento si existe
                double total = orden.total;
                try
                {
                    var totalDescontadoProp = orden.GetType().GetProperty("totalDescontado");
                    if (totalDescontadoProp != null)
                    {
                        var totalDescontado = totalDescontadoProp.GetValue(orden);
                        if (totalDescontado != null && (double)totalDescontado > 0)
                        {
                            total = (double)totalDescontado;
                        }
                    }
                }
                catch { }

                lblOrderTotal.Text = "S/." + total.ToString("F2");

                // Guardar el estado de la orden para usarlo en la carga de productos
                ViewState["EstadoOrden"] = orden.estado.ToString();

                // Cargar productos del carrito - usar el mismo enfoque que DetalleOrdenCompra
                System.Diagnostics.Debug.WriteLine($"DEBUG: orden.carrito es null? {orden.carrito == null}");
                
                if (orden.carrito != null && orden.carrito.lineas != null)
                {
                    System.Diagnostics.Debug.WriteLine($"DEBUG: orden.carrito.lineas.Length = {orden.carrito.lineas.Length}");
                    
                    // Obtener el estado de la orden desde ViewState
                    string estadoOrden = ViewState["EstadoOrden"]?.ToString() ?? "";
                    LoadProductsFromLineas(orden.carrito.lineas, estadoOrden);
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("DEBUG: orden.carrito o orden.carrito.lineas es NULL");
                    rptProducts.DataSource = new List<ProductInfo>();
                    rptProducts.DataBind();
                    lblProductCount.Text = "0 Productos";
                }
            }
            catch (Exception ex)
            {
                MostrarError("Error al cargar la orden: " + ex.Message);
            }
        }

        private int ObtenerIdOrdenActual()
        {
            // Viene por QueryString desde el historial
            if (Request.QueryString["id"] != null)
            {
                int id;
                if (int.TryParse(Request.QueryString["id"], out id))
                {
                    return id;
                }
            }
            return 0;
        }

        private void MostrarError(string mensaje)
        {
            // Mostrar error en la página en lugar de redirigir (igual que DetalleArticulo/DetalleLibro)
            lblOrderId.Text = "Error";
            lblOrderDate.Text = mensaje;
            lblOrderTotal.Text = "S/.0.00";
            lblProductCount.Text = "0 Productos";
            rptProducts.DataSource = new List<ProductInfo>();
            rptProducts.DataBind();
        }

        private void LoadProductsFromLineas(lineaCarrito[] lineas, string estadoOrden)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"=== LoadProductsFromLineas INICIADO con {lineas.Length} líneas ===");
                var products = new List<ProductInfo>();

                foreach (var linea in lineas)
                {
                    System.Diagnostics.Debug.WriteLine($"DEBUG: Procesando línea - idLineaCarrito = {linea.idLineaCarrito}");
                    System.Diagnostics.Debug.WriteLine($"DEBUG: linea.producto es null? {linea.producto == null}");
                    System.Diagnostics.Debug.WriteLine($"DEBUG: linea.tipoProducto = {linea.tipoProducto}");
                    
                    if (linea.producto == null)
                    {
                        System.Diagnostics.Debug.WriteLine("DEBUG: linea.producto es null, saltando...");
                        continue;
                    }

                    // Determinar el precio final
                    decimal precioFinal = linea.precioConDescuento > 0 
                        ? (decimal)linea.precioConDescuento 
                        : (decimal)linea.precioUnitario;

                    decimal subtotalFinal = precioFinal * linea.cantidad;

                    // Determinar el tipo de producto y procesar según corresponda
                    if (linea.tipoProducto == tipoProducto.ARTICULO)
                    {
                        articulo articulo = linea.producto as articulo;
                        
                        if (articulo != null)
                        {
                            System.Diagnostics.Debug.WriteLine($"DEBUG: Agregando artículo - Nombre: {articulo.nombre}, Cantidad: {linea.cantidad}");

                            products.Add(new ProductInfo
                            {
                                ImageUrl = articulo.imagenURL ?? "Images/placeholder.png",
                                Category = articulo.tipoArticulo.ToString(),
                                ProductName = articulo.nombre,
                                Price = precioFinal,
                                Quantity = linea.cantidad,
                                SubTotal = subtotalFinal,
                                PuedeCalificar = estadoOrden == "ENTREGADO",
                                ProductId = articulo.idArticulo,
                                ProductType = "ARTICULO"
                            });
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"DEBUG: No se pudo hacer cast a articulo. Tipo real: {linea.producto?.GetType().FullName}");
                        }
                    }
                    else if (linea.tipoProducto == tipoProducto.LIBRO)
                    {
                        libro libro = linea.producto as libro;
                        
                        if (libro != null)
                        {
                            System.Diagnostics.Debug.WriteLine($"DEBUG: Agregando libro - Nombre: {libro.nombre}, Cantidad: {linea.cantidad}");

                            products.Add(new ProductInfo
                            {
                                ImageUrl = libro.imagenURL ?? "Images/placeholder.png",
                                Category = libro.genero.ToString(),
                                ProductName = libro.nombre,
                                Price = precioFinal,
                                Quantity = linea.cantidad,
                                SubTotal = subtotalFinal,
                                PuedeCalificar = estadoOrden == "ENTREGADO",
                                ProductId = libro.idLibro,
                                ProductType = "LIBRO"
                            });
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"DEBUG: No se pudo hacer cast a libro. Tipo real: {linea.producto?.GetType().FullName}");
                        }
                    }
                }

                System.Diagnostics.Debug.WriteLine($"DEBUG: Total productos agregados = {products.Count}");

                // Actualizar contadores
                if (products.Count > 0)
                {
                    int totalQuantity = products.Sum(p => p.Quantity);
                    lblProductCount.Text = totalQuantity + " Producto" + (totalQuantity != 1 ? "s" : "");
                    System.Diagnostics.Debug.WriteLine($"DEBUG: Productos mostrados - Total items: {totalQuantity}, Total productos: {products.Count}");
                }
                else
                {
                    lblProductCount.Text = "0 Productos";
                    System.Diagnostics.Debug.WriteLine("DEBUG: No se encontraron productos");
                }

                rptProducts.DataSource = products;
                rptProducts.DataBind();
                System.Diagnostics.Debug.WriteLine("=== LoadProductsFromLineas FINALIZADO ===");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ERROR en LoadProductsFromLineas: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack trace: {ex.StackTrace}");
                System.Diagnostics.Debug.WriteLine($"Inner exception: {ex.InnerException?.Message}");
                rptProducts.DataSource = new List<ProductInfo>();
                rptProducts.DataBind();
                lblProductCount.Text = "0 Productos";
            }
        }

        // Método que se ejecuta cuando se hace clic en el botón de calificar
        protected void lnkCalificar_Command(object sender, CommandEventArgs e)
        {
            // Obtener el ID y tipo del producto desde CommandArgument
            string[] argumentos = e.CommandArgument.ToString().Split('|');
            
            if (argumentos.Length == 2)
            {
                int productId = int.Parse(argumentos[0]);
                string productType = argumentos[1];
                
                // Guardar el ID y tipo del producto seleccionado
                GuardarProductoSeleccionado(productId, productType);
                
                System.Diagnostics.Debug.WriteLine($"DEBUG: Producto seleccionado para calificar - ID: {productId}, Tipo: {productType}");
            }
            
            // El modal se abrirá automáticamente con JavaScript después del postback
            // Usamos setTimeout para asegurar que el DOM esté listo
            string script = @"
                setTimeout(function() {
                    var modal = new bootstrap.Modal(document.getElementById('ratingModal'));
                    modal.show();
                }, 100);
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "OpenRatingModal", script, true);
        }

        protected void btnProcederPago_Click(object sender, EventArgs e)
        {
            try
            {
                // Obtener el ID de la orden actual
     
                int idOrden = ObtenerIdOrdenActual();
            
                if (idOrden <= 0)
                {
                    MostrarError("No se pudo identificar la orden.");
                    return;
                }

                System.Diagnostics.Debug.WriteLine($"Redirigiendo a Checkout con idOrden: {idOrden}");

                // Redirigir a Checkout pasando el ID de la orden
                Response.Redirect($"~/Checkout.aspx?idOrden={idOrden}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error al redirigir a checkout: {ex.Message}");
                MostrarError("Error al proceder con el pago. Intenta nuevamente.");
            }
        }

        protected void btnPublishReview_Click(object sender, EventArgs e)
        {
            // Verificar que se haya seleccionado un producto
            if (!ProductoIdSeleccionado.HasValue || string.IsNullOrEmpty(ProductoTipoSeleccionado))
            {
                string errorScript = "alert('Error: No se ha seleccionado un producto para calificar.');";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowError", errorScript, true);
                return;
            }
            
            try
            {
                // Crear el cliente del Web Service dentro del método
                ResenaWSClient resenaWS = new ResenaWSClient();
                
                // Obtener datos del formulario
                string ratingStr = ddlRating.SelectedValue;
                string feedback = txtFeedback.Text;
                
                // Obtener ID y tipo del producto seleccionado
                int productId = ProductoIdSeleccionado.Value;
                string productType = ProductoTipoSeleccionado;
                
                // Obtener el cliente actual
                cliente clienteActual = ClienteActual;
                
                if (clienteActual == null)
                {
                    string errorScript = "alert('Error: No se encontró el cliente.');";
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowError", errorScript, true);
                    resenaWS.Close();
                    return;
                }
                
                // Crear el objeto reseña
                reseña nuevaResena = new reseña();
                
                // Asignar calificación (convertir de string a double)
                nuevaResena.calificacion = double.Parse(ratingStr);
                
                // Asignar comentario (puede ser null o vacío)
                nuevaResena.reseña1 = string.IsNullOrWhiteSpace(feedback) ? null : feedback;
                
                // Asignar tipo de producto (convertir string a enum)
                nuevaResena.tipoProducto = (productType == "ARTICULO") 
                    ? tipoProducto.ARTICULO 
                    : tipoProducto.LIBRO;
                
                // Obtener el producto completo (artículo o libro según el tipo)
                // NO podemos crear uno nuevo con solo el ID porque Producto es abstracto
                // y el Web Service necesita el objeto completo para deserializar correctamente
                if (productType == "ARTICULO")
                {
                    // Obtener el artículo completo desde el Web Service
                    articulo articuloCompleto = articuloWS.obtenerArticulo(productId);
                    if (articuloCompleto == null)
                    {
                        string errorScript = "alert('Error: No se encontró el artículo.');";
                        ScriptManager.RegisterStartupScript(this, GetType(), "ShowError", errorScript, true);
                        resenaWS.Close();
                        return;
                    }
                    nuevaResena.idProducto = articuloCompleto.idArticulo;
                }
                else // LIBRO
                {
                    // Obtener el libro completo desde el Web Service
                    libro libroCompleto = libroWS.obtenerLibro(productId);
                    if (libroCompleto == null)
                    {
                        string errorScript = "alert('Error: No se encontró el libro.');";
                        ScriptManager.RegisterStartupScript(this, GetType(), "ShowError", errorScript, true);
                        resenaWS.Close();
                        return;
                    }
                    nuevaResena.idProducto = libroCompleto.idLibro;
                }
                
                // Asignar el objeto cliente completo
                nuevaResena.cliente = clienteActual;
                
                // Llamar al Web Service para guardar la reseña
                resenaWS.guardarResena(nuevaResena, estado.Nuevo);
                
                // Cerrar el cliente del Web Service
                resenaWS.Close();
                
                // Mostrar mensaje de éxito
                string successScript = "alert('¡Reseña publicada exitosamente!');";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowSuccess", successScript, true);
                
                // Cerrar el modal
                string closeModalScript = "$('#ratingModal').modal('hide');";
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", closeModalScript, true);
                
                // Limpiar campos
                txtFeedback.Text = string.Empty;
                ddlRating.SelectedIndex = 0;
                
                // Limpiar producto seleccionado
                productoIdSeleccionado = null;
                productoTipoSeleccionado = null;
                ViewState["ProductoIdSeleccionado"] = null;
                ViewState["ProductoTipoSeleccionado"] = null;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ERROR al guardar reseña: {ex.Message}");
                string errorScript = $"alert('Error al guardar la reseña: {ex.Message}');";
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowError", errorScript, true);
            }
        }

        // Método para guardar el ID y tipo del producto seleccionado
        protected void GuardarProductoSeleccionado(int productId, string productType)
        {
            productoIdSeleccionado = productId;
            productoTipoSeleccionado = productType;
            ViewState["ProductoIdSeleccionado"] = productId;
            ViewState["ProductoTipoSeleccionado"] = productType;
            System.Diagnostics.Debug.WriteLine($"DEBUG: Producto seleccionado - ID: {productId}, Tipo: {productType}");
        }

        // Clase para representar la información de un producto
        public class ProductInfo
        {
            public string ImageUrl { get; set; }
            public string Category { get; set; }
            public string ProductName { get; set; }
            public decimal Price { get; set; }
            public int Quantity { get; set; }
            public decimal SubTotal { get; set; }
            public bool PuedeCalificar { get; set; }
            public int ProductId { get; set; }
            public string ProductType { get; set; }
        }
    }
}
