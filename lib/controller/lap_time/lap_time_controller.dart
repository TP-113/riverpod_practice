import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../model/lap_time.dart';

part 'lap_time_controller.g.dart';

// ラップタイム情報を保持・更新するProvider
@riverpod
class LapTimeController extends _$LapTimeController {
  @override
  List<LapTime> build() {
    // 初期値として空のリストを返す
    return [];
  }

  // ラップタイムを追加する
  void addLapTime(int totalSeconds) {
    final lapNumber = state.length + 1;
    final lapTime = LapTime(lapNumber: lapNumber, totalSeconds: totalSeconds);

    state = [...state, lapTime];
  }

  // 全てのラップタイムをクリアする
  void clearAllLapTimes() {
    state = [];
  }
}
