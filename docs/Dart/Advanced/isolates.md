# Isolates in Dart

Isolates provide true parallel execution in Dart. Unlike threads, isolates don't share memory—they communicate via message passing.

---

## Theory: Why Isolates?

### The Problem with Single-Threaded Code

Dart is single-threaded by default. Long-running computations block the event loop:

```
Single Thread:
┌─────────────────────────────────────┐
│ UI Update │ Heavy Compute │ UI Update │
└─────────────────────────────────────┘
              ↑ UI Frozen!

With Isolate:
Main:    │ UI │ UI │ UI │ UI │ UI │
Worker:  │ Heavy Computation   │
         └─────────────────────┘
         (Parallel execution)
```

### When to Use Isolates

| Scenario | Example |
|----------|---------|
| **Large JSON** | Parsing/decoding big JSON blobs |
| **Media processing** | Compressing photos, audio, video |
| **File operations** | Converting audio/video files |
| **Data processing** | Filtering large lists, searching filesystems |
| **I/O operations** | Database communication |
| **Network** | Handling large volume of requests |

> **Note**: Flutter web does not support multiple isolates.

---

## Isolate.run() - Simple Worker Isolates

The simplest way to run code in a separate isolate.

### What Isolate.run() Does

1. Spawns (starts) a new isolate
2. Runs a function on that isolate
3. Captures the result
4. Returns the result to the main isolate
5. Terminates the isolate when complete
6. Handles errors back to the main isolate

### Running an Existing Function

```dart
import 'dart:isolate';
import 'dart:convert';
import 'dart:io';

const String filename = 'data.json';

void main() async {
  // Run in separate isolate
  final jsonData = await Isolate.run(_readAndParseJson);

  print('Number of JSON keys: ${jsonData.length}');
}

// This function runs on the worker isolate
Future<Map<String, dynamic>> _readAndParseJson() async {
  final fileData = await File(filename).readAsString();
  final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
  return jsonData;
}
```

### Using Closures

```dart
void main() async {
  final jsonData = await Isolate.run(() async {
    final fileData = await File(filename).readAsString();
    final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
    return jsonData;
  });

  print('Number of JSON keys: ${jsonData.length}');
}
```

### Key Points

- Result is always a `Future` (main isolate continues running)
- Worker isolate **transfers** memory (doesn't copy)
- Works with both sync and async functions
- Isolate terminates automatically after completion

---

## Long-Lived Isolates with Ports

For repeated computations, create persistent isolates to avoid spawn overhead.

### ReceivePort and SendPort

| Class | Purpose |
|-------|---------|
| `ReceivePort` | Receives messages from other isolates |
| `SendPort` | Sends messages to a ReceivePort |

```
Main Isolate                    Worker Isolate
┌─────────────┐                ┌─────────────┐
│ ReceivePort │◄───SendPort────│             │
│             │                │             │
│             │────SendPort───►│ ReceivePort │
└─────────────┘                └─────────────┘
```

> A `SendPort` is associated with exactly one `ReceivePort`, but a `ReceivePort` can have many `SendPorts`.

### Ports are Like Streams

```dart
// SendPort ≈ StreamController (you add/send messages)
// ReceivePort ≈ Stream listener (you receive messages)

sendPort.send(message);           // Like controller.add()
receivePort.listen((msg) {...});  // Like stream.listen()
```

---

## Basic Ports Example

### Step 1: Define Worker Class

```dart
class Worker {
  late SendPort _sendPort;
  final _isolateReady = Completer<void>();

  Future<void> spawn() async {
    // TODO: Spawn isolate
  }

  void _handleResponsesFromIsolate(dynamic message) {
    // TODO: Handle messages from worker
  }

  static void _startRemoteIsolate(SendPort port) {
    // TODO: Worker isolate entry point
  }

  Future<void> parseJson(String message) async {
    // TODO: Send messages to worker
  }
}
```

### Step 2: Spawn Worker Isolate

```dart
Future<void> spawn() async {
  // Create receive port for main isolate
  final receivePort = ReceivePort();

  // Listen for messages from worker
  receivePort.listen(_handleResponsesFromIsolate);

  // Spawn the worker isolate
  await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
}
```

### Step 3: Worker Isolate Entry Point

```dart
static void _startRemoteIsolate(SendPort port) {
  // Create worker's receive port
  final receivePort = ReceivePort();

  // Send worker's SendPort back to main isolate
  port.send(receivePort.sendPort);

  // Listen for messages from main isolate
  receivePort.listen((dynamic message) async {
    if (message is String) {
      final transformed = jsonDecode(message);
      port.send(transformed);  // Send result back
    }
  });
}
```

### Step 4: Handle Responses on Main Isolate

```dart
void _handleResponsesFromIsolate(dynamic message) {
  if (message is SendPort) {
    // First message is the worker's SendPort
    _sendPort = message;
    _isolateReady.complete();
  } else if (message is Map<String, dynamic>) {
    // Subsequent messages are decoded JSON
    print(message);
  }
}
```

### Step 5: Send Messages to Worker

```dart
Future<void> parseJson(String message) async {
  // Wait until isolate is ready
  await _isolateReady.future;

  // Send message to worker
  _sendPort.send(message);
}
```

### Complete Basic Example

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

class Worker {
  late SendPort _sendPort;
  final _isolateReady = Completer<void>();

  Future<void> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
    } else if (message is Map<String, dynamic>) {
      print(message);
    }
  }

  static void _startRemoteIsolate(SendPort port) {
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    receivePort.listen((dynamic message) async {
      if (message is String) {
        final transformed = jsonDecode(message);
        port.send(transformed);
      }
    });
  }

  Future<void> parseJson(String message) async {
    await _isolateReady.future;
    _sendPort.send(message);
  }
}

void main() async {
  final worker = Worker();
  await worker.spawn();
  await worker.parseJson('{"name": "Dart"}');
}
```

---

## Robust Ports Example

Production-ready isolate with error handling, message ordering, and cleanup.

### Step 1: Define Robust Worker Class

```dart
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  // Private constructor
  Worker._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  // Factory method to create Worker
  static Future<Worker> spawn() async {
    // Implementation below
  }

  Future<Object?> parseJson(String message) async {
    // Implementation below
  }

  void close() {
    // Implementation below
  }

  void _handleResponsesFromIsolate(dynamic message) {
    // Implementation below
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    // Implementation below
  }

  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
  ) {
    // Implementation below
  }
}
```

### Step 2: Spawn with RawReceivePort

```dart
static Future<Worker> spawn() async {
  // Create a raw receive port for initial handshake
  final initPort = RawReceivePort();
  final connection = Completer<(ReceivePort, SendPort)>.sync();

  // Handler for initial message (worker's SendPort)
  initPort.handler = (initialMessage) {
    final commandPort = initialMessage as SendPort;
    connection.complete((
      ReceivePort.fromRawReceivePort(initPort),
      commandPort,
    ));
  };

  // Spawn isolate with error handling
  try {
    await Isolate.spawn(_startRemoteIsolate, initPort.sendPort);
  } on Object {
    initPort.close();
    rethrow;
  }

  // Wait for connection and create Worker
  final (ReceivePort receivePort, SendPort sendPort) =
      await connection.future;

  return Worker._(receivePort, sendPort);
}
```

### Step 3: Worker Isolate Setup

```dart
static void _startRemoteIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  _handleCommandsToIsolate(receivePort, sendPort);
}

static void _handleCommandsToIsolate(
  ReceivePort receivePort,
  SendPort sendPort,
) {
  receivePort.listen((message) {
    // Handle shutdown
    if (message == 'shutdown') {
      receivePort.close();
      return;
    }

    // Destructure id and message
    final (int id, String jsonText) = message as (int, String);

    try {
      final jsonData = jsonDecode(jsonText);
      sendPort.send((id, jsonData));  // Send id with response
    } catch (e) {
      sendPort.send((id, RemoteError(e.toString(), '')));
    }
  });
}
```

### Step 4: Handle Messages with IDs

```dart
Future<Object?> parseJson(String message) async {
  if (_closed) throw StateError('Closed');

  // Create completer for this request
  final completer = Completer<Object?>.sync();
  final id = _idCounter++;
  _activeRequests[id] = completer;

  // Send message with id
  _commands.send((id, message));

  // Wait for response
  return await completer.future;
}

void _handleResponsesFromIsolate(dynamic message) {
  // Destructure id and response
  final (int id, Object? response) = message as (int, Object?);

  // Get and remove completer
  final completer = _activeRequests.remove(id)!;

  // Complete with response or error
  if (response is RemoteError) {
    completer.completeError(response);
  } else {
    completer.complete(response);
  }
}
```

### Step 5: Graceful Shutdown

```dart
void close() {
  if (!_closed) {
    _closed = true;
    _commands.send('shutdown');
    if (_activeRequests.isEmpty) {
      _responses.close();
    }
  }
}
```

### Complete Robust Example

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

class Worker {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  Worker._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  static Future<Worker> spawn() async {
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();

    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };

    try {
      await Isolate.spawn(_startRemoteIsolate, initPort.sendPort);
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    return Worker._(receivePort, sendPort);
  }

  Future<Object?> parseJson(String message) async {
    if (_closed) throw StateError('Closed');

    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, message));

    return await completer.future;
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) {
        _responses.close();
      }
    }
  }

  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Object? response) = message as (int, Object?);
    final completer = _activeRequests.remove(id)!;

    if (response is RemoteError) {
      completer.completeError(response);
    } else {
      completer.complete(response);
    }
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
  ) {
    receivePort.listen((message) {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }

      final (int id, String jsonText) = message as (int, String);

      try {
        final jsonData = jsonDecode(jsonText);
        sendPort.send((id, jsonData));
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }
}

void main() async {
  final worker = await Worker.spawn();

  // Send multiple requests
  final results = await Future.wait([
    worker.parseJson('{"id": 1}'),
    worker.parseJson('{"id": 2}'),
    worker.parseJson('{"id": 3}'),
  ]);

  for (var result in results) {
    print(result);
  }

  worker.close();
}
```

---

## Flutter's compute() Function

In Flutter, use `compute()` for simple isolate tasks:

```dart
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>> parseJsonInBackground(String json) async {
  return await compute(_parseJson, json);
}

Map<String, dynamic> _parseJson(String json) {
  return jsonDecode(json) as Map<String, dynamic>;
}
```

> `compute()` is Flutter's simplified wrapper around `Isolate.run()`.

---

## Message Passing Rules

### What Can Be Sent

| Type | Can Send? |
|------|-----------|
| Primitive types (int, String, bool, etc.) | Yes |
| Lists, Maps, Sets | Yes |
| Custom classes | Yes (if all fields are sendable) |
| Closures | Limited |
| ReceivePort | No |
| SendPort | Yes |

### Transfer vs Copy

```dart
// Data is TRANSFERRED (not copied) when possible
final largeList = List.generate(1000000, (i) => i);

await Isolate.run(() {
  // largeList memory is transferred, not copied
  return processData(largeList);
});
```

---

## Error Handling

### With Isolate.run()

```dart
try {
  final result = await Isolate.run(() {
    throw Exception('Worker error');
  });
} catch (e) {
  print('Caught error from isolate: $e');
}
```

### With Ports (RemoteError)

```dart
// In worker isolate
try {
  final result = processData(data);
  sendPort.send(result);
} catch (e) {
  sendPort.send(RemoteError(e.toString(), ''));
}

// In main isolate
void handleResponse(dynamic message) {
  if (message is RemoteError) {
    throw message;
  }
  // Process result
}
```

---

## Best Practices

### 1. Use Isolate.run() for Simple Cases

```dart
// Good - simple one-off computation
final result = await Isolate.run(() => heavyComputation(data));

// Overkill for simple cases
final worker = await Worker.spawn();
final result = await worker.process(data);
worker.close();
```

### 2. Use Long-Lived Isolates for Repeated Work

```dart
// Good - reuse isolate for multiple operations
final worker = await Worker.spawn();
for (var item in items) {
  await worker.process(item);
}
worker.close();
```

### 3. Always Close Ports

```dart
class Worker {
  void dispose() {
    _receivePort.close();
    _sendPort.send('shutdown');
  }
}
```

### 4. Handle Errors Appropriately

```dart
// Always wrap isolate communication in try-catch
try {
  final result = await worker.parseJson(jsonString);
} on RemoteError catch (e) {
  print('Worker error: $e');
} catch (e) {
  print('Communication error: $e');
}
```

### 5. Track Request IDs for Multiple Messages

```dart
// Associate responses with requests using IDs
final id = _idCounter++;
_activeRequests[id] = completer;
_commands.send((id, message));
```

---

## Summary

| Concept | Description |
|---------|-------------|
| `Isolate` | Independent worker with own memory |
| `Isolate.run()` | Simple one-off parallel execution |
| `ReceivePort` | Receives messages from other isolates |
| `SendPort` | Sends messages to a ReceivePort |
| `RawReceivePort` | Low-level port for startup logic |
| Message passing | Only way isolates communicate |
| `compute()` | Flutter's simplified isolate helper |

| Pattern | Use Case |
|---------|----------|
| `Isolate.run()` | Single computation, auto-cleanup |
| Long-lived isolate | Repeated computations, performance |
| Request IDs | Track responses for multiple messages |
| Completer per request | Return correct response to caller |
