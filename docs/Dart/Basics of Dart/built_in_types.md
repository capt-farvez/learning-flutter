# Built-in Types

Dart has special support for the following types:

| Type | Description |
|------|-------------|
| `int`, `double` | Numbers |
| `String` | Text strings |
| `bool` | Boolean values |
| `List` | Arrays |
| `Set` | Unique collections |
| `Map` | Key-value pairs |
| `Runes` | Unicode code points |
| `Symbol` | Identifiers/operators |
| `Null` | The value `null` |

**Special types:**
- `Object` - superclass of all Dart classes (except Null)
- `Enum` - for enumerated types
- `dynamic` - disables static checking (prefer `Object?`)
- `void` - indicates unused return value
- `Never` - expression never completes (always throws)
- `Future` and `Stream` - asynchronous types

---

## Numbers

### int
Integer values (no decimal point), up to 64 bits.

```dart
var x = 1;
var hex = 0xDEADBEEF;
```

### double
64-bit floating-point numbers.

```dart
var y = 1.1;
var exponents = 1.42e5;
```

### num
Can hold both `int` and `double` values.

```dart
num x = 1;
x += 2.5;  // Now a double
```

### Conversions

```dart
// String -> Number
var one = int.parse('1');
var pi = double.parse('3.14');

// Number -> String
String s = 1.toString();           // '1'
String p = 3.14159.toStringAsFixed(2);  // '3.14'
```

### Bitwise Operators (int only)

```dart
assert((3 << 1) == 6);   // Shift left
assert((3 | 4) == 7);    // OR
assert((3 & 4) == 0);    // AND
```

### Digit Separators (Dart 3.6+)

```dart
var million = 1_000_000;
var mac = 0x00_14_22_01_23_45;
var phone = 555_123_4567;
```

---

## Strings

Single or double quotes both work:

```dart
var s1 = 'Single quotes';
var s2 = "Double quotes";
var s3 = 'It\'s escaped';
var s4 = "It's easier with other delimiter";
```

### String Interpolation

```dart
var name = 'Dart';
print('Hello $name!');              // Simple variable
print('Upper: ${name.toUpperCase()}');  // Expression
```

### Concatenation

```dart
var s = 'String ' 'concatenation';  // Adjacent literals
var s2 = 'Hello ' + 'World';        // + operator
```

### Multi-line Strings

```dart
var s = '''
This is a
multi-line string.
''';
```

### Raw Strings

```dart
var s = r'Raw string: \n is not a newline';
```

---

## Booleans

Only `true` and `false` (both compile-time constants).

```dart
// Dart requires explicit boolean checks
var name = '';
if (name.isEmpty) { }    //  Correct

var count = 0;
if (count == 0) { }      //  Correct

// if (name) { }         //  Won't work like in JS
```

---

## Runes and Grapheme Clusters

Runes expose Unicode code points of a string.

```dart
// Unicode escape sequences
var heart = '\u2665';        // e (4 hex digits)
var laugh = '\u{1f606}';     // = (curly braces for other lengths)
```

For complex characters (like emojis, flags), use the `characters` package:

```dart
import 'package:characters/characters.dart';

var hi = 'Hi <�<�';
print(hi.characters.last);  // <�<� (correct)
print(hi.substring(hi.length - 1));  // ??? (broken)
```

---

## Symbols

Represent operators or identifiers. Useful for reflection APIs since minification doesn't affect them.

```dart
var s = #radix;     // Symbol literal
var b = #bar;       // Compile-time constant
```

---

## Cascade Notation
Cascade notation (`..`) allows multiple operations on the same object.

```
var paint = Paint()
  ..color = Colors.black
  ..strokeCap = StrokeCap.round
  ..strokeWidth = 5.0;
```

This is equivalent to:
```
var paint = Paint();
paint.color = Colors.black;
paint.strokeCap = StrokeCap.round;
paint.strokeWidth = 5.0;
```
