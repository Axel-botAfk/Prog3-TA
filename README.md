

# **Sistema Web de E-commerce y Gestión Logística: Campus Store** 🚀

***

### **Descripción General del Proyecto**

Este proyecto es una **aplicación web de e-commerce y gestión administrativa** integral desarrollada como Tarea Académica del curso de Programación 3. Su objetivo fue aplicar los conceptos de **programación en capas**, **arquitectura distribuida** e **integración de servicios web** entre dos stacks tecnológicos principales: **Java** (Backend) y **C#** (Frontend).

El sistema digitaliza el catálogo y la toma de pedidos para el negocio **Campus Store PUQ** (una librería y tienda de artículos variados). Busca **optimizar la gestión de pedidos** y expandir el alcance de la tienda , manteniendo un **trato personalizado** al finalizar la compra.

***

### **Arquitectura y Tecnologías Core**

La solución está construida bajo una **Arquitectura Distribuida y por Capas** , desacoplando la capa de presentación de la lógica de negocio y la persistencia.

| Componente | Tecnologías Clave | Descripción del Uso |
| :--- | :--- | :--- |
| **Backend / API** | **Java**, **Glassfish**, **Web Services REST** | Lógica de negocio robusta, implementada en Java y expuesta mediante una **API RESTful** , desplegada eficientemente en **Glassfish**. |
| **Frontend / Cliente** | **ASP.NET Framework (Web Forms)**, **C#** | Interfaz de usuario dinámica y estructurada, desarrollada en C#. Consume los servicios REST del backend para orquestar la funcionalidad. |
| **Persistencia** | **MySQL** | Base de datos relacional para el almacenamiento confiable de toda la información transaccional y maestra. |
| **Reportes** | **Jasper** | Motor de generación de reportes utilizado para crear informes clave, como Best Sellers y Reporte de Ventas. |

***

### **Funcionalidades Clave y Lógica de Negocio**

El sistema presenta una división de módulos Cliente y Administración con lógica compleja:

* **Flujo de Compra Avanzado (Cliente):**
    * **Catálogo y Filtros:** Búsqueda avanzada de productos aplicando filtros por título, autor, género o editorial.
    * **Pago Diferido:** El cliente genera un pedido, asignándole el estado inicial de **"Pendiente de pago"**La transacción final se coordina manualmente notificando a un encargado vía WhatsApp.
    * **Gestión de Órdenes:** Permite el pago de pedidos pendientes (sin cancelación) y el sistema notifica la realización del abono.

* **Lógica de Pedidos y Stock:**
    * Al generarse una orden, el sistema descuenta un **stock virtual** de los productos.
    * **Cancelación Automática:** Se otorga un plazo de **48 horas** para la realización del abono; caso contrario, la orden es **cancelada automáticamente**.
    * **Restock con Sanción:** Si un pedido no es recogido dentro de **7 días hábiles**, el sistema realiza un restock del producto y se aplica un **reembolso con sanción del 20%**.

* **Funcionalidades del Administrador:**
    * CRUD completo para la **Gestión de Usuarios** y **Productos**.
    * Generación de reportes de **Best Sellers** y **Reporte de Ventas** detallando ingresos, descuentos y el ingreso neto.

* **Integración de Servicios:** Se utiliza una **API externa** para la gestión de imágenes (convertidas a URLs) y la integración de **Códigos QR** y **enlaces de WhatsApp** para automatizar el inicio del proceso de pago.

***

### **Habilidades Técnicas Demostradas**

* Dominio del desarrollo **Full-Stack** en un entorno **Multi-Lenguaje** (**Java** y **C#**).
* Implementación de **Web Services RESTful** y **programación distribuida** para la integración de componentes.
* Diseño e implementación de **Base de Datos Relacional** (**MySQL**) y lógica transaccional compleja.
* Manejo de requerimientos no funcionales de **Rendimiento** (50 sesiones simultáneas) y **Seguridad** (HTTPS).





















































