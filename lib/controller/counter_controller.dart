import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_controller.g.dart';

@riverpod
/// class-based provider
class CounterController extends _$CounterController {
  @override
  int build() => 0;

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}

@riverpod
/// functionnal provider
int doubledCount(Ref ref) {
  return ref.watch(counterControllerProvider) * 2;
}

@riverpod
Future<int> tripledCount(Ref ref) async {
  await Future.delayed(const Duration(seconds: 3));
  return ref.watch(counterControllerProvider) * 3;
}

@riverpod
bool isCounterOverTen(Ref ref) {
  return ref.watch(counterControllerProvider) > 10;
}
