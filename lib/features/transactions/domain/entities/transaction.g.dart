// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      transactionId: json['transactionId'] as String?,
      isTransfer: json['isTransfer'] as bool? ?? false,
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      accountId: json['accountId'] as String?,
      toAccountId: json['toAccountId'] as String?,
      notes: json['notes'] as String?,
      counterparty: json['counterparty'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      accountBalance: (json['accountBalance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'category': instance.category,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'type': instance.type,
      'transactionId': instance.transactionId,
      'isTransfer': instance.isTransfer,
      'fee': instance.fee,
      'accountId': instance.accountId,
      'toAccountId': instance.toAccountId,
      'notes': instance.notes,
      'counterparty': instance.counterparty,
      'tags': instance.tags,
      'accountBalance': instance.accountBalance,
    };
