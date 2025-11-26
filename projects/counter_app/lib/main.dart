import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Counter {
  String title;
  int value;

  Counter({required this.title, this.value = 0});
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Counter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 100, 157, 248),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 100, 248, 219),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(
          title: 'Multi Counter',
          onToggleTheme: _toggleTheme,
          isDarkMode: _isDarkMode),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.onToggleTheme,
      required this.isDarkMode});
  final String title;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Counter> _counters = [];
  final TextEditingController _titleController = TextEditingController();

  void _addCounter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Counter'),
        content: TextField(
          controller: _titleController,
          maxLength: 18,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Counter Title',
            hintText: 'Enter counter name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _titleController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                setState(() {
                  _counters.add(Counter(title: _titleController.text));
                });
                _titleController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _deleteCounter(int index) {
    setState(() {
      _counters.removeAt(index);
    });
  }

  void _incrementCounter(int index) {
    setState(() {
      _counters[index].value++;
      if (_counters[index].value > 10) {
        _counters[index].value = 0;
        _showPopup('${_counters[index].title}: Maximum reached! Reset to 0.');
      }
    });
  }

  void _decrementCounter(int index) {
    setState(() {
      _counters[index].value--;
      if (_counters[index].value < -10) {
        _counters[index].value = 0;
        _showPopup('${_counters[index].title}: Minimum reached! Reset to 0.');
      }
    });
  }

  void _resetCounter(int index) {
    setState(() {
      _counters[index].value = 0;
    });
  }

  void _editCounterTitle(int index) {
    _titleController.text = _counters[index].title;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Counter Title'),
        content: TextField(
          controller: _titleController,
          maxLength: 18,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Counter Title',
            hintText: 'Enter new name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _titleController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                setState(() {
                  _counters[index].title = _titleController.text;
                });
                _titleController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPopup(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: 'Courier New',
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: widget.isDarkMode ? 'Light Mode' : 'Dark Mode',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: _counters.isEmpty
          ? const Center(
              child: Text(
                'No counters yet.\nTap + to create one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _counters.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _counters[index].title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courier New',
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Edit Title',
                                  onPressed: () => _editCounterTitle(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Delete Counter',
                                  onPressed: () => _deleteCounter(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_counters[index].value}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(fontFamily: 'Courier New'),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton.small(
                              heroTag: 'dec_$index',
                              onPressed: () => _decrementCounter(index),
                              tooltip: 'Decrement',
                              child: const Icon(Icons.remove),
                            ),
                            const SizedBox(width: 16),
                            FloatingActionButton.small(
                              heroTag: 'reset_$index',
                              onPressed: () => _resetCounter(index),
                              tooltip: 'Reset',
                              child: const Text('0',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 16),
                            FloatingActionButton.small(
                              heroTag: 'inc_$index',
                              onPressed: () => _incrementCounter(index),
                              tooltip: 'Increment',
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCounter,
        tooltip: 'Add Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
