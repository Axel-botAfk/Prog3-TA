<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SignIn.aspx.cs" Inherits="CampusStoreWeb.SignIn" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Breadcrumb personalizado */
        .custom-breadcrumb {
            background-color: transparent;
            padding: 20px 0;
            margin-bottom: 30px;
        }
        
        .custom-breadcrumb .breadcrumb {
            background-color: transparent;
            padding: 0;
            margin: 0;
        }
        
        .custom-breadcrumb .breadcrumb-item {
            color: #6c757d;
            font-size: 14px;
        }
        
        .custom-breadcrumb .breadcrumb-item a {
            color: #6c757d;
            text-decoration: none;
        }
        
        .custom-breadcrumb .breadcrumb-item a:hover {
            color: #1e5a7d;
        }
        
        .custom-breadcrumb .breadcrumb-item.active {
            color: #00bcd4;
        }
        
        .custom-breadcrumb .breadcrumb-item + .breadcrumb-item::before {
            content: "›";
            color: #6c757d;
        }
        
        /* Sign In Container */
        .signin-container {
            max-width: 450px;
            margin: 0 auto 80px;
        }
        
        .signin-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 40px 35px;
        }
        
        .signin-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .signin-header h2 {
            color: #1e5a7d;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .signin-header p {
            color: #6c757d;
            font-size: 14px;
            margin: 0;
        }
        
        /* Form */
        .form-label {
            font-size: 14px;
            font-weight: 500;
            color: #2b2b2b;
            margin-bottom: 8px;
        }
        
        .form-control {
            padding: 12px 15px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .form-control:focus {
            border-color: #1e5a7d;
            box-shadow: 0 0 0 0.2rem rgba(30, 90, 125, 0.15);
        }
        
        .password-wrapper {
            position: relative;
        }
        
        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #6c757d;
            cursor: pointer;
            padding: 5px;
        }
        
        .password-toggle:hover {
            color: #1e5a7d;
        }
        
        .forgot-password {
            color: #00bcd4;
            text-decoration: none;
            font-size: 14px;
            float: right;
            margin-bottom: 5px;
        }
        
        .forgot-password:hover {
            color: #0097a7;
            text-decoration: underline;
        }
        
        /* Button */
        .btn-signin {
            width: 100%;
            background-color: #ff6b35;
            color: white;
            border: none;
            padding: 12px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 4px;
            text-transform: uppercase;
            transition: background-color 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 25px;
        }
        
        .btn-signin:hover {
            background-color: #e55a28;
        }
        
        .btn-signin:active {
            background-color: #cc4d1f;
        }
        
        /* Sign Up Link */
        .signup-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
            color: #6c757d;
            font-size: 14px;
        }
        
        .signup-link a {
            color: #ff6b35;
            text-decoration: none;
            font-weight: 600;
        }
        
        .signup-link a:hover {
            color: #e55a28;
            text-decoration: underline;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Título de sección -->
    <div class="custom-breadcrumb">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item active" aria-current="page">Inicio de sesión</li>
            </ol>
        </nav>
    </div>
    
    <!-- Sign In Container -->
    <div class="signin-container">
        <div class="signin-card">
            
            <!-- Header -->
            <div class="signin-header">
                <h2>¡Bienvenido!</h2>
                <p>Por favor, inicia sesión para continuar</p>
            </div>
            
            <!-- Sign In Form -->
            <div class="mb-3">
                <label for="txtEmail" class="form-label">Correo electrónico</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" 
                             TextMode="Email" placeholder="" />
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                            ControlToValidate="txtEmail"
                                            ErrorMessage="El correo electrónico es obligatorio" 
                                            CssClass="text-danger small"
                                            Display="Dynamic" />
            </div>
            
            <div class="mb-2">
                <label for="txtPassword" class="form-label">Contraseña</label>
                <%--<asp:HyperLink ID="lnkForgotPassword" runat="server" 
                               NavigateUrl="~/Forget_Password.aspx" 
                               CssClass="forgot-password">
                    Olvidé mi contraseña
                </asp:HyperLink>--%>
                <div style="clear: both;"></div>
            </div>
            
            <div class="mb-3">
                <div class="password-wrapper">
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" 
                                 TextMode="Password" placeholder="" />
                    <button type="button" class="password-toggle" id="togglePassword">
                        <i class="bi bi-eye" id="eyeIcon"></i>
                    </button>
                </div>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                                            ControlToValidate="txtPassword"
                                            ErrorMessage="La contraseña es obligatoria" 
                                            CssClass="text-danger small"
                                            Display="Dynamic" />
            </div>

            <asp:CustomValidator 
                ID="cvLoginError" 
                runat="server" 
                Display="Dynamic"
                CssClass="text-danger small"
                EnableClientScript="false" />
            
            <asp:Button ID="btnSignIn" runat="server" CssClass="btn-signin" 
                        Text="Iniciar sesión ➔" OnClick="btnSignIn_Click" />
            
            <!-- Sign Up Link -->
            <div class="signup-link">
                ¿No tienes cuenta? <a href="SignUp.aspx">Registrarse</a>
            </div>
            
        </div>
    </div>
    
    <script>
        // Password Toggle
        document.getElementById('togglePassword').addEventListener('click', function () {
            const passwordField = document.getElementById('<%= txtPassword.ClientID %>');
            const eyeIcon = document.getElementById('eyeIcon');

            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                eyeIcon.classList.remove('bi-eye');
                eyeIcon.classList.add('bi-eye-slash');
            } else {
                passwordField.type = 'password';
                eyeIcon.classList.remove('bi-eye-slash');
                eyeIcon.classList.add('bi-eye');
            }
        });
    </script>
    
</asp:Content>
