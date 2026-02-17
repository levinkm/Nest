import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  const Account._();

  const factory Account({
    required String id,
    required String name,
    required String type, // 'mpesa', 'bank', 'cash'
    required double balance, // Calculated balance
    required double recordedBalance, // From last SMS
    required double creditLimit, // Fuliza/Ziidi limit
    DateTime? lastSmsDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Account;

  double get debtBalance => balance < 0 ? balance.abs() : 0.0;
  double get availableCredit => creditLimit - debtBalance;
  double get utilizationPercentage =>
      creditLimit > 0 ? (debtBalance / creditLimit) * 100 : 0;
  bool get isOverdrawn => balance < 0;
  double get balanceDifference => balance - recordedBalance;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
