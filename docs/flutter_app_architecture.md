# Flutter App Architecture and Flow

A deep dive into how a Flutter app runs from start to finish.

---

## 1️⃣ Flutter Project Structure

```
my_app/
├── android/          → Android native code
├── ios/              → iOS native code
├── web/              → Web support
├── windows/macos/linux/
├── lib/
│   └── main.dart     → ENTRY POINT
├── pubspec.yaml      → Dependencies & assets
└── build/            → Generated files (auto)
```

**Key File:** `lib/main.dart`

```dart
void main() {
  runApp(MyApp());
}
```

---

## 2️⃣ App Startup Flow

```
Mobile OS
   ↓
Native Runner (Android/iOS)
   ↓
Flutter Engine (C++)
   ↓
Dart VM
   ↓
main() function
   ↓
Widgets
   ↓
Render Tree
   ↓
Skia GPU
   ↓
Screen Pixels
```

### Step-by-Step

#### OS → Native Code

**Android:** `MainActivity.kt`
```kotlin
class MainActivity: FlutterActivity()
```
**iOS:** `AppDelegate.swift`

Purpose: Load Flutter Engine and hand control to Dart.

#### Flutter Engine (C++)
- Skia rendering
- Dart runtime
- Text rendering
- Input handling
- Platform channels

#### Dart VM
- Loads compiled Dart code
- Calls `main()`

#### runApp() → Widget Tree
- Creates **Widget Tree**
- Attaches to Flutter binding
- Starts first frame render

Widget Tree Example:
```
MyApp
 └── MaterialApp
     └── Scaffold
         └── Text
```

---

## 3️⃣ Flutter Internal Trees

Flutter creates **3 trees**:

```
Widget Tree (configuration)
    ↓
Element Tree (instance + lifecycle)
    ↓
Render Tree (layout & painting)
```

- **Widget Tree:** Immutable, cheap, rebuilt often
- **Element Tree:** Holds state, persistent
- **Render Tree:** Calculates layout, draws pixels

---

## 4️⃣ Rendering Pipeline

```
Build Phase
   ↓
Layout Phase
   ↓
Paint Phase
   ↓
Compositing
   ↓
Skia GPU
```

- **Build Phase:** Widgets → Elements
- **Layout Phase:** Compute sizes/positions
- **Paint Phase:** Draw shapes, images, text
- **Compositing:** Combine layers
- **Skia:** GPU renders pixels

---

## 5️⃣ Flutter Layers

```
App Layer (Your Code)
   ↓
Framework Layer (Widgets, Material, Cupertino)
   ↓
Engine Layer (C++, Skia, Dart VM)
   ↓
Embedder Layer (Android/iOS)
   ↓
OS
```

- **Framework Layer:** widgets, rendering, painting, animation
- **Engine Layer:** text rasterization, GPU rendering, thread management

---

## 6️⃣ Platform Channels

```
Dart
 ↓
MethodChannel
 ↓
Native Android / iOS
```

Example:
```dart
MethodChannel('battery').invokeMethod('getLevel');
```

---

## 7️⃣ Thread Model

```
UI Thread      → Dart code
Raster Thread  → GPU drawing
IO Thread      → File/network
Platform Thread → Native calls
```

---

## 8️⃣ Hot Reload (Debug Mode)
- Injects updated Dart code
- Rebuilds Widget Tree
- Keeps state

---

## 9️⃣ Debug vs Release

| Mode | Dart | Performance |
|------|------|-------------|
| Debug | JIT  | Slow        |
| Profile | JIT + metrics | Medium |
| Release | AOT | Fast |

Release: Dart → native ARM, no VM overhead.

---

## 🔟 Full Flow Diagram

```
OS Launch
  ↓
Native Runner
  ↓
Flutter Embedder
  ↓
Flutter Engine (C++)
  ↓
Dart VM
  ↓
main()
  ↓
runApp()
  ↓
Widget Tree
  ↓
Element Tree
  ↓
Render Tree
  ↓
Skia GPU
  ↓
Screen
```

---

## Key Takeaways

- Flutter does **NOT** use native UI widgets.
- Widgets are **configuration**, not UI elements.
- Flutter uses multiple internal trees and layers.
- Rendering is optimized with Skia and GPU.
- Platform communication happens via channels.

