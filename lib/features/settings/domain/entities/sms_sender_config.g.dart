// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_sender_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmsSenderConfigImpl _$$SmsSenderConfigImplFromJson(
  Map<String, dynamic> json,
) => _$SmsSenderConfigImpl(
  id: json['id'] as String,
  senderName: json['senderName'] as String,
  accountType: json['accountType'] as String,
  accountId: json['accountId'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$SmsSenderConfigImplToJson(
  _$SmsSenderConfigImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'senderName': instance.senderName,
  'accountType': instance.accountType,
  'accountId': instance.accountId,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
};
