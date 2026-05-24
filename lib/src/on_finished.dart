import 'package:flutter/material.dart';

class OnFinished extends StatelessWidget {
  const OnFinished({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Center(
        child: Text('End of list', style: textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
      ),
    );
  }
}
