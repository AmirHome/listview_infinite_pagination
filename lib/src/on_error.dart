import 'package:flutter/material.dart';

class OnError extends StatelessWidget {
  const OnError({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 20, color: colorScheme.error),
          const SizedBox(width: 8),
          Flexible(
            child: Text('Something went wrong', style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }
}
