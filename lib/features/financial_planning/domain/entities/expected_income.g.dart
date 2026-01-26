// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expected_income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpectedIncomeImpl _$$ExpectedIncomeImplFromJson(Map<String, dynamic> json) =>
    _$ExpectedIncomeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      frequency: json['frequency'] as String,
      category: json['category'] as String,
      nextExpectedDate: DateTime.parse(json['nextExpectedDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$ExpectedIncomeImplToJson(
  _$ExpectedIncomeImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'amount': instance.amount,
  'frequency': instance.frequency,
  'category': instance.category,
  'nextExpectedDate': instance.nextExpectedDate.toIso8601String(),
  'isActive': instance.isActive,
};
