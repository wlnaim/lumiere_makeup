# Lumière Makeup - AI Agent Instructions

## Project Overview

Lumière is a Flutter-based Point of Sale (POS) application for a makeup retail business. The app manages product catalog, shopping cart, checkout, and automated email receipt delivery via EmailJS.

## Architecture & State Management

- **State Management**: Pure Flutter `StatefulWidget` with `setState()` - no external state management libraries
- **Data Flow**: State is lifted up and passed down through constructor parameters
  - `HomeScreen` owns the product list and cart state
  - Cart modifications return updated `List<CartItem>` via `Navigator.pop(context, result)`
  - All screens receive data as constructor parameters and return results via navigation

## Key Models

### Product (`lib/models/product.dart`)
```dart
Product(
  id: String,           // Generated from timestamp
  name: String,
  price: double,
  imageUrl: String,     // Can be URL or local file path
  timestamp: DateTime,  // Used for "recent" sorting
  isLocalImage: bool    // Distinguishes local vs remote images
)
```

### CartItem (`lib/models/cart_item.dart`)
- Wraps a `Product` with `quantity: int`
- Computed property: `totalPrice = product.price * quantity`

## Screen Flow & Data Passing

1. **HomeScreen** → `AddProductScreen` (Dialog)
   - Returns: `Product?` via `Navigator.pop(context, product)`
   
2. **HomeScreen** → `CartScreen`
   - Passes: `List<CartItem> cartItems`
   - Returns: `List<CartItem>?` (modified cart)
   
3. **CartScreen** → `CheckoutScreen`
   - Passes: `cartItems`, `total`
   - Returns: `bool?` (true = clear cart)
   
4. **CheckoutScreen** → `PaymentSuccessScreen`
   - Passes: `total`, `received`, `change`, `cartItems`
   - Email sending happens here

## Critical Patterns

### Adding Products to Cart
```dart
// Check if product exists, increment quantity or add new
final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
if (existingIndex >= 0) {
  _cartItems[existingIndex].quantity++;
} else {
  _cartItems.add(CartItem(product: product));
}
```

### Image Handling
- Uses `image_picker` package for local images
- Products can have either:
  - Remote URL: `https://images.unsplash.com/...`
  - Local path: `/data/user/0/.../image.jpg` with `isLocalImage: true`
- Display with `Image.network()` or `Image.file()` based on `isLocalImage` flag

### EmailJS Integration
- **Service**: `lib/services/email_service.dart`
- **Config Constants** (hardcoded, no env files):
  ```dart
  const String EMAIL_SERVICE_ID = 'service_jf8vlvw';
  const String EMAIL_TEMPLATE_ID = 'template_ovwr1ul';
  const String EMAIL_PUBLIC_KEY = 'G0nrtT3kvmCBUfGDx';
  ```
- **Template Variables**:
  - `productos_html`: HTML table rows (`<tr><td>...`)
  - `nombre_cliente`, `correo_cliente`, `total`, `monto_recibido`, `cambio`
  - Template expects inline CSS styles (see `EMAILJS_SETUP.md`)

### Receipt Email Flow
1. User completes payment in `PaymentSuccessScreen`
2. Clicks "Correo" button → opens modal dialog
3. Dialog collects: `nombreCliente`, `correoCliente`
4. Validation: non-empty, valid email format (`@` and `.`)
5. Shows loading dialog → calls `EmailService.enviarTicketEmail()`
6. Success/error shown via `SnackBar`

## Project Conventions

### Sorting & Search
- Products support two sort modes: `recent` (by `timestamp` DESC) and `alphabetical` (by `name` ASC)
- Search filters by product name (case-insensitive substring match)
- Apply search filter BEFORE sorting

### Color Scheme
```dart
Primary: Color(0xFFC77D9A)    // Pink
Secondary: Color(0xFFD185A7)  // Light pink
Background: Color(0xFFFCE4EC) // Very light pink
Accent: Color(0xFFF8F0F5)     // Off-white pink
```

### Styling Patterns
- Rounded corners: `BorderRadius.circular(12)` to `20`
- Dialogs/modals: `shape: RoundedRectangleBorder(borderRadius: circular(20))`
- Buttons: Minimal elevation (`elevation: 0`)
- AppBar: White background, no elevation, black87 text

### Form Validation
- Use `GlobalKey<FormState>` with `validator` functions
- Dispose `TextEditingController`s in `dispose()` method
- Number inputs: `TextInputType.numberWithOptions(decimal: true)`

## Dependencies

```yaml
dependencies:
  cupertino_icons: ^1.0.8
  image_picker: ^1.0.7   # For adding product images
  http: ^1.2.0           # For EmailJS API calls
```

## Development Workflow

### Run the App
```bash
flutter run
```

### Common Tasks
- **Add product**: Click `+` button in AppBar → opens dialog
- **Delete product**: Long-press or delete icon on product card
- **Test email**: Complete a purchase, enter test email (check spam folder)
- **Debug EmailJS**: Check console for `print()` statements in `email_service.dart`

## Important Files

- `lib/main.dart`: App entry point, theme configuration
- `lib/screens/home_screen.dart`: Main screen, owns products/cart state, implements search/sort
- `lib/services/email_service.dart`: EmailJS integration, contains credentials
- `EMAILJS_SETUP.md`: Complete guide for configuring EmailJS account and template
- `IMPLEMENTACION_EMAIL.md`: Documentation of email feature implementation

## Known Limitations

- No persistent storage (data resets on app restart)
- No backend/database (all state is in-memory)
- EmailJS credentials are hardcoded in source
- SMS receipt feature is not implemented (UI exists but no backend)
- No user authentication or multi-user support
- No product editing (only add/delete)

## When Making Changes

1. **Adding features**: Follow the StatefulWidget + setState pattern
2. **New screens**: Pass data via constructor, return results via Navigator.pop()
3. **Styling**: Maintain consistency with existing color scheme and border radius patterns
4. **Models**: Keep simple data classes without business logic
5. **Services**: Static methods only (no instances), use async/await for network calls
