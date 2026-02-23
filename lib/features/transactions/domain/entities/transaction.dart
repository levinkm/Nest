import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required double amount,
    required String category,
    required String description,
    required DateTime date,
    required String type,
    String? transactionId,
    @Default(false) bool isTransfer,
    @Default(0.0) double fee,
    String? accountId,
    String? toAccountId,
    String? notes,
    String? counterparty,
    @Default([]) List<String> tags,
    double? accountBalance,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
