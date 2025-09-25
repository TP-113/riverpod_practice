import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../model/user.dart';

part 'user_controller.g.dart';

// 練習問題：Freezed 2 - Userを保持するProviderを作成
@riverpod
class UserController extends _$UserController {
  @override
  User build() {
    // 初期値としてデフォルトのユーザー情報を返す
    return User(
      name: '田中太郎',
      birthDate: DateTime(1990, 1, 1),
      lastUpdated: DateTime.now(),
    );
  }

  // 練習問題：Freezed 3 - 更新ボタンの機能を実装
  void updateUser({required String name, required DateTime birthDate}) {
    state = state.copyWith(
      name: name,
      birthDate: birthDate,
      lastUpdated: DateTime.now(), // 更新日時も自動的に現在の日時に更新
    );
  }
}
