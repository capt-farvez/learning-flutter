# Collections in Dart

Dart has built-in support for three collection types: List, Set, and Map.

---

## Lists

An ordered group of objects (like arrays in other languages).

### Creating Lists

```dart
// List literal
var numbers = [1, 2, 3, 4, 5];

// Typed list
List<String> names = ['Alice', 'Bob', 'Charlie'];

// Empty list
var empty = <int>[];

// Growable list
var growable = List<int>.empty(growable: true);

// Fixed-length list filled with value
var filled = List.filled(5, 0);  // [0, 0, 0, 0, 0]

// Generated list
var generated = List.generate(5, (i) => i * 2);  // [0, 2, 4, 6, 8]
```

### Accessing Elements

```dart
var list = [1, 2, 3, 4, 5];

// By index (zero-based)
var first = list[0];      // 1
var last = list[list.length - 1];  // 5

// Properties
list.first;    // 1
list.last;     // 5
list.length;   // 5
list.isEmpty;  // false

// Safe access
list.elementAtOrNull(10);  // null (no error)
```

### Modifying Lists

```dart
var list = [1, 2, 3];

// Add elements
list.add(4);              // [1, 2, 3, 4]
list.addAll([5, 6]);      // [1, 2, 3, 4, 5, 6]
list.insert(0, 0);        // [0, 1, 2, 3, 4, 5, 6]

// Remove elements
list.remove(3);           // Removes first occurrence of 3
list.removeAt(0);         // Removes element at index
list.removeLast();        // Removes last element
list.removeWhere((n) => n.isEven);  // Remove all even numbers
list.clear();             // Remove all

// Update elements
list[0] = 10;
list.replaceRange(1, 3, [20, 30]);
```

### Const Lists

```dart
// Compile-time constant
const constantList = [1, 2, 3];
// constantList[0] = 10;  // Error!

// Unmodifiable view
var modifiable = [1, 2, 3];
var unmodifiable = List.unmodifiable(modifiable);
```

---

## Sets

An unordered collection of **unique** elements.

### Creating Sets

```dart
// Set literal
var fruits = {'apple', 'banana', 'orange'};

// Typed set
Set<int> numbers = {1, 2, 3};

// Empty set (NOT {} - that's a map!)
var empty = <String>{};
Set<String> alsoEmpty = {};

// From list (removes duplicates)
var fromList = [1, 2, 2, 3, 3, 3].toSet();  // {1, 2, 3}
```

### Set Operations

```dart
var a = {1, 2, 3, 4};
var b = {3, 4, 5, 6};

// Union (all elements from both)
a.union(b);  // {1, 2, 3, 4, 5, 6}

// Intersection (common elements)
a.intersection(b);  // {3, 4}

// Difference (in a but not in b)
a.difference(b);  // {1, 2}

// Check membership
a.contains(2);        // true
a.containsAll({1, 2});  // true
```

### Modifying Sets

```dart
var set = {1, 2, 3};

// Add elements (duplicates ignored)
set.add(4);        // {1, 2, 3, 4}
set.add(1);        // {1, 2, 3, 4} - no change
set.addAll({5, 6});

// Remove elements
set.remove(1);
set.removeWhere((n) => n.isEven);
set.clear();
```

### Const Sets

```dart
const constantSet = {'a', 'b', 'c'};
// constantSet.add('d');  // Error!
```

---

## Maps

A collection of **key-value pairs**. Keys must be unique.

### Creating Maps

```dart
// Map literal
var gifts = {
  'first': 'partridge',
  'second': 'turtledoves',
  'fifth': 'golden rings',
};

// Typed map
Map<String, int> ages = {
  'Alice': 30,
  'Bob': 25,
};

// Empty map
var empty = <String, int>{};

// Using constructor
var map = Map<String, int>();

// From entries
var fromEntries = Map.fromEntries([
  MapEntry('a', 1),
  MapEntry('b', 2),
]);

// From iterables
var keys = ['a', 'b', 'c'];
var values = [1, 2, 3];
var fromIterables = Map.fromIterables(keys, values);
```

### Accessing Map Values

```dart
var map = {'a': 1, 'b': 2, 'c': 3};

// By key
var value = map['a'];  // 1
var missing = map['z'];  // null

// Properties
map.keys;     // (a, b, c)
map.values;   // (1, 2, 3)
map.entries;  // (MapEntry(a: 1), ...)
map.length;   // 3
map.isEmpty;  // false

// Check existence
map.containsKey('a');    // true
map.containsValue(1);    // true
```

### Modifying Maps

```dart
var map = {'a': 1, 'b': 2};

// Add/update entries
map['c'] = 3;              // Add new
map['a'] = 10;             // Update existing
map.addAll({'d': 4, 'e': 5});

// Conditional add
map.putIfAbsent('f', () => 6);  // Adds if key missing

// Update with function
map.update('a', (v) => v * 2);  // Doubles value of 'a'
map.update('z', (v) => v, ifAbsent: () => 0);  // With default

// Remove entries
map.remove('a');
map.removeWhere((k, v) => v > 3);
map.clear();
```

### Const Maps

```dart
const constantMap = {'a': 1, 'b': 2};
// constantMap['c'] = 3;  // Error!
```

---

## Collection Elements

Dart supports powerful collection literal syntax for building collections.

### Expression Elements

Basic elements that evaluate to values:

```dart
var x = 10;
var list = [1, x, x + 5, getValue()];  // [1, 10, 15, ...]
```

### Null-aware Elements (Dart 3.8+)

Insert value only if not null using `?`:

```dart
int? a = null;
int? b = 3;

var items = [1, ?a, ?b, 5];  // [1, 3, 5]  - null is skipped
```

With maps:

```dart
String? key = null;
int? value = 3;

var map1 = {?key: value};      // {} - key is null, entry skipped
var map2 = {'a': ?value};      // {} - value is null, entry skipped
var map3 = {?key: ?value};     // {} - both null checks
```

### Spread Elements

Insert all elements from another collection using `...`:

```dart
var inner = [2, 3, 4];
var outer = [1, ...inner, 5];  // [1, 2, 3, 4, 5]

// Works with sets too
var set1 = {1, 2};
var set2 = {3, 4};
var combined = {...set1, ...set2};  // {1, 2, 3, 4}

// And maps
var map1 = {'a': 1};
var map2 = {'b': 2};
var combined = {...map1, ...map2};  // {a: 1, b: 2}
```

### Null-aware Spread Elements

Spread only if collection is not null using `...?`:

```dart
List<int>? maybeList = null;
var list = [1, ...?maybeList, 2];  // [1, 2]

List<int>? hasValues = [3, 4];
var list2 = [1, ...?hasValues, 5];  // [1, 3, 4, 5]
```

---

## Control Flow in Collections

### If Elements

Conditionally include elements:

```dart
var includeItem = true;
var list = [
  1,
  if (includeItem) 2,
  3,
];  // [1, 2, 3]

// With else
var isAdmin = false;
var menu = [
  'Home',
  'Profile',
  if (isAdmin) 'Admin Panel' else 'Request Access',
];
```

### If-case Elements

Pattern matching in collections:

```dart
Object data = 123;
var info = [
  if (data case int n) 'Integer: $n',
  if (data case String s) 'String: $s',
];  // [Integer: 123]

var order = ['Apple', 12, 'pending'];
var summary = [
  'Product: ${order[0]}',
  if (order case [_, int qty, _]) 'Quantity: $qty',
  if (order case [_, _, 'pending']) 'Status: Pending',
];
```

### For Elements

Generate elements with loops:

```dart
var squares = [
  for (var i = 1; i <= 5; i++) i * i,
];  // [1, 4, 9, 16, 25]

var numbers = [1, 2, 3];
var doubled = [
  for (var n in numbers) n * 2,
];  // [2, 4, 6]

// In maps
var map = {
  for (var i = 0; i < 3; i++) 'key$i': i,
};  // {key0: 0, key1: 1, key2: 2}
```

### Nested Control Flow

Combine control flow elements:

```dart
var numbers = [1, 2, 3, 4, 5, 6];
var evenSquares = [
  for (var n in numbers)
    if (n.isEven) n * n,
];  // [4, 16, 36]

// With spreads
var condition = true;
var items = [
  if (condition) ...[1, 2, 3],
  if (!condition) ...[4, 5, 6],
];  // [1, 2, 3]
```

---

## Common Operations

### Iteration

```dart
var list = [1, 2, 3];

// forEach
list.forEach((item) => print(item));

// for-in
for (var item in list) {
  print(item);
}

// indexed iteration
for (var i = 0; i < list.length; i++) {
  print('$i: ${list[i]}');
}

// with index using indexed property
for (var (index, value) in list.indexed) {
  print('$index: $value');
}
```

### Transformation

```dart
var numbers = [1, 2, 3, 4, 5];

// map - transform each element
var doubled = numbers.map((n) => n * 2).toList();  // [2, 4, 6, 8, 10]

// where - filter elements
var evens = numbers.where((n) => n.isEven).toList();  // [2, 4]

// expand - flatten nested results
var expanded = numbers.expand((n) => [n, n]).toList();  // [1, 1, 2, 2, ...]

// reduce - combine into single value
var sum = numbers.reduce((a, b) => a + b);  // 15

// fold - reduce with initial value
var product = numbers.fold(1, (a, b) => a * b);  // 120
```

### Searching

```dart
var list = [1, 2, 3, 4, 5];

// Find elements
list.firstWhere((n) => n > 3);  // 4
list.lastWhere((n) => n < 4);   // 3
list.singleWhere((n) => n == 3);  // 3 (throws if not exactly one)

// With orElse
list.firstWhere((n) => n > 10, orElse: () => -1);  // -1

// Check conditions
list.any((n) => n > 3);    // true (at least one matches)
list.every((n) => n > 0);  // true (all match)
list.contains(3);          // true

// Index finding
list.indexOf(3);           // 2
list.indexWhere((n) => n > 3);  // 3
```

### Sorting

```dart
var numbers = [3, 1, 4, 1, 5, 9, 2, 6];

// Sort in place
numbers.sort();  // [1, 1, 2, 3, 4, 5, 6, 9]

// Custom comparator
numbers.sort((a, b) => b.compareTo(a));  // Descending

// Objects
var people = [Person('Bob', 30), Person('Alice', 25)];
people.sort((a, b) => a.name.compareTo(b.name));
```

### Slicing

```dart
var list = [0, 1, 2, 3, 4, 5];

list.take(3).toList();      // [0, 1, 2]
list.skip(3).toList();      // [3, 4, 5]
list.sublist(1, 4);         // [1, 2, 3]
list.getRange(1, 4).toList();  // [1, 2, 3]

list.takeWhile((n) => n < 3).toList();  // [0, 1, 2]
list.skipWhile((n) => n < 3).toList();  // [3, 4, 5]
```

---

## Type Conversions

```dart
// List to Set (removes duplicates)
var list = [1, 2, 2, 3, 3, 3];
var set = list.toSet();  // {1, 2, 3}

// Set to List
var backToList = set.toList();

// Map to entries
var map = {'a': 1, 'b': 2};
var entries = map.entries.toList();

// Entries to Map
var backToMap = Map.fromEntries(entries);

// List of pairs to Map
var pairs = [['a', 1], ['b', 2]];
var map = Map.fromEntries(
  pairs.map((p) => MapEntry(p[0] as String, p[1] as int)),
);
```

---

## Best Practices

### 1. Use Collection Literals

```dart
// Good
var list = <int>[];
var set = <String>{};
var map = <String, int>{};

// Avoid
var list = List<int>();
var set = Set<String>();
var map = Map<String, int>();
```

### 2. Prefer const Collections

```dart
// Good - compile-time constant
const defaultOptions = ['a', 'b', 'c'];

// When const not possible, use final
final options = getOptions();
```

### 3. Use Spread for Combining

```dart
// Good
var combined = [...list1, ...list2];

// Avoid
var combined = List.from(list1)..addAll(list2);
```

### 4. Use Collection If/For

```dart
// Good
var items = [
  'always',
  if (condition) 'sometimes',
  for (var i in range) 'item$i',
];

// Avoid
var items = ['always'];
if (condition) items.add('sometimes');
for (var i in range) items.add('item$i');
```

### 5. Trailing Commas

```dart
// Good - easier to edit and better diffs
var list = [
  'first',
  'second',
  'third',
];
```

---

## Summary

| Collection | Description | Duplicates | Ordered |
|------------|-------------|------------|---------|
| `List<T>` | Indexed sequence | Yes | Yes |
| `Set<T>` | Unique elements | No | No* |
| `Map<K,V>` | Key-value pairs | Keys: No, Values: Yes | No* |

*LinkedHashSet and LinkedHashMap maintain insertion order

| Syntax | Purpose |
|--------|---------|
| `?element` | Null-aware element (skip if null) |
| `...list` | Spread (insert all elements) |
| `...?list` | Null-aware spread |
| `if (cond) el` | Conditional element |
| `for (x in y) el` | Generated elements |
