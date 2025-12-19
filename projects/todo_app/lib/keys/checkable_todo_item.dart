import 'package:flutter/material.dart';

enum Priority { urgent, normal, low }

class CheckableTodoItem extends StatefulWidget {
  const CheckableTodoItem(
    this.text,
    this.priority, {
    super.key,
    this.onEdit,
    this.onDelete,
  });

  final String text;
  final Priority priority;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  State<CheckableTodoItem> createState() => _CheckableTodoItemState();
}

class _CheckableTodoItemState extends State<CheckableTodoItem> {
  var _done = false;

  void _setDone(bool? isChecked) {
    setState(() {
      _done = isChecked ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var icon = Icons.low_priority;

    if (widget.priority == Priority.urgent) {
      icon = Icons.notifications_active;
    }

    if (widget.priority == Priority.normal) {
      icon = Icons.list;
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(value: _done, onChanged: _setDone),
          const SizedBox(width: 6),
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text(widget.text)),
          if (widget.onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: widget.onEdit,
            ),
          if (widget.onDelete != null)
            IconButton(
              icon: Icon(
                Icons.delete,
                size: 20,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: widget.onDelete,
            ),
        ],
      ),
    );
  }
}
