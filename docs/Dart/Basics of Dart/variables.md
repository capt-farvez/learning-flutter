# Variables

Variables store references to objects. Dart supports type inference, so you can use `var` and let Dart infer the type, or explicitly declare it.

```dart
var name = 'Bob';           // Type inferred as String
Object name = 'Bob';        // Can hold any type
String name = 'Bob';        // Explicit type declaration
```

---

## Null Safety

Dart enforces **sound null safety**, preventing null dereference errors at compile time.

```dart
String? name   // Nullable - can be null or String
String name    // Non-nullable - must have a value
```

**Key rules:**
- Non-nullable variables must be initialized before use
- You can't call methods on nullable types without null checks
- Nullable variables default to `null`

---

## Default Values

- **Nullable types** → default to `null`
- **Non-nullable types** → must be explicitly initialized

```dart
int? lineCount;        // Defaults to null
int lineCount = 0;     // Must initialize non-nullable
```

---

## Late Variables

The `late` modifier serves two purposes:

1. **Deferred initialization** - declare non-nullable variable initialized later
2. **Lazy initialization** - initializer runs only when first accessed

```dart
late String description;              // Initialized later
late String temp = readThermometer(); // Lazy - only runs if used
```

> ⚠️ Using an uninitialized `late` variable causes a runtime error.

---

## Final and Const

| Keyword | Description |
|---------|-------------|
| `final` | Set only once, at runtime |
| `const` | Compile-time constant, immutable |

```dart
final name = 'Bob';              // Can't reassign
const bar = 1000000;             // Compile-time constant
const double atm = 1.01325 * bar;

var foo = const [];              // Variable with const value
foo = [1, 2, 3];                 // Can reassign (var is mutable)
```

**Important:** A `final` object's fields can change; a `const` object is completely immutable.

---

## Wildcard Variables

Use `_` as a non-binding placeholder (Dart 3.7+). The value isn't accessible, but initializers still execute.

```dart
var _ = computeValue();         // Value discarded
for (var _ in list) {}          // Ignore loop variable
try { } catch (_) { }           // Ignore exception
list.where((_) => true);        // Ignore parameter
```

Multiple `_` declarations can exist in the same scope without collision.
