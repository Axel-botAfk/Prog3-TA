using CampusStoreWeb.CampusStoreWS;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlTypes;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CampusStoreWeb
{
    public partial class DetalleLibro : System.Web.UI.Page
    {
        private readonly LibroWSClient libroWS;
        private readonly DescuentoWSClient descuentoWS;
        private libro libroActual;
        private descuento descuentoActual;
        private int idLibroActual;
        private List<autor> autoresEditSeleccionados;
        private editorial editorialTemporal;

        public DetalleLibro()
        {
            libroWS = new LibroWSClient();
            descuentoWS = new DescuentoWSClient();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarGeneros();
                CargarFormatos();
                CargarEditoriales(); // NUEVO
                CargarAutoresDropdown(); // NUEVO
                CargarDetalleLibro();
            }
            else
            {
                // Recuperar autores del ViewState en postbacks
                if (ViewState["AutoresEditSeleccionados"] != null)
                {
                    autoresEditSeleccionados = (List<autor>)ViewState["AutoresEditSeleccionados"];
                }
            }
        }

        private void CargarEditoriales()
        {
            try
            {
                ddlEditorialEdit.Items.Clear();
                var editoriales = new EditorialWSClient().listarEditoriales();
                ddlEditorialEdit.DataSource = editoriales;
                ddlEditorialEdit.DataTextField = "nombre";
                ddlEditorialEdit.DataValueField = "idEditorial";
                ddlEditorialEdit.DataBind();
                ddlEditorialEdit.Items.Insert(0, new ListItem("-- Seleccione editorial --", "0"));
            }
            catch (Exception ex)
            {
                string script = $"alert('Error al cargar editoriales: {ex.Message}');";
                ClientScript.RegisterStartupScript(this.GetType(), "error", script, true);
            }
        }

        private void CargarAutoresDropdown()
        {
            try
            {
                ddlAutoresEdit.Items.Clear();
                var autores = new AutorWSClient().listarAutores();
                ddlAutoresEdit.DataSource = autores;
                ddlAutoresEdit.DataTextField = "nombre";
                ddlAutoresEdit.DataValueField = "idAutor";
                ddlAutoresEdit.DataBind();
                ddlAutoresEdit.Items.Insert(0, new ListItem("-- Seleccione autor --", "0"));
            }
            catch (Exception ex)
            {
                string script = $"alert('Error al cargar autores: {ex.Message}');";
                ClientScript.RegisterStartupScript(this.GetType(), "error", script, true);
            }
        }

        private void CargarGeneros()
        {
            ddlGenero.Items.Clear();
            ddlGenero.DataSource = Enum.GetNames(typeof(generoLibro));
            ddlGenero.DataBind();
            ddlGenero.Items.Insert(0, new ListItem("Seleccione un género"));
        }

        private void CargarFormatos()
        {
            ddlFormato.Items.Clear();
            ddlFormato.DataSource = Enum.GetNames(typeof(formato));
            ddlFormato.DataBind();
            ddlFormato.Items.Insert(0, new ListItem("Seleccione un formato"));
        }

        private void CargarDetalleLibro()
        {
            if (Request.QueryString["id"] != null)
            {
                if (int.TryParse(Request.QueryString["id"], out idLibroActual))
                {
                    try
                    {
                        libroActual = libroWS.obtenerLibro(idLibroActual);

                        if (libroActual != null)
                        {
                            ViewState["idLibro"] = idLibroActual;
                            MostrarDatosLibro();
                            CargarDescuento();
                        }
                        else
                        {
                            MostrarMensajeError("No se encontró el libro solicitado.");
                        }
                    }
                    catch (Exception ex)
                    {
                        MostrarMensajeError("Error al cargar el libro: " + ex.Message);
                    }
                }
                else
                {
                    MostrarMensajeError("El identificador del libro no es válido.");
                }
            }
            else
            {
                MostrarMensajeError("No se especificó un libro para mostrar.");
            }
        }

        private void MostrarDatosLibro()
        {
            // Mostrar el panel de detalles
            pnlDetalle.Visible = true;
            pnlError.Visible = false;
            pnlVista.Visible = true;
            pnlFormEdicion.Visible = false;

            lblLibroID.Text = libroActual.idLibro.ToString();
            lblNombreLibro.Text = libroActual.nombre;
            lblPrecioUnitario.Text = libroActual.precio.ToString("N2");
            lblPrecioConDescuento.Text = libroActual.precioDescuento.ToString("N2");
            lblStockReal.Text = libroActual.stockReal.ToString();
            lblStockVirtual.Text = libroActual.stockVirtual.ToString();
            lblISBN.Text = libroActual.isbn;
            lblGenero.Text = libroActual.genero.ToString();
            lblFechaPublicacion.Text = libroActual.fechaPublicacion.ToShortDateString();
            lblFormato.Text = libroActual.formato.ToString();
            lblEditorial.Text = libroActual.editorial.nombre;

            libroActual.autores = libroWS.leerAutoresPorLibro(libroActual.idLibro);

            if (libroActual.autores != null && libroActual.autores.Length > 0)
            {
                rptAutores.DataSource = libroActual.autores;
                rptAutores.DataBind();
                rptAutores.Visible = true;
                lblSinAutores.Visible = false;
            }
            else
            {
                rptAutores.Visible = false;
                lblSinAutores.Visible = true;
            }

            lblSinopsis.Text = libroActual.sinopsis ?? "Sin sinopsis disponible.";
            lblDescripcion.Text = libroActual.descripcion ?? "Sin descripción disponible.";
            imgLibro.ImageUrl = libroActual.imagenURL;

            ConfigurarStockBadge(libroActual.stockReal, libroActual.stockVirtual);

            CargarResenas();
        }

        private void ConfigurarStockBadge(int stockReal, int stockVirtual)
        {
            lblStockReal.Text = stockReal + " unidades";
            lblStockVirtual.Text = stockVirtual + " unidades";

            // Aplicar clase CSS según el stock
            if (stockReal == 0)
            {
                lblStockReal.CssClass = "stock-badge stock-agotado";
                lblStockVirtual.CssClass = "stock-badge stock-agotado";
            }
            else if (stockReal < 10)
            {
                lblStockReal.CssClass = "stock-badge stock-bajo";
                lblStockVirtual.CssClass = "stock-badge stock-bajo";
            }
            else
            {
                lblStockReal.CssClass = "stock-badge stock-disponible";
                lblStockVirtual.CssClass = "stock-badge stock-disponible";
            }
        }

        private void CargarDescuento()
        {
            try
            {
                // Obtener descuento del artículo desde el WS
                // Ajusta según tu método en el WS
                descuentoActual = descuentoWS.obtenerDescuentoPorProducto(idLibroActual, tipoProducto.LIBRO);

                if (descuentoActual != null && descuentoActual.activo)
                {
                    // Tiene descuento activo
                    ViewState["idDescuento"] = descuentoActual.idDescuento;
                    ViewState["descuentoActual"] = descuentoActual;
                    MostrarDescuentoActivo();
                }
                else
                {
                    // No tiene descuento
                    MostrarSinDescuento();
                }
            }
            catch
            {
                // Si no existe descuento o hay error, mostrar sin descuento
                MostrarSinDescuento();
            }
        }

        private void MostrarDescuentoActivo()
        {
            pnlDescuentoActivo.Visible = true;
            pnlSinDescuento.Visible = false;
            pnlFormDescuento.Visible = false;

            lblDescuentoValor.Text = descuentoActual.valorDescuento.ToString("N2");
            lblDescuentoFecha.Text = descuentoActual.fechaCaducidad.ToString("dd/MM/yyyy");
            lblDescuentoEstado.Text = descuentoActual.activo ? "Activo" : "Inactivo";
        }

        private void MostrarSinDescuento()
        {
            pnlDescuentoActivo.Visible = false;
            pnlSinDescuento.Visible = true;
            pnlFormDescuento.Visible = false;
        }

        // ========================================
        // BOTÓN AGREGAR DESCUENTO
        // ========================================
        protected void btnAgregarDescuento_Click(object sender, EventArgs e)
        {
            lblTituloDescuento.Text = "Agregar Descuento";
            ViewState.Remove("idDescuento"); // Nuevo descuento
            LimpiarFormularioDescuento();
            MostrarFormularioDescuento(true);
        }

        // ========================================
        // BOTÓN EDITAR DESCUENTO
        // ========================================
        protected void btnEditarDescuento_Click(object sender, EventArgs e)
        {
            if (ViewState["idDescuento"] != null)
            {
                lblTituloDescuento.Text = "Editar Descuento";
                CargarFormularioDescuento();
                MostrarFormularioDescuento(true);
            }
        }

        // ========================================
        // BOTÓN ACTIVAR/DESACTIVAR DESCUENTO
        // ========================================
        protected void btnCambiarEstadoDescuento_Click(object sender, EventArgs e)
        {
            if (ViewState["idDescuento"] != null)
            {
                try
                {
                    // Cambiar el estado al contrario
                    if (ViewState["descuentoActual"] != null)
                        descuentoActual = (descuento)ViewState["descuentoActual"];

                    var d = new descuento
                    {
                        idDescuento = descuentoActual.idDescuento,
                        idDescuentoSpecified = true,

                        valorDescuento = descuentoActual.valorDescuento,
                        valorDescuentoSpecified = true,

                        fechaCaducidad = descuentoActual.fechaCaducidad,
                        fechaCaducidadSpecified = true,

                        activo = !descuentoActual.activo,
                        activoSpecified = true,

                        tipoProducto = tipoProducto.LIBRO,
                        tipoProductoSpecified = true,

                        idProducto = descuentoActual.idProducto,
                        idProductoSpecified = true
                    };

                    // Guardar en el WS
                    descuentoWS.guardarDescuento(d, estado.Modificado);

                    string mensaje = descuentoActual.activo ? "activado" : "desactivado";

                    // NUEVO: Recargar el libro actualizado
                    idLibroActual = (int)ViewState["idLibro"];
                    libroActual = libroWS.obtenerLibro(idLibroActual);
                    MostrarDatosLibro();

                    // Recargar
                    CargarDescuento();


                    string script = $"alert('Descuento {mensaje} exitosamente');";
                    ClientScript.RegisterStartupScript(this.GetType(), "success", script, true);
                }
                catch (Exception ex)
                {
                    string script = $"alert('Error al cambiar estado: {ex.Message}');";
                    ClientScript.RegisterStartupScript(this.GetType(), "error", script, true);
                }
            }
        }

        // ========================================
        // BOTÓN GUARDAR DESCUENTO
        // ========================================
        protected void btnGuardarDescuento_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && ViewState["idLibro"] != null)
            {
                try
                {
                    idLibroActual = (int)ViewState["idLibro"];

                    descuento descuento = new descuento()
                    {
                        valorDescuento = double.Parse(txtDescuentoValor.Text),
                        valorDescuentoSpecified = true,

                        fechaCaducidad = DateTime.Parse(txtDescuentoFecha.Text),
                        fechaCaducidadSpecified = true,

                        activo = chkDescuentoActivo.Checked,
                        activoSpecified = true,

                        tipoProducto = tipoProducto.LIBRO,
                        tipoProductoSpecified = true,

                        idProducto = idLibroActual,
                        idProductoSpecified = true
                    };

                    if (ViewState["idDescuento"] != null)
                    {
                        // ACTUALIZAR descuento existente
                        descuento.idDescuento = (int)ViewState["idDescuento"];
                        descuento.idDescuentoSpecified = true;
                        descuentoWS.guardarDescuento(descuento, estado.Modificado);
                    }
                    else
                    {
                        // CREAR nuevo descuento
                        Console.WriteLine($"TipoProducto enviado: {descuento.tipoProducto}");
                        descuentoWS.guardarDescuento(descuento, estado.Nuevo);
                    }

                    libroActual = libroWS.obtenerLibro(idLibroActual);
                    MostrarDatosLibro();

                    // Recargar
                    CargarDescuento();
                    MostrarFormularioDescuento(false);

                    string script = "alert('Descuento guardado exitosamente');";
                    ClientScript.RegisterStartupScript(this.GetType(), "success", script, true);
                }
                catch (Exception ex)
                {
                    string script = $"alert('Error al guardar descuento: {ex.Message}');";
                    ClientScript.RegisterStartupScript(this.GetType(), "error", script, true);
                }
            }
        }

        // ========================================
        // BOTÓN ELIMINAR DESCUENTO
        // ========================================
        protected void btnEliminarDescuento_Click(object sender, EventArgs e)
        {
            if (ViewState["idDescuento"] != null)
            {
                try
                {
                    int idDescuento = (int)ViewState["idDescuento"];
                    descuentoWS.eliminarDescuento(descuentoActual);

                    ViewState.Remove("idDescuento");

                    // NUEVO: Recargar el libro actualizado
                    idLibroActual = (int)ViewState["idLibro"];
                    libroActual = libroWS.obtenerLibro(idLibroActual);
                    MostrarDatosLibro();

                    MostrarSinDescuento();

                    string script = "alert('Descuento eliminado exitosamente');";
                    ClientScript.RegisterStartupScript(this.GetType(), "success", script, true);
                }
                catch (Exception ex)
                {
                    string script = $"alert('Error al eliminar descuento: {ex.Message}');";
                    ClientScript.RegisterStartupScript(this.GetType(), "error", script, true);
                }
            }
        }

        protected void btnCancelarDescuento_Click(object sender, EventArgs e)
        {
            MostrarFormularioDescuento(false);
        }

        private void MostrarFormularioDescuento(bool mostrar)
        {
            pnlFormDescuento.Visible = mostrar;
            pnlDescuentoActivo.Visible = !mostrar && ViewState["idDescuento"] != null;
            pnlSinDescuento.Visible = !mostrar && ViewState["idDescuento"] == null;
        }

        private void LimpiarFormularioDescuento()
        {
            txtDescuentoValor.Text = string.Empty;
            txtDescuentoFecha.Text = string.Empty;
            chkDescuentoActivo.Checked = true;
        }

        private void CargarFormularioDescuento()
        {
            if (descuentoActual != null)
            {
                txtDescuentoValor.Text = descuentoActual.valorDescuento.ToString("F2");
                txtDescuentoFecha.Text = descuentoActual.fechaCaducidad.ToString("yyyy-MM-dd");
                chkDescuentoActivo.Checked = descuentoActual.activo;
            }
        }

        private void MostrarMensajeError(string mensaje)
        {
            pnlDetalle.Visible = false;
            pnlError.Visible = true;
            lblMensajeError.Text = mensaje;
        }

        protected void btnEditar_Click(object sender, EventArgs e)
        {
            // Recuperar ID del ViewState
            if (ViewState["idLibro"] != null)
            {
                idLibroActual = (int)ViewState["idLibro"];

                try
                {
                    // Recargar el artículo por si cambió
                    libroActual = libroWS.obtenerLibro(idLibroActual);

                    if (libroActual != null)
                    {
                        CargarFormularioEdicion();
                        MostrarFormularioEdicion(true);
                    }
                }
                catch (Exception ex)
                {
                    MostrarMensajeError("Error al cargar datos para editar: " + ex.Message);
                }
            }
        }

        private void CargarFormularioEdicion()
        {
            
            txtNombre.Text = libroActual.nombre;
            txtPrecioUnitario.Text = libroActual.precio.ToString("F2");
            txtPrecioConDescuento.Text = libroActual.precioDescuento.ToString("F2");
            txtStockReal.Text = libroActual.stockReal.ToString();
            txtStockVirtual.Text = libroActual.stockVirtual.ToString();
            txtISBN.Text = libroActual.isbn;
            ddlGenero.SelectedValue = libroActual.genero.ToString();
            txtFechaPublicacion.Text = libroActual.fechaPublicacion.ToString("yyyy-MM-dd");
            ddlFormato.SelectedValue = libroActual.formato.ToString();
            if (libroActual.editorial != null)
            {
                ddlEditorialEdit.SelectedValue = libroActual.editorial.idEditorial.ToString();
            }

            if (libroActual.autores != null && libroActual.autores.Length > 0)
            {
                autoresEditSeleccionados = new List<autor>(libroActual.autores);
                ViewState["AutoresEditSeleccionados"] = autoresEditSeleccionados;
                ActualizarAutoresEdit();
            }
            else
            {
                autoresEditSeleccionados = new List<autor>();
                ViewState["AutoresEditSeleccionados"] = autoresEditSeleccionados;
                ActualizarAutoresEdit();
            }

            txtSinopsis.Text = libroActual.sinopsis;
            txtDescripcion.Text = libroActual.descripcion;

        }

        protected void btnGuardarEditorial_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    // Crear nueva editorial temporal (igual que en AgregarLibro)
                    editorialTemporal = new editorial
                    {
                        idEditorial = 0, // solo temporal
                        idEditorialSpecified = false,
                        nombre = txtEditorialNombre.Text.Trim(),
                        cif = txtEditorialCIF.Text.Trim(),
                        telefono = string.IsNullOrWhiteSpace(txtEditorialTelefono.Text) ? 0 : int.Parse(txtEditorialTelefono.Text),
                        telefonoSpecified = !string.IsNullOrWhiteSpace(txtEditorialTelefono.Text),
                        email = txtEditorialEmail.Text.Trim(),
                        direccion = txtEditorialDireccion.Text.Trim(),
                        sitioWeb = txtEditorialWeb.Text.Trim()
                    };

                    // Guardar en ViewState para mantenerla entre postbacks
                    ViewState["EditorialTemporal"] = editorialTemporal;

                    // Agregar al dropdown como opción temporal
                    ddlEditorialEdit.Items.Insert(1, new ListItem($"[NUEVA] {editorialTemporal.nombre}", "TEMP_EDITORIAL"));
                    ddlEditorialEdit.SelectedValue = "TEMP_EDITORIAL";

                    // Limpiar campos del modal
                    LimpiarModalEditorial();

                    // Cerrar modal y mostrar mensaje
                    string script = @"
                hideModalEditorial();
                alert('Editorial preparada. Se creará al guardar el libro.');
            ";
                    ClientScript.RegisterStartupScript(this.GetType(), "editorialSuccess", script, true);
                }
                catch (Exception ex)
                {
                    string script = $"alert('Error al preparar editorial: {ex.Message}');";
                    ClientScript.RegisterStartupScript(this.GetType(), "error", script, true);
                }
            }
        }

        private void LimpiarModalEditorial()
        {
            txtEditorialNombre.Text = string.Empty;
            txtEditorialCIF.Text = string.Empty;
            txtEditorialTelefono.Text = string.Empty;
            txtEditorialEmail.Text = string.Empty;
            txtEditorialDireccion.Text = string.Empty;
            txtEditorialWeb.Text = string.Empty;
        }

        protected void btnGuardarAutor_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    // Crear nuevo autor temporal (igual que en AgregarLibro)
                    autor nuevoAutorTemporal = new autor
                    {
                        idAutor = 0, // temporal, se creará al guardar el libro
                        idAutorSpecified = false,
                        nombre = txtAutorNombre.Text.Trim(),
                        apellidos = txtAutorApellidos.Text.Trim(),
                        alias = txtAutorAlias.Text.Trim()
                    };

                    // Recuperar la lista de autores en edición
                    if (ViewState["AutoresEditSeleccionados"] != null)
                    {
                        autoresEditSeleccionados = (List<autor>)ViewState["AutoresEditSeleccionados"];
                    }
                    else
                    {
                        autoresEditSeleccionados = new List<autor>();
                    }

                    // Agregar directamente a la lista
                    autoresEditSeleccionados.Add(nuevoAutorTemporal);
                    ViewState["AutoresEditSeleccionados"] = autoresEditSeleccionados;
                    ActualizarAutoresEdit();

                    // Limpiar campos del modal
                    LimpiarModalAutor();

                    // Cerrar modal y mostrar mensaje
                    string script = @"
                hideModalAutor();
                alert('Autor agregado a la lista. Se creará al guardar el libro.');
            ";
                    ClientScript.RegisterStartupScript(this.GetType(), "autorSuccess", script, true);
                }
                catch (Exception ex)
                {
                    string script = $"alert('Error al agregar autor: {ex.Message}');";
                    ClientScript.RegisterStartupScript(this.GetType(), "error", script, true);
                }
            }
        }

        private void LimpiarModalAutor()
        {
            txtAutorNombre.Text = string.Empty;
            txtAutorApellidos.Text = string.Empty;
            txtAutorAlias.Text = string.Empty;
        }

        private void ActualizarAutoresEdit()
        {
            if (autoresEditSeleccionados != null && autoresEditSeleccionados.Count > 0)
            {
                rptAutoresEdit.DataSource = autoresEditSeleccionados;
                rptAutoresEdit.DataBind();
                rptAutoresEdit.Visible = true;
                lblNoAutoresEdit.Visible = false;
            }
            else
            {
                rptAutoresEdit.Visible = false;
                lblNoAutoresEdit.Visible = true;
            }
        }
        protected void btnAgregarAutorEdit_Click(object sender, EventArgs e)
        {
            if (ddlAutoresEdit.SelectedValue != "0")
            {
                try
                {
                    int idAutor = int.Parse(ddlAutoresEdit.SelectedValue);

                    if (ViewState["AutoresEditSeleccionados"] != null)
                    {
                        autoresEditSeleccionados = (List<autor>)ViewState["AutoresEditSeleccionados"];
                    }
                    else
                    {
                        autoresEditSeleccionados = new List<autor>();
                    }

                    // Verificar si ya está en la lista
                    if (!autoresEditSeleccionados.Any(a => a.idAutor == idAutor))
                    {
                        var autorCompleto = new AutorWSClient().obtenerAutor(idAutor);
                        if (autorCompleto != null)
                        {
                            autoresEditSeleccionados.Add(autorCompleto);
                            ViewState["AutoresEditSeleccionados"] = autoresEditSeleccionados;
                            ActualizarAutoresEdit();
                            ddlAutoresEdit.SelectedIndex = 0;
                        }
                    }
                    else
                    {
                        string script = "alert('Este autor ya está en la lista.');";
                        ClientScript.RegisterStartupScript(this.GetType(), "warning", script, true);
                    }
                }
                catch (Exception ex)
                {
                    string script = $"alert('Error al agregar autor: {ex.Message}');";
                    ClientScript.RegisterStartupScript(this.GetType(), "error", script, true);
                }
            }
        }

        protected void rptAutoresEdit_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "EliminarAutor")
            {
                int idAutor = int.Parse(e.CommandArgument.ToString());

                if (ViewState["AutoresEditSeleccionados"] != null)
                {
                    autoresEditSeleccionados = (List<autor>)ViewState["AutoresEditSeleccionados"];
                    autoresEditSeleccionados.RemoveAll(a => a.idAutor == idAutor);
                    ViewState["AutoresEditSeleccionados"] = autoresEditSeleccionados;
                    ActualizarAutoresEdit();
                }
            }
        }

        private void MostrarFormularioEdicion(bool mostrar)
        {
            pnlVista.Visible = !mostrar;
            pnlFormEdicion.Visible = mostrar;

            btnEditar.Visible = !mostrar;
            btnEliminar.Visible = !mostrar;
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && ViewState["idLibro"] != null)
            {
                try
                {
                    idLibroActual = (int)ViewState["idLibro"];

                    editorial editorialLibro;

                    if (ddlEditorialEdit.SelectedValue == "TEMP_EDITORIAL")
                    {
                        // Usar la editorial temporal
                        if (ViewState["EditorialTemporal"] != null)
                        {
                            editorialLibro = (editorial)ViewState["EditorialTemporal"];
                        }
                        else
                        {
                            string scriptA = "alert('Error: No se encontró la editorial temporal.');";
                            ClientScript.RegisterStartupScript(this.GetType(), "error", scriptA, true);
                            return;
                        }
                    }
                    else if (ddlEditorialEdit.SelectedValue != "0")
                    {
                        // Obtener editorial existente
                        int idEditorial = int.Parse(ddlEditorialEdit.SelectedValue);
                        editorial editorialExistente = new EditorialWSClient().obtenerEditorial(idEditorial);

                        editorialLibro = new editorial()
                        {
                            idEditorial = editorialExistente.idEditorial,
                            idEditorialSpecified = true,
                            nombre = editorialExistente.nombre,
                            cif = editorialExistente.cif,
                            direccion = editorialExistente.direccion,
                            email = editorialExistente.email,
                            telefono = editorialExistente.telefono,
                            telefonoSpecified = true,
                            sitioWeb = editorialExistente.sitioWeb
                        };
                    }
                    else
                    {
                        string scriptA = "alert('Debe seleccionar o crear una editorial.');";
                        ClientScript.RegisterStartupScript(this.GetType(), "error", scriptA, true);
                        return;
                    }

                    if (ViewState["AutoresEditSeleccionados"] != null)
                    {
                        autoresEditSeleccionados = (List<autor>)ViewState["AutoresEditSeleccionados"];
                    }
                    else
                    {
                        autoresEditSeleccionados = new List<autor>();
                    }

                    string imagenUrlFinal;
                    libroActual = libroWS.obtenerLibro(idLibroActual);

                    if (fuPortadaEdit.HasFile)
                    {
                        try
                        {
                            imagenUrlFinal = SubirImagenAImgBB(fuPortadaEdit.PostedFile);
                        }
                        catch (Exception imgEx)
                        {
                            string scriptEx = $"alert('Error al subir la imagen: {imgEx.Message}');";
                            ClientScript.RegisterStartupScript(this.GetType(), "errorImagen", scriptEx, true);
                            return;
                        }
                    }
                    else
                    {
                        imagenUrlFinal = libroActual.imagenURL;
                    }

                    libro libroEditado = new libro
                    {
                        idLibro = idLibroActual,
                        idLibroSpecified = true,
                        nombre = txtNombre.Text.Trim(),
                        precio = double.Parse(txtPrecioUnitario.Text),
                        precioSpecified = true,
                        precioDescuento = double.Parse(txtPrecioConDescuento.Text),
                        precioDescuentoSpecified = true,
                        stockReal = int.Parse(txtStockReal.Text),
                        stockRealSpecified = true,
                        stockVirtual = int.Parse(txtStockVirtual.Text),
                        stockVirtualSpecified = true,
                        isbn = txtISBN.Text,
                        genero = (generoLibro)Enum.Parse(typeof(generoLibro), ddlGenero.SelectedItem.Text),
                        generoSpecified = true,
                        fechaPublicacion = DateTime.Parse(txtFechaPublicacion.Text),
                        fechaPublicacionSpecified = true,
                        formato = (formato)Enum.Parse(typeof(formato), ddlFormato.SelectedItem.Text),
                        formatoSpecified = true,
                        sinopsis = txtSinopsis.Text,
                        descripcion = txtDescripcion.Text,
                        editorial = editorialLibro,
                        autores = autoresEditSeleccionados?.ToArray(),
                        imagenURL = imagenUrlFinal
                    };

                    if (ddlEditorialEdit.SelectedValue == "TEMP_EDITORIAL")
                    {
                        libroEditado.editorial.idEditorial = 0;
                        libroEditado.editorial.idEditorialSpecified = true;
                    }
                    else
                    {
                        libroEditado.editorial.idEditorialSpecified = true;
                    }

                    foreach (var a in libroEditado.autores)
                    {
                        a.idAutorSpecified = true;
                    }

                    bool hayTemporales = autoresEditSeleccionados.Any(a => a.idAutor == 0) ||
                                         ddlEditorialEdit.SelectedValue == "TEMP_EDITORIAL";

                    if (hayTemporales)
                    {
                        libroWS.modificarLibroConAutores(libroEditado, autoresEditSeleccionados.ToArray());
                    }
                    else
                    {
                        libroWS.guardarLibro(libroEditado, estado.Modificado);
                    }

                    libroActual = libroWS.obtenerLibro(idLibroActual);

                    ViewState.Remove("EditorialTemporal");
                    ViewState.Remove("AutoresEditSeleccionados");

                    MostrarDatosLibro();
                    MostrarFormularioEdicion(false);

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
        }

        private string SubirImagenAImgBB(System.Web.HttpPostedFile archivo)
        {
            if (archivo == null || archivo.ContentLength == 0)
                throw new Exception("No se recibió ninguna imagen.");

            // Validación simple de tipo de archivo
            if (!archivo.ContentType.StartsWith("image/"))
                throw new Exception("El archivo seleccionado no es una imagen válida.");

            string apiKey = ConfigurationManager.AppSettings["ImgBBApiKey"];
            if (string.IsNullOrEmpty(apiKey))
                throw new Exception("No se ha configurado la API Key de ImgBB.");

            using (var content = new MultipartFormDataContent())
            {
                byte[] bytes;
                using (var br = new BinaryReader(archivo.InputStream))
                {
                    bytes = br.ReadBytes(archivo.ContentLength);
                }

                var fileContent = new ByteArrayContent(bytes);
                fileContent.Headers.ContentType = MediaTypeHeaderValue.Parse(archivo.ContentType);

                content.Add(fileContent, "image", Path.GetFileName(archivo.FileName));

                var url = $"https://api.imgbb.com/1/upload?key={apiKey}";

                using (var httpClient = new HttpClient())
                {
                    var response = httpClient.PostAsync(url, content).Result;
                    response.EnsureSuccessStatusCode();

                    string json = response.Content.ReadAsStringAsync().Result;

                    dynamic result = JsonConvert.DeserializeObject(json);
                    bool success = result.success;

                    if (!success)
                    {
                        throw new Exception("ImgBB no pudo procesar la imagen.");
                    }

                    string imageUrl = result.data.url;
                    return imageUrl;
                }
            }
        }

        protected void btnCancelarEdit_Click(object sender, EventArgs e)
        {
            // Volver a mostrar los datos sin cambios
            MostrarFormularioEdicion(false);
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            if (ViewState["idLibro"] != null)
            {
                try
                {
                    idLibroActual = (int)ViewState["idLibro"];
                    libroWS.eliminarLibro(idLibroActual);

                    // Redirigir con mensaje de éxito
                    Response.Redirect("GestionarLibros.aspx?mensaje=eliminado");
                }
                catch (Exception ex)
                {
                    MostrarMensajeError("Error al eliminar el libro: " + ex.Message);
                }
            }
        }

        private void CargarResenas()
        {
            if (libroActual?.reseñas != null && libroActual.reseñas.Length > 0)
            {
                // Hay reseñas
                pnlConResenas.Visible = true;
                pnlSinResenas.Visible = false;

                // Calcular promedio
                double promedio = libroActual.reseñas.Average(r => r.calificacion);
                lblPromedioRating.Text = promedio.ToString("F1");
                lblTotalResenas.Text = $"({libroActual.reseñas.Length} {(libroActual.reseñas.Length == 1 ? "reseña" : "reseñas")})";

                // Generar estrellas de promedio
                GenerarEstrellasPromedio(promedio);

                // Ordenar por fecha más reciente primero
                
                var resenasOrdenadas = libroActual.reseñas.ToArray();

                // Vincular al Repeater
                rptResenas.DataSource = resenasOrdenadas;
                rptResenas.DataBind();
            }
            else
            {
                // No hay reseñas
                pnlConResenas.Visible = false;
                pnlSinResenas.Visible = true;
                lblPromedioRating.Text = "0.0";
                lblTotalResenas.Text = "(0 reseñas)";
                GenerarEstrellasPromedio(0);
            }
        }

        private void GenerarEstrellasPromedio(double promedio)
        {
            int estrellasLlenas = (int)Math.Floor(promedio);
            bool mediaEstrella = (promedio - estrellasLlenas) >= 0.5;
            int estrellasVacias = 5 - estrellasLlenas - (mediaEstrella ? 1 : 0);

            string html = "";

            // Estrellas llenas
            for (int i = 0; i < estrellasLlenas; i++)
            {
                html += "<i class='bi bi-star-fill' style='color: var(--primary-orange);'></i>";
            }

            // Media estrella
            if (mediaEstrella)
            {
                html += "<i class='bi bi-star-half' style='color: var(--primary-orange);'></i>";
            }

            // Estrellas vacías
            for (int i = 0; i < estrellasVacias; i++)
            {
                html += "<i class='bi bi-star' style='color: #E4E7E9;'></i>";
            }

            estrellasPromedio.InnerHtml = html;
        }

        // Método helper para el Repeater (para generar estrellas de cada reseña)
        protected string GenerarEstrellas(int calificacion)
        {
            string html = "";

            for (int i = 1; i <= 5; i++)
            {
                if (i <= calificacion)
                {
                    html += "<i class='bi bi-star-fill'></i>";
                }
                else
                {
                    html += "<i class='bi bi-star estrella-vacia'></i>";
                }
            }

            return html;
        }
    }
}