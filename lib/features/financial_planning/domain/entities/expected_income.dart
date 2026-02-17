import 'package:freezed_annotation/freezed_annotation.dart';

part 'expected_income.freezed.dart';
part 'expected_income.g.dart';

@freezed
class ExpectedIncome with _$ExpectedIncome {
  const factory ExpectedIncome({
    required String id,
    required String name,
    required double amount,
    required String frequency,
    required String category,
    required DateTime nextExpectedDate,
    @Default(true) bool isActive,
  }) = _ExpectedIncome;

  factory ExpectedIncome.fromJson(Map<String, dynamic> json) =>
      _$ExpectedIncomeFromJson(json);
}
