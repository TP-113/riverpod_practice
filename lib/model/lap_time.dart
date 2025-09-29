import 'package:freezed_annotation/freezed_annotation.dart';

part 'lap_time.freezed.dart';

// ラップタイム情報を表現するFreezedクラス
@freezed
abstract class LapTime with _$LapTime {
  const factory LapTime({
    required int lapNumber, // ラップ番号
    required int totalSeconds, // その時点での総経過時間（秒）
  }) = _LapTime;
}
