# Freezed について学ぼう

【ゴール】不変データクラスを簡単に作成できるパッケージ：[Freezed](https://pub.dev/packages/freezed) について理解できる

- Freezed の基本概念を理解する
- 不変データクラス（Immutable Data Class）の作成方法を学ぶ
- Riverpod と Freezed を組み合わせた実装方法を理解する
- パターンマッチングやコピー機能の使い方を学ぶ

## Freezed とは

Freezed は、Dart で不変データクラスを簡単に作成できるコード生成パッケージです。不変データクラスとは、一度作成されたら変更できないオブジェクトのことです。

### 不変データクラス(immutable)の利点

- **意図しないデータ変更の防止**: データが意図せず変更されることを防ぐ
- **データ同士の比較が可能**: 等価演算子（==）の挙動が明確になる

### 従来の Dart クラスとの比較

```dart
// 従来の Dart クラス（可変）
class User {
  final String name;
  final int age;
  final String email;

  User({required this.name, required this.age, required this.email});

  // 手動でコピー機能を実装する必要がある
  User copyWith({String? name, int? age, String? email}) {
    return User(
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
    );
  }

  // 手動で等価性を実装する必要がある
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.name == name &&
        other.age == age &&
        other.email == email;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode ^ email.hashCode;

  @override
  String toString() => 'User(name: $name, age: $age, email: $email)';
}
```

```dart
// Freezed を使ったクラス（不変）
@freezed
abstract class User with _$User {
  const factory User({
    required String name,
    required int age,
    required String email,
  }) = _User;
}
```

Freezed を使うことで、以下の機能が自動生成されます：

- `copyWith()` メソッド
- `==` 演算子と `hashCode`
- `toString()` メソッド
- パターンマッチング対応

## Freezed の基本的な使い方

### 1. パッケージの追加

`pubspec.yaml` に以下の依存関係を追加します：

```yaml
dependencies:
  freezed_annotation: ^3.1.0
  freezed: ^3.1.0

dev_dependencies:
  build_runner: ^2.4.7
```

### 2. 基本的なデータクラスの作成

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String name,
    required int age,
    required String email,
  }) = _User;
}
```

少し複雑なテンプレートですが、VSCode 拡張機能：[Flutter freezed helpers](https://marketplace.visualstudio.com/items?itemName=mthuong.vscode-flutter-freezed-helper)を入れると補完してくれます。最近は@freezed を入れた時点で Cursor や Copilot が補完してくれる場合も多いです。

### 3. コード生成

以下のコマンドでコードを生成します：

```bash
dart run build_runner build -d
```

### 4. 使用例

```dart
void main() {
  // インスタンスの作成
  final user = User(
    name: '田中太郎',
    age: 25,
    email: 'tanaka@example.com',
  );

  // copyWith で一部のプロパティを変更
  final updatedUser = user.copyWith(age: 26);

  // 等価性の比較
  print(user == updatedUser); // false

  // toString の自動生成
  print(user); // User(name: 田中太郎, age: 25, email: tanaka@example.com)
}
```

## 高度な Freezed の機能

### 1. デフォルト値の設定

```dart
@freezed
abstract class User with _$User {
  const factory User({
    required String name,
    @Default(0) int age,
    @Default('') String email,
  }) = _User;
}
```

### 2. カスタムメソッドの追加

```dart
@freezed
abstract class User with _$User {
  const factory User({
    required String name,
    required int age,
    required String email,
  }) = _User;

  // カスタムメソッドを追加
  bool get isAdult => age >= 18;

  String get displayName => '$name ($age歳)';
}
```

### 3. Union Types（共用体型）

```dart
@freezed
abstract class UserRole with _$UserRole {
  const factory UserRole.admin() = Admin;
  const factory UserRole.moderator() = Moderator;
  const factory UserRole.user() = User;
}

@freezed
abstract class Notification with _$Notification {
  const factory Notification.email({
    required String recipient,
    required String subject,
    required String body,
  }) = EmailNotification;

  const factory Notification.push({
    required String deviceToken,
    required String title,
    required String message,
  }) = PushNotification;

  const factory Notification.sms({
    required String phoneNumber,
    required String message,
  }) = SmsNotification;
}
```

### 4. パターンマッチング

```dart
void handleUserRole(UserRole role) {
  switch (role) {
    case Admin():
      print('管理者権限でアクセス');
    case Moderator():
      print('モデレーター権限でアクセス');
    case User():
      print('一般ユーザー権限でアクセス');
  }
}

void sendNotification(Notification notification) {
  switch (notification) {
    case EmailNotification(:final recipient, :final subject, :final body):
      print('メール送信: $recipient に "$subject" を送信');
    case PushNotification(:final deviceToken, :final title, :final message):
      print('プッシュ通知: $deviceToken に "$title" を送信');
    case SmsNotification(:final phoneNumber, :final message):
      print('SMS送信: $phoneNumber に "$message" を送信');
  }
}
```

## Riverpod と Freezed の組み合わせ

Riverpod と Freezed を組み合わせることで、型安全で予測可能な状態管理を実現できます。

### 1. 状態を Freezed クラスで管理

```dart
// カウンターの状態を Freezed で管理
@freezed
abstract class CounterState with _$CounterState {
  const factory CounterState({
    @Default(0) int count,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _CounterState;
}

// Riverpod で状態を管理
@riverpod
class CounterController extends _$CounterController {
  @override
  CounterState build() => const CounterState();

  void increment() {
    state = state.copyWith(count: state.count + 1);
  }

  void decrement() {
    state = state.copyWith(count: state.count - 1);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(errorMessage: error);
  }
}
```

### 2. Widget での使用

```dart
class UserProfileWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userControllerProvider);

    return switch (userState) {
      UserLoading() => CircularProgressIndicator(),
      UserLoaded(:final user) => Column(
        children: [
          Text('名前: ${user.name}'),
          Text('年齢: ${user.age}'),
          Text('メール: ${user.email}'),
        ],
      ),
      UserError(:final message) => Text('エラー: $message'),
    };
  }
}
```

**_▫️ 練習問題_**

`lib/view/freezed_page.dart` にユーザー情報管理アプリを実装してください：

**用意されている内容：**

- 画面上部にユーザーの氏名、生年月日、更新日が表示されている
- 画面下部にユーザーの氏名、生年月日の入力フォーム、「更新」ボタンがある

**実装する内容：**

1. **User という Freezed クラスを作成**

   - `name` (String): ユーザーの氏名
   - `birthDate` (DateTime): 生年月日
   - `lastUpdated` (DateTime): 最終更新日時

2. **User を「ユーザー情報」に反映**

   - User を保持する Provider を作成し、画面の「ユーザー情報」の部分に表示されるようにする

3. **更新ボタンの機能を実装**

   - 更新ボタンを押すとフォームに入力した内容が画面上部に反映される
   - 更新日時も自動的に現在の日時に更新される
   - Riverpod の Provider でユーザー情報を保持する

4. **フォームの初期値に現在の情報を挿入**
   - ページを開いたときに初期値のユーザー情報が反映される

**ヒント：**

- `copyWith` メソッドを活用して状態を更新する
- Riverpod の Class-based Provider を使用する

# まとめ

この講義では、Freezed の基本的な使い方について学びました。最後にキーワードをまとめておきましょう。

- 不変データクラスの概念と利点
- Freezed を使ったクラス定義方法
- `copyWith` メソッドの活用
- Union Types とパターンマッチング
- Riverpod との組み合わせ

これらの機能を活用すれば、型安全で予測可能なアプリケーションを作成できます！

Freezed の発展的な機能として以下のものがあります。さらに Freezed について学びたい方は、以下のキーワードを[公式ドキュメント](https://pub.dev/packages/freezed)で検索してみましょう。

- **JSON シリアライゼーション**: `json_annotation` との組み合わせ
- **カスタムコンストラクタ**: 複数のファクトリコンストラクタの定義
- **プライベートコンストラクタ**: インスタンス化を制限する方法
- **カスタムコピー**: `copyWith` 以外のカスタムコピーメソッドの実装
