import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_item.dart';

// ============================================
// CONFIGURACIÓN DE EMAILJS - COMPLETA ESTOS VALORES
// ============================================
const String EMAIL_SERVICE_ID = 'service_jf8vlvw';
const String EMAIL_TEMPLATE_ID = 'template_xxlm5e7';
const String EMAIL_PUBLIC_KEY = 'G0nrtT3kvmCBUfGDx';
// ============================================

class EmailService {
  static const String _emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Envía un ticket de compra por correo electrónico usando EmailJS
  /// 
  /// [nombreCliente]: Nombre del cliente que realiza la compra
  /// [correoCliente]: Correo electrónico del cliente
  /// [cartItems]: Lista de productos comprados
  /// [total]: Total de la compra
  /// [montoRecibido]: Monto recibido del cliente (opcional)
  /// [cambio]: Cambio devuelto al cliente (opcional)
  static Future<bool> enviarTicketEmail({
    required String nombreCliente,
    required String correoCliente,
    required List<CartItem> cartItems,
    required double total,
    double? montoRecibido,
    double? cambio,
  }) async {
    try {
      // Construir la lista de productos en formato texto
      final productosTexto = cartItems.map((item) {
        return '${item.quantity}x ${item.product.name} - \$${item.totalPrice.toStringAsFixed(2)}';
      }).join('\n');

      // Construir el HTML de la tabla de productos
      final productosHtml = cartItems.map((item) {
        return '''
          <tr>
            <td style="padding: 8px; border-bottom: 1px solid #ddd;">${item.product.name}</td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd; text-align: center;">${item.quantity}</td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd; text-align: right;">\$${item.product.price.toStringAsFixed(2)}</td>
            <td style="padding: 8px; border-bottom: 1px solid #ddd; text-align: right; font-weight: bold;">\$${item.totalPrice.toStringAsFixed(2)}</td>
          </tr>
        ''';
      }).join('\n');

      // Preparar los parámetros del template
      final templateParams = {
        'to_email': correoCliente,
        'to_name': nombreCliente,
        'nombre_cliente': nombreCliente,
        'correo_cliente': correoCliente,
        'productos_texto': productosTexto,
        'productos_html': productosHtml,
        'total': '\$${total.toStringAsFixed(2)}',
        'monto_recibido': montoRecibido != null 
            ? '\$${montoRecibido.toStringAsFixed(2)}' 
            : '\$${total.toStringAsFixed(2)}',
        'cambio': cambio != null 
            ? '\$${cambio.toStringAsFixed(2)}' 
            : '\$0.00',
        'fecha': DateTime.now().toString().substring(0, 19),
        'tienda': 'Lumière Makeup',
      };

      // Construir el cuerpo de la petición
      final body = jsonEncode({
        'service_id': EMAIL_SERVICE_ID,
        'template_id': EMAIL_TEMPLATE_ID,
        'user_id': EMAIL_PUBLIC_KEY,
        'template_params': templateParams,
      });

      // Realizar la petición POST a EmailJS
      final response = await http.post(
        Uri.parse(_emailJsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Origin': 'http://localhost',
        },
        body: body,
      );

      // Verificar el resultado
      if (response.statusCode == 200) {
        print('✅ Correo enviado exitosamente a $correoCliente');
        return true;
      } else {
        print('❌ Error al enviar correo: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Excepción al enviar correo: $e');
      return false;
    }
  }
}
