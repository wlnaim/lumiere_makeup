# Configuración de EmailJS para Envío de Tickets

## 📧 Guía de Configuración

### Paso 1: Crear Cuenta en EmailJS
1. Ve a [https://www.emailjs.com/](https://www.emailjs.com/)
2. Regístrate o inicia sesión
3. Confirma tu correo electrónico

### Paso 2: Agregar Servicio de Email
1. En el dashboard, ve a **Email Services**
2. Haz clic en **Add New Service**
3. Selecciona tu proveedor (Gmail, Outlook, etc.)
4. Sigue las instrucciones para conectar tu cuenta
5. Copia el **Service ID** (ejemplo: `service_abc123`)

### Paso 3: Crear Template de Email
1. Ve a **Email Templates**
2. Haz clic en **Create New Template**
3. Usa la siguiente estructura para tu template:

#### Configuración del Template:

**Template Name:** Ticket de Compra Lumière

**Subject:** 
```
✨ Tu ticket de compra - Lumière Makeup
```

**Content (HTML):**
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background-color: #C77D9A; color: white; padding: 20px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background-color: #f9f9f9; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th { background-color: #C77D9A; color: white; padding: 10px; text-align: left; }
        td { padding: 8px; border-bottom: 1px solid #ddd; }
        .total-row { font-weight: bold; font-size: 1.2em; background-color: #FCE4EC; }
        .footer { text-align: center; padding: 20px; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>✨ Lumière Makeup</h1>
            <p>Ticket de Compra</p>
        </div>
        <div class="content">
            <h2>Hola {{nombre_cliente}}! 💄</h2>
            <p>Gracias por tu compra. Aquí está el detalle de tu ticket:</p>
            
            <p><strong>Fecha:</strong> {{fecha}}</p>
            
            <h3>Productos Comprados:</h3>
            <table>
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th style="text-align: center;">Cantidad</th>
                        <th style="text-align: right;">Precio Unit.</th>
                        <th style="text-align: right;">Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    {{productos_html}}
                </tbody>
            </table>
            
            <table>
                <tr class="total-row">
                    <td>Total</td>
                    <td style="text-align: right;">{{total}}</td>
                </tr>
                <tr>
                    <td>Monto Recibido</td>
                    <td style="text-align: right;">{{monto_recibido}}</td>
                </tr>
                <tr>
                    <td>Cambio</td>
                    <td style="text-align: right;">{{cambio}}</td>
                </tr>
            </table>
            
            <p style="margin-top: 30px; font-style: italic;">
                ¡Esperamos verte pronto! ✨
            </p>
        </div>
        <div class="footer">
            <p>Este es un correo automático, por favor no responder.</p>
            <p>© 2025 Lumière Makeup - Todos los derechos reservados</p>
        </div>
    </div>
</body>
</html>
```

4. Guarda el template y copia el **Template ID** (ejemplo: `template_xyz789`)

### Paso 4: Obtener Public Key
1. Ve a **Account** en el menú
2. En la sección **API Keys**, copia tu **Public Key** (ejemplo: `VwXYz_ABCdefg12345`)

### Paso 5: Configurar en la Aplicación
1. Abre el archivo `lib/services/email_service.dart`
2. Reemplaza los valores en las constantes:

```dart
const String EMAIL_SERVICE_ID = 'tu_service_id';      // Ejemplo: 'service_abc123'
const String EMAIL_TEMPLATE_ID = 'tu_template_id';    // Ejemplo: 'template_xyz789'
const String EMAIL_PUBLIC_KEY = 'tu_public_key';      // Ejemplo: 'VwXYz_ABCdefg12345'
```

## 🔧 Variables del Template

El template recibe las siguientes variables automáticamente:

- `{{to_email}}` - Correo del destinatario
- `{{to_name}}` - Nombre del destinatario
- `{{nombre_cliente}}` - Nombre del cliente
- `{{correo_cliente}}` - Correo del cliente
- `{{productos_texto}}` - Lista de productos en texto plano
- `{{productos_html}}` - Lista de productos en HTML (tabla)
- `{{total}}` - Total de la compra
- `{{monto_recibido}}` - Monto recibido
- `{{cambio}}` - Cambio devuelto
- `{{fecha}}` - Fecha y hora de la compra
- `{{tienda}}` - Nombre de la tienda (Lumière Makeup)

## ✅ Prueba de Funcionamiento

1. Ejecuta la aplicación: `flutter run`
2. Agrega productos al carrito
3. Procede al checkout
4. Confirma el pago
5. En la pantalla de pago exitoso, presiona el botón **Correo**
6. Ingresa un nombre y correo electrónico válido
7. Espera a que se envíe el correo
8. Revisa la bandeja de entrada del correo ingresado

## 🚨 Solución de Problemas

### El correo no se envía
- Verifica que las credenciales de EmailJS sean correctas
- Asegúrate de tener conexión a internet
- Revisa que el correo ingresado sea válido
- Verifica los logs en la consola de Flutter

### Error 403 o 401
- Verifica que tu Public Key sea correcta
- Asegúrate de que el Service y Template estén activos en EmailJS

### El correo llega a spam
- Configura SPF y DKIM en tu servicio de email
- Pide a los usuarios agregar tu correo a contactos

## 📊 Límites de EmailJS

**Plan Gratuito:**
- 200 emails por mes
- 1 servicio de email
- 2 templates

Para más información, visita: [https://www.emailjs.com/pricing/](https://www.emailjs.com/pricing/)

---

**¿Necesitas ayuda?** Visita la documentación de EmailJS: [https://www.emailjs.com/docs/](https://www.emailjs.com/docs/)
