# Riverpod について学ぼう

ゴール: スニダンで使用している状態管理フレームワーク：Riverpod について理解できる

- Riverpod の主要なインターフェースを理解する
  - Provider
  - [ref.watch](http://ref.watch)/read
- Riverpod の Generator 機能を使って、Provider を生成できる

# 状態管理とは

アプリケーションにおける「状態（State）」とは、アプリケーションが保持する動的なデータのことです。

状態管理の例)

- ユーザーの入力内容（テキストフィールドの値、チェックボックスの状態など）
- API から取得したデータ（ユーザー情報、商品リストなど）
- UI の表示状態（ローディング中、エラー表示、タブの選択状態など）
- アプリ全体の設定（ダークモード、言語設定など）

これらの状態は時間とともに変化し、その変化に応じて UI を更新する必要があります。

## なぜ状態管理が必要なのか

Flutter アプリケーションでは、以下のような課題があります：

1. **Widget 間の状態の共有**: 複数の Widget で同じデータを使いたい
2. **状態の永続化**: 画面遷移しても状態を保持したい
3. **状態の更新と反映**: データが変わったら自動的に UI を更新したい
4. **依存関係の管理**: ある状態が変わったら、関連する他の状態も更新したい

これらの課題を解決するために、状態管理フレームワークが必要になります。

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
}
```

`setState()`の問題点：

- 状態が Widget 内に閉じ込められる（他の Widget と共有できない）
- 大規模なアプリケーションでは管理が複雑になる
- 状態の依存関係を手動で管理する必要がある

そこで、Riverpod のような状態管理フレームワークを使うことで、これらの問題を解決できます。

# サンプルプロジェクトのダウンロード

今回の講義で ↓ のプロジェクトを使用するので、git でクローンしておいてください。

[https://github.com/TP-113/riverpod_practice.git](https://github.com/TP-113/riverpod_practice.git)

# Riverpod

Riverpod は、Flutter の状態管理・画面反映まわりの処理についての包括的なフレームワークです。

Riverpod は以下のような課題を解決してくれます。

- 状態管理のための変数・インスタンスを楽に管理したい
- 状態更新時に、他の状態にも更新を伝播させたい
- 状態を更新したら画面に勝手に反映されてほしい
- クラスの利用シーンに応じて、柔軟に依存関係を注入したい（テストなど、別のコンテキストでの実行時）

これらを実現するために、Riverpod では以下のような機能が実装されています。

- 各種の Provider による状態管理
- `ref.read`/ `ref.watch` による依存関係の注入（状態値の取得）
- 状態値のキャッシュ
- 状態の変化を Widget に自動的に反映する

## Riverpod の基本構文

Riverpod では、**Provider**を定義し、`ref.read/watch` で状態を取得します。

### Pvovider の基本

Provider を定義する方法を説明します。Provider は状態変数を保持できます。

```dart
@riverpod
int myNumber(Ref ref){
  return 100;
}
```

これが、最も基本的な Provider の定義になります。この Provider は、100 という整数を保持します。

Provider 同士は接続できます。他の Provider の値を使って、新しい Provider を定義することができます。他の Provider の値を取得するには、`ref.watch()`を使用します。

```dart
@riverpod
int doubledMyNumber(Ref ref){
  return ref.watch(myNumberProvider) * 2; //実行時、200を返す
}
```

この Provider では、myNumber の値を 2 倍して返します。よって、この Provider が保持する値は 200 になります。

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
