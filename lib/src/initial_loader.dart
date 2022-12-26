import 'package:flutter/material.dart';

class InitialLoader extends StatelessWidget {
  const InitialLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: null,
      backgroundColor: Colors.white,
      // valueColor: AlwaysStoppedAnimation<Color>(PaletteColors.initial)
    );
  }
}
