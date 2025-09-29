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

    // 練習問題：Hooks 1 - useEffectを使って開始・停止ボタンでタイマーが起動・停止し、1秒ごとに秒数が更新されるように実装
    useEffect(() {
      if (isRunning.value) {
        // タイマーが開始状態の場合、1秒ごとに秒数を増加
        timer.value = Timer.periodic(Duration(seconds: 1), (timer) {
          seconds.value += 1;
        });
      } else {
        // タイマーが停止状態の場合、タイマーをキャンセル
        timer.value?.cancel();
      }

      return null;
    }, [isRunning.value]); // isRunning.valueが変化した時にuseEffectが実行される

    useEffect(() {
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
      // 練習問題：Hooks 2 - resetTimerの中身を実装し、リセットボタンでタイマーの秒数がリセットされるように実装
      // タイマーを停止
      isRunning.value = false;
      // 秒数を0にリセット
      seconds.value = 0;
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
                color:
                    isRunning.value
                        ? Colors.green.shade50
                        : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isRunning.value
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
                      color:
                          isRunning.value
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
                      color:
                          isRunning.value
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
                    backgroundColor:
                        isRunning.value ? Colors.red : Colors.green,
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
                color:
                    isRunning.value
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
                      color:
                          isRunning.value
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
