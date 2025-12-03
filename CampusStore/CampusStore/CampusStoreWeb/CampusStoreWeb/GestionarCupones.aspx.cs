using CampusStoreWeb.CampusStoreWS;
using System;
using System.ComponentModel;
using System.Linq;
using System.Web.UI.WebControls;

namespace CampusStoreWeb
{
    public partial class GestionarCupones : System.Web.UI.Page
    {
        private readonly CuponWSClient cuponWS;
        private BindingList<cupon> cupones;

        public GestionarCupones()
        {
            this.cuponWS = new CuponWSClient();
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
                CargarCupones();
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            // Solo cargar en Init si no es PostBack
            if (!IsPostBack)
            {
                CargarCupones();
            }
        }

        private void CargarCupones()
        {
            cupones = new BindingList<cupon>(cuponWS.listarCupones());
            // Guardar en ViewState para persistencia y filtrado
            ViewState["CuponesOriginales"] = cupones;
            gvCupones.DataSource = cupones;
            gvCupones.DataBind();
        }

        // LÓGICA DE BÚSQUEDA
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string textoBuscar = txtBuscar.Text.Trim();

            if (string.IsNullOrEmpty(textoBuscar))
            {
                CargarCupones();
                return;
            }

            // Recuperar lista original del ViewState
            cupones = ViewState["CuponesOriginales"] as BindingList<cupon>;
            if (cupones == null)
            {
                cupones = new BindingList<cupon>(cuponWS.listarCupones());
                ViewState["CuponesOriginales"] = cupones;
            }

            // Intentar buscar por ID primero
            if (int.TryParse(textoBuscar, out int idCupon))
            {
                // Buscar por ID
                var cuponesFiltrados = cupones.Where(x => x.idCupon == idCupon).ToList();

                // Si no encuentra por ID, intentar por Código
                if (cuponesFiltrados.Count == 0)
                {
                    cuponesFiltrados = cupones.Where(x =>
                        x.codigo != null && x.codigo.ToLower().Contains(textoBuscar.ToLower())
                    ).ToList();
                }

                gvCupones.DataSource = cuponesFiltrados;
                gvCupones.DataBind();
            }
            else
            {
                // Buscar solo por Código
                var cuponesFiltrados = cupones.Where(x =>
                    x.codigo != null && x.codigo.ToLower().Contains(textoBuscar.ToLower())
                ).ToList();

                gvCupones.DataSource = cuponesFiltrados;
                gvCupones.DataBind();
            }

            gvCupones.PageIndex = 0;
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtBuscar.Text = string.Empty;
            CargarCupones();
            gvCupones.PageIndex = 0;
        }

        protected void gvCupones_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // 1. Asignar el nuevo índice de página
            gvCupones.PageIndex = e.NewPageIndex;

            // 2. Verificar si hay una búsqueda activa
            string textoBuscar = txtBuscar.Text.Trim();

            if (string.IsNullOrEmpty(textoBuscar))
            {
                // CASO A: Sin búsqueda, cargar todos los cupones
                CargarCupones();
            }
            else
            {
                // CASO B: Con búsqueda, hay que volver a filtrar los datos

                // Recuperar la lista original del ViewState
                cupones = ViewState["CuponesOriginales"] as BindingList<cupon>;

                // Seguridad: si el ViewState expiró, recargar de la BD
                if (cupones == null)
                {
                    cupones = new BindingList<cupon>(cuponWS.listarCupones());
                    ViewState["CuponesOriginales"] = cupones;
                }

                System.Collections.Generic.List<cupon> cuponesFiltrados;

                // Aplicar la misma lógica de filtrado que en btnBuscar_Click
                if (int.TryParse(textoBuscar, out int idCupon))
                {
                    // Buscar por ID
                    cuponesFiltrados = cupones.Where(x => x.idCupon == idCupon).ToList();

                    // Si no encuentra por ID, intentar por Código
                    if (cuponesFiltrados.Count == 0)
                    {
                        cuponesFiltrados = cupones.Where(x =>
                            x.codigo != null && x.codigo.ToLower().Contains(textoBuscar.ToLower())
                        ).ToList();
                    }
                }
                else
                {
                    // Buscar solo por Código
                    cuponesFiltrados = cupones.Where(x =>
                        x.codigo != null && x.codigo.ToLower().Contains(textoBuscar.ToLower())
                    ).ToList();
                }

                // 3. Asignar los datos filtrados y enlazar la tabla
                gvCupones.DataSource = cuponesFiltrados;
                gvCupones.DataBind();
            }
        }

        protected void gvCupones_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                cupon cupon = (cupon)e.Row.DataItem;
                Label lblEstado = (Label)e.Row.FindControl("lblEstado");

                if (lblEstado != null)
                {
                    // Determinar el estado del cupón
                    string estadoTexto = "";
                    string estadoClase = "estado-badge ";

                    if (!cupon.activo)
                    {
                        // Desactivado manualmente
                        estadoTexto = "Inactivo";
                        estadoClase += "estado-inactivo";
                    }
                    else if (cupon.usosRestantes <= 0)
                    {
                        // Agotado (sin usos)
                        estadoTexto = "Agotado";
                        estadoClase += "estado-agotado";
                    }
                    else if (cupon.fechaCaducidad < DateTime.Now)
                    {
                        // Vencido
                        estadoTexto = "Vencido";
                        estadoClase += "estado-vencido";
                    }
                    else
                    {
                        // Activo y disponible
                        estadoTexto = "Activo";
                        estadoClase += "estado-activo";
                    }

                    lblEstado.Text = estadoTexto;
                    lblEstado.CssClass = estadoClase;
                }
            }
        }

        protected void btnAgregarCupon_Click(object sender, EventArgs e)
        {
            Response.Redirect("AgregarCupon.aspx");
        }
    }
}