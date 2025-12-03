<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GenerarReportes.aspx.cs" Inherits="CampusStoreWeb.GenerarReportes" %>
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
        
        /* Card de reportes */
        .reportes-card {
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 40px;
        }
        
        /* Headers de la tabla */
        .reportes-header {
            background-color: #F2F4F5;
            padding: 15px 20px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .reportes-header-row {
            display: grid;
            grid-template-columns: 2fr 1.5fr 1.5fr 1fr;
            gap: 20px;
            align-items: center;
        }
        
        .reportes-header-row span {
            color: #475156;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        /* Fila de reporte */
        .reporte-row {
            display: grid;
            grid-template-columns: 2fr 1.5fr 1.5fr 1fr;
            gap: 20px;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #E4E7E9;
        }
        
        .reporte-row:last-child {
            border-bottom: none;
        }
        
        .reporte-name {
            color: #191C1F;
            font-size: 16px;
            font-weight: 500;
        }
        
        /* Date input personalizado */
        .date-input-wrapper {
            position: relative;
        }
        
        .date-input {
            width: 100%;
            padding: 10px 35px 10px 15px;
            border: 1px solid #E4E7E9;
            border-radius: 4px;
            font-size: 14px;
            color: #5F6C72;
            background-color: white;
            cursor: pointer;
        }
        
        .date-input:focus {
            outline: none;
            border-color: var(--primary-orange);
        }
        
        .date-icon {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #5F6C72;
            pointer-events: none;
        }
        
        /* Botón generar */
        .btn-generar {
            background-color: transparent;
            color: #2DA5F3;
            border: none;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 0;
            transition: all 0.3s;
        }
        
        .btn-generar:hover {
            color: #1e8ed9;
        }
        
        .btn-generar i {
            font-size: 16px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Título de sección -->
    <div class="breadcrumb-custom">
        <div class="container">
            <h2 class="mb-0">Generar Reportes</h2>
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
                    <asp:HyperLink runat="server" NavigateUrl="~/GestionarOrdenesCompra.aspx" CssClass="menu-item">
                        <i class="bi bi-file-earmark-text"></i>
                        <span>Gestionar Ordenes de Compra</span>
                    </asp:HyperLink>
                    <asp:HyperLink runat="server" NavigateUrl="~/GenerarReportes.aspx" CssClass="menu-item active">
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
                <div class="reportes-card">
                    
                    <!-- Headers -->
                    <div class="reportes-header">
                        <div class="reportes-header-row">
                            <span></span>
                            <span>FECHA INICIO</span>
                            <span>FECHA FIN</span>
                            <span>ACCIÓN</span>
                        </div>
                    </div>
                    
                    <!-- Reporte de Best Sellers -->
                    <div class="reporte-row">
                        <div class="reporte-name">Reporte de Best Sellers</div>
                        <div class="date-input-wrapper">
                            <asp:TextBox ID="txtFechaInicioBestSellers" runat="server" CssClass="date-input" placeholder="Select date" TextMode="Date"></asp:TextBox>
                            <i class="bi bi-calendar3 date-icon"></i>
                        </div>
                        <div class="date-input-wrapper">
                            <asp:TextBox ID="txtFechaFinBestSellers" runat="server" CssClass="date-input" placeholder="Select date" TextMode="Date"></asp:TextBox>
                            <i class="bi bi-calendar3 date-icon"></i>
                        </div>
                        <div>
                            <asp:LinkButton ID="btnGenerarBestSellers" runat="server" CssClass="btn-generar" OnClick="btnGenerarBestSeller_Click">
                                GENERAR <i class="bi bi-arrow-right"></i>
                            </asp:LinkButton>
                        </div>
                    </div>
                    
                    <!-- Reporte de Ventas -->
                    <div class="reporte-row">
                        <div class="reporte-name">Reporte de Ventas</div>
                        <div class="date-input-wrapper">
                            <asp:TextBox ID="txtFechaInicioVentas" runat="server" CssClass="date-input" placeholder="Select date" TextMode="Date"></asp:TextBox>
                            <i class="bi bi-calendar3 date-icon"></i>
                        </div>
                        <div class="date-input-wrapper">
                            <asp:TextBox ID="txtFechaFinVentas" runat="server" CssClass="date-input" placeholder="Select date" TextMode="Date"></asp:TextBox>
                            <i class="bi bi-calendar3 date-icon"></i>
                        </div>
                        <div>
                            <asp:LinkButton ID="btnGenerarVentas" 
                                            runat="server" 
                                            CssClass="btn-generar"
                                            OnClick="btnGenerarVentas_Click">
                                GENERAR <i class="bi bi-arrow-right"></i>
                            </asp:LinkButton>

                        </div>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
    
</asp:Content>