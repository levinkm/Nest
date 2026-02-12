// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_sender_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SmsSenderConfig _$SmsSenderConfigFromJson(Map<String, dynamic> json) {
  return _SmsSenderConfig.fromJson(json);
}

/// @nodoc
mixin _$SmsSenderConfig {
  String get id => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get accountType =>
      throw _privateConstructorUsedError; // 'mpesa', 'bank', 'ziidi'
  String? get accountId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SmsSenderConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmsSenderConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmsSenderConfigCopyWith<SmsSenderConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmsSenderConfigCopyWith<$Res> {
  factory $SmsSenderConfigCopyWith(
    SmsSenderConfig value,
    $Res Function(SmsSenderConfig) then,
  ) = _$SmsSenderConfigCopyWithImpl<$Res, SmsSenderConfig>;
  @useResult
  $Res call({
    String id,
    String senderName,
    String accountType,
    String? accountId,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class _$SmsSenderConfigCopyWithImpl<$Res, $Val extends SmsSenderConfig>
    implements $SmsSenderConfigCopyWith<$Res> {
  _$SmsSenderConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmsSenderConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderName = null,
    Object? accountType = null,
    Object? accountId = freezed,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            senderName: null == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String,
            accountType: null == accountType
                ? _value.accountType
                : accountType // ignore: cast_nullable_to_non_nullable
                      as String,
            accountId: freezed == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SmsSenderConfigImplCopyWith<$Res>
    implements $SmsSenderConfigCopyWith<$Res> {
  factory _$$SmsSenderConfigImplCopyWith(
    _$SmsSenderConfigImpl value,
    $Res Function(_$SmsSenderConfigImpl) then,
  ) = __$$SmsSenderConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String senderName,
    String accountType,
    String? accountId,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SmsSenderConfigImplCopyWithImpl<$Res>
    extends _$SmsSenderConfigCopyWithImpl<$Res, _$SmsSenderConfigImpl>
    implements _$$SmsSenderConfigImplCopyWith<$Res> {
  __$$SmsSenderConfigImplCopyWithImpl(
    _$SmsSenderConfigImpl _value,
    $Res Function(_$SmsSenderConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SmsSenderConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderName = null,
    Object? accountType = null,
    Object? accountId = freezed,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$SmsSenderConfigImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        senderName: null == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String,
        accountType: null == accountType
            ? _value.accountType
            : accountType // ignore: cast_nullable_to_non_nullable
                  as String,
        accountId: freezed == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SmsSenderConfigImpl implements _SmsSenderConfig {
  const _$SmsSenderConfigImpl({
    required this.id,
    required this.senderName,
    required this.accountType,
    this.accountId,
    this.isActive = true,
    required this.createdAt,
  });

  factory _$SmsSenderConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmsSenderConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String senderName;
  @override
  final String accountType;
  // 'mpesa', 'bank', 'ziidi'
  @override
  final String? accountId;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SmsSenderConfig(id: $id, senderName: $senderName, accountType: $accountType, accountId: $accountId, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmsSenderConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    senderName,
    accountType,
    accountId,
    isActive,
    createdAt,
  );

  /// Create a copy of SmsSenderConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmsSenderConfigImplCopyWith<_$SmsSenderConfigImpl> get copyWith =>
      __$$SmsSenderConfigImplCopyWithImpl<_$SmsSenderConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SmsSenderConfigImplToJson(this);
  }
}

abstract class _SmsSenderConfig implements SmsSenderConfig {
  const factory _SmsSenderConfig({
    required final String id,
    required final String senderName,
    required final String accountType,
    final String? accountId,
    final bool isActive,
    required final DateTime createdAt,
  }) = _$SmsSenderConfigImpl;

  factory _SmsSenderConfig.fromJson(Map<String, dynamic> json) =
      _$SmsSenderConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get senderName;
  @override
  String get accountType; // 'mpesa', 'bank', 'ziidi'
  @override
  String? get accountId;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;

  /// Create a copy of SmsSenderConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmsSenderConfigImplCopyWith<_$SmsSenderConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
