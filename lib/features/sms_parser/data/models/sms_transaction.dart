import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../transactions/domain/entities/transaction.dart';
import 'package:uuid/uuid.dart';

part 'sms_transaction.freezed.dart';
part 'sms_transaction.g.dart';

@freezed
class SmsTransaction with _$SmsTransaction {
  const SmsTransaction._();
  
  const factory SmsTransaction({
    required double amount,
    required String category,
    required String description,
    required DateTime date,
    required String type,
    String? transactionId,
    @Default(false) bool isTransfer,
    @Default(0.0) double fee,
    double? recordedBalance,
    double? fulizaBalance,
    DateTime? fulizaDueDate,
    double? ziidiBalance,
    String? counterparty,
  }) = _SmsTransaction;

  factory SmsTransaction.fromJson(Map<String, dynamic> json) => _$SmsTransactionFromJson(json);
  
  Transaction toTransaction() {
    return Transaction(
      id: const Uuid().v4(),
      amount: amount,
      category: category,
      description: description,
      date: date,
      type: type,
      transactionId: transactionId,
      isTransfer: isTransfer,
      fee: fee,
    );
  }
}
