using CampusStoreWeb.CampusStoreWS;
using System;
using System.ComponentModel;
using System.Linq;
using System.Web.UI.WebControls;

namespace CampusStoreWeb
{
    public partial class GestionarLibros : System.Web.UI.Page
    {
        private readonly LibroWSClient libroWS;
        private BindingList<libro> libros;

        public GestionarLibros()
        {
            this.libroWS = new LibroWSClient();
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
                CargarLibros();
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarLibros();
            }
        }

        private void CargarLibros()
        {
            libros = new BindingList<libro>(libroWS.listarLibros());
            ViewState["LibrosOriginales"] = libros;
            gvLibros.DataSource = libros;
            gvLibros.DataBind();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string textoBuscar = txtBuscar.Text.Trim();

            if (string.IsNullOrEmpty(textoBuscar))
            {
                // Si no hay texto, mostrar todos los libros
                CargarLibros();
                return;
            }

            // Obtener lista completa de libros
            libros = ViewState["LibrosOriginales"] as BindingList<libro>;
            if (libros == null)
            {
                libros = new BindingList<libro>(libroWS.listarLibros());
                ViewState["LibrosOriginales"] = libros;
            }

            // Intentar buscar por ID primero
            if (int.TryParse(textoBuscar, out int idLibro))
            {
                // Buscar por ID exacto
                var librosFiltrados = libros.Where(x => x.idLibro == idLibro).ToList();

                // Si no encuentra por ID, buscar por nombre
                if (librosFiltrados.Count == 0)
                {
                    librosFiltrados = libros.Where(x =>
                        x.nombre != null &&
                        x.nombre.ToLower().Contains(textoBuscar.ToLower())
                    ).ToList();
                }

                gvLibros.DataSource = librosFiltrados;
                gvLibros.DataBind();
            }
            else
            {
                // Si no es número, buscar solo por nombre
                var librosFiltrados = libros.Where(x =>
                    x.nombre != null &&
                    x.nombre.ToLower().Contains(textoBuscar.ToLower())
                ).ToList();

                gvLibros.DataSource = librosFiltrados;
                gvLibros.DataBind();
            }

            // Resetear paginación
            gvLibros.PageIndex = 0;
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            // Limpiar el campo de búsqueda
            txtBuscar.Text = string.Empty;

            // Recargar todos los libros
            CargarLibros();

            // Resetear paginación
            gvLibros.PageIndex = 0;
        }

        protected void gvLibros_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // 1. Asignar el nuevo índice de página
            gvLibros.PageIndex = e.NewPageIndex;

            // 2. Verificar si hay texto en el buscador para mantener el filtro
            string textoBuscar = txtBuscar.Text.Trim();

            if (string.IsNullOrEmpty(textoBuscar))
            {
                // CASO A: Sin búsqueda, cargar todos los libros
                CargarLibros();
            }
            else
            {
                // CASO B: Con búsqueda, aplicar nuevamente el filtro

                // Recuperar la lista original del ViewState
                libros = ViewState["LibrosOriginales"] as BindingList<libro>;

                // Si el ViewState expiró, recargar de la BD
                if (libros == null)
                {
                    libros = new BindingList<libro>(libroWS.listarLibros());
                    ViewState["LibrosOriginales"] = libros;
                }

                System.Collections.Generic.List<libro> librosFiltrados;

                // Aplicar la misma lógica de filtro que en el botón Buscar
                if (int.TryParse(textoBuscar, out int idLibro))
                {
                    // Buscar por ID
                    librosFiltrados = libros.Where(x => x.idLibro == idLibro).ToList();

                    // Si no encuentra por ID, buscar por nombre
                    if (librosFiltrados.Count == 0)
                    {
                        librosFiltrados = libros.Where(x =>
                            x.nombre != null &&
                            x.nombre.ToLower().Contains(textoBuscar.ToLower())
                        ).ToList();
                    }
                }
                else
                {
                    // Buscar solo por nombre
                    librosFiltrados = libros.Where(x =>
                        x.nombre != null &&
                        x.nombre.ToLower().Contains(textoBuscar.ToLower())
                    ).ToList();
                }

                // 3. IMPORTANTE: Asignar los datos filtrados y enlazar la tabla
                gvLibros.DataSource = librosFiltrados;
                gvLibros.DataBind();
            }
        }

        protected void lbModificar_Click(object sender, EventArgs e)
        {
            int idLibro = int.Parse(((LinkButton)sender).CommandArgument);
            libro libro = libros.SingleOrDefault(x => x.idLibro == idLibro);
            Session["libro"] = libro;
            Response.Redirect("GestionarLibros.aspx?accion=modificar");
        }

        protected void lbEliminar_Click(object sender, EventArgs e)
        {
            int idLibro = Int32.Parse(((LinkButton)sender).CommandArgument);
            libroWS.eliminarLibro(idLibro);
            Response.Redirect("GestionarLibros.aspx");
        }

        protected void lbVerDetalle_Click(object sender, EventArgs e)
        {
            int idLibro = int.Parse(((LinkButton)sender).CommandArgument);
            libro libro = libros.SingleOrDefault(x => x.idLibro == idLibro);
            // Guardar el libro en sesión con un nombre específico para detalles
            Session["libroDetalle"] = libro;
            // Redirigir a la página de detalles del libro
            Response.Redirect("DetalleLibro.aspx");
        }

        protected void btnAgregarLibro_Click(object sender, EventArgs e)
        {
            Response.Redirect("AgregarLibro.aspx");
        }
    }
}