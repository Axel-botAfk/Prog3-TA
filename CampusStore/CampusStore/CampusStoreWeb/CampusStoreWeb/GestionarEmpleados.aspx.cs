using CampusStoreWeb.CampusStoreWS;
using System;
using System.ComponentModel;
using System.Linq;

namespace CampusStoreWeb
{
    public partial class GestionarEmpleados : System.Web.UI.Page
    {
        private readonly EmpleadoWSClient empleadoWS;
        private BindingList<empleado> empleados;
        
        public GestionarEmpleados()
        {
            this.empleadoWS = new EmpleadoWSClient();
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
                CargarEmpleados();
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            // Solo cargar en Init si no es postback para respetar la búsqueda
            if (!IsPostBack)
            {
                CargarEmpleados();
            }
        }

        private void CargarEmpleados()
        {
            empleados = new BindingList<empleado>(empleadoWS.listarEmpleados());
            // Guardar en ViewState para filtrar sin ir a BD
            ViewState["EmpleadosOriginales"] = empleados;
            gvEmpleados.DataSource = empleados;
            gvEmpleados.DataBind();
        }

        // LÓGICA DEL BOTÓN BUSCAR
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string textoBuscar = txtBuscar.Text.Trim();

            if (string.IsNullOrEmpty(textoBuscar))
            {
                CargarEmpleados();
                return;
            }

            // Recuperar lista original
            empleados = ViewState["EmpleadosOriginales"] as BindingList<empleado>;
            if (empleados == null)
            {
                empleados = new BindingList<empleado>(empleadoWS.listarEmpleados());
                ViewState["EmpleadosOriginales"] = empleados;
            }

            // Búsqueda
            if (int.TryParse(textoBuscar, out int idEmpleado))
            {
                // Buscar por ID
                var empleadosFiltrados = empleados.Where(x => x.idEmpleado == idEmpleado).ToList();

                // Si no encuentra por ID, intentar buscar por texto (nombre/usuario)
                if (empleadosFiltrados.Count == 0)
                {
                    empleadosFiltrados = empleados.Where(x =>
                        (x.nombre != null && x.nombre.ToLower().Contains(textoBuscar.ToLower())) ||
                        (x.nombreUsuario != null && x.nombreUsuario.ToLower().Contains(textoBuscar.ToLower()))
                    ).ToList();
                }

                gvEmpleados.DataSource = empleadosFiltrados;
                gvEmpleados.DataBind();
            }
            else
            {
                // Buscar por Nombre o Nombre de Usuario
                var empleadosFiltrados = empleados.Where(x =>
                    (x.nombre != null && x.nombre.ToLower().Contains(textoBuscar.ToLower())) ||
                    (x.nombreUsuario != null && x.nombreUsuario.ToLower().Contains(textoBuscar.ToLower()))
                ).ToList();

                gvEmpleados.DataSource = empleadosFiltrados;
                gvEmpleados.DataBind();
            }

            gvEmpleados.PageIndex = 0;
        }

        // LÓGICA DEL BOTÓN LIMPIAR
        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtBuscar.Text = string.Empty;
            CargarEmpleados();
            gvEmpleados.PageIndex = 0;
        }

        protected void gvEmpleados_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            // 1. Asignar el nuevo índice de página
            gvEmpleados.PageIndex = e.NewPageIndex;

            // 2. Verificar si hay texto en el buscador para mantener el filtro
            string textoBuscar = txtBuscar.Text.Trim();

            if (string.IsNullOrEmpty(textoBuscar))
            {
                // CASO A: Sin búsqueda, cargar todos los empleados
                CargarEmpleados();
            }
            else
            {
                // CASO B: Con búsqueda, aplicar nuevamente el filtro

                // Recuperar lista original del ViewState
                empleados = ViewState["EmpleadosOriginales"] as BindingList<empleado>;

                // Si el ViewState expiró, recargar de BD
                if (empleados == null)
                {
                    empleados = new BindingList<empleado>(empleadoWS.listarEmpleados());
                    ViewState["EmpleadosOriginales"] = empleados;
                }

                System.Collections.Generic.List<empleado> empleadosFiltrados;

                // Aplicar lógica de filtrado (ID, Nombre o Usuario) igual que en el botón Buscar
                if (int.TryParse(textoBuscar, out int idEmpleado))
                {
                    // Buscar por ID
                    empleadosFiltrados = empleados.Where(x => x.idEmpleado == idEmpleado).ToList();

                    // Si no encuentra por ID, intentar buscar por texto (nombre/usuario)
                    if (empleadosFiltrados.Count == 0)
                    {
                        empleadosFiltrados = empleados.Where(x =>
                            (x.nombre != null && x.nombre.ToLower().Contains(textoBuscar.ToLower())) ||
                            (x.nombreUsuario != null && x.nombreUsuario.ToLower().Contains(textoBuscar.ToLower()))
                        ).ToList();
                    }
                }
                else
                {
                    // Buscar solo por texto
                    empleadosFiltrados = empleados.Where(x =>
                        (x.nombre != null && x.nombre.ToLower().Contains(textoBuscar.ToLower())) ||
                        (x.nombreUsuario != null && x.nombreUsuario.ToLower().Contains(textoBuscar.ToLower()))
                    ).ToList();
                }

                // 3. IMPORTANTE: Asignar los datos filtrados y enlazar la tabla
                gvEmpleados.DataSource = empleadosFiltrados;
                gvEmpleados.DataBind();
            }
        }

        protected void lbModificar_Click(object sender, EventArgs e)
        {
            int idEmpleado = int.Parse(((System.Web.UI.WebControls.LinkButton)sender).CommandArgument);
            empleado empleado = empleados.SingleOrDefault(x => x.idEmpleado == idEmpleado);
            Session["empleado"] = empleado;
            Response.Redirect("GestionarEmpleados.aspx?accion=modificar");
        }

        protected void lbEliminar_Click(object sender, EventArgs e)
        {
            int idEmpleado = Int32.Parse(((System.Web.UI.WebControls.LinkButton)sender).CommandArgument);
            empleadoWS.eliminarEmpleado(idEmpleado);
            Response.Redirect("GestionarEmpleados.aspx");
        }

        protected void lbVerDetalle_Click(object sender, EventArgs e)
        {
            int idEmpleado = int.Parse(((System.Web.UI.WebControls.LinkButton)sender).CommandArgument);
            empleado empleado = empleados.SingleOrDefault(x => x.idEmpleado == idEmpleado);
            // Guardar el empleado en sesión con un nombre específico para detalles
            Session["empleadoDetalle"] = empleado;
            // Redirigir a la página de detalles del empleado
            Response.Redirect("DetalleEmpleado.aspx");
        }

        protected void btnAgregarEmpleado_Click(object sender, EventArgs e)
        {
            Response.Redirect("AgregarEmpleado.aspx");
        }
    }
}