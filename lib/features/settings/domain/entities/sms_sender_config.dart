import 'package:freezed_annotation/freezed_annotation.dart';

part 'sms_sender_config.freezed.dart';
part 'sms_sender_config.g.dart';

@freezed
class SmsSenderConfig with _$SmsSenderConfig {
  const factory SmsSenderConfig({
    required String id,
    required String senderName,
    required String accountType, // 'mpesa', 'bank', 'ziidi'
    String? accountId,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _SmsSenderConfig;

  factory SmsSenderConfig.fromJson(Map<String, dynamic> json) =>
      _$SmsSenderConfigFromJson(json);
}
