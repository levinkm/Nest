// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmsTransactionImpl _$$SmsTransactionImplFromJson(Map<String, dynamic> json) =>
    _$SmsTransactionImpl(
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      transactionId: json['transactionId'] as String?,
      isTransfer: json['isTransfer'] as bool? ?? false,
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      recordedBalance: (json['recordedBalance'] as num?)?.toDouble(),
      fulizaBalance: (json['fulizaBalance'] as num?)?.toDouble(),
      fulizaDueDate: json['fulizaDueDate'] == null
          ? null
          : DateTime.parse(json['fulizaDueDate'] as String),
      ziidiBalance: (json['ziidiBalance'] as num?)?.toDouble(),
      counterparty: json['counterparty'] as String?,
    );

Map<String, dynamic> _$$SmsTransactionImplToJson(
  _$SmsTransactionImpl instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'category': instance.category,
  'description': instance.description,
  'date': instance.date.toIso8601String(),
  'type': instance.type,
  'transactionId': instance.transactionId,
  'isTransfer': instance.isTransfer,
  'fee': instance.fee,
  'recordedBalance': instance.recordedBalance,
  'fulizaBalance': instance.fulizaBalance,
  'fulizaDueDate': instance.fulizaDueDate?.toIso8601String(),
  'ziidiBalance': instance.ziidiBalance,
  'counterparty': instance.counterparty,
};
