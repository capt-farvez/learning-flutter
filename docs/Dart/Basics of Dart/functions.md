# Functions

Functions are first-class objects in Dart with type `Function`. They can be assigned to variables, passed as arguments, and returned from other functions.

```dart
// Standard function
bool isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}

// Arrow syntax (single expression)
bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

> **Note:** Arrow syntax `=>` is shorthand for `{ return expr; }`. Only expressions allowed, not statements.

---

## Parameters

### Named Parameters

Use `{}` to define. Optional by default unless marked `required`.

```dart
// Definition (nullable without default)
void enableFlags({bool? bold, bool? hidden}) { }

// With defaults
void enableFlags({bool bold = false, bool hidden = false}) { }

// Required parameter
void createWidget({required Widget child}) { }

// Calling
enableFlags(bold: true, hidden: false);
```

### Optional Positional Parameters

Use `[]` to define. Must be last in parameter list.

```dart
String say(String from, String msg, [String? device]) {
  var result = '$from says $msg';
  if (device != null) {
    result = '$result with a $device';
  }
  return result;
}

// With default
String say(String from, String msg, [String device = 'carrier pigeon']) { }

// Calling
say('Bob', 'Howdy');                    // Without optional
say('Bob', 'Howdy', 'smoke signal');    // With optional
```

---

## The main() Function

Entry point for every Dart app. Returns `void`, optional `List<String>` for arguments.

```dart
void main() {
  print('Hello, World!');
}

// With command-line arguments
void main(List<String> arguments) {
  print(arguments);
}
```

---

## Functions as First-Class Objects

```dart
// Pass function as parameter
void printElement(int element) => print(element);
list.forEach(printElement);

// Assign to variable
var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
print(loudify('hello'));  // !!! HELLO !!!
```

### Function Types

```dart
void greet(String name, {String greeting = 'Hello'}) =>
    print('$greeting $name!');

// Typed function variable
void Function(String, {String greeting}) g = greet;
g('Dash', greeting: 'Howdy');
```

---

## Anonymous Functions (Lambdas)

```dart
// Block body
var uppercaseList = list.map((item) {
  return item.toUpperCase();
}).toList();

// Arrow syntax
var uppercaseList = list.map((item) => item.toUpperCase()).toList();
```

---

## Lexical Scope & Closures

Variables are scoped by curly braces. Functions can "close over" variables from surrounding scopes.

```dart
Function makeAdder(int addBy) {
  return (int i) => addBy + i;  // Captures addBy
}

var add2 = makeAdder(2);
var add4 = makeAdder(4);

print(add2(3));  // 5
print(add4(3));  // 7
```

---

## Tear-offs

Reference a function without calling it (no parentheses). Preferred over wrapping in a lambda.

```dart
// Good - tear-offs
charCodes.forEach(print);
charCodes.forEach(buffer.write);

// Bad - unnecessary lambdas
charCodes.forEach((code) { print(code); });
charCodes.forEach((code) { buffer.write(code); });
```

---

## Return Values

All functions return a value. Without explicit return, `null` is returned.

```dart
foo() {}
assert(foo() == null);

// Return multiple values with records
(String, int) foo() {
  return ('something', 42);
}
```

---

## Getters and Setters

Define computed properties with `get` and `set` keywords.

```dart
String _secret = 'Hello';

// Getter
String get secret => _secret.toUpperCase();

// Setter
set secret(String value) {
  if (value.isNotEmpty) _secret = value;
}

// Usage
print(secret);          // Calls getter
secret = 'New value';   // Calls setter
```

---

## Generators

Lazily produce sequences of values.

### Synchronous Generator (`sync*`)

Returns `Iterable`.

```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}
```

### Asynchronous Generator (`async*`)

Returns `Stream`.

```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) yield k++;
}
```

### Recursive Generator (`yield*`)

```dart
Iterable<int> naturalsDownFrom(int n) sync* {
  if (n > 0) {
    yield n;
    yield* naturalsDownFrom(n - 1);  // Delegates to recursive call
  }
}
```

---

## External Functions

Body implemented separately (often in another language for interop).

```dart
external void someFunc(int i);
```

Used for C/JavaScript interoperability. Can be functions, methods, getters, setters, or constructors.
