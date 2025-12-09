# Operators

Dart operators listed by precedence (highest to lowest):

| Category | Operators |
|----------|-----------|
| Unary postfix | `expr++` `expr--` `()` `[]` `?[]` `.` `?.` `!` |
| Unary prefix | `-expr` `!expr` `~expr` `++expr` `--expr` `await` |
| Multiplicative | `*` `/` `%` `~/` |
| Additive | `+` `-` |
| Shift | `<<` `>>` `>>>` |
| Bitwise | `&` `^` `\|` |
| Relational | `>=` `>` `<=` `<` `as` `is` `is!` |
| Equality | `==` `!=` |
| Logical | `&&` `\|\|` |
| If-null | `??` |
| Conditional | `? :` |
| Cascade | `..` `?..` |
| Assignment | `=` `*=` `/=` `+=` `-=` `&=` `^=` etc. |
| Spread | `...` `...?` |

---

## Arithmetic Operators

```dart
assert(2 + 3 == 5);      // Add
assert(2 - 3 == -1);     // Subtract
assert(2 * 3 == 6);      // Multiply
assert(5 / 2 == 2.5);    // Divide (returns double)
assert(5 ~/ 2 == 2);     // Integer division
assert(5 % 2 == 1);      // Modulo (remainder)
```

### Increment / Decrement

```dart
var a = 0;
var b = ++a;  // Increment BEFORE: a=1, b=1
var c = a++;  // Increment AFTER:  a=2, c=1

var d = --a;  // Decrement BEFORE: a=1, d=1
var e = a--;  // Decrement AFTER:  a=0, e=1
```

---

## Equality and Relational Operators

```dart
assert(2 == 2);   // Equal
assert(2 != 3);   // Not equal
assert(3 > 2);    // Greater than
assert(2 < 3);    // Less than
assert(3 >= 3);   // Greater than or equal
assert(2 <= 3);   // Less than or equal
```

> Use `identical(a, b)` to check if two objects are the exact same instance.

---

## Type Test Operators

| Operator | Meaning |
|----------|---------|
| `as` | Typecast |
| `is` | True if object has the type |
| `is!` | True if object doesn't have the type |

```dart
// Safe type check
if (employee is Person) {
  employee.firstName = 'Bob';
}

// Typecast (throws if wrong type)
(employee as Person).firstName = 'Bob';
```

---

## Assignment Operators

```dart
a = value;      // Simple assignment
b ??= value;    // Assign only if b is null

// Compound assignment
a += b;   // Same as: a = a + b
a -= b;   // Same as: a = a - b
a *= b;   // Same as: a = a * b
a ~/= b;  // Same as: a = a ~/ b
```

---

## Logical Operators

```dart
!expr      // Invert (NOT)
a || b     // Logical OR
a && b     // Logical AND

if (!done && (col == 0 || col == 3)) {
  // ...
}
```

---

## Bitwise and Shift Operators

```dart
final value = 0x22;
final bitmask = 0x0f;

assert((value & bitmask) == 0x02);   // AND
assert((value | bitmask) == 0x2f);   // OR
assert((value ^ bitmask) == 0x2d);   // XOR
assert((~value) == -0x23);           // NOT (complement)

assert((value << 4) == 0x220);       // Shift left
assert((value >> 4) == 0x02);        // Shift right
assert((value >>> 4) == 0x02);       // Unsigned shift right
```

---

## Conditional Expressions

### Ternary Operator (`? :`)

```dart
var visibility = isPublic ? 'public' : 'private';
```

### If-Null Operator (`??`)

Returns left side if non-null, otherwise right side.

```dart
String playerName(String? name) => name ?? 'Guest';

// Equivalent to:
String playerName(String? name) => name != null ? name : 'Guest';
```

---

## Cascade Notation (`..` / `?..`)

Perform multiple operations on the same object without repeating the reference.

```dart
var paint = Paint()
  ..color = Colors.black
  ..strokeCap = StrokeCap.round
  ..strokeWidth = 5.0;

// Equivalent to:
var paint = Paint();
paint.color = Colors.black;
paint.strokeCap = StrokeCap.round;
paint.strokeWidth = 5.0;
```

### Null-Shorting Cascade (`?..`)

```dart
document.querySelector('#confirm')
  ?..textContent = 'Confirm'    // Skip all if null
  ..classList.add('important')
  ..onClick.listen((e) => window.alert('Confirmed!'));
```

---

## Spread Operators (`...` / `...?`)

Unpack collections into another collection.

```dart
var list1 = [1, 2, 3];
var list2 = [0, ...list1, 4];  // [0, 1, 2, 3, 4]

var nullableList = null;
var list3 = [0, ...?nullableList];  // [0] - safely handles null
```

---

## Other Operators

| Operator | Name | Example |
|----------|------|---------|
| `()` | Function call | `foo()` |
| `[]` | Subscript access | `list[0]` |
| `?[]` | Conditional subscript | `list?[0]` (null if list is null) |
| `.` | Member access | `foo.bar` |
| `?.` | Conditional member | `foo?.bar` (null if foo is null) |
| `!` | Not-null assertion | `foo!.bar` (throws if foo is null) |
