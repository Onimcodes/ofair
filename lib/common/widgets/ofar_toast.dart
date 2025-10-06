import 'package:flutter/material.dart';

class OfairToast extends StatelessWidget {
  final String message;
  final bool success;

  const OfairToast({
    super.key,
    required this.message,
    this.success = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = success
        ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
        : Colors.redAccent.withOpacity(0.9);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            success ? Icons.check_circle_outline : Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
