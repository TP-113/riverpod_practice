import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HooksPage extends HookWidget {
  const HooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // タイマーの状態管理
    final seconds = useState(0);
    final isRunning = useState(false);
    final timer = useRef<Timer?>(null);

    // タイマーの開始/停止制御

    // 課題１：タイマーの開始/停止制御をuseEffectを使って実装してください
    // ヒント：
    //  1秒ごとに秒数を足す処理：
    //    timer.value = Timer.periodic(Duration(seconds: 1), (timer) {
    //      if (isRunning.value) {
    //        seconds.value += 1;
    //      }
    //    });
    //  タイマーの停止：
    //    timer.value?.cancel();
    //  useEffectの第二引数に変数を与えると、その変数が変化した時にuseEffectの処理が実行されます

    useEffect(() {
      // Widgetが破棄される時の処理
      return () {
        timer.value?.cancel();
      };
    }, []);

    // フォーマットされた時間文字列をメモ化
    final formattedTime = useMemoized(() {
      final minutes = seconds.value ~/ 60;
      final remainingSeconds = seconds.value % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }, [seconds.value]);

    // イベントハンドラーをメモ化
    final toggleTimer = useCallback(() {
      isRunning.value = !isRunning.value;
    }, []);

    final resetTimer = useCallback(() {
      // 課題２：ここに表示時間をリセットする処理を追加
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマーアプリ'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // メインタイマー表示
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isRunning.value
                    ? Colors.green.shade50
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isRunning.value
                      ? Colors.green.shade300
                      : Colors.blue.shade300,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '経過時間',
                    style: TextStyle(
                      fontSize: 18,
                      color: isRunning.value
                          ? Colors.green.shade700
                          : Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: isRunning.value
                          ? Colors.green.shade800
                          : Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // コントロールボタン
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 開始/停止ボタン
                ElevatedButton(
                  onPressed: toggleTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRunning.value
                        ? Colors.red
                        : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isRunning.value ? Icons.pause : Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text(
                        isRunning.value ? '停止' : '開始',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // リセットボタン
                ElevatedButton(
                  onPressed: resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 8),
                      Text(
                        'リセット',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            const Spacer(),

            // ステータス表示
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isRunning.value
                    ? Colors.green.shade100
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isRunning.value ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isRunning.value ? '実行中' : '停止中',
                    style: TextStyle(
                      color: isRunning.value
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
