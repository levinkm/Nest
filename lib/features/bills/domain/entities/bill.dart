import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill.freezed.dart';
part 'bill.g.dart';

@freezed
class Bill with _$Bill {
  const Bill._();

  const factory Bill({
    required String id,
    required String name,
    required double amount,
    required DateTime dueDate,
    required String frequency,
    required String category,
    String? paymentMethod,
    String? merchant,
    @Default(false) bool isVariable,
    double? averageAmount,
    @Default('upcoming') String status,
    DateTime? paidDate,
    String? paidTransactionId,
    @Default(true) bool isActive,
    @Default(false) bool autoDetected,
    DateTime? createdAt,
  }) = _Bill;

  bool get isOverdue => status == 'upcoming' && DateTime.now().isAfter(dueDate);

  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
}
