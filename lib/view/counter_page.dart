import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/controller/counter_controller.dart';
import 'package:riverpod_practice/controller/my_number_controller.dart';

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
            Text('My number : ${ref.watch(myNumberProvider)}'),
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
                    ref.read(counterControllerProvider.notifier).decrement();
                  },
                  child: const Text('-1'),
                ),
              ],
            ),
            SizedBox(height: 60),
            switch (ref.watch(tripledCountProvider)) {
              AsyncData(:final value) => Text('Tripled count: $value'),
              AsyncLoading() => const CircularProgressIndicator(),
              AsyncError(:final error) => Text('Error: $error'),
              _ => const CircularProgressIndicator(),
            },
            Text(
              'Is counter over 10? : ${ref.watch(isCounterOverTenProvider)}',
            ),
          ],
        ),
      ),
    );
  }
}
