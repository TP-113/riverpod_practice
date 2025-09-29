import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user.dart';

part 'user_controller.g.dart';

// 練習問題：Freezed 2 - Userを保持するProviderを作成
@riverpod
class UserController extends _$UserController {
  static const String _nameKey = 'user_name';
  static const String _birthDateKey = 'user_birth_date';
  static const String _lastUpdatedKey = 'user_last_updated';

  static final User defaultUser = User(
    name: '田中太郎',
    birthDate: DateTime(1990, 1, 1),
    lastUpdated: DateTime.now(),
  );

  @override
  User build() {
    return defaultUser;
  }

  // ローカルストレージからユーザー情報を読み込む（公開メソッド）
  Future<void> loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_nameKey);
      final birthDateMillis = prefs.getInt(_birthDateKey);
      final lastUpdatedMillis = prefs.getInt(_lastUpdatedKey);

      if (name != null &&
          birthDateMillis != null &&
          lastUpdatedMillis != null) {
        final user = User(
          name: name,
          birthDate: DateTime.fromMillisecondsSinceEpoch(birthDateMillis),
          lastUpdated: DateTime.fromMillisecondsSinceEpoch(lastUpdatedMillis),
        );
        state = user;
      }
    } catch (e) {
      // エラーが発生した場合はデフォルト値を使用
      print('ユーザー情報の読み込みに失敗しました: $e');
    }
  }

  // ユーザー情報をローカルストレージに保存する
  Future<void> _saveUserToStorage(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_nameKey, user.name);
      await prefs.setInt(_birthDateKey, user.birthDate.millisecondsSinceEpoch);
      await prefs.setInt(
        _lastUpdatedKey,
        user.lastUpdated.millisecondsSinceEpoch,
      );
    } catch (e) {
      print('ユーザー情報の保存に失敗しました: $e');
    }
  }

  // 練習問題：Freezed 3 - 更新ボタンの機能を実装
  void updateUser({required String name, required DateTime birthDate}) {
    final updatedUser = state.copyWith(
      name: name,
      birthDate: birthDate,
      lastUpdated: DateTime.now(), // 更新日時も自動的に現在の日時に更新
    );

    state = updatedUser;

    // ローカルストレージに保存
    _saveUserToStorage(updatedUser);
  }
}
