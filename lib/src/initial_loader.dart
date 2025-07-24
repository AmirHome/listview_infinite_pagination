import 'package:flutter/material.dart';

class InitialLoader extends StatelessWidget {
  const InitialLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const LinearProgressIndicator(
      value: null,
      backgroundColor: Colors.white,
      // valueColor: AlwaysStoppedAnimation<Color>(PaletteColors.initial)
    );
  }
}
