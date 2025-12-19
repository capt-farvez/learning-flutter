import 'package:flutter/material.dart';

import 'package:todo_app/keys/checkable_todo_item.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key, required this.onAddTodo});

  final void Function(String text, Priority priority) onAddTodo;

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _textController = TextEditingController();
  var _selectedPriority = Priority.normal;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitTodo() {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      return; 
    }
    widget.onAddTodo(text, _selectedPriority);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Todo',
              hintText: 'Enter todo text',
            ),
            autofocus: true,
            onSubmitted: (_) => _submitTodo(),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Priority>(
            initialValue: _selectedPriority,
            decoration: const InputDecoration(
              labelText: 'Priority',
            ),
            items: Priority.values
                .map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(p.name[0].toUpperCase() + p.name.substring(1)),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedPriority = value ?? Priority.normal;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submitTodo,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
