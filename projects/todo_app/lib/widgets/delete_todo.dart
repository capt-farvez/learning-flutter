import 'package:flutter/material.dart';

class DeleteTodo extends StatelessWidget {
  const DeleteTodo({
    super.key,
    required this.todoText,
    required this.onConfirmDelete,
  });

  final String todoText;
  final VoidCallback onConfirmDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Todo'),
      content: Text('Are you sure you want to delete "$todoText"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirmDelete();
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
