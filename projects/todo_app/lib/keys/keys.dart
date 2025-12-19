import 'package:flutter/material.dart';

import 'package:todo_app/keys/checkable_todo_item.dart';
import 'package:todo_app/widgets/add_todo.dart';
import 'package:todo_app/widgets/edit_todo.dart';
import 'package:todo_app/widgets/delete_todo.dart';


class Todo {
  const Todo(this.text, this.priority);

  final String text;
  final Priority priority;
}

class Keys extends StatefulWidget {
  const Keys({super.key});

  @override
  State<Keys> createState() {
    return _KeysState();
  }
}

class _KeysState extends State<Keys> {
  var _order = 'asc';
  final _todos = [
    const Todo(
      'Learn Flutter',
      Priority.urgent,
    ),
    const Todo(
      'Practice Flutter',
      Priority.normal,
    ),
    const Todo(
      'Explore other courses',
      Priority.low,
    ),
  ];

  List<Todo> get _orderedTodos {
    final sortedTodos = List.of(_todos);
    sortedTodos.sort((a, b) {
      final bComesAfterA = a.text.compareTo(b.text);
      return _order == 'asc' ? bComesAfterA : -bComesAfterA;
    });
    return sortedTodos;
  }

  void _changeOrder() {
    setState(() {
      _order = _order == 'asc' ? 'desc' : 'asc';
    });
  }

  void _addTodo(String text, Priority priority) {
    setState(() {
      _todos.add(Todo(text, priority));
    });
  }

  void _updateTodo(Todo oldTodo, String text, Priority priority) {
    final index = _todos.indexOf(oldTodo);
    if (index != -1) {
      setState(() {
        _todos[index] = Todo(text, priority);
      });
    }
  }

  void _deleteTodo(Todo todo) {
    final index = _todos.indexOf(todo);
    if (index != -1) {
      setState(() {
        _todos.removeAt(index);
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Todo deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _todos.insert(index, todo);
              });
            },
          ),
        ),
      );
    }
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AddTodo(onAddTodo: _addTodo),
    );
  }

  void _showEditTodoDialog(Todo todo) {
    showDialog(
      context: context,
      builder: (ctx) => EditTodo(
        initialText: todo.text,
        initialPriority: todo.priority,
        onUpdateTodo: (text, priority) => _updateTodo(todo, text, priority),
      ),
    );
  }

  void _showDeleteTodoDialog(Todo todo) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteTodo(
        todoText: todo.text,
        onConfirmDelete: () => _deleteTodo(todo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: _showAddTodoDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Todo'),
            ),
            TextButton.icon(
              onPressed: _changeOrder,
              icon: Icon(
                _order == 'asc' ? Icons.arrow_downward : Icons.arrow_upward,
              ),
              label: Text('Sort ${_order == 'asc' ? 'Descending' : 'Ascending'}'),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              // for (final todo in _orderedTodos) TodoItem(todo.text, todo.priority),
              for (final todo in _orderedTodos)
                CheckableTodoItem(
                  key: ObjectKey(todo), // ValueKey()
                  todo.text,
                  todo.priority,
                  onEdit: () => _showEditTodoDialog(todo),
                  onDelete: () => _showDeleteTodoDialog(todo),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
