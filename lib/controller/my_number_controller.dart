//ここにmyNumberを作成する

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_number_controller.g.dart';

@riverpod
int myNumber(Ref ref) {
  return 100;
}
