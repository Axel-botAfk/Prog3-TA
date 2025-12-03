<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GestionarOrdenesCompra.aspx.cs" Inherits="CampusStoreWeb.GestionarOrdenesCompra" %>
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
        
        /* Menú lateral */
        .sidebar-menu {
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .sidebar-menu .menu-item {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            color: #191C1F;
            text-decoration: none;
            border-bottom: 1px solid #E4E7E9;
            transition: all 0.3s;
            gap: 12px;
            font-size: 14px;
        }
        
        .sidebar-menu .menu-item:last-child {
            border-bottom: none;
        }
        
        .sidebar-menu .menu-item i {
            font-size: 20px;
            width: 24px;
            text-align: center;
        }
        
        .sidebar-menu .menu-item:hover {
            background-color: #FFF3E6;
            color: var(--primary-orange);
        }
        
        .sidebar-menu .menu-item.active {
            background-color: var(--primary-orange);
            color: white;
        }
        
        /* Tabla de pedidos */
        .pedidos-card {
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 24px;
        }
        
        .pedidos-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        
        .pedidos-header h2 {
            font-size: 20px;
            font-weight: 600;
            color: #191C1F;
            margin: 0;
        }
        
        .view-all-link {
            color: var(--primary-orange);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .view-all-link:hover {
            color: #d86f28;
        }
        
        /* Barra de búsqueda */
        .search-box {
            margin-bottom: 24px;
            position: relative;
        }
        
        .search-box input {
            width: 100%;
            padding: 10px 40px 10px 15px;
            border: 1px solid #E4E7E9;
            border-radius: 4px;
            font-size: 14px;
            color: #5F6C72;
        }
        
        .search-box input::placeholder {
            color: #929FA5;
        }
        
        .search-box i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #5F6C72;
            font-size: 16px;
        }
        
        /* Tabla personalizada */
        .table-pedidos {
            width: 100%;
            border-collapse: collapse;
            border: none;
        }
        
        .table-pedidos thead th {
            background-color: #F2F4F5;
            color: #475156;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            padding: 12px 16px;
            text-align: left;
            border-bottom: 2px solid #E4E7E9;
        }
        
        .table-pedidos tbody td {
            padding: 16px;
            color: #191C1F;
            font-size: 14px;
            border-bottom: 1px solid #E4E7E9;
        }

        .table-header{
            background-color: #F2F4F5;
            color: #475156;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            padding: 12px 16px;
            text-align: left;
            border-bottom: 2px solid #E4E7E9;
        }

        .table-items{
            padding: 16px;
            color: #475156;
            font-size: 14px;
            border-bottom: 1px solid #E4E7E9;
            font-weight: 500;
        }
        
        .table-pedidos tbody tr:last-child td {
            border-bottom: none;
        }
        
        .table-pedidos tbody tr:hover {
            background-color: #F9FAFB;
        }
        
        .order-id {
            color: #191C1F;
            font-weight: 500;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
            text-transform: uppercase;
        }
        
        .status-pagado {
            background-color: #FFF3E6;
            color: var(--primary-orange);
        }
        
        .status-entregado {
            background-color: #EAF7ED;
            color: #2DB224;
        }
        
        .status-no-pagado {
            background-color: #FFE5E5;
            color: #EE5858;
        }
        
        .order-date {
            color: #5F6C72;
            font-size: 14px;
        }
        
        .order-total {
            font-weight: 600;
            color: #191C1F;
        }
        
        .btn-edit {
            background: none;
            border: none;
            color: #5F6C72;
            cursor: pointer;
            font-size: 18px;
            padding: 0;
            margin-right: 8px;
        }
        
        .btn-edit:hover {
            color: var(--primary-orange);
        }
        
        .btn-view-details {
            color: #2DA5F3;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-view-details:hover {
            color: #1e8ed9;
        }
        
        /* Botón flotante de agregar */
        .btn-agregar-container {
            display: flex;
            justify-content: flex-end;
            padding-top: 20px;
            margin-top: 20px;
            border-top: 1px solid #E4E7E9;
        }

        .btn-agregar-articulo {
            background-color: var(--primary-orange);
            color: white;
            padding: 12px 24px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
            text-transform: uppercase;
            box-shadow: 0 2px 8px rgba(250, 130, 50, 0.3);
        }

        .btn-agregar-articulo:hover {
            background-color: #d86f28;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(250, 130, 50, 0.4);
        }

        .btn-agregar-articulo i {
            font-size: 18px;
        }

        /* Formulario de agregar/editar inline */
        .formulario-card {
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
            border: 2px solid var(--primary-orange);
        }

        .formulario-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #E4E7E9;
        }

        .formulario-header h2 {
            font-size: 24px;
            font-weight: 600;
            color: #191C1F;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .formulario-header h2 i {
            color: var(--primary-orange);
        }

        .btn-cerrar-form {
            background: none;
            border: none;
            color: #5F6C72;
            font-size: 24px;
            cursor: pointer;
            transition: color 0.3s;
            padding: 0;
            line-height: 1;
        }

        .btn-cerrar-form:hover {
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
            font-size: 14px;
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
            min-height: 100px;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 30px;
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

        .btn-cancelar {
            background-color: #E4E7E9;
            color: #5F6C72;
        }

        .btn-cancelar:hover {
            background-color: #d1d5d9;
        }

        .search-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 24px;
            align-items: stretch;
        }

        .search-input-group {
            flex: 1;
            position: relative;
            display: flex;
        }

        .search-input-group input {
            width: 100%;
            padding: 12px 45px 12px 16px;
            border: 2px solid #E4E7E9;
            border-radius: 6px;
            font-size: 14px;
            color: #191C1F;
            transition: all 0.3s;
        }

        .search-input-group input:focus {
            outline: none;
            border-color: var(--primary-orange);
            box-shadow: 0 0 0 3px rgba(250, 130, 50, 0.1);
        }

        .search-input-group input::placeholder {
            color: #ADB7BC;
        }

        .search-icon {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #ADB7BC;
            font-size: 18px;
            pointer-events: none;
            transition: color 0.3s;
        }

        .search-input-group input:focus ~ .search-icon {
            color: var(--primary-orange);
        }

        .search-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-search {
            background-color: var(--primary-orange);
            color: white;
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            white-space: nowrap;
        }

        .btn-search:hover {
            background-color: #d86f28;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(250, 130, 50, 0.3);
        }

        .btn-clear {
            background-color: white;
            color: #5F6C72;
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            border: 2px solid #E4E7E9;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            white-space: nowrap;
        }

        .btn-clear:hover {
            background-color: #F9FAFB;
            border-color: #ADB7BC;
            color: #191C1F;
        }

        .view-all-link {
            color: var(--primary-orange);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .view-all-link:hover {
            color: #d86f28;
        }

        /* Mensaje sin resultados */
        .no-results {
            text-align: center;
            padding: 40px 20px;
            color: #5F6C72;
        }

        .no-results i {
            font-size: 48px;
            color: #E4E7E9;
            margin-bottom: 16px;
        }

        .no-results p {
            font-size: 16px;
            margin: 0;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Título de sección -->
    <div class="breadcrumb-custom">
        <div class="container">
            <h2 class="mb-0">Gestionar Órdenes de Compra</h2>
        </div>
    </div>
    
    <div class="container">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-3 col-md-4 mb-4">
                <div class="sidebar-menu">
                    <asp:HyperLink runat="server" NavigateUrl="~/GestionarLibros.aspx" CssClass="menu-item">
                        <i class="bi bi-layers"></i>
                        <span>Gestionar Libros</span>
                    </asp:HyperLink>
                    <asp:HyperLink runat="server" NavigateUrl="~/GestionarArticulos.aspx" CssClass="menu-item">
                        <i class="bi bi-box-seam"></i>
                        <span>Gestionar Artículos</span>
                    </asp:HyperLink>
                    <asp:HyperLink runat="server" NavigateUrl="~/GestionarEmpleados.aspx" CssClass="menu-item">
                        <i class="bi bi-person-badge"></i>
                        <span>Gestionar Empleados</span>
                    </asp:HyperLink>
                    <asp:HyperLink runat="server" NavigateUrl="~/GestionarClientes.aspx" CssClass="menu-item">
                        <i class="bi bi-cart3"></i>
                        <span>Gestionar Clientes</span>
                    </asp:HyperLink>
                    <asp:HyperLink runat="server" NavigateUrl="~/GestionarCupones.aspx" CssClass="menu-item">
                        <i class="bi bi-ticket-perforated"></i>
                        <span>Gestionar Cupones</span>
                    </asp:HyperLink>
                    <asp:HyperLink runat="server" NavigateUrl="~/GestionarOrdenesCompra.aspx" CssClass="menu-item active">
                        <i class="bi bi-file-earmark-text"></i>
                        <span>Gestionar Ordenes de Compra</span>
                    </asp:HyperLink>
                    <asp:HyperLink runat="server" NavigateUrl="~/GenerarReportes.aspx" CssClass="menu-item">
                        <i class="bi bi-gear"></i>
                        <span>Generar Reportes</span>
                    </asp:HyperLink>
                    <asp:HyperLink runat="server" NavigateUrl="~/Logout.aspx" CssClass="menu-item">
                        <i class="bi bi-box-arrow-right"></i>
                        <span>Cerrar Sesión</span>
                    </asp:HyperLink>
                </div>
            </div>
            
            <!-- Contenido principal -->
            <div class="col-lg-9 col-md-8">
                <div class="pedidos-card">
                    <!-- Header -->
                    <div class="pedidos-header">
                        <h2>PEDIDOS</h2>
                    </div>
                    
                    <!-- Barra de búsqueda -->
                    <div class="search-bar">
                        <div class="search-input-group">
                            <asp:TextBox ID="txtBuscar" runat="server" 
                                placeholder="Buscar por ID o Código de cupón..." 
                                CssClass="form-control">
                            </asp:TextBox>
                            <i class="bi bi-search search-icon"></i>
                        </div>
                        <div class="search-buttons">
                            <asp:Button ID="btnBuscar" runat="server" 
                                Text="Buscar" 
                                CssClass="btn-search" 
                                OnClick="btnBuscar_Click">
                            </asp:Button>
                            <asp:Button ID="btnLimpiar" runat="server" 
                                Text="Limpiar" 
                                CssClass="btn-clear" 
                                OnClick="btnLimpiar_Click">
                            </asp:Button>
                        </div>
                    </div>
                    
                    <!-- Tabla -->
                    <div class="table-responsive">
                        <asp:GridView ID="gvOrdenesCompra" runat="server" AutoGenerateColumns="false"
                            CssClass="table-pedidos" PageSize="5" AllowPaging="true" OnPageIndexChanging="gvOrdenesCompra_PageIndexChanging">
                            <Columns>
                                <asp:BoundField HeaderStyle-CssClass="table-header" ItemStyle-CssClass="table-items" HeaderText="ID" DataField="idOrdenCompra" />
                                <asp:BoundField HeaderStyle-CssClass="table-header" ItemStyle-CssClass="table-items" HeaderText="ESTADO" DataField="estado" />
                                <asp:TemplateField HeaderStyle-CssClass="table-header" HeaderText="FECHA CREACIÓN">
                                    <ItemTemplate>
                                        <span class="table-items"><%# Eval("fechaCreacion") != null ? ((DateTime)Eval("fechaCreacion")).ToString("MM/dd/yyyy") : "" %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-CssClass="table-header" HeaderText="FECHA LIMITE">
                                    <ItemTemplate>
                                        <span class="table-items"><%# Eval("limitePago") != null ? ((DateTime)Eval("limitePago")).ToString("MM/dd/yyyy") : "" %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField HeaderStyle-CssClass="table-header" ItemStyle-CssClass="table-items" HeaderText="TOTAL" DataField="total" />
                                <asp:TemplateField HeaderStyle-CssClass="table-header" HeaderText="DETALLES">
                                    <ItemTemplate>
                                        <asp:HyperLink runat="server" 
                                            NavigateUrl='<%# "~/DetalleOrdenCompra.aspx?id=" + Eval("idOrdenCompra") %>' 
                                            CssClass="btn-view-details">
                                            Ver Detalles <i class="bi bi-arrow-right"></i>
                                        </asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="no-results">
                                    <i class="bi bi-search"></i>
                                    <p>No se encontraron ordenes que coincidan con tu búsqueda.</p>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
    
</asp:Content>
