// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$doubledCountHash() => r'fae6a4b33edb2a3d79516c4f7e993b0c4f51497d';

/// functionnal provider
///
/// Copied from [doubledCount].
@ProviderFor(doubledCount)
final doubledCountProvider = AutoDisposeProvider<int>.internal(
  doubledCount,
  name: r'doubledCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$doubledCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DoubledCountRef = AutoDisposeProviderRef<int>;
String _$tripledCountHash() => r'99d813e2134f6ae2f140ce4c7e5e5146b2559909';

/// See also [tripledCount].
@ProviderFor(tripledCount)
final tripledCountProvider = AutoDisposeFutureProvider<int>.internal(
  tripledCount,
  name: r'tripledCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tripledCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripledCountRef = AutoDisposeFutureProviderRef<int>;
String _$isCounterOverTenHash() => r'b99cffe04a4a43eb9baa864c783017f34bb1b61c';

/// See also [isCounterOverTen].
@ProviderFor(isCounterOverTen)
final isCounterOverTenProvider = AutoDisposeProvider<bool>.internal(
  isCounterOverTen,
  name: r'isCounterOverTenProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isCounterOverTenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsCounterOverTenRef = AutoDisposeProviderRef<bool>;
String _$counterControllerHash() => r'603d7558d5463044e0ac6a6a7798c61973eef372';

/// class-based provider
///
/// Copied from [CounterController].
@ProviderFor(CounterController)
final counterControllerProvider =
    AutoDisposeNotifierProvider<CounterController, int>.internal(
      CounterController.new,
      name: r'counterControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$counterControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CounterController = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
