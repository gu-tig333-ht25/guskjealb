import 'package:flutter/material.dart';
import 'todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Transform.scale(
              scale: 1.3,
              child: Checkbox(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                side: WidgetStateBorderSide.resolveWith(
                  (states) => const BorderSide(color: Colors.black, width: 1.5),
                ),
                fillColor: WidgetStateColor.transparent,
                checkColor: Colors.black,
                value: todo.done,
                onChanged: (_) => onToggle(),
              ),
            ),
            Expanded(
              child: Text(
                todo.text,
                style: TextStyle(
                  fontSize: 35,
                  decoration: todo.done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            IconButton(
              tooltip: "Delete",
              onPressed: onDelete,
              icon: const Icon(Icons.close, size: 35),
            ),
          ],
        ),
      ),
    );
  }
}