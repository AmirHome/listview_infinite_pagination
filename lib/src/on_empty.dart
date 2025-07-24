import 'package:flutter/material.dart';

class OnEmpty extends StatelessWidget {
  const OnEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7),
      // color: Colors.amber,
      child: const Center(
        child: Text('Fetched all of the content'),
      ),
    );
  }
}
