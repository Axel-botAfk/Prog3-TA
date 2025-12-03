using CampusStoreWeb.CampusStoreWS;
using System;
using System.ComponentModel;
using System.Linq;
using System.Web.UI.WebControls;

namespace CampusStoreWeb
{
    public partial class GestionarClientes : System.Web.UI.Page
    {
        private readonly ClienteWSClient clienteWS;
        private BindingList<cliente> clientes;

        public GestionarClientes()
        {
            this.clienteWS = new ClienteWSClient();
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
                CargarClientes();
            }
        }
        
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarClientes();
            }
        }

        private void CargarClientes()
        {
            clientes = new BindingList<cliente>(clienteWS.listarClientes());
            // Guardamos la lista original en ViewState para filtrar después sin ir a BD
            ViewState["ClientesOriginales"] = clientes;
            gvClientes.DataSource = clientes;
            gvClientes.DataBind();
        }

        // LÓGICA DEL BOTÓN BUSCAR
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string textoBuscar = txtBuscar.Text.Trim();

            if (string.IsNullOrEmpty(textoBuscar))
            {
                // Si no hay texto, recargar la lista completa
                CargarClientes();
                return;
            }

            // Recuperar la lista original del ViewState
            clientes = ViewState["ClientesOriginales"] as BindingList<cliente>;
            if (clientes == null)
            {
                // Seguridad por si el ViewState expiró
                clientes = new BindingList<cliente>(clienteWS.listarClientes());
                ViewState["ClientesOriginales"] = clientes;
            }

            // Intentar buscar por ID primero
            if (int.TryParse(textoBuscar, out int idCliente))
            {
                // Buscar por ID exacto
                var clientesFiltrados = clientes.Where(x => x.idCliente == idCliente).ToList();

                // Si no encuentra por ID, intentar buscar también en el nombre (porsiacaso el nombre sea un número)
                if (clientesFiltrados.Count == 0)
                {
                    clientesFiltrados = clientes.Where(x =>
                        (x.nombre != null && x.nombre.ToLower().Contains(textoBuscar.ToLower())) ||
                        (x.nombreUsuario != null && x.nombreUsuario.ToLower().Contains(textoBuscar.ToLower()))
                    ).ToList();
                }

                gvClientes.DataSource = clientesFiltrados;
                gvClientes.DataBind();
            }
            else
            {
                // Si no es número, buscar por nombre o nombre de usuario
                var clientesFiltrados = clientes.Where(x =>
                    (x.nombre != null && x.nombre.ToLower().Contains(textoBuscar.ToLower())) ||
                    (x.nombreUsuario != null && x.nombreUsuario.ToLower().Contains(textoBuscar.ToLower()))
                ).ToList();

                gvClientes.DataSource = clientesFiltrados;
                gvClientes.DataBind();
            }

            // Resetear paginación a la página 1
            gvClientes.PageIndex = 0;
        }

        // LÓGICA DEL BOTÓN LIMPIAR
        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtBuscar.Text = string.Empty;
            CargarClientes();
            gvClientes.PageIndex = 0;
        }

        protected void gvClientes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // 1. Asignar el nuevo índice de página
            gvClientes.PageIndex = e.NewPageIndex;

            // 2. Verificar si hay texto en el buscador
            string textoBuscar = txtBuscar.Text.Trim();

            if (string.IsNullOrEmpty(textoBuscar))
            {
                // CASO A: Sin búsqueda, cargar todo
                CargarClientes();
            }
            else
            {
                // CASO B: Con búsqueda, aplicar el filtro nuevamente

                // Recuperar lista original del ViewState para no ir a la BD si no es necesario
                clientes = ViewState["ClientesOriginales"] as BindingList<cliente>;

                if (clientes == null)
                {
                    clientes = new BindingList<cliente>(clienteWS.listarClientes());
                    ViewState["ClientesOriginales"] = clientes;
                }

                System.Collections.Generic.List<cliente> clientesFiltrados;

                // Aplicar la misma lógica que en el botón Buscar
                if (int.TryParse(textoBuscar, out int idCliente))
                {
                    // Búsqueda por ID
                    clientesFiltrados = clientes.Where(x => x.idCliente == idCliente).ToList();

                    // Si no encuentra por ID, intentar por nombre/usuario
                    if (clientesFiltrados.Count == 0)
                    {
                        clientesFiltrados = clientes.Where(x =>
                            (x.nombre != null && x.nombre.ToLower().Contains(textoBuscar.ToLower())) ||
                            (x.nombreUsuario != null && x.nombreUsuario.ToLower().Contains(textoBuscar.ToLower()))
                        ).ToList();
                    }
                }
                else
                {
                    // Búsqueda por texto (nombre o usuario)
                    clientesFiltrados = clientes.Where(x =>
                        (x.nombre != null && x.nombre.ToLower().Contains(textoBuscar.ToLower())) ||
                        (x.nombreUsuario != null && x.nombreUsuario.ToLower().Contains(textoBuscar.ToLower()))
                    ).ToList();
                }

                // 3. IMPORTANTE: Asignar el DataSource y enlazar
                gvClientes.DataSource = clientesFiltrados;
                gvClientes.DataBind();
            }
        }

        protected void lbModificar_Click(object sender, EventArgs e)
        {
            int idCliente = int.Parse(((LinkButton)sender).CommandArgument);
            cliente cliente = clientes.SingleOrDefault(x => x.idCliente == idCliente);
            Session["cliente"] = cliente;
            Response.Redirect("GestionarClientes.aspx?accion=modificar");
        }

        protected void lbEliminar_Click(object sender, EventArgs e)
        {
            int idCliente = Int32.Parse(((LinkButton)sender).CommandArgument);
            clienteWS.eliminarCliente(idCliente);
            Response.Redirect("GestionarClientes.aspx");
        }

        protected void lbVerDetalle_Click(object sender, EventArgs e)
        {
            int idCliente = int.Parse(((LinkButton)sender).CommandArgument);
            cliente cliente = clientes.SingleOrDefault(x => x.idCliente == idCliente);
            // Guardar el cliente en sesión con un nombre específico para detalles
            Session["clienteDetalle"] = cliente;
            // Redirigir a la página de detalles del cliente
            Response.Redirect("DetalleCliente.aspx");
        }

        protected void btnAgregarCliente_Click(object sender, EventArgs e)
        {
            Response.Redirect("AgregarCliente.aspx");
        }
    }
}