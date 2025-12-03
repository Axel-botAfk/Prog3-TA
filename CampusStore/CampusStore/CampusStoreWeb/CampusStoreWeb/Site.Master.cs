using CampusStoreWeb.CampusStoreWS;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CampusStoreWeb
{
    public partial class Site : System.Web.UI.MasterPage
    {
        public CarritoWSClient carritoWS;
        public ClienteWSClient clienteWS;

        public Site()
        {
            carritoWS = new CarritoWSClient();
            clienteWS = new ClienteWSClient();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.User.Identity.IsAuthenticated)
            {

                bool isAdmin = Session["IsAdmin"] != null && (bool)Session["IsAdmin"];

                if (isAdmin)
                {
                    // Menú para Admin

                    // Ocultar opciones de cliente
                    if (pnlBusqueda != null)
                    {
                        pnlBusqueda.Visible = false;
                    }
                    txtBusqueda.Enabled = false;
                    btnBuscar.Visible = false;

                    if (lnkLogo != null)
                    {
                        lnkLogo.HRef = "GestionarEmpleados.aspx";
                    }

                    lnkShopProduct.Visible = false;
                    lnkShoppingCart.Visible = false;
                    lnkFooterCuadernos.Visible = false;
                    lnkFooterLibros.Visible = false;
                    lnkFooterPeluches.Visible = false;
                    lnkFooterTomatelodos.Visible = false;
                    lnkFooterUtiles.Visible = false;
                    lnkBrowseAll.Visible = false;
                    lnkPerfil.Visible = false;
                    
                    // Ocultar popup del carrito para admin
                    string script = @"
                        document.addEventListener('DOMContentLoaded', function() {
                            var cartIcon = document.getElementById('lnkCarrito');
                            var cartPopup = document.getElementById('shoppingCartPopup');
                            if (cartIcon) {
                                cartIcon.style.display = 'none';
                            }
                            if (cartPopup) {
                                cartPopup.style.display = 'none';
                            }
                        });
                    ";
                    ScriptManager.RegisterStartupScript(this, GetType(), "HideCartForAdmin", script, true);
                }
                else
                {
                    CargarCarrito();
                    // Menú para Cliente
                    lnkShopProduct.Visible = true;
                    lnkShoppingCart.Visible = true;
                    lnkFooterCuadernos.Visible = true;
                    lnkFooterLibros.Visible = true;
                    lnkFooterPeluches.Visible = true;
                    lnkFooterTomatelodos.Visible = true;
                    lnkFooterUtiles.Visible = true;
                    lnkBrowseAll.Visible = true;
                    lnkPerfil.Visible = true;
                }
            }
            else
            {
                // Menú para usuario no autenticado
                OcultarCarrito();
                lnkPerfil.Visible = false;
            }
        }

        private void OcultarCarrito()
        {
            string script = @"
                document.addEventListener('DOMContentLoaded', function() {
                    var cartIcon = document.getElementById('lnkCarrito');
                    if (cartIcon) {
                        cartIcon.style.display = 'none';
                    }
                });
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "HideCartPopup", script, true);
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            bool isAdmin = Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
            if (isAdmin)
            {
                Response.Redirect("~/GestionarEmpleados.aspx");
                return;
            }

            string busqueda = txtBusqueda.Text;
            if (busqueda.Length == 0)
            {
                Response.Redirect($"~/Shop_Page.aspx");
            }
            else
            {
                // Redirigir a Shop_Page con el término de búsqueda
                Response.Redirect($"~/Shop_Page.aspx?busqueda={Server.UrlEncode(busqueda)}");
            }
        }

        private void CargarCarrito()
        {
            if (!Request.IsAuthenticated)
            {
                MostrarCarritoVacio();
                return;
            }

            try
            {
                // Obtener el ID del cliente logueado
                string cuenta = Page.User.Identity.Name;
                cliente cliente = clienteWS.buscarClientePorCuenta(cuenta);
                if (cliente == null)
                {
                    MostrarCarritoVacio();
                    return;
                }
                int idCliente = cliente.idCliente;

                // Llamar al servicio SOAP para obtener el carrito
                var carrito = carritoWS.obtenerCarritoPorCliente(idCliente);
                System.Diagnostics.Debug.WriteLine($"[Site.Master] Carrito obtenido: ID={carrito?.idCarrito}, completado={carrito?.completado}, lineas={carrito?.lineas?.Length ?? 0}");

                // Verificar que el carrito existe, NO está completado y tiene productos
                if (carrito != null && !carrito.completado && carrito.lineas != null && carrito.lineas.Length > 0)
                {
                    // Bind de datos al Repeater
                    rptCarritoItems.DataSource = carrito.lineas;
                    rptCarritoItems.DataBind();

                    // Calcular totales
                    int cantidadTotal = carrito.lineas.Sum(l => l.cantidad);

                    // Calcular subtotal considerando precios con descuento
                    decimal total = 0;
                    foreach (var linea in carrito.lineas)
                    {
                        // Si tiene precio con descuento, usar ese; si no, usar el precio unitario
                        decimal precioFinal = linea.precioConDescuento > 0
                            ? (decimal)linea.precioConDescuento
                            : (decimal)linea.precioUnitario;

                        total += precioFinal * linea.cantidad;
                    }

                    // Actualizar labels
                    lblCantidadCarrito.Text = cantidadTotal.ToString();
                    lblCantidadPopup.Text = cantidadTotal.ToString("00");
                    lblTotal.Text = total.ToString("N2");

                    // Mostrar productos, ocultar mensaje de vacío
                    pnlCarritoVacio.Visible = false;
                    rptCarritoItems.Visible = true;

                    // Ocultar/mostrar el badge según si hay items
                    if (cantidadTotal == 0)
                    {
                        string script = "document.querySelector('.cart-badge').classList.add('cart-badge-hidden');";
                        ScriptManager.RegisterStartupScript(this, GetType(), "HideBadge", script, true);
                    }
                    else
                    {
                        string script = "document.querySelector('.cart-badge').classList.remove('cart-badge-hidden');";
                        ScriptManager.RegisterStartupScript(this, GetType(), "ShowBadge", script, true);
                    }
                }
                else
                {
                    MostrarCarritoVacio();
                }
            }
            catch (Exception ex)
            {
                // Log del error
                System.Diagnostics.Debug.WriteLine($"Error al cargar carrito: {ex.Message}");
                MostrarCarritoVacio();
            }
        }

        private void MostrarCarritoVacio()
        {
            rptCarritoItems.DataSource = null;
            rptCarritoItems.DataBind();
            rptCarritoItems.Visible = false;

            pnlCarritoVacio.Visible = true;
            lblCantidadCarrito.Text = "0";
            lblCantidadPopup.Text = "0";

            lblTotal.Visible = false;
            lnkCheckout.Visible = false;
            lnkVerCarrito.Visible = false;
        }

        protected void rptCarritoItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
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

                        // Recargar el carrito
                        CargarCarrito();

                        // Actualizar el UpdatePanel
                        upCarrito.Update();
                        upIconoCarrito.Update();
                        
                        // Mostrar mensaje de éxito
                        ScriptManager.RegisterStartupScript(this, GetType(), "productoEliminado",
                            "showNotification('Producto eliminado del carrito');", true);
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
    }
}