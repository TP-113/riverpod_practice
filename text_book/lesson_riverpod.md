# Riverpod について学ぼう

【ゴール】スニダンで使用している状態管理フレームワーク：[Riverpod](https://riverpod.dev/ja/) について理解できる

- Riverpod の主要なインターフェースを理解する
  - Provider
  - ref.read/watch
- Riverpod の Generator 機能を使って、Provider を生成できる
- Provider の値を Widget から参照して利用できる

# 状態管理とは

アプリケーションにおける「状態（State）」とは、アプリケーションが保持する動的なデータのことです。この状態をいかに管理するかということがアプリケーションを作る上で重要になります。

状態管理の例）

- ユーザーの入力内容（テキストフィールドの値、チェックボックスの状態など）
- API から取得したデータ（ユーザー情報、商品リストなど）
- UI の表示状態（ローディング中、エラー表示、タブの選択状態など）
- アプリ全体の設定（ダークモード、言語設定など）

これらの状態は随時変化し、その変化に応じて UI を更新する必要があります。

Flutter では宣言型の UI フレームワークとして実装されています。宣言型の UI とは、アプリの状態と UI が結びつき、UI が状態の関数として表現されているような方式のことです。これは 公式ドキュメントにおいて

```
UI=f(state)
```

という表現で説明されています。UI を状態の関数として表現することで、UI と状態が一意に結びつくようになり、デバッグやテストなどの開発活動が行いやすくなるという利点があります。

宣言型についての Flutter 公式ドキュメント → https://docs.flutter.dev/data-and-backend/state-mgmt/declarative

## Flutter の標準的な状態管理

Flutter には`setState()`という基本的な状態管理の仕組みがありますが、これには限界があります。

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int counter = 0;

  void increment() {
    setState(() {
      counter++;  // この状態は、このWidget内でしか使えない
    });
  }

  @override
  Widget build(BuildContext context){
    //...
  }
}
```

`setState()`の問題点：

- 状態が Widget 内に閉じ込められる（他の Widget と共有できない）
- 大規模なアプリケーションでは管理が複雑になる
- 状態の依存関係を手動で管理する必要がある

これらの課題を解決するために、状態管理フレームワークが必要になります。

# サンプルプロジェクトのダウンロード

今回の講義で ↓ のプロジェクトを使用するので、git でクローンしておいてください。

[https://github.com/TP-113/riverpod_practice.git](https://github.com/TP-113/riverpod_practice.git)

# Riverpod

Riverpod は、Flutter の状態管理・画面反映まわりの処理についての包括的なフレームワークです。

Riverpod は以下のような課題を解決してくれます。

- 状態管理のための変数・インスタンスを楽に管理したい
- ある状態の更新時に、他の状態にも更新を伝播させたい
- 状態を更新したら画面に勝手に反映されてほしい
- クラスの利用シーンに応じて、柔軟に依存関係を注入したい（テストなど、別のコンテキストでの実行時）

これらを実現するために、Riverpod では以下のような機能が実装されています。

- 各種の Provider による状態管理
- `ref.read`/ `ref.watch` による状態値の取得（および依存関係の注入）
- 状態値のキャッシュ
- 状態の変化を Widget に自動的に反映する

## Riverpod の基本構文

Riverpod では、**Provider**を定義し、`ref.read/watch` で状態を取得します。

### Provider の基本

Provider を定義する方法を説明します。Provider は状態変数を保持（キャッシュ）できます。

```dart
@riverpod
int myNumber(Ref ref){
  return 100;
}
```

これが、最も基本的な Provider の定義になります。この Provider は、`100` という整数を保持します。

Provider 同士は接続できます。他の Provider の値を使って、新しい Provider を定義することができます。他の Provider の値を取得するには、`ref.watch()`を使用します。

```dart
@riverpod
int doubledMyNumber(Ref ref){
  return ref.watch(myNumberProvider) * 2; //実行時、200を返す
}
```

この Provider では、myNumber の値を 2 倍して返します。よって、この Provider が保持する値は `200` になります。

### Widget から Provider を利用する

Provider の値を Widget で使用するには、通常の `StatelessWidget` ではなく `ConsumerWidget` を継承する必要があります。`ConsumerWidget` を使うことで、`build` メソッドに `WidgetRef ref` パラメータが追加され、これを通じて Provider にアクセスできるようになります。

```dart
// ❌ 通常のStatelessWidgetではProviderを使えない
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final number = ref.watch(myNumberProvider); //refが存在しないので、この行でエラーになる
    return Text('Number: $number');
  }
}

// ✅ ConsumerWidgetを使うとProviderにアクセスできる
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch() でProviderの値を取得
    final number = ref.watch(myNumberProvider);
    return Text('Number: $number');
  }
}
```

**_▫️ 練習問題_**

上記の myNumber と doubledMyNumber を定義し、アプリ画面の「My number : xxx」の箇所に表示しましょう。

@riverpod をつけてメソッドを実装した後、以下のコマンドでコードを生成してください：

```bash
dart run build_runner build -d
```

### Provider の種類

Provider は**class-based provider**と**functional provider**の二種類に分けられます。

参照（Riverpod 公式ドキュメント） → https://riverpod.dev/ja/docs/concepts/about_code_generation#provider-%E3%81%AE%E5%AE%9A%E7%BE%A9

#### Functional Provider

functional provider は、純粋な関数として定義される Provider です。副作用（API 呼び出し、ファイル書き込みなど）を持たず、入力に対して常に同じ出力を返します。

```dart
@riverpod
int myNumber(Ref ref) {
  return 100;  // 固定値を返す
}

@riverpod
int doubledCount(Ref ref) {
  final count = ref.watch(counterControllerProvider);
  return count * 2;  // 他のProviderの値を加工して返す
}
```

特徴：

- 計算結果や加工したデータを提供するのに適している
- 状態を直接変更することはできない（読み取り専用）

#### Class-based Provider

class-based provider は、クラスとして定義される Provider です。内部に状態を持ち、その状態を変更するメソッドを定義できます。

```dart
@riverpod
class CounterController extends _$CounterController {
  @override
  int build() => 0;  // 初期値を返す

  // 状態を変更するメソッド（副作用）
  void increment() {
    state++;  // stateプロパティで状態を更新
  }

  void reset() {
    state = 0;
  }
}
```

build()で返した値が初期値となり、これが state 変数に格納されます。定義したメソッドで state 変数に新しい値を代入すると、Provider の値が更新されます。state 変数は Riverpod がコード生成で定義している変数なので、変数名は state で固定です。

特徴：

- 状態を保持し、変更できる
- 外部（ボタンタップなど）からのアクションに対応する処理を実装できる

#### どちらを使うべきか？

使い分けの指針：

**Functional Provider を使う場面：**

- 他の Provider の値を計算・加工するだけの場合
- 純粋な計算ロジックを実装する場合
- 複数の Provider の値を組み合わせた状態を定義したい場合

**Class-based Provider を使う場面：**

- ユーザーの操作に応じて状態を変更する必要がある場合
- メソッドで状態を操作する必要がある場合

実際のアプリケーションでは、これらを組み合わせて使用します：

```dart
// Class-based: カウンターの状態管理
@riverpod
class CounterController extends _$CounterController {
  @override
  int build() => 0;

  void increment() {
    return state++;
  }
}

// Functional: カウンターの値を加工してStringを返す
@riverpod
String counterMessage(Ref ref) {
  final count = ref.watch(counterControllerProvider);
  return 'Current count: $count';
}

// Functional: 与えられたintが偶数かどうか判定してboolを返す
@riverpod
bool isCounterEven(Ref ref) {
  final count = ref.watch(counterControllerProvider);
  return count % 2 == 0;
}
```

**_▫️ 練習問題_**

`lib/controller/counter_controller.dart` に以下の機能を追加してください：

1. `CounterController` クラスに `decrement()` メソッドを追加し、カウンターを減らす機能を実装する
2. カウンターの値を 3 倍にする functional provider `tripledCount` を作成し、"Tripled Count :"の部分に表示する
3. カウンターが 10 以上かどうかを判定する functional provider `isCounterOverTen` を作成し、"Is counter over 10? : "の部分に表示する

ヒント：

- Class-based provider では `state` プロパティを使って状態を更新します
- Provider では `ref.watch()` で他の Provider の値を取得できます

### ref.read/watch について

Riverpod では、Provider の値を取得するために `ref.read()` と `ref.watch()` という 2 つのメソッドを使います。これらは似ているようで、重要な違いがあります。

#### ref.watch

`ref.watch()` は Provider の値を取得し、その Provider の値が変更されたときに**自動的に再ビルド**をトリガーします。

```dart
// Widget内での使用例
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // counterControllerProviderの値を監視
    final counter = ref.watch(counterControllerProvider);

    return Text('Counter: $counter');
    // カウンターが変更されるたびに、このWidgetが再ビルドされる
  }
}

// Provider内での使用例
@riverpod
String counterDisplay(Ref ref) {
  // 他のProviderの値を監視
  final counter = ref.watch(counterControllerProvider);
  return 'The count is $counter';
  // counterControllerProviderが変わると、このProviderも再計算される
}
```

**ref.watch の特徴：**

- リアクティブ：監視している Provider の値が変わると自動的に再実行される
- Widget の build メソッド内で使用する
- Provider の中で他の Provider を参照する際に使用する

#### ref.read

`ref.read()` は Provider の値を一度だけ取得します。値が変更されても再ビルドは**トリガーされません**。

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // ボタンが押されたときに一度だけ値を取得
        print("Count : ${ref.read(counterControllerProvider)}"); // コンソールに"Count : 1"のように表示される
      },
      child: Text('Push'),
    );
  }
}
```

**ref.read の特徴：**

- 非リアクティブ：値の変更を監視しない
- イベントハンドラ（onPressed、onTap など）内で使用する
- 一度だけ値を取得したい場合に使用する

#### 使い分けのルール

**ref.watch を使う場面：**

- Widget の build メソッド内で Provider の値を表示する
- Provider 内で他の Provider の値に依存した計算をする
- 値の変化に応じて UI や他の Provider を更新したい

**ref.read を使う場面：**

- ボタンのクリックなどのイベントハンドラ内
- initState などのライフサイクルメソッド内
- 値の変化を監視する必要がない一時的な処理

#### よくある間違い

```dart
// ❌ 間違い：build内でref.readを使う
class BadExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.read(counterControllerProvider); // ❌
    return Text('$counter');
    // カウンターが変わってもUIが更新されない！
  }
}

// ✅ 正解：build内ではref.watchを使う
class GoodExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterControllerProvider); // ✅
    return Text('$counter');
    // カウンターが変わるとUIが自動更新される
  }
}
```

```dart
// ❌ 間違い：イベントハンドラ内でref.watchを使う
onPressed: () {
  final counter = ref.watch(counterControllerProvider); // ❌
  // 不要な依存関係が作られる
}

// ✅ 正解：イベントハンドラ内ではref.readを使う
onPressed: () {
  final counter = ref.read(counterControllerProvider); // ✅
  // 値を一度だけ取得
}
```

#### .notifier の使い方

Class-based Provider のメソッドを呼びたい場合は、`.notifier` を付けてコントローラーのインスタンスを取得します：

```dart
// Providerの値を取得
final counterValue = ref.watch(counterControllerProvider);

// コントローラーのインスタンスを取得してメソッドを呼ぶ
final controller = ref.read(counterControllerProvider.notifier);
controller.increment();
```

**重要：** メソッドを呼ぶ場合は通常 `ref.read` を使います。`ref.watch` でコントローラーを監視する必要はありません。

### Future/StreamProvider - 非同期処理の扱い方

Riverpod では、非同期処理（API 呼び出し、データベース操作など）を扱うための専用の Provider があります。

#### FutureProvider

`FutureProvider` は非同期処理の結果を提供する Provider です。API からデータを取得する場合などに使用します。

```dart
// APIからユーザー情報を取得する例
@riverpod
Future<User> fetchUser(Ref ref) async {
  final userId = ref.watch(userIdProvider);
  final response = await http.get(
    Uri.parse('https://api.example.com/users/$userId'),
  );

  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}
```

**Widget から使用する方法：**

FutureProvider の値を ref.read/watch で取得すると、AsyncValue という型で返ってきます。AsyncValue は Value, Loading, Error という 3 つの状態を持ちます。Widget ではこれらの状態ごとの処理を実装しておきます。

```dart
class UserProfileWidget extends ConsumerWidget {
  const UserProfileWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncValueで非同期データを扱う
    final userAsync = ref.watch(fetchUserProvider);

    // switch式でパターンマッチング
    return switch (userAsync) {
      AsyncData(:final value) => Text('Hello, ${value.name}!'),
      AsyncLoading() => CircularProgressIndicator(),
      AsyncError(:final error) => Text('Error: $error'),
    };
  }
}
```

**他の Provider から利用する場合 :**

FutureProvider の値を普通に ref.read/watch すると AsyncValue が返ってきてしまいます。`ref.watch(provider.future)`のように、`.future` をつけることで、Provider が扱っている Future をそのまま取得することができます。

Provider でも AsyncValue で受け取ることは可能ですが、コードが煩雑になるため、FutureProvider の値を他の Provider で受け取る場合には`.future`を使って Future のまま処理する方がおすすめです。

```dart
// 別のFutureProviderから値を取得する例
@riverpod
Future<String> userGreeting(Ref ref) async {
  // .futureを使ってFutureのまま処理
  final user = await ref.watch(fetchUserProvider.future);
  return 'Welcome, ${user.name}!';
}

// 複数のFutureProviderを組み合わせる例
@riverpod
Future<UserProfile> completeUserProfile(Ref ref) async {
  // 複数のFutureProviderから値を取得
  final user = await ref.watch(fetchUserProvider.future);
  final posts = await ref.watch(fetchUserPostsProvider(user.id).future);
  final stats = await ref.watch(fetchUserStatsProvider(user.id).future);

  return UserProfile(
    user: user,
    posts: posts,
    statistics: stats,
  );
}
```

#### StreamProvider

`StreamProvider` はリアルタイムでデータを配信する Provider です。WebSocket 接続や Firestore のリアルタイムデータなどに使用します。
これも`Future Provider`と同様に `AsyncValue` を返します。

```dart
// 1秒ごとにカウントアップするストリームの例
@riverpod
Stream<int> counterStream(Ref ref) async* {
  int count = 0;
  while (true) {
    yield count++;
    await Future.delayed(Duration(seconds: 1));
  }
}

// Firestoreからリアルタイムでメッセージを取得する例
@riverpod
Stream<List<Message>> chatMessages(Ref ref) {
  return FirebaseFirestore.instance
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Message.fromFirestore(doc))
          .toList());
}
```

#### AsyncValue の詳細

`AsyncValue` は非同期データの状態を表現するクラスです。3 つの状態を持ちます：

1. **AsyncLoading**: データ読み込み中
2. **AsyncData**: データ取得成功
3. **AsyncError**: エラー発生

**パターンマッチングでの処理：**

```dart
// switch式を使った処理
final widget = switch (userAsync) {
  AsyncData(:final value) => UserCard(user: value),
  AsyncLoading() => LoadingSpinner(),
  AsyncError(:final error) => ErrorMessage(error: error),
  _ => LoadingSpinner(),
};
```

#### Class-based の非同期 Provider

Class-based Provider でも非同期処理を扱えます：

```dart
@riverpod
class UserController extends _$UserController {
  @override
  Future<User?> build() async { //buildの戻り値をFutureにすることで、FutureProviderになる
    // 初期データの取得
    return await _fetchCurrentUser();
  }

  Future<void> updateProfile(String name) async {
    // ローディング状態にする
    state = const AsyncLoading();

    try {
      final updatedUser = await _updateUserAPI(name);
      // 成功時、新しいデータで更新
      state = AsyncData(updatedUser);
    } catch (error, stackTrace) {
      // エラー時
      state = AsyncError(error, stackTrace);
    }
  }

  Future<User?> _fetchCurrentUser() async {
    // API呼び出しなど
  }

  Future<User> _updateUserAPI(String name) async {
    // API呼び出しなど
  }
}
```

**_▫️ 練習問題_**

カウンターアプリに遅延処理を実装します。TripledCount の値について、カウントの変化から 3 秒遅れで表示されるようにしましょう。

ヒント：

- TripledCount の Provider を FutureProvider にする
- `await Future.delayed()` を使って遅延を実装
- `swtich`式で FutureProvider の状態（AsyncValue）ごとに処理を分ける

## おまけ：Generator を使わない Provider 定義

これまでの講義では、`@riverpod` アノテーションと Riverpod Generator を使って Provider を定義してきました。実は、Generator を使わずに Provider を定義することも可能です。

### 手動での Provider 定義

Generator を使わない場合、以下のように Provider を定義します：

```dart
// Generatorなしでの定義（従来の方法）
final myNumberProvider = Provider<int>((ref) {
  return 100;
});

// StateNotifierProviderの例
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() {
    state++;
  }
}

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

// FutureProviderの例
final fetchUserProvider = FutureProvider<User>((ref) async {
  final response = await http.get(Uri.parse('...'));
  return User.fromJson(json.decode(response.body));
});
```

### Generator を使った場合との比較

同じ機能を Generator を使って実装すると：

```dart
// Generatorを使った定義（推奨）
@riverpod
int myNumber(Ref ref) {
  return 100;
}

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() {
    state++;
  }
}

@riverpod
Future<User> fetchUser(Ref ref) async {
  final response = await http.get(Uri.parse('...'));
  return User.fromJson(json.decode(response.body));
}
```

### なぜ Generator を使うべきか

Generator を使わない方法も完全に有効ですが、以下の理由から **Generator の使用が推奨されています**：

1. **コードがシンプル**: Provider の型を明示的に指定する必要がなく、コードが簡潔になります
2. **パラメータ対応**: Family Provider（パラメータ付き Provider）の実装が簡単です
3. **公式推奨**: Riverpod 公式ドキュメントでも Generator の使用が推奨されています

```dart
// パラメータ付きProviderの比較

// Generatorなし（複雑）
final userProvider = Provider.family<User, String>((ref, userId) {
  return fetchUserById(userId);
});

// Generatorあり（シンプル）
@riverpod
User user(Ref ref, String userId) {
  return fetchUserById(userId);
}
```

Generator を使わない方法を知っておくことは、既存のコードを理解する上で役立ちます。しかし、新しくコードを書く場合は、**Generator を使用することを強く推奨します**。

Generator を使うことで：

- コードがより読みやすくなる
- 開発効率が向上する
- Riverpod の最新機能を活用できる
- チーム開発での一貫性を保てる

この講義で学んだ Generator ベースの書き方を実践で活用していきましょう！

# まとめ

この講義では、Riverpod の基本的な使い方について学びました。最後にキーワードをまとめておきましょう。

- Provider の作成方法
  - Functional / Class-based Provider
- ref.read/watch の使い分け
- Future/Stream Provider
  - AsyncValue

これらの機能を活用すれば、単純なアプリの作成は始められます！

Riverpod の発展的な機能として以下のものがあります。さらに Riverpod について学びたい方は、以下のキーワードを[公式ドキュメント](https://riverpod.dev/ja/docs/introduction/getting_started)で検索してみましょう。

- **Family** : 初期の引数を与えつつ Provider を生成する機能
- **Consumer**：ConsumerWidget とは違う方法で Widget から Provider の状態を取得する方法
- **Provider Overrides**：実行環境で使用する Provider を選択（上書き）する方法。主にテストを書く際によく使います
