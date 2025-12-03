<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="CampusStoreWeb.SignUp" %>
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
        
        /* Sign Up Container */
        .signup-container {
            max-width: 450px;
            margin: 0 auto 80px;
        }
        
        .signup-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 40px 35px;
        }
        
        .signup-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .signup-header h2 {
            color: #1e5a7d;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .signup-header p {
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
        
        /* Button */
        .btn-signup {
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
        
        .btn-signup:hover {
            background-color: #e55a28;
        }
        
        .btn-signup:active {
            background-color: #cc4d1f;
        }
        
        /* Sign In Link */
        .signin-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
            color: #6c757d;
            font-size: 14px;
        }
        
        .signin-link a {
            color: #ff6b35;
            text-decoration: none;
            font-weight: 600;
        }
        
        .signin-link a:hover {
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
                <li class="breadcrumb-item active" aria-current="page">Registrarse</li>
            </ol>
        </nav>
    </div>
    
    <!-- Sign Up Container -->
    <div class="signup-container">
        <div class="signup-card">
            
            <!-- Header -->
            <div class="signup-header">
                <h2>Crea tu cuenta</h2>
                <p>¡Únete a nosotros y empieza a comprar ahora!</p>
            </div>
            
            <!-- Sign Up Form -->
            <div class="mb-3">
                <label for="txtUserName" class="form-label">Nombre Usuario</label>
                <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control" 
                             placeholder="" />
                <asp:RequiredFieldValidator ID="rfvUserName" runat="server" 
                                            ControlToValidate="txtUserName"
                                            ErrorMessage="El nombre de usuario es obligatorio" 
                                            CssClass="text-danger small"
                                            Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label for="txtEmail" class="form-label">Dirección de correo electrónico</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" 
                             TextMode="Email" placeholder="" />
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                            ControlToValidate="txtEmail"
                                            ErrorMessage="El correo electrónico es obligatorio" 
                                            CssClass="text-danger small"
                                            Display="Dynamic" />
            </div>
            
            <div class="mb-3">
                <label for="txtPassword" class="form-label">Contraseña</label>
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
            
            <div class="mb-3">
                <label for="txtConfirmPassword" class="form-label">Confirmar contraseña</label>
                <div class="password-wrapper">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" 
                                 TextMode="Password" placeholder="" />
                    <button type="button" class="password-toggle" id="toggleConfirmPassword">
                        <i class="bi bi-eye" id="eyeIconConfirm"></i>
                    </button>
                </div>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                                            ControlToValidate="txtConfirmPassword"
                                            ErrorMessage="Es necesario confirmar la contraseña" 
                                            CssClass="text-danger small"
                                            Display="Dynamic" />
                <asp:CompareValidator ID="cvPasswordMatch" runat="server"
                                      ControlToValidate="txtConfirmPassword"
                                      ControlToCompare="txtPassword"
                                      ErrorMessage="Las contraseñas no coinciden"
                                      CssClass="text-danger small"
                                      Display="Dynamic" />
            </div>

            <asp:CustomValidator 
                ID="cvSignUpError" 
                runat="server" 
                Display="Dynamic"
                CssClass="text-danger small d-block"
                EnableClientScript="false" />
            
            <asp:Button ID="btnSignUp" runat="server" CssClass="btn-signup" 
                        Text="Registrarse ➔" OnClick="btnSignUp_Click" />
            
            <!-- Sign In Link -->
            <div class="signin-link">
                ¿Ya tienes una cuenta? <a href="SignIn.aspx">Iniciar sesión</a>
            </div>
            
        </div>
    </div>
    
    <script>
        // Password Toggle for Password
        document.getElementById('togglePassword').addEventListener('click', function() {
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
        
        // Password Toggle for Confirm Password
        document.getElementById('toggleConfirmPassword').addEventListener('click', function() {
            const passwordField = document.getElementById('<%= txtConfirmPassword.ClientID %>');
            const eyeIcon = document.getElementById('eyeIconConfirm');
            
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
            text: 'Cuenta registrada con éxito',
            icon: 'success',
            confirmButtonColor: '#FA8232',
            confirmButtonText: 'Aceptar'
        }).then((result) => {
            // Opcional: Recargar la página al cerrar
            if (result.isConfirmed) {
                window.location.href = "SignIn.aspx";
            }
        });
    }

    function mostrarModalError(mensaje) {
        if (typeof Swal === 'undefined') { alert(mensaje); return; }

        Swal.fire({
            title: 'Error',
            text: 'Ocurrió un error inesperado, intente nuevamente',
            icon: 'error',
            confirmButtonColor: '#FA8232',
            confirmButtonText: 'Ok'
        });
    }
</script>
</asp:Content>
