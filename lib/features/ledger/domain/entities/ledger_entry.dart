import 'package:freezed_annotation/freezed_annotation.dart';

part 'ledger_entry.freezed.dart';
part 'ledger_entry.g.dart';

@freezed
class LedgerEntry with _$LedgerEntry {
  const factory LedgerEntry({
    required String id,
    required String transactionId,
    required String accountId,
    required DateTime date,
    required String description,
    required double debit,
    required double credit,
    required double balance,
    required double fee,
    String? category,
    String? reference,
  }) = _LedgerEntry;

  factory LedgerEntry.fromJson(Map<String, dynamic> json) =>
      _$LedgerEntryFromJson(json);
}
