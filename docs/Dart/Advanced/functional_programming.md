# Functional Programming in Dart

Dart treats functions as first-class objects. They can be assigned to variables, passed as arguments, and returned from other functions.

---

## Theory: First-Class Functions

In Dart, functions are objects of type `Function`. This enables:

- **Assigning** functions to variables
- **Passing** functions as arguments
- **Returning** functions from other functions
- **Storing** functions in collections

```dart
// Function assigned to variable
var greet = (String name) => 'Hello, $name!';

// Function passed as argument
list.forEach(print);

// Function returned from function
Function makeMultiplier(int n) => (int x) => x * n;
```

---

## Function Syntax

### Standard Function

```dart
int add(int a, int b) {
  return a + b;
}
```

### Arrow Syntax

For single-expression functions:

```dart
int add(int a, int b) => a + b;

String greet(String name) => 'Hello, $name!';

void logMessage(String msg) => print('[LOG] $msg');
```

### Function Types

```dart
// Explicit function type
int Function(int, int) operation = add;

// With named parameters
void Function(String, {String? prefix}) logger;

// Typedef for reusability
typedef IntOperation = int Function(int, int);
IntOperation multiply = (a, b) => a * b;
```

---

## Parameters

### Required Positional Parameters

```dart
String greet(String name, String greeting) {
  return '$greeting, $name!';
}

greet('Alice', 'Hello');  // "Hello, Alice!"
```

### Optional Positional Parameters

Wrapped in `[]`:

```dart
String greet(String name, [String greeting = 'Hello']) {
  return '$greeting, $name!';
}

greet('Alice');           // "Hello, Alice!"
greet('Alice', 'Hi');     // "Hi, Alice!"
```

### Named Parameters

Wrapped in `{}`:

```dart
String greet({required String name, String greeting = 'Hello'}) {
  return '$greeting, $name!';
}

greet(name: 'Alice');                    // "Hello, Alice!"
greet(name: 'Alice', greeting: 'Hi');    // "Hi, Alice!"
```

### Mixed Parameters

```dart
void configure(
  String host,                    // Required positional
  int port, [                     // Required positional
  String? path,                   // Optional positional
  int timeout = 30,               // Optional positional with default
]) { ... }

// Or with named parameters
void configure(
  String host,
  int port, {
  String? path,
  int timeout = 30,
}) { ... }
```

---

## Anonymous Functions (Lambdas)

Functions without names:

```dart
// Full syntax
var multiply = (int a, int b) {
  return a * b;
};

// Arrow syntax
var multiply = (int a, int b) => a * b;

// As callback
list.map((item) => item.toUpperCase());
list.where((item) => item.length > 3);
list.forEach((item) { print(item); });
```

### Type Inference

```dart
// Types inferred from context
var numbers = [1, 2, 3];
var doubled = numbers.map((n) => n * 2);  // n is inferred as int
```

---

## Lexical Scope

Variables are accessible based on code structure:

```dart
var topLevel = 'top';

void main() {
  var mainLevel = 'main';

  void nested() {
    var nestedLevel = 'nested';

    // Can access all outer scopes
    print(topLevel);     // OK
    print(mainLevel);    // OK
    print(nestedLevel);  // OK
  }

  // Cannot access inner scope
  // print(nestedLevel);  // Error!
}
```

---

## Closures

Functions that capture variables from their surrounding scope:

```dart
Function makeCounter() {
  int count = 0;  // Captured by closure
  return () {
    count++;
    return count;
  };
}

void main() {
  var counter = makeCounter();
  print(counter());  // 1
  print(counter());  // 2
  print(counter());  // 3

  // Each call creates new closure with own state
  var counter2 = makeCounter();
  print(counter2());  // 1
}
```

### Practical Closure Example

```dart
// Factory function using closure
Function makeAdder(int addBy) {
  return (int i) => addBy + i;
}

var add5 = makeAdder(5);
var add10 = makeAdder(10);

print(add5(3));   // 8
print(add10(3));  // 13
```

### Closure in Callbacks

```dart
void fetchData(String url, void Function(String) onComplete) {
  // Simulated async fetch
  Future.delayed(Duration(seconds: 1), () {
    onComplete('Data from $url');
  });
}

void main() {
  var results = <String>[];  // Captured by closure

  fetchData('api/users', (data) {
    results.add(data);  // Closure accesses outer variable
    print('Got: $data');
  });
}
```

---

## Tear-offs

Reference to a function without calling it:

```dart
// Instead of lambda wrapper
var codes = [68, 97, 114, 116];

// Bad - unnecessary lambda
codes.forEach((code) => print(code));

// Good - tear-off
codes.forEach(print);
```

### Method Tear-offs

```dart
class Logger {
  void log(String msg) => print('[LOG] $msg');
}

var logger = Logger();

// Method tear-off
var messages = ['Hello', 'World'];
messages.forEach(logger.log);
```

### Static Method Tear-offs

```dart
class StringUtils {
  static String capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

var words = ['hello', 'world'];
var capitalized = words.map(StringUtils.capitalize).toList();
```

### Constructor Tear-offs

```dart
class Point {
  final int x, y;
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;
}

// Constructor tear-off
var coords = [(1, 2), (3, 4), (5, 6)];
var points = coords.map((c) => Point(c.$1, c.$2)).toList();

// Named constructor tear-off
var makeOrigin = Point.origin;
var origin = makeOrigin();
```

---

## Higher-Order Functions

Functions that take or return other functions.

### Functions as Parameters

```dart
// Function that takes a function
void repeat(int times, void Function(int) action) {
  for (var i = 0; i < times; i++) {
    action(i);
  }
}

repeat(3, (i) => print('Iteration $i'));
// Iteration 0
// Iteration 1
// Iteration 2
```

### Functions Returning Functions

```dart
// Function that returns a function
Comparator<String> makeComparator({bool descending = false}) {
  if (descending) {
    return (a, b) => b.compareTo(a);
  }
  return (a, b) => a.compareTo(b);
}

var names = ['Charlie', 'Alice', 'Bob'];
names.sort(makeComparator());                    // [Alice, Bob, Charlie]
names.sort(makeComparator(descending: true));    // [Charlie, Bob, Alice]
```

---

## Common Higher-Order Methods

### map - Transform Elements

```dart
var numbers = [1, 2, 3, 4, 5];

var doubled = numbers.map((n) => n * 2).toList();
// [2, 4, 6, 8, 10]

var strings = numbers.map((n) => 'Number: $n').toList();
// ['Number: 1', 'Number: 2', ...]
```

### where - Filter Elements

```dart
var numbers = [1, 2, 3, 4, 5, 6];

var evens = numbers.where((n) => n.isEven).toList();
// [2, 4, 6]

var greaterThan3 = numbers.where((n) => n > 3).toList();
// [4, 5, 6]
```

### reduce - Combine Elements

```dart
var numbers = [1, 2, 3, 4, 5];

var sum = numbers.reduce((a, b) => a + b);
// 15

var max = numbers.reduce((a, b) => a > b ? a : b);
// 5
```

### fold - Reduce with Initial Value

```dart
var numbers = [1, 2, 3, 4, 5];

var sum = numbers.fold(0, (acc, n) => acc + n);
// 15

var product = numbers.fold(1, (acc, n) => acc * n);
// 120

// Different return type
var concatenated = numbers.fold('', (acc, n) => '$acc$n');
// '12345'
```

### expand - Flatten Results

```dart
var nested = [[1, 2], [3, 4], [5, 6]];

var flat = nested.expand((list) => list).toList();
// [1, 2, 3, 4, 5, 6]

var numbers = [1, 2, 3];
var duplicated = numbers.expand((n) => [n, n]).toList();
// [1, 1, 2, 2, 3, 3]
```

### Chaining Methods

```dart
var words = ['Hello', 'World', 'Dart', 'Flutter', 'Code'];

var result = words
    .where((w) => w.length > 4)
    .map((w) => w.toUpperCase())
    .toList();
// ['HELLO', 'WORLD', 'FLUTTER']
```

---

## Generators

### Synchronous Generator (sync*)

Returns an `Iterable`:

```dart
Iterable<int> range(int start, int end) sync* {
  for (var i = start; i <= end; i++) {
    yield i;
  }
}

for (var n in range(1, 5)) {
  print(n);  // 1, 2, 3, 4, 5
}
```

### Asynchronous Generator (async*)

Returns a `Stream`:

```dart
Stream<int> countDown(int from) async* {
  for (var i = from; i >= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

await for (var n in countDown(5)) {
  print(n);  // 5, 4, 3, 2, 1, 0
}
```

### yield* for Delegation

```dart
Iterable<int> countUpAndDown(int n) sync* {
  yield* range(1, n);        // Delegate to another generator
  yield* range(n - 1, 1);    // Then to another
}

// 1, 2, 3, 4, 5, 4, 3, 2, 1
```

---

## Getters and Setters

Computed properties using function-like syntax:

```dart
class Circle {
  double radius;

  Circle(this.radius);

  // Getter
  double get area => 3.14159 * radius * radius;

  // Getter and setter
  double get diameter => radius * 2;
  set diameter(double value) => radius = value / 2;
}

var circle = Circle(5);
print(circle.area);       // 78.53975
print(circle.diameter);   // 10
circle.diameter = 20;
print(circle.radius);     // 10
```

### Top-Level Getters/Setters

```dart
String _secret = 'hidden';

String get secret => _secret.toUpperCase();

set secret(String value) {
  if (value.isNotEmpty) {
    _secret = value;
  }
}
```

---

## Function Equality

```dart
void foo() {}

class MyClass {
  static void staticMethod() {}
  void instanceMethod() {}
}

void main() {
  // Top-level functions
  var f1 = foo;
  var f2 = foo;
  print(f1 == f2);  // true

  // Static methods
  var s1 = MyClass.staticMethod;
  var s2 = MyClass.staticMethod;
  print(s1 == s2);  // true

  // Instance methods - same instance
  var obj = MyClass();
  var m1 = obj.instanceMethod;
  var m2 = obj.instanceMethod;
  print(m1 == m2);  // true

  // Instance methods - different instances
  var obj2 = MyClass();
  var m3 = obj2.instanceMethod;
  print(m1 == m3);  // false
}
```

---

## Callable Classes

Make class instances callable like functions:

```dart
class Multiplier {
  final int factor;

  Multiplier(this.factor);

  // call method makes instance callable
  int call(int value) => value * factor;
}

void main() {
  var triple = Multiplier(3);

  // Call like a function
  print(triple(5));   // 15
  print(triple(10));  // 30

  // Can be used where Function is expected
  var numbers = [1, 2, 3, 4, 5];
  var tripled = numbers.map(triple).toList();
  // [3, 6, 9, 12, 15]
}
```

---

## Best Practices

### 1. Use Tear-offs Over Lambdas

```dart
// Good
items.forEach(print);
items.map(transform).toList();

// Avoid
items.forEach((item) => print(item));
items.map((item) => transform(item)).toList();
```

### 2. Use Arrow Syntax for Simple Functions

```dart
// Good
int double(int n) => n * 2;

// Verbose for simple case
int double(int n) {
  return n * 2;
}
```

### 3. Use Named Parameters for Clarity

```dart
// Good - clear what each parameter means
createUser(name: 'Alice', age: 30, isAdmin: false);

// Less clear
createUser('Alice', 30, false);
```

### 4. Typedef Complex Function Types

```dart
// Good
typedef JsonParser = Map<String, dynamic> Function(String);
JsonParser parser = parseJson;

// Hard to read inline
Map<String, dynamic> Function(String) parser = parseJson;
```

### 5. Prefer Pure Functions

```dart
// Pure - no side effects, same input = same output
int add(int a, int b) => a + b;

// Impure - depends on external state
int counter = 0;
int increment() => ++counter;
```

---

## Summary

| Concept | Description |
|---------|-------------|
| First-class functions | Functions are objects, can be stored/passed |
| Arrow syntax `=>` | Shorthand for single-expression functions |
| Anonymous functions | Functions without names (lambdas) |
| Closures | Functions that capture surrounding scope |
| Tear-offs | Function references without calling |
| Higher-order functions | Take or return other functions |
| `sync*` / `yield` | Synchronous generator (returns Iterable) |
| `async*` / `yield` | Asynchronous generator (returns Stream) |
| `call()` method | Makes class instances callable |
