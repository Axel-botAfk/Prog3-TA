using CampusStoreWeb.CampusStoreWS;
using System;
using System.ComponentModel;
using System.Linq;
using System.Web.UI.WebControls;

namespace CampusStoreWeb
{
    public partial class GestionarArticulos : System.Web.UI.Page
    {
        private readonly ArticuloWSClient articuloWS;
        private BindingList<articulo> articulos;

        public GestionarArticulos()
        {
            this.articuloWS = new ArticuloWSClient();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar que sea Admin
            bool isAdmin = Session["IsAdmin"] != null && (bool)Session["IsAdmin"];
            if (!isAdmin)
            {
                Response.Redirect("Catalogo.aspx");
                return;
            }

            if (!IsPostBack)
            {
                CargarArticulos();
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarArticulos();
            }
        }

        private void CargarArticulos()
        {
            articulos = new BindingList<articulo>(articuloWS.listarArticulos());
            ViewState["ArticulosOriginales"] = articulos;
            gvArticulos.DataSource = articulos;
            gvArticulos.DataBind();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string textoBuscar = txtBuscar.Text.Trim();

            if (string.IsNullOrEmpty(textoBuscar))
            {
                // Si no hay texto, mostrar todos los artículos
                CargarArticulos();
                return;
            }

            // Obtener lista completa de artículos
            articulos = ViewState["ArticulosOriginales"] as BindingList<articulo>;
            if (articulos == null)
            {
                articulos = new BindingList<articulo>(articuloWS.listarArticulos());
                ViewState["ArticulosOriginales"] = articulos;
            }

            // Intentar buscar por ID primero
            if (int.TryParse(textoBuscar, out int idArticulo))
            {
                // Buscar por ID exacto
                var articulosFiltrados = articulos.Where(x => x.idArticulo == idArticulo).ToList();

                // Si no encuentra por ID, buscar por nombre
                if (articulosFiltrados.Count == 0)
                {
                    articulosFiltrados = articulos.Where(x =>
                        x.nombre != null &&
                        x.nombre.ToLower().Contains(textoBuscar.ToLower())
                    ).ToList();
                }

                gvArticulos.DataSource = articulosFiltrados;
                gvArticulos.DataBind();
            }
            else
            {
                // Si no es número, buscar solo por nombre
                var articulosFiltrados = articulos.Where(x =>
                    x.nombre != null &&
                    x.nombre.ToLower().Contains(textoBuscar.ToLower())
                ).ToList();

                gvArticulos.DataSource = articulosFiltrados;
                gvArticulos.DataBind();
            }

            // Resetear paginación
            gvArticulos.PageIndex = 0;
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            // Limpiar el campo de búsqueda
            txtBuscar.Text = string.Empty;

            // Recargar todos los artículos
            CargarArticulos();

            // Resetear paginación
            gvArticulos.PageIndex = 0;
        }

        protected void gvArticulos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // 1. Establecer el nuevo índice de página
            gvArticulos.PageIndex = e.NewPageIndex;

            // 2. Verificar si el usuario tiene algo escrito en el buscador
            string textoBuscar = txtBuscar.Text.Trim();

            if (string.IsNullOrEmpty(textoBuscar))
            {
                // CASO A: No hay búsqueda, cargar todo normal
                CargarArticulos();
            }
            else
            {
                // CASO B: Hay búsqueda, debemos filtrar de nuevo los datos para la nueva página

                // Recuperar la lista completa del ViewState
                articulos = ViewState["ArticulosOriginales"] as BindingList<articulo>;

                // Prevención de errores: si el ViewState expiró, recargar de BD
                if (articulos == null)
                {
                    articulos = new BindingList<articulo>(articuloWS.listarArticulos());
                    ViewState["ArticulosOriginales"] = articulos;
                }

                System.Collections.Generic.List<articulo> articulosFiltrados;

                // Aplicar la misma lógica de filtro que en el botón Buscar
                if (int.TryParse(textoBuscar, out int idArticulo))
                {
                    // Buscar por ID
                    articulosFiltrados = articulos.Where(x => x.idArticulo == idArticulo).ToList();

                    // Si no encuentra por ID, intentar por nombre
                    if (articulosFiltrados.Count == 0)
                    {
                        articulosFiltrados = articulos.Where(x =>
                            x.nombre != null &&
                            x.nombre.ToLower().Contains(textoBuscar.ToLower())
                        ).ToList();
                    }
                }
                else
                {
                    // Buscar solo por nombre
                    articulosFiltrados = articulos.Where(x =>
                        x.nombre != null &&
                        x.nombre.ToLower().Contains(textoBuscar.ToLower())
                    ).ToList();
                }

                // 3. Enlazar los datos filtrados a la tabla
                gvArticulos.DataSource = articulosFiltrados;
                gvArticulos.DataBind();
            }
        }

        protected void lbModificar_Click(object sender, EventArgs e)
        {
            int idArticulo = int.Parse(((LinkButton)sender).CommandArgument);
            articulo articulo = articulos.SingleOrDefault(x => x.idArticulo == idArticulo);
            Session["articulo"] = articulo;
            Response.Redirect("GestionarArticulos.aspx?accion=modificar");
        }

        protected void lbEliminar_Click(object sender, EventArgs e)
        {
            int idArticulo = Int32.Parse(((LinkButton)sender).CommandArgument);
            articuloWS.eliminarArticulo(idArticulo);
            Response.Redirect("GestionarArticulos.aspx");
        }

        // NUEVO MÉTODO: Ver detalles del artículo
        protected void lbVerDetalle_Click(object sender, EventArgs e)
        {
            int idArticulo = int.Parse(((LinkButton)sender).CommandArgument);
            articulo articulo = articulos.SingleOrDefault(x => x.idArticulo == idArticulo);

            // Guardar el artículo en sesión con un nombre específico para detalles
            Session["articuloDetalle"] = articulo;

            // Redirigir a la página de detalles
            Response.Redirect("DetalleArticulo.aspx");
        }

        protected void btnAgregarArticulo_Click(object sender, EventArgs e)
        {
            Response.Redirect("AgregarArticulo.aspx");
        }

    }
}