import 'package:flutter/material.dart';

class LoadMoreLoader extends StatelessWidget {
  const LoadMoreLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2));
  }
}
