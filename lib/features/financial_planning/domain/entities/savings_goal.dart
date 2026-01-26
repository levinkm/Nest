import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_goal.freezed.dart';
part 'savings_goal.g.dart';

@freezed
class SavingsGoal with _$SavingsGoal {
  const factory SavingsGoal({
    required String id,
    required String name,
    required double targetAmount,
    required double currentAmount,
    required DateTime targetDate,
    required DateTime createdAt,
    @Default(true) bool isActive,
  }) = _SavingsGoal;

  factory SavingsGoal.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalFromJson(json);
}
