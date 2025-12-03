<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DetalleLibro.aspx.cs" Inherits="CampusStoreWeb.DetalleLibro" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Breadcrumb personalizado */
        .breadcrumb-custom {
            background-color: #f8f9fa;
            padding: 20px 0;
            margin-bottom: 30px;
        }
    
        .breadcrumb-custom .breadcrumb {
            background-color: transparent;
            margin-bottom: 0;
            padding: 0;
        }
    
        .breadcrumb-custom .breadcrumb-item {
            font-size: 14px;
            color: #5F6C72;
        }
    
        .breadcrumb-custom .breadcrumb-item.active {
            color: var(--primary-orange);
            font-weight: 500;
        }
    
        .breadcrumb-custom .breadcrumb-item a {
            color: #5F6C72;
            text-decoration: none;
        }
    
        .breadcrumb-custom .breadcrumb-item a:hover {
            color: var(--primary-orange);
        }
    
        /* Botón volver */
        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #5F6C72;
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 20px;
            transition: color 0.3s;
        }
    
        .btn-back:hover {
            color: var(--primary-orange);
        }
    
        /* Card principal */
        .detalle-card {
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 40px;
        }
    
        .detalle-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 2px solid #E4E7E9;
        }
    
        .detalle-title h1 {
            font-size: 28px;
            font-weight: 600;
            color: #191C1F;
            margin-bottom: 8px;
        }
    
        .detalle-id {
            color: #5F6C72;
            font-size: 14px;
        }
    
        .detalle-actions {
            display: flex;
            gap: 12px;
        }
    
        .btn-edit-detail, .btn-delete-detail {
            padding: 10px 24px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            border: none;
        }
    
        .btn-edit-detail {
            background-color: var(--primary-orange);
            color: white;
        }
    
        .btn-edit-detail:hover {
            background-color: #d86f28;
            color: white;
        }
    
        .btn-delete-detail {
            background-color: #FFE5E5;
            color: #EE5858;
        }
    
        .btn-delete-detail:hover {
            background-color: #ffcccc;
        }
    
        /* Grid de información */
        .detalle-grid {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 40px;
            margin-bottom: 40px;
        }
    
        .detalle-imagen {
            width: 100%;
            aspect-ratio: 1;
            border: 2px solid #E4E7E9;
            border-radius: 8px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #F9FAFB;
        }
    
        .detalle-imagen img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
    
        .detalle-info {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }
    
        .info-row {
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #E4E7E9;
        }
    
        .info-row:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }
    
        .info-label {
            color: #5F6C72;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
        }
    
        .info-value {
            color: #191C1F;
            font-size: 16px;
            font-weight: 500;
        }
    
        .precio-value {
            color: var(--primary-orange);
            font-size: 24px;
            font-weight: 700;
        }
    
        .stock-badge {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
        }
    
        .stock-disponible {
            background-color: #EAF7ED;
            color: #2DB224;
        }
    
        .stock-bajo {
            background-color: #FFF3E6;
            color: var(--primary-orange);
        }
    
        .stock-agotado {
            background-color: #FFE5E5;
            color: #EE5858;
        }
    
        /* Mensaje de error */
        .error-message {
            background-color: #FFE5E5;
            color: #EE5858;
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
    
        .error-message i {
            font-size: 24px;
        }

        /* ============================================ */
        /* FORMULARIO DE EDICIÓN INLINE */
        /* ============================================ */
        .form-edicion {
            background-color: #F9FAFB;
            border: 2px solid var(--primary-orange);
            border-radius: 8px;
            padding: 30px;
            margin-top: 30px;
        }

        .form-edicion h3 {
            font-size: 20px;
            font-weight: 600;
            color: #191C1F;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-edicion h3 i {
            color: var(--primary-orange);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group-full {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            color: #475156;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 8px;
            text-transform: uppercase;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #E4E7E9;
            border-radius: 4px;
            font-size: 14px;
            color: #191C1F;
            background-color: white;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-orange);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #E4E7E9;
        }

        .btn-form {
            padding: 12px 30px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            text-transform: uppercase;
        }

        .btn-guardar {
            background-color: var(--primary-orange);
            color: white;
        }

        .btn-guardar:hover {
            background-color: #d86f28;
        }

        .btn-cancelar-edit {
            background-color: #E4E7E9;
            color: #5F6C72;
        }

        .btn-cancelar-edit:hover {
            background-color: #d1d5d9;
        }

        /* ============================================ */
        /* SECCIÓN DE DESCUENTO */
        /* ============================================ */
        .descuento-section {
            background-color: #F9FAFB;
            border: 2px solid #E4E7E9;
            border-radius: 8px;
            padding: 24px;
            margin-top: 30px;
        }

        .descuento-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .descuento-header h3 {
            font-size: 18px;
            font-weight: 600;
            color: #191C1F;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .descuento-header i {
            color: var(--primary-orange);
            font-size: 22px;
        }

        .descuento-activo {
            background-color: white;
            border: 2px solid #2DB224;
            border-radius: 8px;
            padding: 20px;
        }

        .descuento-activo-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background-color: #EAF7ED;
            color: #2DB224;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 16px;
        }

        .descuento-info-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 16px;
        }

        .descuento-info-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .descuento-info-label {
            font-size: 12px;
            color: #5F6C72;
            text-transform: uppercase;
            font-weight: 600;
        }

        .descuento-info-value {
            font-size: 16px;
            color: #191C1F;
            font-weight: 600;
        }

        .descuento-valor-grande {
            font-size: 24px;
            color: #2DB224;
        }

        .descuento-actions {
            display: flex;
            gap: 10px;
            padding-top: 16px;
            border-top: 1px solid #E4E7E9;
        }

        .sin-descuento {
            background-color: white;
            border: 2px dashed #E4E7E9;
            border-radius: 8px;
            padding: 30px;
            text-align: center;
        }

        .sin-descuento i {
            font-size: 48px;
            color: #929FA5;
            margin-bottom: 12px;
        }

        .sin-descuento p {
            color: #5F6C72;
            margin-bottom: 16px;
        }

        .btn-agregar-descuento {
            background-color: var(--primary-orange);
            color: white;
            padding: 10px 24px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }

        .btn-agregar-descuento:hover {
            background-color: #d86f28;
        }

        .btn-small {
            padding: 8px 16px;
            font-size: 13px;
        }

        .btn-secondary-small {
            background-color: #E4E7E9;
            color: #5F6C72;
        }

        .btn-secondary-small:hover {
            background-color: #d1d5d9;
        }

        .btn-danger-small {
            background-color: #FFE5E5;
            color: #EE5858;
        }

        .btn-danger-small:hover {
            background-color: #ffcccc;
        }

        /* Badges de autores */
        .autores-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .autor-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background-color: #E8F4FD;
            color: #2DA5F3;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
            border: 1px solid #2DA5F3;
        }

        .autor-badge i {
            font-size: 14px;
        }

        .text-muted {
            color: #929FA5;
            font-size: 14px;
            font-style: italic;
        }

        /* Grid con botón para editorial */
        .form-control-with-button {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 8px;
            align-items: start;
        }

        .btn-nuevo-item {
            background-color: #2DA5F3;
            color: white;
            padding: 10px 16px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            white-space: nowrap;
            margin-top: 26px;
        }
        /* ============================================ */
        /* SECCIÓN DE RESEÑAS */
        /* ============================================ */
        .resenas-section {
            background-color: #F9FAFB;
            border: 2px solid #E4E7E9;
            border-radius: 8px;
            padding: 32px;
            margin-top: 30px;
            overflow: visible;
            box-sizing: border-box;
        }

        .resenas-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            padding: 16px 0 20px 0;
            border-bottom: 2px solid #E4E7E9;
            flex-wrap: wrap;
            gap: 20px;
            width: 100%;
            box-sizing: border-box;
        }

        .resenas-title-group {
            display: flex;
            align-items: center;
            gap: 12px;
            flex: 1;
            min-width: 200px;
            padding-right: 16px;
            box-sizing: border-box;
        }

        .resenas-title-group h3 {
            font-size: 20px;
            font-weight: 600;
            color: #191C1F;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .resenas-title-group h3 i {
            color: var(--primary-orange);
            font-size: 24px;
        }

        .resenas-count {
            color: #5F6C72;
            font-size: 14px;
            font-weight: 500;
        }

        .resenas-rating-summary {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-shrink: 0;
            padding-left: 16px;
            box-sizing: border-box;
        }

        .rating-promedio {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            min-width: fit-content;
            padding: 8px;
            box-sizing: border-box;
        }

        .rating-numero {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-orange);
            line-height: 1;
            white-space: nowrap;
        }

        .rating-estrellas-grande {
            display: flex;
            gap: 3px;
            font-size: 16px;
            flex-wrap: nowrap;
            align-items: center;
            justify-content: center;
        }

        /* Lista de reseñas */
        .resenas-lista {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .resena-card {
            background-color: white;
            border: 1px solid #E4E7E9;
            border-radius: 8px;
            padding: 20px;
            transition: box-shadow 0.3s;
        }

        .resena-card:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .resena-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }

        .resena-usuario-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .resena-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background-color: #F9FAFB;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #5F6C72;
            font-size: 32px;
        }

        .resena-usuario-datos {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .resena-usuario-nombre {
            font-size: 15px;
            font-weight: 600;
            color: #191C1F;
        }

        .resena-fecha {
            font-size: 13px;
            color: #5F6C72;
        }

        .resena-calificacion {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .rating-estrellas {
            display: flex;
            gap: 2px;
            color: var(--primary-orange);
            font-size: 16px;
        }

        .rating-estrellas i {
            color: var(--primary-orange);
        }

        .rating-estrellas .estrella-vacia {
            color: #E4E7E9;
        }

        .rating-numero-pequeno {
            font-size: 14px;
            font-weight: 600;
            color: #5F6C72;
        }

        .resena-contenido {
            margin-bottom: 12px;
        }

        .resena-comentario {
            font-size: 14px;
            line-height: 1.6;
            color: #475156;
            margin: 0;
        }

        /* Respuesta del vendedor */
        .resena-respuesta {
            background-color: #FFF9F5;
            border-left: 3px solid var(--primary-orange);
            border-radius: 4px;
            padding: 16px;
            margin-top: 16px;
        }

        .respuesta-header {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            color: var(--primary-orange);
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .respuesta-header i {
            font-size: 16px;
        }

        .respuesta-texto {
            font-size: 14px;
            line-height: 1.6;
            color: #475156;
            margin: 0 0 8px 0;
        }

        .respuesta-fecha {
            font-size: 12px;
            color: #5F6C72;
        }

        /* Sin reseñas */
        .sin-resenas {
            background-color: white;
            border: 2px dashed #E4E7E9;
            border-radius: 8px;
            padding: 40px;
            text-align: center;
        }

        .sin-resenas i {
            font-size: 56px;
            color: #929FA5;
            margin-bottom: 16px;
        }

        .sin-resenas p {
            color: #5F6C72;
            font-size: 16px;
            font-weight: 500;
            margin: 0 0 8px 0;
        }

        .sin-resenas-subtexto {
            color: #929FA5;
            font-size: 14px;
        }

        /* Panel Modal */
        .modal-panel {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            padding: 20px;
        }

        .modal-panel.show {
            display: flex;
        }

        .modal-content {
            background-color: white;
            border-radius: 8px;
            max-width: 600px;
            width: 100%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .modal-header {
            padding: 24px;
            border-bottom: 2px solid #E4E7E9;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            font-size: 20px;
            font-weight: 600;
            color: #191C1F;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .modal-header h2 i {
            color: var(--primary-orange);
        }

        .btn-close-modal {
            background: none;
            border: none;
            color: #5F6C72;
            font-size: 24px;
            cursor: pointer;
            padding: 0;
            line-height: 1;
        }

        .btn-close-modal:hover {
            color: var(--primary-orange);
        }

        .modal-body {
            padding: 24px;
        }

        .modal-footer {
            padding: 20px 24px;
            border-top: 1px solid #E4E7E9;
            display: flex;
            gap: 12px;
            justify-content: flex-end;
        }
    
        @media (max-width: 768px) {
            .detalle-grid {
                grid-template-columns: 1fr;
            }
        
            .detalle-header {
                flex-direction: column;
                gap: 20px;
            }
        
            .info-row {
                grid-template-columns: 1fr;
                gap: 8px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .descuento-info-grid {
                grid-template-columns: 1fr;
            }

            .resenas-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }

            .resenas-rating-summary {
                width: 100%;
                justify-content: flex-start;
            }

            .resena-header {
                flex-direction: column;
                gap: 12px;
            }

            .rating-promedio {
                flex-direction: row;
                gap: 12px;
                align-items: center;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Breadcrumb -->
    <div class="breadcrumb-custom">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <asp:HyperLink runat="server" NavigateUrl="~/">
                            <i class="bi bi-house-door"></i> Home
                        </asp:HyperLink>
                    </li>
                    <li class="breadcrumb-item">
                        <asp:HyperLink runat="server" NavigateUrl="~/GestionarLibros.aspx">Gestionar Libros</asp:HyperLink>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Detalle del Libro</li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="container">
    
        <!-- Botón volver -->
        <asp:HyperLink ID="btnVolver" runat="server" NavigateUrl="~/GestionarLibros.aspx" CssClass="btn-back">
            <i class="bi bi-arrow-left"></i> Volver a Libros
        </asp:HyperLink>
    
        <!-- Panel de error (oculto por defecto) -->
        <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="error-message">
            <i class="bi bi-exclamation-triangle-fill"></i>
            <div>
                <strong>Error:</strong> 
                <asp:Label ID="lblMensajeError" runat="server"></asp:Label>
            </div>
        </asp:Panel>
    
        <!-- Card de detalle -->
        <asp:Panel ID="pnlDetalle" runat="server" CssClass="detalle-card">
        
            <!-- Header -->
            <div class="detalle-header">
                <div class="detalle-title">
                    <h1>
                        <asp:Label ID="lblNombreLibro" runat="server" Text=""></asp:Label>
                    </h1>
                    <span class="detalle-id">
                        Libro ID: #<asp:Label ID="lblLibroID" runat="server" Text=""></asp:Label>
                    </span>
                </div>
                <div class="detalle-actions">
                    <asp:LinkButton ID="btnEditar" runat="server" CssClass="btn-edit-detail" OnClick="btnEditar_Click" CausesValidation="false">
                        <i class="bi bi-pencil"></i> Editar
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnEliminar" runat="server" CssClass="btn-delete-detail" OnClick="btnEliminar_Click" OnClientClick="return confirm('¿Estás seguro de eliminar este artículo?');" CausesValidation="false">
                        <i class="bi bi-trash"></i> Eliminar
                    </asp:LinkButton>
                </div>
            </div>
        
            <!-- Vista de Detalle (solo lectura) -->
            <asp:Panel ID="pnlVista" runat="server">
                <div class="detalle-grid">
                
                    <!-- Imagen -->
                    <div class="detalle-imagen">
                        <asp:Image runat="server" ID="imgLibro" />
                    </div>
                
                    <!-- Información -->
                    <div class="detalle-info">
                    
                        <div class="info-row">
                            <span class="info-label">Precio Unitario</span>
                            <span class="precio-value">
                                S/.<asp:Label ID="lblPrecioUnitario" runat="server" Text="0.00"></asp:Label>
                            </span>
                        </div>

                        <div class ="info-row">
                            <span class="info-label">Precio con Descuento</span>
                            <span class ="precio-value">
                                S/.<asp:Label ID="lblPrecioConDescuento" runat="server" Text="0.00"></asp:Label>
                            </span>
                        </div>
                    
                        <div class="info-row">
                            <span class="info-label">Stock Real</span>
                            <div>
                                <asp:Label ID="lblStockReal" runat="server" CssClass="stock-badge stock-disponible" Text=""></asp:Label>
                            </div>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Stock Virtual</span>
                            <div>
                                <asp:Label ID="lblStockVirtual" runat="server" CssClass="stock-badge stock-disponible" Text=""></asp:Label>
                            </div>
                        </div>

                        <div class ="info-row">
                            <span class="info-label">ISBN</span>
                            <div>
                                <asp:Label ID="lblISBN" runat="server" Text="ISBN"></asp:Label>
                            </div>
                        </div>
                    
                        <div class="info-row">
                            <span class="info-label">Género</span>
                            <span class="info-value">
                                <asp:Label ID="lblGenero" runat="server" Text="Género"></asp:Label>
                            </span>
                        </div>

                        <div class ="info-row">
                            <span class="info-label">Fecha de Publicación</span>
                            <div>
                                <asp:Label ID="lblFechaPublicacion" runat="server" Text="Fecha"></asp:Label>
                            </div>
                        </div>

                        <div class ="info-row">
                            <span class="info-label">Formato</span>
                            <div>
                                <asp:Label ID="lblFormato" runat="server" Text="Formato"></asp:Label>
                            </div>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Editorial</span>
                            <span class="info-value">
                                <asp:Label ID="lblEditorial" runat="server" Text="Editorial"></asp:Label>
                            </span>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Autores</span>
                            <div class="autores-list">
                                <asp:Repeater ID="rptAutores" runat="server">
                                    <ItemTemplate>
                                        <span class="autor-badge">
                                            <i class="bi bi-person-fill"></i>
                                            <%# Eval("nombre") %> <%# Eval("apellidos") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Label ID="lblSinAutores" runat="server" Text="No se especificaron autores" CssClass="text-muted" Visible="false"></asp:Label>
                            </div>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Sinopsis</span>
                            <span class="info-value">
                                <asp:Label ID="lblSinopsis" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                    
                        <div class="info-row">
                            <span class="info-label">Descripción</span>
                            <span class="info-value">
                                <asp:Label ID="lblDescripcion" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                    
                    </div>
                    <div class="resenas-section">
                        <div class="resenas-header">
                            <div class="resenas-title-group">
                                <h3><i class="bi bi-star-fill"></i> Reseñas y Calificaciones</h3>
                                <asp:Label ID="lblTotalResenas" runat="server" CssClass="resenas-count" Text="(0 reseñas)"></asp:Label>
                            </div>
                            <div class="resenas-rating-summary">
                                <div class="rating-promedio">
                                    <span class="rating-numero">
                                        <asp:Label ID="lblPromedioRating" runat="server" Text="0.0"></asp:Label>
                                    </span>
                                    <div class="rating-estrellas-grande" id="estrellasPromedio" runat="server">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Lista de reseñas -->
                        <asp:Panel ID="pnlConResenas" runat="server" Visible="false">
                            <div class="resenas-lista">
                                <asp:Repeater ID="rptResenas" runat="server">
                                    <ItemTemplate>
                                        <div class="resena-card">
                                            <div class="resena-header">
                                                <div class="resena-usuario-info">
                                                    <div class="resena-avatar">
                                                        <i class="bi bi-person-circle"></i>
                                                    </div>
                                                    <div class="resena-usuario-datos">
                                                        <span class="resena-usuario-nombre"><%# Eval("cliente.nombre") %> <%# Eval("cliente.nombreUsuario") %></span>
                                    
                                                    </div>
                                                </div>
                                                <div class="resena-calificacion">
                                                    <div class="rating-estrellas">
                                                        <%# GenerarEstrellas(Convert.ToInt32(Eval("calificacion"))) %>
                                                    </div>
                                                    <span class="rating-numero-pequeno"><%# Eval("calificacion") %>.0</span>
                                                </div>
                                            </div>
                                            <div class="resena-contenido">
                                                <p class="resena-comentario"><%# Eval("reseña1") %></p>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:Panel>

                        <!-- Sin reseñas -->
                        <asp:Panel ID="pnlSinResenas" runat="server" Visible="true" CssClass="sin-resenas">
                            <i class="bi bi-chat-left-text"></i>
                            <p>Este producto aún no tiene reseñas</p>
                            <span class="sin-resenas-subtexto">Sé el primero en compartir tu opinión</span>
                        </asp:Panel>
                    </div>
                </div>

                <div class="descuento-section">
                    <div class="descuento-header">
                        <h3><i class="bi bi-percent"></i> Descuento</h3>
                    </div>

                    <!-- SI TIENE DESCUENTO ACTIVO -->
                    <asp:Panel ID="pnlDescuentoActivo" runat="server" Visible="false" CssClass="descuento-activo">
                        <div class="descuento-activo-badge">
                            <i class="bi bi-check-circle-fill"></i>
                            Descuento activo
                        </div>

                        <div class="descuento-info-grid">
                            <div class="descuento-info-item">
                                <span class="descuento-info-label">Valor</span>
                                <span class="descuento-info-value descuento-valor-grande">
                                    <asp:Label ID="lblDescuentoValor" runat="server" Text="0"></asp:Label>% OFF
                                </span>
                            </div>
                            <div class="descuento-info-item">
                                <span class="descuento-info-label">Válido hasta</span>
                                <span class="descuento-info-value">
                                    <asp:Label ID="lblDescuentoFecha" runat="server" Text=""></asp:Label>
                                </span>
                            </div>
                            <div class="descuento-info-item">
                                <span class="descuento-info-label">Estado</span>
                                <span class="descuento-info-value">
                                    <asp:Label ID="lblDescuentoEstado" runat="server" Text="Activo"></asp:Label>
                                </span>
                            </div>
                        </div>

                        <div class="descuento-actions">
                            <asp:LinkButton ID="btnEditarDescuento" runat="server" CssClass="btn-form btn-small btn-guardar" OnClick="btnEditarDescuento_Click" CausesValidation="false">
                                <i class="bi bi-pencil"></i> Editar
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnDesactivarDescuento" runat="server" CssClass="btn-form btn-small btn-desactivar-small" OnClick="btnCambiarEstadoDescuento_Click" OnClientClick="return confirm('¿Desactivar este descuento?');" CausesValidation="false">
                                <i class="bi bi-pause-circle"></i> Desactivar
                            </asp:LinkButton>
                        </div>
                    </asp:Panel>

                    <!-- SI NO TIENE DESCUENTO -->
                    <asp:Panel ID="pnlSinDescuento" runat="server" Visible="true" CssClass="sin-descuento">
                        <i class="bi bi-percent"></i>
                        <p>Este artículo no tiene descuento aplicado</p>
                        <asp:LinkButton ID="btnAgregarDescuento" runat="server" CssClass="btn-agregar-descuento" OnClick="btnAgregarDescuento_Click" CausesValidation="false">
                            <i class="bi bi-plus-lg"></i> Agregar Descuento
                        </asp:LinkButton>
                    </asp:Panel>

                    <!-- FORMULARIO DE DESCUENTO (oculto por defecto) -->
                    <asp:Panel ID="pnlFormDescuento" runat="server" Visible="false" CssClass="form-edicion">
                        <h3>
                            <i class="bi bi-percent"></i>
                            <asp:Label ID="lblTituloDescuento" runat="server" Text="Agregar Descuento"></asp:Label>
                        </h3>

                        <div class="form-grid">
                            <div class="form-group">
                                <label>Valor del Descuento (%) *</label>
                                <asp:TextBox ID="txtDescuentoValor" runat="server" TextMode="Number" step="0.01" min="0" max="100" placeholder="15.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDescuentoValor" runat="server" 
                                    ControlToValidate="txtDescuentoValor" 
                                    ErrorMessage="El valor es requerido" 
                                    ForeColor="Red" 
                                    Display="Dynamic"
                                    ValidationGroup="DescuentoForm" />
                            </div>

                            <div class="form-group">
                                <label>Fecha de Caducidad *</label>
                                <asp:TextBox ID="txtDescuentoFecha" runat="server" TextMode="Date"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDescuentoFecha" runat="server" 
                                    ControlToValidate="txtDescuentoFecha" 
                                    ErrorMessage="La fecha es requerida" 
                                    ForeColor="Red" 
                                    Display="Dynamic"
                                    ValidationGroup="DescuentoForm" />
                            </div>

                            <div class="form-group">
                                <label>Estado</label>
                                <asp:CheckBox ID="chkDescuentoActivo" runat="server" Text="Activo" Checked="true" />
                            </div>
                        </div>

                        <div class="form-actions">
                            <asp:Button ID="btnCancelarDescuento" runat="server" Text="Cancelar" CssClass="btn-form btn-cancelar-edit" OnClick="btnCancelarDescuento_Click" CausesValidation="false" />
                            <asp:Button ID="btnGuardarDescuento" runat="server" Text="Guardar Descuento" CssClass="btn-form btn-guardar" OnClick="btnGuardarDescuento_Click" ValidationGroup="DescuentoForm" />
                        </div>
                    </asp:Panel>
                </div>
            </asp:Panel>



            <!-- Formulario de Edición del Libro -->
            <asp:Panel ID="pnlFormEdicion" runat="server" Visible="false" CssClass="form-edicion">
                <h3><i class="bi bi-pencil-square"></i> Editando artículo</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Nombre *</label>
                        <asp:TextBox ID="txtNombre" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="Requerido" ForeColor="Red" Display="Dynamic" ValidationGroup="EditarForm" />
                    </div>
                    <div class="form-group">
                        <label>Precio unitario *</label>
                        <asp:TextBox ID="txtPrecioUnitario" runat="server" TextMode="Number" step="0.01"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPrecioUnitario" runat="server" ControlToValidate="txtPrecioUnitario" ErrorMessage="Requerido" ForeColor="Red" Display="Dynamic" ValidationGroup="EditarForm" />
                    </div>
                    <div class="form-group">
                        <label>Precio con Descuento *</label>
                        <asp:TextBox ID="txtPrecioConDescuento" runat="server" TextMode="Number" step="0.01"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPrecioConDescuento" runat="server" ControlToValidate="txtPrecioConDescuento" ErrorMessage="Requerido" ForeColor="Red" Display="Dynamic" ValidationGroup="EditarForm" />
                    </div>
                    <div class="form-group">
                        <label>Stock Real *</label>
                        <asp:TextBox ID="txtStockReal" runat="server" TextMode="Number"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvStockReal" runat="server" ControlToValidate="txtStockReal" ErrorMessage="Requerido" ForeColor="Red" Display="Dynamic" ValidationGroup="EditarForm" />
                    </div>
                    <div class="form-group">
                        <label>Stock Virtual *</label>
                        <asp:TextBox ID="txtStockVirtual" runat="server" TextMode="Number"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvStockVirtual" runat="server" ControlToValidate="txtStockVirtual" ErrorMessage="Requerido" ForeColor="Red" Display="Dynamic" ValidationGroup="EditarForm" />
                    </div>
                    <div class="form-group">
                        <label>ISBN *</label>
                        <asp:TextBox ID="txtISBN" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvISBN" runat="server" ControlToValidate="txtISBN" ErrorMessage="Requerido" ForeColor="Red" Display="Dynamic" ValidationGroup="EditarForm" />
                    </div>
                    <div class="form-group">
                        <label>Género *</label>
                        <asp:DropDownList ID="ddlGenero" runat="server"></asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Fecha de Publicación *</label>
                        <asp:TextBox ID="txtFechaPublicacion" runat="server" TextMode="Date"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFechaPublicacion" runat="server" ControlToValidate="txtFechaPublicacion" ErrorMessage="Requerido" ForeColor="Red" Display="Dynamic" ValidationGroup="EditarForm" />
                    </div>
                    <div class="form-group">
                        <label>Formato *</label>
                        <asp:DropDownList ID="ddlFormato" runat="server"></asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Editorial *</label>
                        <div class="form-control-with-button">
                            <asp:DropDownList ID="ddlEditorialEdit" runat="server"></asp:DropDownList>
                            <asp:Button ID="btnNuevaEditorialEdit" runat="server" Text="+ Nueva" CssClass="btn-nuevo-item" OnClientClick="showModalEditorial(); return false;" CausesValidation="false" />
                        </div>
                        <asp:RequiredFieldValidator ID="rfvEditorialEdit" runat="server" 
                            ControlToValidate="ddlEditorialEdit" 
                            InitialValue="0"
                            ErrorMessage="Seleccione una editorial" 
                            CssClass="validator"
                            Display="Dynamic" 
                            ValidationGroup="EditarForm" />
                    </div>
                    <div class="form-group form-group-full">
                        <label>Autores</label>
                        <div class="autores-edit-section" style="background-color: #F9FAFB; border: 2px solid #E4E7E9; border-radius: 8px; padding: 16px;">
                            <div style="display: grid; grid-template-columns: 1fr auto auto; gap: 12px; align-items: end; margin-bottom: 12px;">
                                <asp:DropDownList ID="ddlAutoresEdit" runat="server"></asp:DropDownList>
                                <asp:Button ID="btnNuevoAutorEdit" runat="server" Text="+ Nuevo" CssClass="btn-nuevo-item" OnClientClick="showModalAutor(); return false;" CausesValidation="false" style="margin-top: 0;" />
                                <asp:Button ID="btnAgregarAutorEdit" runat="server" Text="Agregar" CssClass="btn-agregar-autor" OnClick="btnAgregarAutorEdit_Click" CausesValidation="false" style="margin-top: 0; padding: 10px 20px; background-color: var(--primary-orange); color: white; border-radius: 4px; font-size: 13px; font-weight: 600; border: none; cursor: pointer;" />
                            </div>
                            <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                                <asp:Repeater ID="rptAutoresEdit" runat="server" OnItemCommand="rptAutoresEdit_ItemCommand">
                                    <ItemTemplate>
                                        <div class="autor-tag" style="background-color: white; border: 1px solid #E4E7E9; padding: 6px 12px; border-radius: 20px; font-size: 13px; display: inline-flex; align-items: center; gap: 8px;">
                                            <span><%# Eval("nombre") %> <%# Eval("apellidos") %></span>
                                            <asp:LinkButton runat="server" CommandName="EliminarAutor" CommandArgument='<%# Eval("idAutor") %>' CausesValidation="false" style="background: none; border: none; color: #EE5858; cursor: pointer; font-size: 16px; padding: 0;">
                                                <i class="bi bi-x"></i>
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Label ID="lblNoAutoresEdit" runat="server" Text="No hay autores seleccionados" CssClass="text-muted" Visible="false" style="color: #929FA5; font-size: 14px; font-style: italic;"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <!-- IMAGEN -->
                    <div class="form-group form-group-full">
                        <label>Portada (imagen)</label>
                        <asp:FileUpload ID="fuPortadaEdit" runat="server" />
                        <span class="form-help-text">
                            Deje vacío para mantener la imagen actual. Seleccione una nueva imagen para reemplazarla (JPG, PNG).
                        </span>
                    </div>
                    <div class="form-group form-group-full">
                        <label>Sinopsis</label>
                        <asp:TextBox ID="txtSinopsis" runat="server" TextMode="MultiLine"></asp:TextBox>
                    </div>
                    <div class="form-group form-group-full">
                        <label>Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine"></asp:TextBox>
                    </div>
                </div>
                <div class="form-actions">
                    <asp:Button ID="btnCancelarEdit" runat="server" Text="Cancelar" CssClass="btn-form btn-cancelar-edit" OnClick="btnCancelarEdit_Click" CausesValidation="false" />
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar Cambios" CssClass="btn-form btn-guardar" OnClick="btnGuardar_Click" ValidationGroup="EditarForm" />
                </div>
            </asp:Panel>

            <!-- MODAL: Nueva Editorial -->
            <asp:Panel ID="pnlModalEditorial" runat="server" CssClass="modal-panel">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2><i class="bi bi-building"></i> Nueva Editorial</h2>
                        <button type="button" class="btn-close-modal" onclick="hideModalEditorial()">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="form-grid">
                            <div class="form-group form-group-full">
                                <label>Nombre <span class="required">*</span></label>
                                <asp:TextBox ID="txtEditorialNombre" runat="server" placeholder="Nombre de la editorial"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEditorialNombre" runat="server" 
                                    ControlToValidate="txtEditorialNombre" 
                                    ErrorMessage="El nombre es requerido" 
                                    CssClass="validator"
                                    Display="Dynamic" 
                                    ValidationGroup="EditorialForm" />
                            </div>
                            <div class="form-group">
                                <label>CIF <span class="required">*</span></label>
                                <asp:TextBox ID="txtEditorialCIF" runat="server" placeholder="CIF"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEditorialCIF" runat="server" 
                                    ControlToValidate="txtEditorialCIF" 
                                    ErrorMessage="El CIF es requerido" 
                                    CssClass="validator"
                                    Display="Dynamic" 
                                    ValidationGroup="EditorialForm" />
                            </div>
                            <div class="form-group">
                                <label>Teléfono</label>
                                <asp:TextBox ID="txtEditorialTelefono" runat="server" TextMode="Number" placeholder="999999999"></asp:TextBox>
                            </div>
                            <div class="form-group form-group-full">
                                <label>Email</label>
                                <asp:TextBox ID="txtEditorialEmail" runat="server" TextMode="Email" placeholder="contacto@editorial.com"></asp:TextBox>
                            </div>
                            <div class="form-group form-group-full">
                                <label>Dirección</label>
                                <asp:TextBox ID="txtEditorialDireccion" runat="server" placeholder="Dirección completa"></asp:TextBox>
                            </div>
                            <div class="form-group form-group-full">
                                <label>Sitio Web</label>
                                <asp:TextBox ID="txtEditorialWeb" runat="server" placeholder="https://www.editorial.com"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-form btn-cancelar" onclick="hideModalEditorial()">Cancelar</button>
                        <asp:Button ID="btnGuardarEditorial" runat="server" Text="Guardar Editorial" CssClass="btn-form btn-guardar" OnClick="btnGuardarEditorial_Click" ValidationGroup="EditorialForm" />
                    </div>
                </div>
            </asp:Panel>

            <!-- MODAL: Nuevo Autor -->
            <asp:Panel ID="pnlModalAutor" runat="server" CssClass="modal-panel">
                <div class="modal-content">
                    <div class="modal-header">
                        <h2><i class="bi bi-person-plus"></i> Nuevo Autor</h2>
                        <button type="button" class="btn-close-modal" onclick="hideModalAutor()">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Nombre <span class="required">*</span></label>
                                <asp:TextBox ID="txtAutorNombre" runat="server" placeholder="Nombre del autor"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvAutorNombre" runat="server" 
                                    ControlToValidate="txtAutorNombre" 
                                    ErrorMessage="El nombre es requerido" 
                                    CssClass="validator"
                                    Display="Dynamic" 
                                    ValidationGroup="AutorForm" />
                            </div>
                            <div class="form-group">
                                <label>Apellidos <span class="required">*</span></label>
                                <asp:TextBox ID="txtAutorApellidos" runat="server" placeholder="Apellidos del autor"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvAutorApellidos" runat="server" 
                                    ControlToValidate="txtAutorApellidos" 
                                    ErrorMessage="Los apellidos son requeridos" 
                                    CssClass="validator"
                                    Display="Dynamic" 
                                    ValidationGroup="AutorForm" />
                            </div>
                            <div class="form-group form-group-full">
                                <label>Alias / Seudónimo</label>
                                <asp:TextBox ID="txtAutorAlias" runat="server" placeholder="Alias o seudónimo (opcional)"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-form btn-cancelar" onclick="hideModalAutor()">Cancelar</button>
                        <asp:Button ID="btnGuardarAutor" runat="server" Text="Guardar Autor" CssClass="btn-form btn-guardar" OnClick="btnGuardarAutor_Click" ValidationGroup="AutorForm" />
                    </div>
                </div>
            </asp:Panel>
        
        </asp:Panel>
    </div>

    


    <script type="text/javascript">
        function showModalEditorial() {
            document.getElementById('<%= pnlModalEditorial.ClientID %>').classList.add('show');
            return false;
        }

        function hideModalEditorial() {
            document.getElementById('<%= pnlModalEditorial.ClientID %>').classList.remove('show');
            return false;
        }

        function showModalAutor() {
            document.getElementById('<%= pnlModalAutor.ClientID %>').classList.add('show');
        return false;
        }

        function hideModalAutor() {
            document.getElementById('<%= pnlModalAutor.ClientID %>').classList.remove('show');
            return false;
        }

        // Cerrar modal al hacer clic fuera del contenido
        document.addEventListener('click', function(event) {
            var modalEditorial = document.getElementById('<%= pnlModalEditorial.ClientID %>');
            var modalAutor = document.getElementById('<%= pnlModalAutor.ClientID %>');

            if (event.target === modalEditorial) {
                hideModalEditorial();
            }
            if (event.target === modalAutor) {
                hideModalAutor();
            }
        });
    </script>

           <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script type="text/javascript">

    function mostrarModalExito() {
        // Verifica si Swal está cargado
        if (typeof Swal === 'undefined') {
            console.error('SweetAlert2 no está cargado. Revisa tu MasterPage.');
            alert('Datos guardados (Fallback)'); // Solo por si falla la librería
            return;
        }

        Swal.fire({
            title: '¡Éxito!',
            text: 'Datos cambiados con éxito',
            icon: 'success',
            confirmButtonColor: '#FA8232',
            confirmButtonText: 'Aceptar'
        }).then((result) => {
            // Opcional: Recargar la página al cerrar
            if (result.isConfirmed) {
                window.location.href = window.location.href;
            }
        });
    }

    function mostrarModalError(mensaje) {
        if (typeof Swal === 'undefined') { alert(mensaje); return; }

        Swal.fire({
            title: 'Error',
            text: mensaje,
            icon: 'error',
            confirmButtonColor: '#FA8232',
            confirmButtonText: 'Ok'
        });
    }
</script>
</asp:Content>
