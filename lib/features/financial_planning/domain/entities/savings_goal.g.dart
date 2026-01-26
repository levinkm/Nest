// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavingsGoalImpl _$$SavingsGoalImplFromJson(Map<String, dynamic> json) =>
    _$SavingsGoalImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      targetDate: DateTime.parse(json['targetDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$SavingsGoalImplToJson(_$SavingsGoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'targetAmount': instance.targetAmount,
      'currentAmount': instance.currentAmount,
      'targetDate': instance.targetDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'isActive': instance.isActive,
    };
