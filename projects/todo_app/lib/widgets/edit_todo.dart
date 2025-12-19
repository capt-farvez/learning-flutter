import 'package:flutter/material.dart';

import 'package:todo_app/keys/checkable_todo_item.dart';

class EditTodo extends StatefulWidget {
  const EditTodo({
    super.key,
    required this.initialText,
    required this.initialPriority,
    required this.onUpdateTodo,
  });

  final String initialText;
  final Priority initialPriority;
  final void Function(String text, Priority priority) onUpdateTodo;

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  late final TextEditingController _textController;
  late Priority _selectedPriority;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
    _selectedPriority = widget.initialPriority;
  }

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
    widget.onUpdateTodo(text, _selectedPriority);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Todo'),
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
          child: const Text('Update'),
        ),
      ],
    );
  }
}
