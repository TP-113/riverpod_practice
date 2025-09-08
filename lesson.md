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

### Provider の種類

Provider は**class-based provider**と**functional provider**の二種類に分けられます。

参照（Riverpod 公式ドキュメント） → https://riverpod.dev/ja/docs/concepts/about_code_generation#provider-%E3%81%AE%E5%AE%9A%E7%BE%A9

- class-based provider
  - 関数で副作用を実行できる Provider
- functional provider
  - 副作用を実行できない Provider

前の節で紹介したのは functional provider です。

実際には、これらの Provider は以下のように定義できます。

```dart
@riverpod
// class-based provider
class CounterController extends _$CounterController {
  @override
  int build() => 0;

  void increment() {
    state++;
  }
}

@riverpod
// functional provider
int doubledCount(Ref ref) {
  return ref.watch(counterControllerProvider) * 2;
}
```
