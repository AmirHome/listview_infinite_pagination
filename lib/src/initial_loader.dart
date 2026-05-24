import 'package:flutter/material.dart';

class InitialLoader extends StatelessWidget {
  const InitialLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LinearProgressIndicator(
      value: null,
      backgroundColor: colorScheme.surfaceContainerHighest,
      color: colorScheme.primary,
      borderRadius: BorderRadius.circular(2),
    );
  }
}
