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
            Text('Count: ${ref.watch(counterControllerProvider)}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 18,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(counterControllerProvider.notifier).increment();
                  },
                  child: const Text('+1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // ここにdecrement処理を追加
                  },
                  child: const Text('-1'),
                ),
              ],
            ),
            SizedBox(height: 60),
            Text('Tripled count: xxx'),
            Text('Is counter over 10? : xxx'),
          ],
        ),
      ),
    );
  }
}
