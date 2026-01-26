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
    };
