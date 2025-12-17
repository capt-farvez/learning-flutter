# Streams in Dart

Streams provide an asynchronous sequence of data events. While a `Future` represents a single async result, a `Stream` delivers multiple results over time.

---

## Theory: Streams vs Futures

| Concept | Future | Stream |
|---------|--------|--------|
| **Values** | Single value | Multiple values |
| **Completion** | Completes once | Can emit many events |
| **Use case** | HTTP request, file read | User events, WebSocket, file chunks |

```
Future<T>:     ──────────●  (one value)

Stream<T>:     ──●──●──●──●──●──|  (many values, then done)
```

---

## Receiving Stream Events

### await for Loop

The most common way to consume a stream:

```dart
Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  await for (final value in stream) {
    sum += value;
  }
  return sum;
}
```

### Error Handling with await for

```dart
Future<void> processStream(Stream<int> stream) async {
  try {
    await for (final value in stream) {
      print('Value: $value');
    }
    print('Stream completed');
  } catch (e) {
    print('Error: $e');
  }
}
```

---

## Two Kinds of Streams

### Single Subscription Streams

- Can only be listened to **once**
- Events delivered in order
- Used for: file reading, HTTP responses

```dart
// File reading - single subscription
Stream<List<int>> fileStream = File('data.txt').openRead();

// Can only listen once
fileStream.listen((bytes) => print('Got ${bytes.length} bytes'));

// ERROR: Already listened to!
// fileStream.listen((bytes) => ...);
```

### Broadcast Streams

- Can have **multiple listeners**
- Listeners get events fired while listening
- Used for: UI events, notifications

```dart
// Create broadcast stream
final controller = StreamController<int>.broadcast();

// Multiple listeners allowed
controller.stream.listen((n) => print('Listener 1: $n'));
controller.stream.listen((n) => print('Listener 2: $n'));

controller.add(1);  // Both listeners receive this
controller.add(2);
```

### Converting Single to Broadcast

```dart
Stream<int> singleStream = getDataStream();
Stream<int> broadcastStream = singleStream.asBroadcastStream();
```

---

## Creating Streams

### async* Generator Function

The simplest way to create a stream:

```dart
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;  // Emit value to stream
  }
}

// Usage
await for (final n in countStream(5)) {
  print(n);  // Prints 1, 2, 3, 4, 5 (one per second)
}
```

### yield* for Nested Streams

```dart
Stream<int> countUp(int max) async* {
  for (int i = 1; i <= max; i++) {
    yield i;
  }
}

Stream<int> countUpAndDown(int max) async* {
  yield* countUp(max);           // Yield all events from another stream
  yield* countUp(max).map((n) => max - n);
}
```

### Stream Constructors

```dart
// From iterable
Stream<int> fromList = Stream.fromIterable([1, 2, 3, 4, 5]);

// From future
Stream<String> fromFuture = Stream.fromFuture(fetchData());

// From futures
Stream<String> fromFutures = Stream.fromFutures([
  fetchA(),
  fetchB(),
  fetchC(),
]);

// Periodic events
Stream<int> periodic = Stream.periodic(
  Duration(seconds: 1),
  (count) => count,  // Transform function
).take(10);  // Stop after 10 events

// Empty stream
Stream<int> empty = Stream.empty();

// Single error
Stream<int> error = Stream.error('Something went wrong');

// Single value
Stream<int> value = Stream.value(42);
```

---

## StreamController

For complex streams with multiple event sources:

```dart
StreamController<int> controller = StreamController<int>();

// Add events from anywhere
controller.add(1);
controller.add(2);
controller.addError('Oops');
controller.add(3);

// Close when done
controller.close();

// Get the stream
Stream<int> stream = controller.stream;
```

### StreamController with Callbacks

```dart
Stream<int> timedCounter(Duration interval, int maxCount) {
  late StreamController<int> controller;
  Timer? timer;
  int counter = 0;

  void tick(_) {
    counter++;
    controller.add(counter);
    if (counter >= maxCount) {
      timer?.cancel();
      controller.close();
    }
  }

  void startTimer() {
    timer = Timer.periodic(interval, tick);
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  controller = StreamController<int>(
    onListen: startTimer,    // Called when first listener subscribes
    onPause: stopTimer,      // Called when listener pauses
    onResume: startTimer,    // Called when listener resumes
    onCancel: stopTimer,     // Called when last listener cancels
  );

  return controller.stream;
}
```

### Broadcast StreamController

```dart
final controller = StreamController<String>.broadcast();

// Multiple listeners OK
controller.stream.listen((msg) => print('A: $msg'));
controller.stream.listen((msg) => print('B: $msg'));

controller.add('Hello');  // Both A and B receive this
```

---

## Stream Methods

### Methods That Return Futures

```dart
Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

// Single values
int first = await numbers.first;
int last = await numbers.last;
int single = await numbers.single;  // Error if not exactly one
int length = await numbers.length;
bool isEmpty = await numbers.isEmpty;

// Finding
int? found = await numbers.firstWhere((n) => n > 3);
int? lastFound = await numbers.lastWhere((n) => n < 3);
bool hasEven = await numbers.any((n) => n.isEven);
bool allPositive = await numbers.every((n) => n > 0);
bool contains3 = await numbers.contains(3);

// Aggregation
int sum = await numbers.reduce((a, b) => a + b);
int product = await numbers.fold(1, (a, b) => a * b);
List<int> list = await numbers.toList();
Set<int> set = await numbers.toSet();
String joined = await numbers.join(', ');
```

### Methods That Return Streams (Transformations)

```dart
Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

// Filtering
Stream<int> evens = numbers.where((n) => n.isEven);
Stream<int> firstThree = numbers.take(3);
Stream<int> afterTwo = numbers.skip(2);
Stream<int> untilThree = numbers.takeWhile((n) => n < 4);
Stream<int> afterOdd = numbers.skipWhile((n) => n.isOdd);
Stream<int> unique = numbers.distinct();

// Mapping
Stream<String> strings = numbers.map((n) => 'Number: $n');
Stream<int> doubled = numbers.expand((n) => [n, n]);

// Async transformations
Stream<Data> data = ids.asyncMap((id) => fetchData(id));
Stream<List<Item>> items = ids.asyncExpand((id) => getItemsStream(id));

// Type casting
Stream<num> nums = numbers.cast<num>();
```

---

## Error Handling

### handleError

```dart
Stream<int> stream = getDataStream();

Stream<int> safeStream = stream.handleError(
  (error) => print('Handled: $error'),
  test: (error) => error is FormatException,  // Optional filter
);
```

### Error Recovery Pattern

```dart
Stream<int> resilientStream(Stream<int> source) async* {
  await for (final value in source.handleError((e) => log(e))) {
    yield value;
  }
}
```

### Timeout

```dart
Stream<int> withTimeout = stream.timeout(
  Duration(seconds: 5),
  onTimeout: (sink) {
    sink.addError('Timed out');
    sink.close();
  },
);
```

---

## Stream Transformers

### Using transform()

```dart
import 'dart:convert';
import 'dart:io';

void main() async {
  Stream<List<int>> fileBytes = File('data.txt').openRead();

  // Chain transformers
  Stream<String> lines = fileBytes
      .transform(utf8.decoder)
      .transform(LineSplitter());

  await for (final line in lines) {
    print(line);
  }
}
```

### Custom StreamTransformer

```dart
class DoubleTransformer extends StreamTransformerBase<int, int> {
  @override
  Stream<int> bind(Stream<int> stream) async* {
    await for (final value in stream) {
      yield value * 2;
    }
  }
}

// Usage
Stream<int> doubled = numbers.transform(DoubleTransformer());
```

---

## The listen() Method

Low-level stream subscription:

```dart
StreamSubscription<int> subscription = stream.listen(
  (data) => print('Data: $data'),      // onData
  onError: (error) => print('Error: $error'),
  onDone: () => print('Done'),
  cancelOnError: false,  // Continue after errors
);

// Control subscription
subscription.pause();
subscription.resume();
await subscription.cancel();
```

### StreamSubscription Control

```dart
late StreamSubscription<int> subscription;

subscription = stream.listen((value) {
  print(value);

  if (value == 5) {
    subscription.pause();  // Pause for a bit

    Future.delayed(Duration(seconds: 2), () {
      subscription.resume();
    });
  }

  if (value == 10) {
    subscription.cancel();  // Stop listening
  }
});
```

---

## StreamBuilder (Flutter)

Display stream data in UI:

```dart
StreamBuilder<int>(
  stream: counterStream,
  initialData: 0,
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('No stream');
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return Text('Count: ${snapshot.data}');
      case ConnectionState.done:
        return Text('Stream closed');
    }
  },
)
```

---

## Common Patterns

### Debounce Pattern

```dart
Stream<String> debounce(
  Stream<String> source,
  Duration duration,
) async* {
  Timer? timer;
  String? lastValue;

  await for (final value in source) {
    lastValue = value;
    timer?.cancel();
    timer = Timer(duration, () {});

    // Wait for timer
    await Future.delayed(duration);
    if (lastValue == value) {
      yield value;
    }
  }
}
```

### Throttle Pattern

```dart
Stream<T> throttle<T>(
  Stream<T> source,
  Duration duration,
) async* {
  DateTime? lastEmit;

  await for (final value in source) {
    final now = DateTime.now();
    if (lastEmit == null ||
        now.difference(lastEmit!) >= duration) {
      lastEmit = now;
      yield value;
    }
  }
}
```

### Merge Streams

```dart
Stream<T> merge<T>(List<Stream<T>> streams) {
  final controller = StreamController<T>();
  int activeStreams = streams.length;

  for (final stream in streams) {
    stream.listen(
      controller.add,
      onError: controller.addError,
      onDone: () {
        activeStreams--;
        if (activeStreams == 0) {
          controller.close();
        }
      },
    );
  }

  return controller.stream;
}
```

### Buffer Pattern

```dart
Stream<List<T>> buffer<T>(
  Stream<T> source,
  int size,
) async* {
  var buffer = <T>[];

  await for (final value in source) {
    buffer.add(value);
    if (buffer.length >= size) {
      yield buffer;
      buffer = [];
    }
  }

  if (buffer.isNotEmpty) {
    yield buffer;
  }
}
```

---

## Best Practices

### 1. Always Cancel Subscriptions

```dart
class MyWidget extends StatefulWidget { ... }

class _MyWidgetState extends State<MyWidget> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = stream.listen(handleData);
  }

  @override
  void dispose() {
    _subscription?.cancel();  // Always cancel!
    super.dispose();
  }
}
```

### 2. Close Controllers

```dart
class DataService {
  final _controller = StreamController<Data>.broadcast();

  Stream<Data> get stream => _controller.stream;

  void dispose() {
    _controller.close();  // Always close!
  }
}
```

### 3. Handle Errors

```dart
// Bad - errors crash the app
stream.listen((data) => process(data));

// Good - errors handled
stream.listen(
  (data) => process(data),
  onError: (error) => handleError(error),
);
```

### 4. Use Broadcast Streams for Multiple Listeners

```dart
// Bad - will throw if listened twice
final stream = getSingleStream();

// Good - explicitly support multiple listeners
final stream = getSingleStream().asBroadcastStream();
```

---

## Summary

| Concept | Description |
|---------|-------------|
| `Stream<T>` | Async sequence of `T` values |
| `await for` | Iterate over stream events |
| `async*` / `yield` | Create streams with generator |
| `StreamController` | Manual stream control |
| `listen()` | Subscribe to stream events |
| `map()`, `where()`, `take()` | Transform streams |
| `transform()` | Apply StreamTransformer |
| `StreamBuilder` | Display stream in Flutter UI |
| Single subscription | One listener, ordered events |
| Broadcast | Multiple listeners |
