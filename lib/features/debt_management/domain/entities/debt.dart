import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt.freezed.dart';
part 'debt.g.dart';

@freezed
class Debt with _$Debt {
  const Debt._();
  
  const factory Debt({
    required String id,
    required String name,
    required double principal,
    required double creditLimit,
    required double interestRate,
    required String interestType,
    DateTime? dueDate,
    required DateTime createdAt,
    @Default(true) bool isActive,
  }) = _Debt;

  double get availableCredit => creditLimit - principal;
  double get utilizationPercentage => creditLimit > 0 ? (principal / creditLimit) * 100 : 0;
  bool get isMaxedOut => principal >= creditLimit;

  factory Debt.fromJson(Map<String, dynamic> json) => _$DebtFromJson(json);
}
