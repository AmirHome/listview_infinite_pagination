import 'package:flutter/material.dart';

class OnEmpty extends StatelessWidget {
  const OnEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      child: const Center(
        child: Text('No items found'),
      ),
    );
  }
}
