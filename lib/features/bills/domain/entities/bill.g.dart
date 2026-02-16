// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillImpl _$$BillImplFromJson(Map<String, dynamic> json) => _$BillImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  amount: (json['amount'] as num).toDouble(),
  dueDate: DateTime.parse(json['dueDate'] as String),
  frequency: json['frequency'] as String,
  category: json['category'] as String,
  paymentMethod: json['paymentMethod'] as String?,
  merchant: json['merchant'] as String?,
  isVariable: json['isVariable'] as bool? ?? false,
  averageAmount: (json['averageAmount'] as num?)?.toDouble(),
  status: json['status'] as String? ?? 'upcoming',
  paidDate: json['paidDate'] == null
      ? null
      : DateTime.parse(json['paidDate'] as String),
  paidTransactionId: json['paidTransactionId'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  autoDetected: json['autoDetected'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$BillImplToJson(_$BillImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'dueDate': instance.dueDate.toIso8601String(),
      'frequency': instance.frequency,
      'category': instance.category,
      'paymentMethod': instance.paymentMethod,
      'merchant': instance.merchant,
      'isVariable': instance.isVariable,
      'averageAmount': instance.averageAmount,
      'status': instance.status,
      'paidDate': instance.paidDate?.toIso8601String(),
      'paidTransactionId': instance.paidTransactionId,
      'isActive': instance.isActive,
      'autoDetected': instance.autoDetected,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
