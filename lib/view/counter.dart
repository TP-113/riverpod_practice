import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends ConsumerWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text('Hello! This is a counter app.'),
        TextButton(onPressed: () {}, child: const Text('Increment')),
      ],
    );
  }
}
