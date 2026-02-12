// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LedgerEntryImpl _$$LedgerEntryImplFromJson(Map<String, dynamic> json) =>
    _$LedgerEntryImpl(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      accountId: json['accountId'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      debit: (json['debit'] as num).toDouble(),
      credit: (json['credit'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
      category: json['category'] as String?,
      reference: json['reference'] as String?,
    );

Map<String, dynamic> _$$LedgerEntryImplToJson(_$LedgerEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionId': instance.transactionId,
      'accountId': instance.accountId,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'debit': instance.debit,
      'credit': instance.credit,
      'balance': instance.balance,
      'fee': instance.fee,
      'category': instance.category,
      'reference': instance.reference,
    };
