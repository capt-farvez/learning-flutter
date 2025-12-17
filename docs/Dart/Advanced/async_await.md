# Asynchronous Programming: Futures, async, await

Dart uses `Future` objects and `async`/`await` keywords for asynchronous programming.

---

## Theory: Why Asynchronous Code?

### The Problem with Synchronous Code

Synchronous operations block execution until they complete. For long-running tasks like:
- Fetching data over a network
- Writing to a database
- Reading files from disk

...blocking would freeze your entire application.

### The Solution: Futures

A `Future` represents a value that will be available *sometime in the future*. Instead of waiting, you get a promise of a result and continue executing other code.

```
Synchronous:           Asynchronous:
┌─────────────┐        ┌─────────────┐
│ Request     │        │ Request     │──┐
├─────────────┤        ├─────────────┤  │ (continues)
│ WAITING...  │        │ Other work  │  │
│ WAITING...  │        │ Other work  │  │
│ WAITING...  │        │ Other work  │  │
├─────────────┤        ├─────────────┤  │
│ Response    │        │ Response ◄──┘  │
└─────────────┘        └─────────────┘
```

---

## What is a Future?

A `Future<T>` is an object representing an asynchronous operation that will eventually produce a value of type `T` (or an error).

### Future States

| State | Description |
|-------|-------------|
| **Uncompleted** | Operation is still running |
| **Completed with value** | Operation succeeded, result available |
| **Completed with error** | Operation failed |

### Basic Future Types

```dart
Future<String>  // Will produce a String
Future<int>     // Will produce an int
Future<List<User>>  // Will produce a List<User>
Future<void>    // Completes but produces no value
```

---

## Creating Futures

### Future.delayed

Completes after a delay:

```dart
Future<String> fetchData() {
  return Future.delayed(
    Duration(seconds: 2),
    () => 'Data loaded',
  );
}
```

### Future.value

Immediately completes with a value:

```dart
Future<int> getCachedValue() {
  return Future.value(42);
}
```

### Future.error

Immediately completes with an error:

```dart
Future<String> failingOperation() {
  return Future.error('Something went wrong');
}
```

### Completer

For manual control over completion:

```dart
Future<String> manualFuture() {
  final completer = Completer<String>();

  // Some async work...
  Timer(Duration(seconds: 1), () {
    completer.complete('Done!');
    // Or: completer.completeError('Failed');
  });

  return completer.future;
}
```

---

## async and await

The `async` and `await` keywords make asynchronous code look synchronous.

### Basic Syntax

```dart
// Mark function as async
Future<String> fetchUserOrder() async {
  // await pauses until Future completes
  var order = await getOrderFromDatabase();
  return 'Your order: $order';
}
```

### Rules

1. `await` can only be used inside `async` functions
2. `async` functions always return a `Future`
3. Code after `await` runs after the Future completes

### Without async/await vs With async/await

```dart
// Without async/await (callback style)
void processOrder() {
  fetchUserOrder().then((order) {
    validateOrder(order).then((isValid) {
      if (isValid) {
        submitOrder(order).then((result) {
          print('Order submitted: $result');
        });
      }
    });
  });
}

// With async/await (clean and readable)
Future<void> processOrder() async {
  var order = await fetchUserOrder();
  var isValid = await validateOrder(order);
  if (isValid) {
    var result = await submitOrder(order);
    print('Order submitted: $result');
  }
}
```

---

## Execution Flow

### Synchronous Until First await

Code runs synchronously until the first `await`:

```dart
Future<void> printOrderMessage() async {
  print('1. Before await');           // Runs immediately
  var order = await fetchUserOrder(); // Pauses here
  print('2. After await: $order');    // Runs after Future completes
}

void main() {
  print('A. Before calling');
  printOrderMessage();
  print('B. After calling');
}

// Output:
// A. Before calling
// 1. Before await
// B. After calling        <- main() continues!
// 2. After await: Latte   <- After Future completes
```

### Key Insight

When you `await`, the function pauses but the event loop continues processing other work.

---

## Error Handling

### try-catch with async/await

```dart
Future<void> fetchData() async {
  try {
    var data = await riskyOperation();
    print('Success: $data');
  } catch (e) {
    print('Error: $e');
  } finally {
    print('Cleanup');
  }
}
```

### Catching Specific Errors

```dart
Future<void> fetchUser() async {
  try {
    var user = await getUserFromApi();
    print('User: ${user.name}');
  } on NetworkException catch (e) {
    print('Network error: ${e.message}');
  } on FormatException catch (e) {
    print('Data format error: $e');
  } catch (e) {
    print('Unknown error: $e');
  }
}
```

### Error Propagation

Unhandled errors propagate up:

```dart
Future<String> innerFunction() async {
  throw Exception('Inner error');
}

Future<void> outerFunction() async {
  try {
    await innerFunction();  // Error propagates here
  } catch (e) {
    print('Caught: $e');
  }
}
```

---

## Working with Multiple Futures

### Sequential Execution

```dart
Future<void> sequential() async {
  var a = await fetchA();  // Wait for A
  var b = await fetchB();  // Then wait for B
  var c = await fetchC();  // Then wait for C
  print('$a, $b, $c');
}
// Total time: A + B + C
```

### Parallel Execution with Future.wait

```dart
Future<void> parallel() async {
  var results = await Future.wait([
    fetchA(),
    fetchB(),
    fetchC(),
  ]);
  print('${results[0]}, ${results[1]}, ${results[2]}');
}
// Total time: max(A, B, C)
```

### Future.wait with Error Handling

```dart
Future<void> parallelWithErrors() async {
  try {
    var results = await Future.wait(
      [fetchA(), fetchB(), fetchC()],
      eagerError: true,  // Fail fast on first error
    );
    print(results);
  } catch (e) {
    print('One or more failed: $e');
  }
}
```

### Future.any - First to Complete

```dart
Future<String> fastest() async {
  return await Future.any([
    fetchFromServer1(),
    fetchFromServer2(),
    fetchFromServer3(),
  ]);
  // Returns result from whichever completes first
}
```

---

## Future API (Callback Style)

While `async`/`await` is preferred, understanding the callback-based Future API is important for legacy code.

### then() and catchError()

The `then().catchError()` pattern is like `try-catch`:

```dart
myFunc()
    .then(processValue)
    .catchError(handleError);
```

**Rules:**
- `then()` callback fires if Future completes with a **value**
- `catchError()` callback fires if Future completes with an **error**

### Chaining then() Calls

```dart
Future<String> one() => Future.value('from one');
Future<String> two() => Future.error('error from two');
Future<String> three() => Future.value('from three');

void main() {
  one()
      .then((_) => two())      // Error occurs here
      .then((_) => three())    // Skipped - error propagates
      .then((value) => print(value))  // Skipped
      .catchError((e) {
        print('Got error: $e');  // Handles the error
        return 'recovered';
      })
      .then((value) => print('Value: $value'));  // Continues
}
// Output:
//   Got error: error from two
//   Value: recovered
```

### catchError() as Comprehensive Handler

Catches errors from **both** the original Future and `then()` callbacks:

```dart
myFunc()
    .then((value) {
      doSomethingWith(value);
      throw Exception('Error in then()');  // Also caught!
    })
    .catchError(handleError);  // Catches both sources
```

### Error Handling Within then()

Use `onError` parameter to handle errors differently:

```dart
asyncErrorFunction()
    .then(
      successCallback,
      onError: (e) {
        handleError(e);  // Handle original error
        anotherAsyncFunction();  // New error possible
      },
    )
    .catchError(handleError);  // Catches error from onError
```

### Handling Specific Errors with test

```dart
handleAuthResponse(params)
    .then((_) => redirectUser())
    .catchError(
      handleFormatException,
      test: (e) => e is FormatException,
    )
    .catchError(
      handleAuthException,
      test: (e) => e is AuthorizationException,
    )
    .catchError(handleGenericError);  // Catches remaining errors
```

### whenComplete() - The finally Equivalent

Runs regardless of success or error:

```dart
final server = connectToServer();
server
    .post(myUrl, fields: {'name': 'Dash'})
    .then(handleResponse)
    .catchError(handleError)
    .whenComplete(server.close);  // Always runs
```

**whenComplete() completion rules:**
- If no error in `whenComplete()`: completes same as receiver
- If error thrown in `whenComplete()`: completes with that error

```dart
asyncFunction()
    .catchError((e) {
      handleError(e);
      return someObject;  // Future completes with someObject
    })
    .whenComplete(() => print('Done!'));  // Still completes with someObject

asyncFunction()
    .catchError(handleError)
    .whenComplete(() => throw Exception('New error'))  // Overrides!
    .catchError(handleError);  // Handles the new error
```

---

## Common Pitfalls

### Pitfall 1: Late Error Handler Registration

```dart
// BAD: Error handler registered too late
void main() {
  Future<Object> future = asyncErrorFunction();

  Future.delayed(Duration(milliseconds: 500), () {
    future.then(...).catchError(...);  // Too late!
  });
}

// GOOD: Register handler immediately
void main() {
  asyncErrorFunction()
      .then(...)
      .catchError(...);
}
```

### Pitfall 2: Mixing Sync and Async Errors

```dart
// BAD: Synchronous error leaks out
Future<int> parseAndRead(Map<String, dynamic> data) {
  final filename = obtainFilename(data);  // Could throw sync!
  final file = File(filename);
  return file.readAsString().then((contents) {
    return parseFileData(contents);
  });
}

// catchError won't catch obtainFilename() error!
parseAndRead(data).catchError(handleError);  // Doesn't work
```

### Solution: Future.sync()

Wrap function body to convert sync errors to async:

```dart
// GOOD: All errors are async
Future<int> parseAndRead(Map<String, dynamic> data) {
  return Future.sync(() {
    final filename = obtainFilename(data);  // Now caught!
    final file = File(filename);
    return file.readAsString().then((contents) {
      return parseFileData(contents);
    });
  });
}

// Now catchError catches everything
parseAndRead(data).catchError(handleError);  // Works!
```

**Use `Future.sync()` when:**
- Your function returns a Future
- It contains code that might throw synchronously
- You want consistent async error handling

---

## timeout

Set a maximum wait time:

```dart
Future<String> fetchWithTimeout() async {
  try {
    return await fetchData().timeout(
      Duration(seconds: 5),
      onTimeout: () => 'Default value',
    );
  } on TimeoutException {
    return 'Timed out';
  }
}
```

---

## Common Patterns

### Loading State Pattern

```dart
class DataLoader {
  bool isLoading = false;
  String? data;
  String? error;

  Future<void> loadData() async {
    isLoading = true;
    error = null;

    try {
      data = await fetchData();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
```

### Retry Pattern

```dart
Future<T> retry<T>(
  Future<T> Function() operation, {
  int maxAttempts = 3,
  Duration delay = const Duration(seconds: 1),
}) async {
  int attempts = 0;

  while (true) {
    attempts++;
    try {
      return await operation();
    } catch (e) {
      if (attempts >= maxAttempts) rethrow;
      await Future.delayed(delay * attempts);
    }
  }
}

// Usage
var data = await retry(() => fetchData(), maxAttempts: 3);
```

### Debounce Pattern

```dart
Timer? _debounceTimer;

void onSearchChanged(String query) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(Duration(milliseconds: 300), () {
    performSearch(query);
  });
}
```

### Cache Pattern

```dart
class CachedFetcher {
  final Map<String, String> _cache = {};

  Future<String> fetch(String key) async {
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    var value = await expensiveFetch(key);
    _cache[key] = value;
    return value;
  }
}
```

---

## FutureBuilder (Flutter)

For displaying async data in UI:

```dart
FutureBuilder<String>(
  future: fetchData(),
  builder: (context, snapshot) {
    // Check connection state
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    // Check for error
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    // Display data
    return Text('Data: ${snapshot.data}');
  },
)
```

### Connection States

| State | Description |
|-------|-------------|
| `none` | No future provided |
| `waiting` | Future is running |
| `active` | Stream has data (for StreamBuilder) |
| `done` | Future completed |

---

## Best Practices

### 1. Always Handle Errors

```dart
// Bad - errors silently ignored
fetchData();

// Good - errors handled
try {
  await fetchData();
} catch (e) {
  handleError(e);
}
```

### 2. Avoid Fire-and-Forget

```dart
// Bad - future result ignored
void doSomething() {
  saveData();  // Warning: unawaited_futures lint
}

// Good - explicitly await or use unawaited()
Future<void> doSomething() async {
  await saveData();
}

// Or if intentionally not awaiting:
void doSomething() {
  unawaited(saveData());  // Explicit intent
}
```

### 3. Don't Block the UI

```dart
// Bad - blocks until all complete sequentially
for (var item in items) {
  await processItem(item);
}

// Good - parallel processing
await Future.wait(items.map((item) => processItem(item)));
```

### 4. Use Proper Return Types

```dart
// Bad - loses type information
Future fetchUser() async {  // Returns Future<dynamic>
  return await api.getUser();
}

// Good - explicit return type
Future<User> fetchUser() async {
  return await api.getUser();
}
```

### 5. Cancel When Appropriate

```dart
class SearchService {
  CancelableOperation<List<String>>? _currentSearch;

  Future<List<String>> search(String query) async {
    // Cancel previous search
    _currentSearch?.cancel();

    _currentSearch = CancelableOperation.fromFuture(
      api.search(query),
    );

    return await _currentSearch!.value;
  }
}
```

---

## Recommended Lints

Enable these lints in `analysis_options.yaml`:

```yaml
linter:
  rules:
    - discarded_futures    # Warn when Future result is ignored
    - unawaited_futures    # Warn when Future is not awaited
    - avoid_void_async     # Prefer Future<void> over void
```

---

## Summary

| Concept | Description |
|---------|-------------|
| `Future<T>` | Represents an async operation that produces `T` |
| `async` | Marks a function as asynchronous |
| `await` | Pauses until a Future completes |
| `Future.wait()` | Run multiple Futures in parallel |
| `try-catch` | Handle errors in async functions |
| `timeout()` | Set maximum wait time |
| `FutureBuilder` | Display async data in Flutter UI |
