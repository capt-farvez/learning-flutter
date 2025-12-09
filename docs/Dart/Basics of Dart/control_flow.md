# Control Flow

Dart supports the following control flow statements:

- `if` / `else` - conditional branching
- `for` loops - iteration
- `while` / `do-while` loops - conditional iteration
- `break` / `continue` - loop control
- `switch` / `case` - pattern matching
- `assert` - development-time checks

---

## If and Else

```dart
if (isRaining()) {
  you.bringRainCoat();
} else if (isSnowing()) {
  you.wearJacket();
} else {
  car.putTopDown();
}
```

> Dart requires boolean conditions. Unlike JavaScript, you can't use `if (nonBooleanValue)`.

### If-Case (Pattern Matching)

```dart
if (pair case [int x, int y]) {
  print('Coordinates: $x, $y');
} else {
  throw FormatException('Invalid coordinates');
}
```

---

## For Loops

### Standard For Loop

```dart
for (var i = 0; i < 5; i++) {
  print(i);
}
```

### For-In Loop

```dart
for (var item in items) {
  print(item);
}
```

### forEach Method

```dart
items.forEach((item) => print(item));
// Or with tear-off
items.forEach(print);
```

---

## While and Do-While

### While Loop

Checks condition before each iteration.

```dart
while (!isDone()) {
  doSomething();
}
```

### Do-While Loop

Executes body at least once, then checks condition.

```dart
do {
  printLine();
} while (!atEndOfPage());
```

---

## Break and Continue

### Break

Exit the loop entirely.

```dart
while (true) {
  if (shutDownRequested()) break;
  processIncomingRequests();
}
```

### Continue

Skip to the next iteration.

```dart
for (var i = 0; i < candidates.length; i++) {
  var candidate = candidates[i];
  if (candidate.yearsExperience < 5) continue;
  candidate.interview();
}
```

### Using Labels

Jump to a specific outer loop.

```dart
outerLoop:
for (var i = 0; i < 3; i++) {
  for (var j = 0; j < 3; j++) {
    if (i == 1 && j == 1) break outerLoop;
    print('$i $j');
  }
}
```

---

## Switch and Case

Dart's switch supports pattern matching (Dart 3.0+).

### Basic Switch Statement

```dart
var command = 'OPEN';
switch (command) {
  case 'OPEN':
    executeOpen();
  case 'CLOSED':
    executeClosed();
  case 'PENDING':
    executePending();
  default:
    executeUnknown();
}
```

> **Note:** No `break` needed - Dart doesn't fall through by default.

### Switch Expression

Returns a value directly.

```dart
var result = switch (command) {
  'OPEN' => 'Opening...',
  'CLOSED' => 'Closing...',
  'PENDING' => 'Waiting...',
  _ => 'Unknown command',
};
```

### Pattern Matching in Switch

```dart
switch (obj) {
  case int n when n < 0:
    print('Negative integer');
  case int n:
    print('Positive integer: $n');
  case String s:
    print('String: $s');
  case (int a, int b):
    print('Record with $a and $b');
  default:
    print('Something else');
}
```

### Guard Clauses (`when`)

```dart
switch (pair) {
  case (int a, int b) when a > b:
    print('First is larger');
  case (int a, int b):
    print('First is not larger');
}
```

### Exhaustiveness Checking

With sealed classes or enums, Dart ensures all cases are handled.

```dart
sealed class Shape {}
class Circle extends Shape {}
class Square extends Shape {}

String describe(Shape shape) => switch (shape) {
  Circle() => 'A circle',
  Square() => 'A square',
  // No default needed - compiler knows all cases covered
};
```

---

## Assert

Development-time checks that are ignored in production.

```dart
assert(text != null);
assert(number < 100);
assert(urlString.startsWith('https'), 'URL must use HTTPS');
```

- First argument: boolean condition
- Second argument (optional): error message

> Assertions only run in debug mode. They're stripped from production builds.

---

## Branches

Dart 3.0+ provides powerful branching with pattern matching.

### If-Case Expression

```dart
var pair = [1, 2];

// Destructure and bind in one step
if (pair case [int x, int y]) {
  print('Sum: ${x + y}');
}

// With guard clause
if (pair case [int x, int y] when x < y) {
  print('First is smaller');
}
```

### Switch Expression (Branching)

```dart
var message = switch (status) {
  200 => 'OK',
  400 => 'Bad Request',
  404 => 'Not Found',
  500 => 'Server Error',
  _ => 'Unknown',
};
```

### Logical-Or Patterns

Match multiple values in one case.

```dart
var result = switch (char) {
  'a' || 'e' || 'i' || 'o' || 'u' => 'vowel',
  _ => 'consonant',
};
```

---

## Error Handling

Dart uses exceptions for error handling. All exceptions are unchecked (no `throws` declaration required).

### Throwing Exceptions

```dart
throw FormatException('Invalid input');
throw 'Something went wrong';  // Can throw any object
throw ArgumentError.value(x, 'x', 'must be positive');
```

### Common Exception Types

| Exception | Use Case |
|-----------|----------|
| `Exception` | Base class for programmatic exceptions |
| `Error` | Base class for programming errors |
| `FormatException` | Invalid format/parsing errors |
| `ArgumentError` | Invalid argument values |
| `StateError` | Invalid state for operation |
| `RangeError` | Value out of valid range |
| `TypeError` | Type mismatch at runtime |

### Try-Catch

```dart
try {
  breedMoreLlamas();
} on OutOfLlamasException {
  // Specific exception type
  buyMoreLlamas();
} on Exception catch (e) {
  // Any Exception, with access to object
  print('Exception: $e');
} catch (e, stackTrace) {
  // Any object, with stack trace
  print('Error: $e');
  print('Stack: $stackTrace');
}
```

### Finally

Always executes, regardless of exception.

```dart
try {
  openFile();
  processFile();
} catch (e) {
  print('Error: $e');
} finally {
  closeFile();  // Always runs
}
```

### Rethrow

Propagate exception after partial handling.

```dart
try {
  riskyOperation();
} catch (e) {
  logError(e);
  rethrow;  // Propagate to caller
}
```

### Custom Exceptions

```dart
class AuthException implements Exception {
  final String message;
  final int code;

  AuthException(this.message, {this.code = 0});

  @override
  String toString() => 'AuthException: $message (code: $code)';
}

// Usage
throw AuthException('Invalid token', code: 401);
```

### Async Error Handling

```dart
// With async/await
try {
  var data = await fetchData();
} catch (e) {
  print('Failed to fetch: $e');
}

// With Future
fetchData()
  .then((data) => processData(data))
  .catchError((e) => print('Error: $e'));
```
