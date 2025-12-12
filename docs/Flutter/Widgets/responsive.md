# Adaptive and Responsive Design in Flutter

Flutter enables building apps from a single codebase that work across watches, phones, foldables, tablets, and desktop monitors.

---

## Theory: Why Responsive & Adaptive Design Matters

### The Multi-Device Challenge

Modern apps must work across an enormous range of devices:
- **Watches** - ~1.5" screens, limited interaction
- **Phones** - 4-7" screens, touch-first
- **Foldables** - Dual screens, changing form factors
- **Tablets** - 7-13" screens, touch + stylus
- **Desktops** - 13-32"+ screens, mouse + keyboard

Each device has different:
- **Screen dimensions** and pixel densities
- **Input methods** (touch, mouse, keyboard, stylus)
- **Platform conventions** (gestures, navigation patterns)
- **Use contexts** (one-handed mobile, productivity desktop)

### Responsive vs Adaptive

| Concept | Focus | Example |
|---------|-------|---------|
| **Responsive** | Fitting UI into available space | Adjusting column count in a grid |
| **Adaptive** | Making UI usable in the space | Switching from bottom nav to side panel on tablet |

**Responsive Design** answers: *"How does this layout scale?"*
- Fluid grids that expand/contract
- Flexible images and media
- Content reflow based on width

**Adaptive Design** answers: *"What's the right UI for this context?"*
- Different navigation patterns (tabs vs. rail vs. drawer)
- Platform-specific widgets (Material vs. Cupertino)
- Input-aware interactions (hover states for mouse users)

> **Note:** These terms are often used interchangeably. "Adaptive" typically encompasses both concepts.

### The Layout Spectrum

```
┌─────────────────────────────────────────────────────────────────┐
│  COMPACT          │    MEDIUM           │     EXPANDED         │
│  (< 600dp)        │    (600-840dp)      │     (> 840dp)        │
├───────────────────┼─────────────────────┼──────────────────────┤
│  Single column    │    Two columns      │     Multi-pane       │
│  Bottom nav       │    Navigation rail  │     Side navigation  │
│  Full-screen      │    Master-detail    │     Dashboard        │
│  dialogs          │    dialogs          │     inline panels    │
└─────────────────────────────────────────────────────────────────┘
```

### Key Principles

1. **Content-First**: Design for content, not devices. Let breakpoints emerge from where content breaks.

2. **Progressive Enhancement**: Start with the constrained mobile experience, then enhance for larger screens.

3. **Fluid Over Fixed**: Use relative units and constraints rather than fixed pixel values.

4. **Touch-Friendly Always**: Even on desktop, maintain adequate touch targets (48x48dp minimum) for touchscreen laptops.

5. **Context Awareness**: Consider not just size, but how users interact—standing with one hand vs. sitting with keyboard.

### Flutter's Approach

Flutter provides tools at multiple levels:

| Level | Tool | Purpose |
|-------|------|---------|
| **Query** | `MediaQuery` | Get device/window info |
| **Constraint** | `LayoutBuilder` | React to parent size |
| **Flexibility** | `Expanded`, `Flexible` | Proportional sizing |
| **Adaptation** | `Platform`, `kIsWeb` | Platform detection |
| **Protection** | `SafeArea` | Avoid system UI |

---

## SafeArea

Avoid system UI intrusions (notches, status bars, navigation bars).

### Theory

Modern devices have various screen intrusions:
- **Notches** - Camera/sensor cutouts at top of screen
- **Status bars** - System time, battery, notifications
- **Navigation bars** - Software buttons or gesture areas
- **Rounded corners** - Physical display shape
- **Camera holes** - Punch-hole cameras

`SafeArea` automatically insets its child to avoid all these obstacles. It uses `MediaQuery` behind the scenes to detect these features.

**Key insight:** SafeArea modifies the `MediaQuery` for its children, making it appear the padding doesn't exist. This means nested SafeAreas won't double-apply padding—only the topmost one adds the insets.

### Best Practices

- Wrap the `body` of `Scaffold`, not the entire Scaffold (AppBar handles its own safe area)
- Move SafeArea lower in the tree if you want content to extend under cutouts
- Use selective sides when you want specific edges unprotected

```dart
// Recommended: Wrap Scaffold body
Scaffold(
  body: SafeArea(
    child: YourContent(),
  ),
)

// Selective padding
SafeArea(
  top: true,
  bottom: true,
  left: false,
  right: false,
  child: YourContent(),
)

// Let content extend under notch, protect only specific areas
Scaffold(
  body: Column(
    children: [
      FullBleedHeader(),  // Extends under notch
      Expanded(
        child: SafeArea(
          top: false,  // Header handles top
          child: MainContent(),
        ),
      ),
    ],
  ),
)
```

---

## MediaQuery

Access device and window information.

### Theory

`MediaQuery` is the foundation for responsive design in Flutter. It provides:

| Category | Properties | Use Case |
|----------|------------|----------|
| **Size** | `size`, `orientation` | Layout decisions |
| **Padding** | `padding`, `viewInsets`, `viewPadding` | Safe areas, keyboard |
| **Display** | `devicePixelRatio`, `displayFeatures` | Foldables, pixel density |
| **Accessibility** | `textScaleFactor`, `boldText`, `highContrast` | A11y support |
| **Interaction** | `platformBrightness`, `gestureSettings` | Theme, input |

**padding vs viewInsets vs viewPadding:**
- `padding` - Areas obscured by system UI (notches, status bar)
- `viewInsets` - Areas obscured by keyboard or other transient UI
- `viewPadding` - Original padding, unaffected by keyboard

**Performance tip:** Use specific methods like `MediaQuery.sizeOf(context)` instead of `MediaQuery.of(context).size` to rebuild only when that specific property changes.

```dart
// Screen dimensions
var size = MediaQuery.of(context).size;
var width = size.width;
var height = size.height;

// Orientation
var orientation = MediaQuery.of(context).orientation;
if (orientation == Orientation.landscape) { }

// Safe area padding
var padding = MediaQuery.of(context).padding;

// Text scale factor
var textScale = MediaQuery.of(context).textScaleFactor;

// Device pixel ratio
var pixelRatio = MediaQuery.of(context).devicePixelRatio;

// Platform brightness (light/dark mode)
var brightness = MediaQuery.of(context).platformBrightness;
```

### MediaQuery.sizeOf (Performance Optimized)

```dart
// Only rebuilds when size changes
var size = MediaQuery.sizeOf(context);
```

---

## LayoutBuilder

Build different layouts based on parent constraints.

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return WideLayout();
    } else {
      return NarrowLayout();
    }
  },
)
```

---

## Responsive Breakpoints

Common breakpoint patterns:

```dart
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

Widget build(BuildContext context) {
  var width = MediaQuery.sizeOf(context).width;

  if (width < Breakpoints.mobile) {
    return MobileLayout();
  } else if (width < Breakpoints.tablet) {
    return TabletLayout();
  } else {
    return DesktopLayout();
  }
}
```

---

## Flexible Widgets

### Expanded & Flexible

```dart
Row(
  children: [
    Expanded(
      flex: 2,
      child: Container(color: Colors.red),
    ),
    Expanded(
      flex: 1,
      child: Container(color: Colors.blue),
    ),
  ],
)
```

### FractionallySizedBox

```dart
FractionallySizedBox(
  widthFactor: 0.8,   // 80% of parent width
  heightFactor: 0.5,  // 50% of parent height
  child: Container(),
)
```

### AspectRatio

```dart
AspectRatio(
  aspectRatio: 16 / 9,
  child: Container(),
)
```

---

## Responsive Grids

### Theory: ListView vs GridView

**Problem:** A `ListView` that looks fine on mobile stretches awkwardly on tablets/desktops. Android and iOS guidelines say content shouldn't span the full width on large screens.

**Solution:** Use `GridView` to automatically create columns based on available space.

| Widget | Use Case |
|--------|----------|
| `ListView` | Single column, variable height items |
| `GridView.count` | Fixed number of columns |
| `GridView.builder` | Dynamic columns, large item counts |
| `GridView.extent` | Columns based on max item width |

**Important:** Don't hardcode column counts based on device type. Use window size instead (supports multi-window mode, web resizing).

### GridView with Adaptive Columns

```dart
// Recommended: Let Flutter calculate columns based on max item width
GridView.builder(
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200,  // Max item width - columns auto-calculated
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => GridItem(items[index]),
)

// Alternative: Fixed column count
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,  // Always 3 columns
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemBuilder: (context, index) => GridItem(),
)
```

### Constraining Width

For content that shouldn't expand infinitely:

```dart
// Using ConstrainedBox
Center(
  child: ConstrainedBox(
    constraints: BoxConstraints(maxWidth: 840),  // Material 3 recommendation
    child: YourContent(),
  ),
)

// Using Container
Center(
  child: Container(
    constraints: BoxConstraints(maxWidth: 840),
    child: YourContent(),
  ),
)
```

### Wrap Widget

```dart
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: items.map((item) => Chip(label: Text(item))).toList(),
)
```

---

## Large Screens & Foldables

### Theory: Why Large Screens Matter

**Market reality (as of 2024):**
- 270+ million active large screen and foldable Android devices
- 14.9+ million iPad users
- Growing demand for tablet and desktop experiences

**Benefits of large screen optimization:**
- Improved user engagement metrics
- Better Play Store visibility (ratings now shown by device type)
- Meets iPadOS App Store submission guidelines
- Multi-window mode support

**Large screen devices include:**
- Tablets (Android, iPad)
- Foldables (Galaxy Fold, Pixel Fold)
- ChromeOS devices
- Desktop (Windows, macOS, Linux)
- Web browsers

### The Foldable Challenge

**Problem:** Apps that lock screen orientation can get letterboxed on foldables when unfolded.

**Why it happens:** `setPreferredOrientations` causes Android to use portrait compatibility mode, and `MediaQuery` never receives the larger window size.

**Solutions:**
1. Support all orientations (recommended)
2. Use physical display dimensions via Display API

```dart
// Getting physical display dimensions (Flutter 3.13+)
ui.FlutterView? _view;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _view = View.maybeOf(context);
}

void didChangeMetrics() {
  final ui.Display? display = _view?.display;
  // display.size gives physical dimensions
}
```

### Detecting Foldables

```dart
// Using MediaQuery for display features
var displayFeatures = MediaQuery.of(context).displayFeatures;

for (var feature in displayFeatures) {
  if (feature.type == DisplayFeatureType.fold) {
    // Handle fold - content should avoid this area
  } else if (feature.type == DisplayFeatureType.hinge) {
    // Handle hinge - physical separation between screens
  }
}
```

### Two-Pane Layout

```dart
Widget build(BuildContext context) {
  var width = MediaQuery.sizeOf(context).width;

  if (width > 600) {
    // Side-by-side layout
    return Row(
      children: [
        Expanded(child: ListPane()),
        VerticalDivider(),
        Expanded(flex: 2, child: DetailPane()),
      ],
    );
  } else {
    // Single pane with navigation
    return ListPane();
  }
}
```

---

## Adaptive Navigation

### Theory: Navigation Patterns by Screen Size

Android's Large Screen App Quality Guidelines define three tiers of support:

| Tier | Level | Requirements |
|------|-------|--------------|
| **Tier 3** | Basic | Mouse & stylus input support |
| **Tier 2** | Better | Responsive layouts, keyboard nav |
| **Tier 1** | Best | Optimized UX, multi-window, drag-drop |

**Navigation widget selection:**

| Screen Width | Navigation Widget | Notes |
|--------------|-------------------|-------|
| < 600dp | `BottomNavigationBar` | Thumb-reachable on phones |
| 600-840dp | `NavigationRail` | Compact side navigation |
| > 840dp | `NavigationDrawer` | Full side navigation with labels |

**Key insight:** If using Material 3 widgets, mouse/stylus hover states are built-in. Custom widgets need explicit input handling.

```dart
Widget build(BuildContext context) {
  var width = MediaQuery.sizeOf(context).width;

  return Scaffold(
    body: Row(
      children: [
        // Side navigation for wide screens
        if (width >= 600)
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
        Expanded(child: _pages[_selectedIndex]),
      ],
    ),
    // Bottom navigation for narrow screens
    bottomNavigationBar: width < 600
        ? BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          )
        : null,
  );
}
```

---

## Platform Adaptation

### Detecting Platform

```dart
import 'dart:io' show Platform;

if (Platform.isIOS) { }
if (Platform.isAndroid) { }
if (Platform.isMacOS) { }
if (Platform.isWindows) { }
if (Platform.isLinux) { }

// For web (doesn't support dart:io)
import 'package:flutter/foundation.dart' show kIsWeb;

if (kIsWeb) { }
```

### Adaptive Widgets

```dart
// Platform-aware dialog
showDialog(
  context: context,
  builder: (context) => Platform.isIOS
      ? CupertinoAlertDialog(
          title: Text('Title'),
          actions: [CupertinoDialogAction(child: Text('OK'))],
        )
      : AlertDialog(
          title: Text('Title'),
          actions: [TextButton(onPressed: () {}, child: Text('OK'))],
        ),
);
```

---

## User Input & Accessibility

### Theory: Beyond Touch

A truly adaptive app supports multiple input types:

| Input Type | Considerations |
|------------|----------------|
| **Touch** | Large hit areas (48x48dp min), gestures |
| **Mouse** | Hover states, right-click, scroll wheel, precise clicks |
| **Keyboard** | Tab traversal, shortcuts, focus indicators |
| **Stylus** | Pressure sensitivity, palm rejection |
| **Assistive** | Screen readers, switch access |

**Key insight:** Features that help power users (keyboard shortcuts) often also help users with accessibility needs. Good adaptive design is inherently accessible.

### Scroll Wheel

Built-in for `ScrollView`, `ListView`. For custom scroll behavior:

```dart
Listener(
  onPointerSignal: (event) {
    if (event is PointerScrollEvent) {
      print(event.scrollDelta.dy);
    }
  },
  child: CustomScrollWidget(),
)
```

### Tab Traversal & Focus

Users expect Tab key navigation. Use `FocusableActionDetector` for custom widgets:

```dart
FocusableActionDetector(
  onFocusChange: (hasFocus) => setState(() => _hasFocus = hasFocus),
  actions: <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<Intent>(
      onInvoke: (intent) {
        print('Enter or Space pressed!');
        return null;
      },
    ),
  },
  child: Container(
    decoration: _hasFocus
        ? BoxDecoration(border: Border.all(color: Colors.blue, width: 2))
        : null,
    child: YourWidget(),
  ),
)
```

### Controlling Tab Order

Group related fields for logical tab order:

```dart
Column(
  children: [
    FocusTraversalGroup(
      child: MyFormWithMultipleFields(),  // Tab through form first
    ),
    SubmitButton(),  // Then tab to submit
  ],
)
```

### Keyboard Shortcuts

**Option 1: Widget-level** (fires only when widget has focus)

```dart
Shortcuts(
  shortcuts: <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.keyN, control: true): CreateNewIntent(),
  },
  child: Actions(
    actions: <Type, Action<Intent>>{
      CreateNewIntent: CallbackAction<CreateNewIntent>(
        onInvoke: (intent) => _createNewItem(),
      ),
    },
    child: Focus(autofocus: true, child: YourWidget()),
  ),
)
```

**Option 2: Global listener** (app-wide, always active)

```dart
@override
void initState() {
  super.initState();
  HardwareKeyboard.instance.addHandler(_handleKey);
}

@override
void dispose() {
  HardwareKeyboard.instance.removeHandler(_handleKey);
  super.dispose();
}

bool _handleKey(KeyEvent event) {
  final isShiftDown = HardwareKeyboard.instance.logicalKeysPressed
      .intersection({LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight})
      .isNotEmpty;

  if (isShiftDown && event.logicalKey == LogicalKeyboardKey.keyN) {
    _createNewItem();
    return true;
  }
  return false;
}
```

> **Warning:** Disable global shortcuts when user is typing in text fields!

### Mouse Hover & Cursors

```dart
MouseRegion(
  cursor: SystemMouseCursors.click,  // Hand cursor
  onEnter: (_) => setState(() => _isHovered = true),
  onExit: (_) => setState(() => _isHovered = false),
  onHover: (event) => print(event.localPosition),
  child: Container(
    color: _isHovered ? Colors.blue.shade100 : Colors.white,
    child: YourButton(),
  ),
)
```

### Visual Density

Adjust hit area sizes for different input types:

```dart
// In MaterialApp theme
double densityAmt = isTouchDevice ? 0.0 : -1.0;  // Smaller on desktop
return MaterialApp(
  theme: ThemeData(
    visualDensity: VisualDensity(
      horizontal: densityAmt,
      vertical: densityAmt,
    ),
  ),
  home: MyApp(),
);

// Access in widgets
VisualDensity density = Theme.of(context).visualDensity;
```

**Density values:**
- `0.0` = Standard (touch-friendly)
- `-1.0` to `-4.0` = More compact (desktop)
- `+1.0` to `+4.0` = More spacious

---

## Capabilities & Policies

### Theory: Structuring Adaptive Code

Beyond layout, apps need to adapt to platform-specific rules and hardware capabilities. Flutter recommends separating this logic into **Capability** and **Policy** classes.

| Concept | Definition | Examples |
|---------|------------|----------|
| **Capability** | What the code/device *can* do | API existence, hardware (camera), OS restrictions |
| **Policy** | What the code *should* do | App store rules, design preferences, feature flags |

**Why separate them?**
- Capabilities change when platforms add features
- Policies change based on business decisions
- Both can be mocked in tests independently

### Capability Class

Check what the device/platform supports:

```dart
class Capability {
  /// Whether the device has a camera
  bool get hasCamera {
    // Check actual hardware capability
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Whether biometric auth is available
  Future<bool> get hasBiometrics async {
    final auth = LocalAuthentication();
    return await auth.canCheckBiometrics;
  }

  /// Whether the platform supports in-app purchases
  bool get supportsInAppPurchase {
    return Platform.isAndroid || Platform.isIOS;
  }
}
```

### Policy Class

Define what the app should do based on rules/preferences:

```dart
class Policy {
  /// Apple App Store prohibits linking to external purchase pages
  bool get shouldAllowExternalPurchaseLink {
    return !Platform.isIOS;
  }

  /// Show Cupertino widgets on Apple platforms
  bool get useCupertinoWidgets {
    return Platform.isIOS || Platform.isMacOS;
  }

  /// Feature flag from server
  bool shouldShowNewFeature(RemoteConfig config) {
    return config.getBool('new_feature_enabled');
  }
}
```

### Using in Widgets

```dart
class MyWidget extends StatelessWidget {
  final Policy policy;
  final Capability capability;

  const MyWidget({
    required this.policy,
    required this.capability,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Policy decision
        if (policy.shouldAllowExternalPurchaseLink)
          TextButton(
            onPressed: () => launchUrl(Uri.parse('https://store.example.com')),
            child: Text('Buy on Web'),
          ),

        // Capability check
        if (capability.hasCamera)
          ElevatedButton(
            onPressed: _takePhoto,
            child: Text('Take Photo'),
          ),
      ],
    );
  }
}
```

### Policy Check Types

| Type | Use Case | Example |
|------|----------|---------|
| **Compile-time** | Platform rules unlikely to change | App Store payment restrictions |
| **Runtime** | Hardware/API detection | Touch screen availability |
| **RPC-backed** | Server-controlled features | A/B tests, feature rollout |

### Best Practice: Name by Intent

```dart
// Bad - names by platform
bool isIOS() => Platform.isIOS;

// Good - names by intent
bool shouldUseApplePaymentFlow() => Platform.isIOS;
bool requiresPermissionDialog() => Platform.isAndroid && sdkVersion >= 33;
```

---

## Best Practices

1. **Start mobile-first** - Design for smallest screen, then expand
2. **Use constraints, not fixed sizes** - Prefer `Expanded`, `Flexible`, `LayoutBuilder`
3. **Test on multiple form factors** - Use device preview tools
4. **Consider touch targets** - Minimum 48x48 dp for touch targets
5. **Handle orientation changes** - Use `OrientationBuilder` when needed
6. **Respect platform conventions** - iOS back swipe, Android back button
7. **Use responsive text** - Consider `FittedBox` or responsive font sizes
8. **Separate capabilities from policies** - Use dedicated classes for testability
9. **Name methods by intent** - `shouldAllowPurchase()` not `isIOS()`
10. **Design to platform strengths** - Leverage deep links on web, biometrics on mobile
