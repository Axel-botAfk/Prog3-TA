using CampusStoreWeb.CampusStoreWS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CampusStoreWeb
{
    public partial class Shopping_Car : System.Web.UI.Page
    {
        public CarritoWSClient carritoWS;
        public ClienteWSClient clienteWS;
        public CuponWSClient cuponWS;
        private const decimal PORCENTAJE_IMPUESTO = 0.18m;

        public Shopping_Car()
        {
            carritoWS = new CarritoWSClient();
            clienteWS = new ClienteWSClient();
            cuponWS = new CuponWSClient();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool isAdmin = Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
            if (isAdmin)
            {
                Response.Redirect("GestionarEmpleados.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarCarrito();
            }
        }

        private void CargarCarrito()
        {
            try
            {
                // Obtener el ID del cliente logueado
                string cuenta = Page.User.Identity.Name;
                int idCliente = clienteWS.buscarClientePorCuenta(cuenta).idCliente;

                if (idCliente <= 0)
                {
                    MostrarCarritoVacio();
                    return;
                }

                // Obtener el carrito del cliente
                var carrito = carritoWS.obtenerCarritoPorCliente(idCliente);
                System.Diagnostics.Debug.WriteLine($"[Shopping_Car] Carrito obtenido: ID={carrito?.idCarrito}, completado={carrito?.completado}, lineas={carrito?.lineas?.Length ?? 0}");

                // Verificar que el carrito existe, NO está completado y tiene productos
                if (carrito != null && !carrito.completado && carrito.lineas != null && carrito.lineas.Length > 0)
                {
                    rptCartItems.DataSource = carrito.lineas;
                    rptCartItems.DataBind();

                    // Calcular resumen
                    CalcularResumen(carrito);

                    pnlResumen.Visible = true;
                    pnlResumenVacio.Visible = false;
                }
                else
                {
                    MostrarCarritoVacio();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error: {ex.Message}");
                MostrarCarritoVacio();
            }
        }

        private void MostrarCarritoVacio()
        {
            rptCartItems.DataSource = null;
            rptCartItems.DataBind();

            pnlResumen.Visible = false;
            pnlResumenVacio.Visible = true;
        }

        private void CalcularResumen(dynamic carrito)
        {
            // 1. Calcular total (suma de todos los productos)
            decimal subtotalProductos = 0;
            foreach (var linea in carrito.lineas)
            {
                decimal precioFinal = linea.precioConDescuento > 0
                    ? (decimal)linea.precioConDescuento
                    : (decimal)linea.precioUnitario;

                subtotalProductos += precioFinal * linea.cantidad;
            }

            // 2. Calcular descuento del cupón (si existe)
            decimal descuentoCupon = 0;
            if (carrito.cupon != null && carrito.cupon.activo)
            {
                descuentoCupon = subtotalProductos * ((decimal)carrito.cupon.descuento / 100m);
                lblDescuento.Text = descuentoCupon.ToString("N2");
                pnlDescuento.Visible = true;
            }
            else
            {
                pnlDescuento.Visible = false;
            }

            // 3. Calcular impuesto (sobre subtotal)
            decimal impuesto = subtotalProductos * PORCENTAJE_IMPUESTO;
            lblImpuesto.Text = impuesto.ToString("N2");

            // 4. Calcular subtotal
            decimal subtotalConImpuesto = subtotalProductos - impuesto;
            lblSubtotal.Text = subtotalConImpuesto.ToString("N2");
            
            // 5. Mostrar total final (subtotal con descuento)
            decimal total = subtotalProductos;
            lblTotal.Text = total.ToString("N2");

            // 6. Calcular total después del descuento del cupón
            decimal totalConDescuento = total - descuentoCupon;
            lblTotal.Text = totalConDescuento.ToString("N2");
        }

        protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // ESTO DEBE APARECER SIEMPRE que presiones CUALQUIER botón
            System.Diagnostics.Debug.WriteLine("╔════════════════════════════════════╗");
            System.Diagnostics.Debug.WriteLine("║ EVENTO ItemCommand EJECUTADO      ║");
            System.Diagnostics.Debug.WriteLine($"║ CommandName: {e.CommandName,-20}║");
            System.Diagnostics.Debug.WriteLine($"║ CommandArgument: {e.CommandArgument,-16}║");
            System.Diagnostics.Debug.WriteLine("╚════════════════════════════════════╝");

            if (e.CommandName == "Eliminar")
            {
                try
                {
                    string cuenta = Page.User.Identity.Name;
                    cliente cliente = clienteWS.buscarClientePorCuenta(cuenta);
                    int idCliente = cliente.idCliente;

                    var carrito = carritoWS.obtenerCarritoPorCliente(idCliente);
                    int lineaCarritoId = Convert.ToInt32(e.CommandArgument);

                    //  Mini función para encontrar la línea de carrito a eliminar
                    int i;
                    for (i = 0; i < carrito.lineas.Length; i++)
                    {
                        if (carrito.lineas[i].idLineaCarrito == lineaCarritoId) break;
                    }

                    bool resultado = carritoWS.eliminarLineaDelCarrito(carrito.lineas[i]);

                    if (resultado)
                    {
                        // Mostrar mensaje de éxito
                        ScriptManager.RegisterStartupScript(this, GetType(), "productoEliminado",
                            "showNotification('Producto eliminado del carrito');", true);

                        // Recargar el carrito
                        Response.Redirect(Request.RawUrl);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "error",
                            "alert('No se pudo eliminar el producto');", true);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error al eliminar producto: {ex.Message}");
                    ScriptManager.RegisterStartupScript(this, GetType(), "error",
                        "alert('Error al eliminar el producto');", true);
                }
            }
        }

        protected void btnActualizarCarrito_Click(object sender, EventArgs e)
        {
            try
            {
                string cuenta = Page.User.Identity.Name;
                cliente cliente = clienteWS.buscarClientePorCuenta(cuenta);
                var carrito = carritoWS.obtenerCarritoPorCliente(cliente.idCliente);

                // Recorrer TODAS las filas del Repeater
                foreach (RepeaterItem item in rptCartItems.Items)
                {
                    if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                    {
                        HiddenField hdnCantidad = (HiddenField)item.FindControl("hdnCantidad");
                        HiddenField hdnIdLinea = (HiddenField)item.FindControl("hdnIdLinea");

                        if (hdnCantidad != null && hdnIdLinea != null)
                        {
                            int lineaId = Convert.ToInt32(hdnIdLinea.Value);
                            int nuevaCantidad = Convert.ToInt32(hdnCantidad.Value);

                            // Actualizar la cantidad en el carrito
                            for (int i = 0; i < carrito.lineas.Length; i++)
                            {
                                if (carrito.lineas[i].idLineaCarrito == lineaId)
                                {
                                    carrito.lineas[i].cantidad = nuevaCantidad;
                                    break;
                                }
                            }
                        }
                    }
                }

                carritoWS.guardarCarrito(carrito, estado.Modificado);
                Response.Redirect(Request.RawUrl);
                string script = "mostrarModalExito();";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertaExito", script, true);
            }
            catch (Exception ex)
            {
                string mensaje = ex.Message.Replace("'", "").Replace("\n", " ");
                string script = $"mostrarModalError('{mensaje}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertaError", script, true);
            }
        }

        protected void btnAplicarCupon_Click(object sender, EventArgs e)
        {
            try
            {
                string codigoCupon = txtCodigoCupon.Text.Trim();
                
                if (string.IsNullOrEmpty(codigoCupon))
                {
                    MostrarMensajeCupon("Por favor ingrese un código de cupón", false);
                    return;
                }

                // Obtener el ID del cliente logueado
                string cuenta = Page.User.Identity.Name;
                cliente cliente = clienteWS.buscarClientePorCuenta(cuenta);
                int idCliente = cliente.idCliente;

                if (idCliente <= 0)
                {
                    MostrarMensajeCupon("Error: No se pudo identificar al cliente", false);
                    return;
                }

                // Buscar el cupón por código
                cupon cuponEncontrado = cuponWS.buscarCuponPorCodigo(codigoCupon);

                if (cuponEncontrado == null)
                {
                    MostrarMensajeCupon("El cupón no existe o no está disponible", false);
                    return;
                }

                // Verificar si el cliente ya usó este cupón
                bool yaUsado = cuponWS.verificarCuponUsado(cuponEncontrado.idCupon, idCliente);

                if (yaUsado)
                {
                    MostrarMensajeCupon("Ya has usado este cupón anteriormente", false);
                    return;
                }

                // Obtener el carrito del cliente
                var carrito = carritoWS.obtenerCarritoPorCliente(idCliente);

                if (carrito == null || carrito.completado)
                {
                    MostrarMensajeCupon("No se encontró un carrito activo", false);
                    return;
                }

                // Aplicar el cupón al carrito
                bool resultado = carritoWS.aplicarCuponACarrito(
                    cuponEncontrado.idCupon, 
                    idCliente, 
                    carrito.idCarrito
                );

                if (resultado)
                {
                    MostrarMensajeCupon("¡Cupón aplicado correctamente!", true);
                    txtCodigoCupon.Text = "";
                    // Recargar el carrito para mostrar el descuento
                    CargarCarrito();
                }
                else
                {
                    MostrarMensajeCupon("No se pudo aplicar el cupón. Verifique que el cupón sea válido.", false);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error al aplicar cupón: {ex.Message}");
                MostrarMensajeCupon("Error al aplicar el cupón: " + ex.Message, false);
            }
        }

        private void MostrarMensajeCupon(string mensaje, bool esExito)
        {
            lblMensajeCupon.Text = mensaje;
            lblMensajeCupon.Visible = true;
            lblMensajeCupon.CssClass = esExito ? "coupon-message success" : "coupon-message error";
        }
    }
}