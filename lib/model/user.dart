import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

// 練習問題：Freezed 1 - User Freezedクラスを作成
@freezed
abstract class User with _$User {
  const factory User({
    required String name,
    required DateTime birthDate,
    required DateTime lastUpdated,
  }) = _User;
}
