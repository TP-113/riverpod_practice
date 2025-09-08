import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/controller/counter_controller.dart';

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('My number : xxx'),
            SizedBox(height: 120),
            Text('Hello! This is a counter app.'),
            Text('Count: ${ref.watch(counterControllerProvider)}'),
            ElevatedButton(
              onPressed: () {
                ref.read(counterControllerProvider.notifier).increment();
              },
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
