// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DebtImpl _$$DebtImplFromJson(Map<String, dynamic> json) => _$DebtImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  principal: (json['principal'] as num).toDouble(),
  creditLimit: (json['creditLimit'] as num).toDouble(),
  interestRate: (json['interestRate'] as num).toDouble(),
  interestType: json['interestType'] as String,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$$DebtImplToJson(_$DebtImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'principal': instance.principal,
      'creditLimit': instance.creditLimit,
      'interestRate': instance.interestRate,
      'interestType': instance.interestType,
      'dueDate': instance.dueDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'isActive': instance.isActive,
    };
