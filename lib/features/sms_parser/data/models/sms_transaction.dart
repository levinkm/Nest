import 'package:freezed_annotation/freezed_annotation.dart';

part 'sms_transaction.freezed.dart';
part 'sms_transaction.g.dart';

@freezed
class SmsTransaction with _$SmsTransaction {
  const factory SmsTransaction({
    required double amount,
    required String category,
    required String description,
    required DateTime date,
    required String type,
    String? transactionId,
    @Default(false) bool isTransfer,
  }) = _SmsTransaction;

  factory SmsTransaction.fromJson(Map<String, dynamic> json) => _$SmsTransactionFromJson(json);
}
