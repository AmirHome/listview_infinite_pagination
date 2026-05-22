import 'package:flutter/material.dart';

class OnError extends StatelessWidget {
  const OnError({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: const Center(
        child: Text('Something went wrong'),
      ),
    );
  }
}
