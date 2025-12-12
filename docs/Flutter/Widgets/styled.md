# Styling in Flutter

Flutter provides multiple approaches to styling widgets, from inline styles to global themes and custom design systems.

---

## Theory: Styling Approaches

### The Styling Spectrum

Flutter offers styles at different levels of abstraction:

| Level | Scope | Examples |
|-------|-------|----------|
| **Inline** | Per-widget | `TextStyle()`, `BoxDecoration`, `EdgeInsets` |
| **Widget-level** | Reusable | Custom widgets, Style classes, Extension methods |
| **App-level** | Global | `ThemeData`, `ColorScheme`, `TextTheme` |

### When to Use Each

| Level | Use Case | Example |
|-------|----------|---------|
| **Inline** | One-off styles, prototyping | `TextStyle(fontSize: 16)` |
| **Widget-level** | Reusable components | `PrimaryButton`, `AppCard` |
| **App-level** | Consistent design system | `Theme.of(context)` |

---

## ThemeData

The central configuration for Material Design styling.

### Basic Theme Setup

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  ),
  themeMode: ThemeMode.system,  // Follows device setting
  home: MyApp(),
)
```

### Accessing Theme

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  return Container(
    color: colorScheme.primaryContainer,
    child: Text(
      'Styled Text',
      style: textTheme.headlineMedium,
    ),
  );
}
```

---

## ColorScheme

Material 3 color system with semantic color roles.

### Color Roles

| Role | Use For |
|------|---------|
| `primary` | Key components, FABs, active states |
| `onPrimary` | Text/icons on primary |
| `primaryContainer` | Less prominent containers |
| `secondary` | Accents, toggles, filters |
| `tertiary` | Contrasting accents |
| `surface` | Card, sheet, menu backgrounds |
| `error` | Error states, destructive actions |

### Creating ColorScheme

```dart
// From seed color (Material 3)
ColorScheme.fromSeed(
  seedColor: Colors.blue,
  brightness: Brightness.light,
)

// From image (dynamic theming)
final colorScheme = await ColorScheme.fromImageProvider(
  provider: NetworkImage(imageUrl),
);

// Manual definition
ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF6750A4),
  onPrimary: Colors.white,
  secondary: Color(0xFF625B71),
  // ... other colors
)
```

### Using Colors

```dart
Widget build(BuildContext context) {
  final colors = Theme.of(context).colorScheme;

  return Container(
    color: colors.surface,
    child: Column(
      children: [
        // Primary action
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
          ),
          onPressed: () {},
          child: Text('Primary'),
        ),

        // Error state
        Text(
          'Error message',
          style: TextStyle(color: colors.error),
        ),

        // Container with tonal color
        Container(
          color: colors.primaryContainer,
          child: Text(
            'In container',
            style: TextStyle(color: colors.onPrimaryContainer),
          ),
        ),
      ],
    ),
  );
}
```

---

## TextTheme

Predefined text styles following Material typography.

### Text Style Hierarchy

| Style | Typical Use |
|-------|-------------|
| `displayLarge/Medium/Small` | Hero text, headlines |
| `headlineLarge/Medium/Small` | Section headers |
| `titleLarge/Medium/Small` | Card titles, dialogs |
| `bodyLarge/Medium/Small` | Paragraph text |
| `labelLarge/Medium/Small` | Buttons, captions |

### Using TextTheme

```dart
Widget build(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Welcome', style: textTheme.displayMedium),
      Text('Section Title', style: textTheme.headlineSmall),
      Text('Card Title', style: textTheme.titleMedium),
      Text('Body content goes here.', style: textTheme.bodyMedium),
      Text('BUTTON', style: textTheme.labelLarge),
    ],
  );
}
```

### Custom TextTheme

```dart
ThemeData(
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
  ),
)
```

### Custom Fonts

```dart
// In pubspec.yaml:
// fonts:
//   - family: Roboto
//     fonts:
//       - asset: fonts/Roboto-Regular.ttf
//       - asset: fonts/Roboto-Bold.ttf
//         weight: 700

ThemeData(
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    bodyMedium: TextStyle(fontFamily: 'Roboto'),
  ),
)
```

---

## TextStyle

Direct text styling.

### Common Properties

```dart
TextStyle(
  // Font
  fontSize: 16,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  fontFamily: 'Roboto',

  // Color
  color: Colors.black87,
  backgroundColor: Colors.yellow,

  // Spacing
  letterSpacing: 0.5,
  wordSpacing: 2.0,
  height: 1.5,  // Line height multiplier

  // Decoration
  decoration: TextDecoration.underline,
  decorationColor: Colors.red,
  decorationStyle: TextDecorationStyle.dashed,
  decorationThickness: 2,

  // Effects
  shadows: [Shadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 2)],
)
```

### Merging Styles

```dart
// Start with theme style, add modifications
final baseStyle = Theme.of(context).textTheme.bodyMedium!;

Text(
  'Modified',
  style: baseStyle.copyWith(
    fontWeight: FontWeight.bold,
    color: Colors.red,
  ),
)
```

### Rich Text

```dart
RichText(
  text: TextSpan(
    style: DefaultTextStyle.of(context).style,
    children: [
      TextSpan(text: 'Hello '),
      TextSpan(
        text: 'World',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      TextSpan(text: '!'),
    ],
  ),
)
```

---

## BoxDecoration

Styling containers with backgrounds, borders, shadows.

### Basic Properties

```dart
Container(
  decoration: BoxDecoration(
    // Background
    color: Colors.white,

    // Or gradient
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),

    // Or image
    image: DecorationImage(
      image: AssetImage('assets/bg.png'),
      fit: BoxFit.cover,
    ),

    // Border
    border: Border.all(color: Colors.grey, width: 1),

    // Rounded corners
    borderRadius: BorderRadius.circular(8),

    // Shadow
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: YourContent(),
)
```

### Border Variations

```dart
// All sides
Border.all(color: Colors.black, width: 2)

// Specific sides
Border(
  top: BorderSide(color: Colors.red, width: 2),
  bottom: BorderSide(color: Colors.blue, width: 2),
)

// Only bottom (underline effect)
Border(bottom: BorderSide(color: Colors.grey))
```

### BorderRadius Variations

```dart
// All corners
BorderRadius.circular(8)

// Specific corners
BorderRadius.only(
  topLeft: Radius.circular(16),
  topRight: Radius.circular(16),
)

// Horizontal/Vertical
BorderRadius.horizontal(left: Radius.circular(8))
BorderRadius.vertical(top: Radius.circular(8))
```

### Gradients

```dart
// Linear gradient
LinearGradient(
  colors: [Colors.blue, Colors.purple],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.0, 1.0],  // Color positions
)

// Radial gradient
RadialGradient(
  colors: [Colors.white, Colors.blue],
  center: Alignment.center,
  radius: 0.8,
)

// Sweep gradient
SweepGradient(
  colors: [Colors.red, Colors.blue, Colors.green, Colors.red],
  startAngle: 0,
  endAngle: 2 * pi,
)
```

---

## ShapeDecoration

For non-rectangular shapes.

```dart
Container(
  decoration: ShapeDecoration(
    color: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    shadows: [
      BoxShadow(color: Colors.black26, blurRadius: 8),
    ],
  ),
)

// Stadium shape (pill)
ShapeDecoration(
  color: Colors.green,
  shape: StadiumBorder(),
)

// Circle
ShapeDecoration(
  color: Colors.red,
  shape: CircleBorder(),
)

// Custom shape
ShapeDecoration(
  shape: BeveledRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
)
```

---

## Button Styles

### ButtonStyle

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    // Colors
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    disabledBackgroundColor: Colors.grey,

    // Shape
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),

    // Size
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    minimumSize: Size(120, 48),

    // Elevation
    elevation: 2,
    shadowColor: Colors.black26,

    // Text
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  ),
  onPressed: () {},
  child: Text('Button'),
)
```

### Theme-Level Button Styles

```dart
ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.blue,
      side: BorderSide(color: Colors.blue),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blue,
    ),
  ),
)
```

### Material State Properties

Handle different button states:

```dart
ElevatedButton(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) return Colors.blue.shade700;
      if (states.contains(WidgetState.hovered)) return Colors.blue.shade600;
      if (states.contains(WidgetState.disabled)) return Colors.grey;
      return Colors.blue;
    }),
    foregroundColor: WidgetStateProperty.all(Colors.white),
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) return Colors.white24;
      return null;
    }),
  ),
  onPressed: () {},
  child: Text('Stateful Button'),
)
```

---

## Input Decoration

Styling text fields.

### Basic InputDecoration

```dart
TextField(
  decoration: InputDecoration(
    // Labels
    labelText: 'Email',
    hintText: 'Enter your email',
    helperText: 'We will never share your email',

    // Icons
    prefixIcon: Icon(Icons.email),
    suffixIcon: Icon(Icons.clear),

    // Border
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),

    // Colors
    fillColor: Colors.grey.shade100,
    filled: true,

    // Error state
    errorText: 'Invalid email',
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
  ),
)
```

### Border Types

```dart
// Outlined (default Material 3)
OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: Colors.grey),
)

// Underline (classic Material)
UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.grey),
)

// No border
InputBorder.none
```

### Theme-Level Input Styling

```dart
ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
)
```

---

## Card Styling

```dart
Card(
  elevation: 4,
  shadowColor: Colors.black26,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  clipBehavior: Clip.antiAlias,  // Clip children to shape
  child: Column(
    children: [
      Image.network('https://example.com/image.jpg'),
      Padding(
        padding: EdgeInsets.all(16),
        child: Text('Card Title'),
      ),
    ],
  ),
)

// Theme-level
ThemeData(
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: Colors.white,
  ),
)
```

---

## Custom Theme Extensions

Add custom design tokens to theme.

### Define Extension

```dart
class AppColors extends ThemeExtension<AppColors> {
  final Color brandPrimary;
  final Color brandSecondary;
  final Color success;
  final Color warning;

  const AppColors({
    required this.brandPrimary,
    required this.brandSecondary,
    required this.success,
    required this.warning,
  });

  @override
  AppColors copyWith({
    Color? brandPrimary,
    Color? brandSecondary,
    Color? success,
    Color? warning,
  }) {
    return AppColors(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}
```

### Register Extension

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      AppColors(
        brandPrimary: Color(0xFF6750A4),
        brandSecondary: Color(0xFF625B71),
        success: Color(0xFF4CAF50),
        warning: Color(0xFFFFC107),
      ),
    ],
  ),
)
```

### Use Extension

```dart
Widget build(BuildContext context) {
  final appColors = Theme.of(context).extension<AppColors>()!;

  return Container(
    color: appColors.success,
    child: Text('Success!'),
  );
}
```

---

## Spacing and Sizing

### EdgeInsets

```dart
// All sides
EdgeInsets.all(16)

// Symmetric
EdgeInsets.symmetric(horizontal: 16, vertical: 8)

// Individual sides
EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8)

// LTRB shorthand
EdgeInsets.fromLTRB(16, 8, 16, 8)
```

### SizedBox for Spacing

```dart
Column(
  children: [
    Widget1(),
    SizedBox(height: 16),  // Vertical spacing
    Widget2(),
    SizedBox(height: 8),
    Widget3(),
  ],
)

Row(
  children: [
    Widget1(),
    SizedBox(width: 16),  // Horizontal spacing
    Widget2(),
  ],
)
```

### Gap Widget (flutter_gap package or custom)

```dart
// Custom Gap widget
class Gap extends StatelessWidget {
  final double size;
  const Gap(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size);
  }
}

// Usage
Column(
  children: [
    Widget1(),
    Gap(16),
    Widget2(),
  ],
)
```

---

## Best Practices

1. **Use Theme First** - Start with `Theme.of(context)` before inline styles
2. **Create Design Tokens** - Use `ThemeExtension` for custom values
3. **Avoid Magic Numbers** - Define spacing/sizing constants
4. **Leverage ColorScheme** - Use semantic color roles
5. **copyWith for Variations** - Extend base styles instead of duplicating
6. **Keep Widget-Level Styles** - Create styled widget wrappers for reuse
7. **Test Dark Mode** - Always verify both light and dark themes
8. **Use Semantic Styles** - `textTheme.titleMedium` over `TextStyle(fontSize: 16)`

### Style Constants Pattern

```dart
class AppStyles {
  // Spacing
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  // Border radius
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 16;

  // Common decorations
  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(radiusMd),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}

// Usage
Container(
  padding: EdgeInsets.all(AppStyles.spacingMd),
  decoration: AppStyles.cardDecoration(context),
  child: YourContent(),
)
```
