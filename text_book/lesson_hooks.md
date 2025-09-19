# Flutter Hooks について学ぼう

【ゴール】Flutter で再利用可能な状態管理とライフサイクル処理を簡単に実装できるパッケージ：[Flutter Hooks](https://pub.dev/packages/flutter_hooks) について理解できる

- Flutter Hooks の基本概念を理解する
- 主要な Hooks の使い方を学ぶ
- 従来の StatefulWidget との違いを理解する
- 実践的なアプリケーションでの活用方法を学ぶ

## Flutter Hooks とは

Flutter Hooks は、React の Hooks にインスパイアされた Flutter の状態管理ライブラリです。StatefulWidget の複雑なライフサイクル管理を簡潔に記述できるようになります。

### 従来の StatefulWidget の問題点

```dart
class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    // 初期化処理
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    // クリーンアップ処理
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('時間: $_seconds秒'),
        ElevatedButton(
          onPressed: _isRunning ? _stopTimer : _startTimer,
          child: Text(_isRunning ? '停止' : '開始'),
        ),
      ],
    );
  }
}
```

**StatefulWidget の問題点：**

- ライフサイクル管理が複雑
- 状態とロジックが混在
- 再利用が困難
- テストが難しい

### Flutter Hooks を使った解決

```dart
class TimerWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final seconds = useState(0);
    final isRunning = useState(false);
    final timer = useRef<Timer?>(null);

    useEffect(() {
      if (isRunning.value) {
        timer.value = Timer.periodic(Duration(seconds: 1), (timer) {
          seconds.value++;
        });
      } else {
        timer.value?.cancel();
      }

      return () => timer.value?.cancel(); // クリーンアップ
    }, [isRunning.value]);

    return Column(
      children: [
        Text('時間: ${seconds.value}秒'),
        ElevatedButton(
          onPressed: () => isRunning.value = !isRunning.value,
          child: Text(isRunning.value ? '停止' : '開始'),
        ),
      ],
    );
  }
}
```

**Flutter Hooks の利点：**

- 簡潔で読みやすいコード
- 状態とロジックの分離
- 再利用可能なロジック
- 自動的なライフサイクル管理

## Flutter Hooks の基本的な使い方

### 1. パッケージの追加

`pubspec.yaml` に以下の依存関係を追加します：

```yaml
dependencies:
  flutter_hooks: ^0.20.5
  hooks_riverpod: ^2.6.1

dev_dependencies:
  build_runner: ^2.4.7
```

### 2. 基本的な Hooks

#### useState - 状態管理

`useState(初期値)`とすることで、state を定義できます。state は Widget が破棄されるまで保持され、再描画されても値が変化しません。

```dart
class CounterWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final count = useState(0);

    return Column(
      children: [
        Text('カウント: ${count.value}'),
        ElevatedButton(
          onPressed: () => count.value++,
          child: Text('インクリメント'),
        ),
      ],
    );
  }
}
```

#### useEffect - 副作用の管理

Widget の初期化とクリーンアップ時の処理を簡潔に記述することができます。イベントのリスナーを登録したり、初回のみの API 通信を行ったりします。

```dart
class DataWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final data = useState<String?>(null);
    final isLoading = useState(true);

    useEffect(() {
      // データ取得処理
      Future.delayed(Duration(seconds: 2), () {
        data.value = '取得したデータ';
        isLoading.value = false;
      });

      return null; // クリーンアップ関数（不要な場合は null）
    }, []); // 依存配列（空の場合は初回のみ実行）

    if (isLoading.value) {
      return CircularProgressIndicator();
    }

    return Text('データ: ${data.value}');
  }
}
```

#### useRef - 参照の保持

主に mutable なオブジェクトを保持したいときに使います。
FlutterHooks には、よく使うオブジェクトの useRef はあらかじめ定義されています（use~の形）。

```dart
class TextFieldWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();

    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: 'テキストを入力してください',
      ),
    );
  }
}
```

## 高度な Hooks の機能

### 1. カスタム Hooks の作成

```dart
// カスタム Hook
ValueNotifier<int> useCounter({int initialValue = 0}) {
  final counter = useState(initialValue);

  final increment = useCallback(() {
    counter.value++;
  }, [counter.value]);

  final decrement = useCallback(() {
    counter.value--;
  }, [counter.value]);

  final reset = useCallback(() {
    counter.value = initialValue;
  }, [counter.value, initialValue]);

  return ValueNotifier({
    'value': counter.value,
    'increment': increment,
    'decrement': decrement,
    'reset': reset,
  });
}

// 使用例
class CounterWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useCounter(initialValue: 10);

    return Column(
      children: [
        Text('カウント: ${counter.value['value']}'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: counter.value['decrement'],
              child: Text('-'),
            ),
            ElevatedButton(
              onPressed: counter.value['reset'],
              child: Text('リセット'),
            ),
            ElevatedButton(
              onPressed: counter.value['increment'],
              child: Text('+'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### 2. 複数の Hooks の組み合わせ

```dart
class CounterWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    final step = useState(1);
    final history = useState<List<int>>([]);

    // カウント履歴をメモ化
    final formattedHistory = useMemoized(() {
      return history.value.map((value) => 'カウント: $value').toList();
    }, [history.value]);

    // カウントアップ関数をメモ化
    final increment = useCallback(() {
      count.value += step.value;
      history.value = [...history.value, count.value];
    }, [count.value, step.value]);

    // カウントダウン関数をメモ化
    final decrement = useCallback(() {
      count.value -= step.value;
      history.value = [...history.value, count.value];
    }, [count.value, step.value]);

    // リセット関数をメモ化
    final reset = useCallback(() {
      count.value = 0;
      history.value = [];
    }, []);

    // ステップ変更関数をメモ化
    final changeStep = useCallback((int newStep) {
      step.value = newStep;
    }, []);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'カウント: ${count.value}',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text('ステップ: ${step.value}'),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: decrement,
              child: Text('-${step.value}'),
            ),
            ElevatedButton(
              onPressed: increment,
              child: Text('+${step.value}'),
            ),
            ElevatedButton(
              onPressed: reset,
              child: Text('リセット'),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => changeStep(1),
              child: Text('ステップ1'),
            ),
            ElevatedButton(
              onPressed: () => changeStep(5),
              child: Text('ステップ5'),
            ),
            ElevatedButton(
              onPressed: () => changeStep(10),
              child: Text('ステップ10'),
            ),
          ],
        ),
        if (history.value.isNotEmpty) ...[
          SizedBox(height: 20),
          Text('履歴:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            height: 200,
            child: ListView.builder(
              itemCount: formattedHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(formattedHistory[index]),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
```

### 3. 非同期処理での使用

```dart
class ApiWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final data = useState<Map<String, dynamic>?>(null);
    final isLoading = useState(false);
    final error = useState<String?>(null);

    final fetchData = useCallback(() async {
      isLoading.value = true;
      error.value = null;

      try {
        // 模擬的な API 呼び出し
        await Future.delayed(Duration(seconds: 2));
        data.value = {
          'id': 1,
          'name': 'サンプルデータ',
          'timestamp': DateTime.now().toIso8601String(),
        };
      } catch (e) {
        error.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }, []);

    // 初回読み込み
    useEffect(() {
      fetchData();
      return null;
    }, []);

    if (isLoading.value) {
      return Center(child: CircularProgressIndicator());
    }

    if (error.value != null) {
      return Column(
        children: [
          Text('エラー: ${error.value}'),
          ElevatedButton(
            onPressed: fetchData,
            child: Text('再試行'),
          ),
        ],
      );
    }

    return Column(
      children: [
        Text('ID: ${data.value?['id']}'),
        Text('名前: ${data.value?['name']}'),
        Text('取得時刻: ${data.value?['timestamp']}'),
        ElevatedButton(
          onPressed: fetchData,
          child: Text('更新'),
        ),
      ],
    );
  }
}
```

## Riverpod と Hooks の組み合わせ

Riverpod と Hooks を組み合わせることで、より強力な状態管理を実現できます。Riverpod と Hook の状態管理を同じ Widget で同居させることが可能です。Widget 本体の動作ロジックを Hooks で管理し、Widget に表示するパラメータなどの管理は Riverpod で行うというふうに使い分けます。

### 1. HookConsumerWidget の使用

Riverpod と Hooks を同時に使用する場合は、HookConsumerWidget を継承します。

```dart
class UserProfileWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isLoading = useState(false);

    final updateProfile = useCallback(() async {
      isLoading.value = true;
      try {
        await ref.read(userControllerProvider.notifier).updateProfile();
      } finally {
        isLoading.value = false;
      }
    }, []);

    return Column(
      children: [
        Text('ユーザー: ${user.name}'),
        ElevatedButton(
          onPressed: isLoading.value ? null : updateProfile,
          child: isLoading.value
              ? CircularProgressIndicator()
              : Text('プロフィール更新'),
        ),
      ],
    );
  }
}
```

## パフォーマンス最適化

### 1. useMemoized による計算の最適化

計算結果をメモ化して、再描画による不要な再計算を防ぐことができます。

```dart
class ExpensiveListWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final items = useState<List<int>>([]);
    final filter = useState('');

    // 重いフィルタリング処理をメモ化
    final filteredItems = useMemoized(() {
      print('フィルタリング実行中...');
      return items.value.where((item) =>
        item.toString().contains(filter.value)
      ).toList();
    }, [items.value, filter.value]);

    // ソート処理もメモ化
    final sortedItems = useMemoized(() {
      return [...filteredItems]..sort();
    }, [filteredItems]);

    return Column(
      children: [
        TextField(
          onChanged: (value) => filter.value = value,
          decoration: InputDecoration(hintText: 'フィルタ'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sortedItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('アイテム: ${sortedItems[index]}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

### 2. useCallback による関数の最適化

useCallback を利用することで関数定義をキャッシュできます。

```dart
class OptimizedListWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final items = useState<List<String>>([]);

    // 関数をメモ化して不要な再作成を防ぐ
    final addItem = useCallback(() {
      items.value = [...items.value, 'アイテム ${items.value.length + 1}'];
    }, [items.value]);

    final removeItem = useCallback((int index) {
      items.value = items.value.where((_, i) => i != index).toList();
    }, [items.value]);

    return Column(
      children: [
        ElevatedButton(
          onPressed: addItem,
          child: Text('アイテム追加'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.value.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items.value[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => removeItem(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

**_▫️ 練習問題_**

`lib/view/hooks_page.dart` にタイマーアプリを実装してください：

**実装する内容：**

- 開始/停止ボタン
- リセットボタン
- 経過時間の表示（分:秒形式）
- タイマーの状態に応じた UI の変化

**課題 １:**

useEffect を使って、開始・停止ボタンを押したときにタイマーが起動・停止し、1 秒ごとに秒数が更新されるようにしましょう。

**課題 2:**

resetTimer の中身を実装し、リセットボタンを押すとタイマーの秒数がリセットされるようにしましょう。

**ヒント：**

- `Timer.periodic` を使用してタイマーを実装
- `useEffect` の依存配列を適切に設定

# まとめ

この講義では、Flutter Hooks の基本的な使い方について学びました。最後にキーワードをまとめておきましょう。

- 状態管理: `useState`
- 副作用の管理: `useEffect`
- 参照の保持: `useRef`
- 関数のメモ化: `useCallback`
- 値のメモ化: `useMemoized`
- カスタム Hooks の作成
- Riverpod との組み合わせ
- パフォーマンス最適化

これらの機能を活用すれば、より保守性が高く、再利用可能な Flutter アプリケーションを作成できます！

Flutter Hooks の発展的な機能として以下のものがあります。さらに Flutter Hooks について学びたい方は、以下のキーワードを[公式ドキュメント](https://pub.dev/packages/flutter_hooks)で検索してみましょう。

- **useAnimationController**: アニメーション制御
- **useStream**: ストリームの購読
- **useFuture**: Future の管理
- **useListenable**: Listenable の購読
- **useValueNotifier**: ValueNotifier の管理
