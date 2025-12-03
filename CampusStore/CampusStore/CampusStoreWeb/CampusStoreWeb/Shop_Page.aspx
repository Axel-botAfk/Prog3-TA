<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Shop_Page.aspx.cs" Inherits="CampusStoreWeb.Shop_Page" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- 2. CSS para el efecto Hover y los nuevos botones -->
    <style>
        /* 1. Contenedor de la imagen: Le decimos que será el "ancla" para los botones */
    .product-card .card-img-container { 
        position: relative; 
        overflow: hidden; 
    }

    /* 2. Capa de los botones (NUEVA TÉCNICA DE CENTRADO) */
    .product-card .product-actions {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        
        /* Centrado con Flexbox: robusto y moderno */
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;

        background-color: rgba(0, 0, 0, 0.2); /* Opcional: un ligero velo oscuro */
        opacity: 0; /* Oculto por defecto */
        transition: opacity 0.3s ease-in-out;
    }

    /* 3. El efecto hover ahora solo muestra/oculta la capa */
    .product-card:hover .product-actions { 
        opacity: 1; 
    }

    /* 4. Estilo de los botones (sin cambios) */
    .product-card .action-btn { 
        display: flex; 
        justify-content: center; 
        align-items: center; 
        width: 45px; 
        height: 45px; 
        background-color: white; 
        color: #333; 
        border-radius: 50%; 
        text-decoration: none; 
        box-shadow: 0 2px 8px rgba(0,0,0,0.15); 
        transition: background-color 0.2s, color 0.2s; 
        
        /* Evita que los botones se muevan al aparecer la capa */
        transform: translateY(10px);
        transition: transform 0.3s ease-in-out, background-color 0.2s, color 0.2s;
    }
    
    .product-card:hover .action-btn {
        transform: translateY(0);
    }

    .product-card .action-btn:hover { 
        background-color: #fd7e14; 
        color: #fff; 
    }

    /* Estilos de los filtros (sin cambios) */
    .form-check-list { list-style-type: none; padding-left: 0; }
     #quickViewModal .modal-lg { max-width: 900px; }
        #quickViewModal .modal-content { border-radius: 4px; border: none; }
        #quickViewModal .modal-body { padding: 2rem; }
        #quickViewModal .quick-view-title { font-size: 2rem; font-weight: 700; margin-bottom: 0.5rem; }
        #quickViewModal .quick-view-price { font-size: 1.75rem; font-weight: 600; color: #0d6efd; margin-bottom: 1rem; }
        #quickViewModal .quick-view-description { color: #6c757d; margin-bottom: 1.5rem; }
        #quickViewModal .quick-view-availability { font-size: 0.9rem; margin-bottom: 1.5rem; }
        #quickViewModal .quick-view-availability .in-stock { color: #198754; font-weight: bold; }
        #quickViewModal .quick-view-availability .out-stock { color: #dc3545; font-weight: bold; }
        #quickViewModal .loading-spinner { display: flex; justify-content: center; align-items: center; min-height: 400px; }
        #quickViewModal .quick-view-actions { display: flex; align-items: center; gap: 10px; }
        #quickViewModal .quick-view-qty { width: 70px; text-align: center; height: 40px; }
        #quickViewModal .btn-add-to-cart { background-color: #ffc107; border-color: #ffc107; color: #212529; font-weight: bold; height: 40px; }
        #quickViewModal .btn-add-to-cart:hover { background-color: #e0a800; border-color: #e0a800; }
    </style>
    <script type="text/javascript">
        function validarFiltrosCliente() {
            // Obtener la categoría seleccionada
            var categoriaSeleccionada = '';
            var radioButtons = document.querySelectorAll('input[type="radio"][name*="rblCategorias"]');
            for (var i = 0; i < radioButtons.length; i++) {
                if (radioButtons[i].checked) {
                    categoriaSeleccionada = radioButtons[i].value;
                    break;
                }
            }

            // Si NO es libro, verificar que no haya filtros de libro seleccionados
            if (categoriaSeleccionada !== 'libro') {
                var hayFiltrosLibro = false;

                // Verificar Editoriales
                var checkboxesEditoriales = document.querySelectorAll('input[type="checkbox"][name*="cblEditoriales"]');
                for (var i = 0; i < checkboxesEditoriales.length; i++) {
                    if (checkboxesEditoriales[i].checked) {
                        hayFiltrosLibro = true;
                        break;
                    }
                }

                // Verificar Autores
                if (!hayFiltrosLibro) {
                    var checkboxesAutores = document.querySelectorAll('input[type="checkbox"][name*="cblAutores"]');
                    for (var i = 0; i < checkboxesAutores.length; i++) {
                        if (checkboxesAutores[i].checked) {
                            hayFiltrosLibro = true;
                            break;
                        }
                    }
                }

                // Verificar Géneros
                if (!hayFiltrosLibro) {
                    var checkboxesGeneros = document.querySelectorAll('input[type="checkbox"][name*="cblGeneros"]');
                    for (var i = 0; i < checkboxesGeneros.length; i++) {
                        if (checkboxesGeneros[i].checked) {
                            hayFiltrosLibro = true;
                            break;
                        }
                    }
                }

                if (hayFiltrosLibro) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Filtros Incompatibles',
                        html: 'No puedes aplicar filtros de <strong>Editorial, Autor o Género</strong> cuando la categoría no es "Libros".<br/><br/>Por favor, selecciona la categoría <strong>"Libros"</strong> o desmarca los filtros específicos.',
                        confirmButtonColor: '#0d6efd',
                        confirmButtonText: 'Entendido'
                    });
                    return false; // Prevenir postback
                }
            }

            return true; // Permitir el postback
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container-fluid">

        <!-- =================================================================== -->
        <!-- ESTE ES EL <div class="row"> PRINCIPAL QUE ENVUELVE AMBAS COLUMNAS -->
        <!-- =================================================================== -->
        <div class="row">

            <!-- ============================================= -->
            <!-- COLUMNA 1: FILTROS (col-md-3)                 -->
            <!-- ============================================= -->
            <aside class="col-md-3">
                <div class="filters-sidebar">
                    
                    <!-- SECCIÓN DE CATEGORÍAS -->
                    <div class="filter-section">
                        <h4>CATEGORÍAS</h4>
                        <asp:RadioButtonList ID="rblCategorias" runat="server" CssClass="form-check-list" RepeatLayout="Flow">
                            <asp:ListItem Value="libro" Text="Libros" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="articulo" Text="Todos los artículos"></asp:ListItem>
                            <asp:ListItem Value="LAPICERO" Text="Lapiceros"></asp:ListItem>
                            <asp:ListItem Value="CUADERNO" Text="Cuadernos"></asp:ListItem>
                            <asp:ListItem Value="PELUCHE" Text="Peluches"></asp:ListItem>
                            <asp:ListItem Value="TOMATODO" Text="Tomatodos"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>

                    <!-- SECCIÓN DE EDITORIALES -->
                    <div class="filter-section">
                        <h4>EDITORIALES</h4>
                        <asp:CheckBoxList ID="cblEditoriales" runat="server" CssClass="form-check-list">
                            <%-- El Code-Behind llenará esta lista dinámicamente --%>
                        </asp:CheckBoxList>
                    </div>

                    <!-- SECCIÓN DE AUTORES -->
                    <div class="filter-section">
                        <h4>AUTORES</h4>
                        <asp:CheckBoxList ID="cblAutores" runat="server" CssClass="form-check-list">
                            <%-- El Code-Behind llenará esta lista dinámicamente --%>
                        </asp:CheckBoxList>
                    </div>

                    <!-- SECCIÓN DE GÉNERO -->
                    <div class="filter-section">
                        <h4>GÉNERO LIBRO</h4>
                        <asp:CheckBoxList ID="cblGeneros" runat="server" CssClass="form-check-list">
                            <asp:ListItem Value="NOVELA">Novela</asp:ListItem>
                            <asp:ListItem Value="NARRATIVO">Narrativo</asp:ListItem>
                            <asp:ListItem Value="DRAMA">Drama</asp:ListItem>
                            <asp:ListItem Value="FANTASIA">Fantasía</asp:ListItem>
                            <asp:ListItem Value="AVENTURA">Aventura</asp:ListItem>
                            <asp:ListItem Value="CIENCIA_FICCION">Ciencia ficción</asp:ListItem>
                        </asp:CheckBoxList>
                    </div>
                    
                    <div>
                        <asp:Button ID="btnAplicarFiltros" runat="server" Text="Aplicar Filtros" 
                                    OnClick="btnAplicarFiltros_Click" 
                                    OnClientClick="return validarFiltrosCliente();"
                                    CssClass="btn btn-outline-primary" />
                    </div>
                </div>
            </aside>

            <!-- ============================================= -->
            <!-- COLUMNA 2: PRODUCTOS (col-md-9)               -->
            <!-- ============================================= -->
            <main class="col-md-9">
                <!-- Fila INTERNA para la cuadrícula de productos y el mensaje -->
                <div class="row">
                    
                    <!-- El Repeater que genera las tarjetas de producto -->
                   <!-- El Repeater que genera las tarjetas de producto -->
            <asp:Repeater ID="rptProductos" runat="server" OnItemCommand="rptProductos_ItemCommand">
                <ItemTemplate>
                    <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                        <div class="card h-100 product-card">

                            <!-- Contenedor de la imagen (el ancla) -->
                            <div class="card-img-container">
                    
                                <!-- Imagen principal -->
                                <a href='<%# Eval("TipoProducto", "Product_detail.aspx?type={0}&id=") + Eval("Id") %>'>
                                    <asp:Image runat="server" CssClass="card-img-top" ImageUrl='<%# Eval("UrlImagen") %>' AlternateText='<%# Eval("Nombre") %>' />
                                </a>
                    
                                <!-- Capa de acciones (hijo directo del contenedor) -->
                                <div class="product-actions">
                                    <!-- Botón de Vista Rápida (Ojo) -->
                                       <a href="#" class="action-btn" title="Vista Rápida" 
                                               onclick='openQuickView(<%# Eval("Id") %>, "<%# Eval("TipoProducto") %>"); return false;'>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16"><path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/><path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/></svg>
                                            </a>
                                    
                                    <!-- Botón de Añadir al Carrito -->
                                    <asp:LinkButton runat="server" CommandName="AddToCart" CommandArgument='<%# Eval("Id") + "," + Eval("TipoProducto") %>' CssClass="action-btn" ToolTip="Añadir al Carrito">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16"><path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM3.102 4l1.313 7h8.17l1.313-7H3.102zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/></svg>
                                    </asp:LinkButton>
                                </div>
                            </div>

                            <!-- Cuerpo de la tarjeta -->
                            <div class="card-body">
                                <h5 class="card-title">
                                    <a href='<%# Eval("TipoProducto", "Product_detail.aspx?type={0}&id=") + Eval("Id") %>'><%# Eval("Nombre") %></a>
                                </h5>
                                <p class="card-text price">S/.<%# Eval("Precio", "{0:F2}") %></p>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

                    <!-- El Panel para el mensaje de "No hay productos" -->
                    <div class="col-12">
                         <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="text-center mt-5">
                            <h4>No se encontraron productos con estas características.</h4>
                            <p>Intenta ajustar tus filtros o selecciona otra categoría.</p>
                        </asp:Panel>
                    </div>

                </div> <!-- CORRECCIÓN: Este es el cierre de la fila INTERNA de contenido -->

                <!-- PAGINACIÓN -->
                <asp:Panel ID="pnlPaginacion" runat="server" CssClass="d-flex justify-content-center mt-4">
                    <nav>
                        <ul class="pagination">
            
                            <!-- Botón Anterior -->
                            <li class="page-item">
                                <asp:LinkButton ID="btnAnterior" runat="server" 
                                    CssClass="page-link" 
                                    OnClick="btnAnterior_Click" 
                                    Visible="false">&larr;</asp:LinkButton>
                            </li>

                            <!-- Repetidor para los números de página -->
                            <asp:Repeater ID="rptPaginacionNumeros" runat="server" OnItemCommand="rptPaginacionNumeros_ItemCommand">
                                <ItemTemplate>
                                    <li class='<%# Convert.ToInt32(Container.DataItem) == PaginaActual ? "page-item active" : "page-item" %>'>
                                        <asp:LinkButton ID="lnkPagina" runat="server" 
                                            CssClass="page-link" 
                                            CommandName="IrPagina" 
                                            CommandArgument='<%# Container.DataItem %>'>
                                            <%# Container.DataItem %>
                                        </asp:LinkButton>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>

                            <!-- Botón Siguiente -->
                            <li class="page-item">
                                <asp:LinkButton ID="btnSiguiente" runat="server" 
                                    CssClass="page-link" 
                                    OnClick="btnSiguiente_Click" 
                                    Visible="false">&rarr;</asp:LinkButton>
                            </li>

                        </ul>
                    </nav>
                </asp:Panel>

            </main>
          
        </div> <!-- CORRECCIÓN: Este es el CIERRE CORRECTO del <div class="row"> PRINCIPAL -->

    </div>
    <!-- HTML DEL MODAL DE VISTA RÁPIDA -->
     <div class="modal fade" id="quickViewModal" tabindex="-1" aria-labelledby="quickViewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="quickViewModalLabel">Vista Rápida</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="modalContent"></div>
                    <div id="modalLoading" class="loading-spinner">
                        <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!-- JAVASCRIPT para la lógica del Modal -->
    <script type="text/javascript">
        var quickViewModal; // Hacemos la variable del modal global

        // 1. Envolvemos la inicialización en DOMContentLoaded
        document.addEventListener('DOMContentLoaded', function () {
            var modalElement = document.getElementById('quickViewModal');
            if (modalElement) {
                quickViewModal = new bootstrap.Modal(modalElement, {});
            }
        });

        // 2. Definimos las funciones en el scope GLOBAL (fuera de DOMContentLoaded)
        function openQuickView(id, tipo) {
            if (!quickViewModal) {
                console.error('Bootstrap Modal no está inicializado.');
                return;
            }
            document.getElementById('modalContent').innerHTML = '';
            document.getElementById('modalLoading').style.display = 'flex';
            quickViewModal.show();
            PageMethods.GetProductDetails(tipo, id, onGetDetailsSuccess, onGetDetailsError);
        }

        function onGetDetailsSuccess(result) {
            document.getElementById('modalLoading').style.display = 'none';
            if (result) {
                let autorHtml = result.Autor ? `<p class="text-muted mb-2">Autor: ${result.Autor}</p>` : '';
                let disponibilidadClass = result.Stock > 0 ? "in-stock" : "out-stock";
                let disponibilidadTexto = result.Stock > 0 ? "En Stock" : "Agotado";

                let contentHtml = `
                    <div class="row">
                        <div class="col-md-6">
                            <img id="mainModalImage" src="${result.UrlImagen}" class="img-fluid rounded" />
                        </div>
                        <div class="col-md-6">
                            <p class="text-muted mb-1">${result.TipoDeProducto || (result.TipoProducto === 'libro' ? 'Libro' : 'Artículo')}</p>
                            <h2 class="quick-view-title">${result.Nombre}</h2>
                            ${autorHtml}
                            <h3 class="quick-view-price">${result.Precio.toLocaleString('es-PE', { style: 'currency', currency: 'PEN' })}</h3>
                            <p class="quick-view-description">${result.Descripcion || 'Sin descripción.'}</p>
                            <p class="quick-view-availability">Disponibilidad: <span class="${disponibilidadClass}">${disponibilidadTexto}</span></p>
                        </div>
                    </div>`;

                document.getElementById('modalContent').innerHTML = contentHtml;
            } else {
                document.getElementById('modalContent').innerHTML = '<p class="text-center text-danger">No se pudieron cargar los detalles del producto.</p>';
            }
        }

        function onGetDetailsError(error) {
            document.getElementById('modalLoading').style.display = 'none';
            document.getElementById('modalContent').innerHTML = `<p class="text-center text-danger">Error: ${error.get_message()}</p>`;
        }

        function addFromModal(productoId, tipoProducto) {
            var cantidad = parseInt(document.getElementById('modalQty').value) || 1;

            // Crear un formulario oculto para hacer el postback
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = window.location.href;

            var targetInput = document.createElement('input');
            targetInput.type = 'hidden';
            targetInput.name = '__EVENTTARGET';
            targetInput.value = 'AddToCartFromModal';
            form.appendChild(targetInput);

            var argInput = document.createElement('input');
            argInput.type = 'hidden';
            argInput.name = '__EVENTARGUMENT';
            argInput.value = productoId + ',' + tipoProducto + ',' + cantidad;
            form.appendChild(argInput);

            document.body.appendChild(form);
            form.submit();
        }

    </script>
</asp:Content>