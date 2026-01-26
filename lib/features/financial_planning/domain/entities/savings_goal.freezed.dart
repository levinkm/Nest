// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SavingsGoal _$SavingsGoalFromJson(Map<String, dynamic> json) {
  return _SavingsGoal.fromJson(json);
}

/// @nodoc
mixin _$SavingsGoal {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get targetAmount => throw _privateConstructorUsedError;
  double get currentAmount => throw _privateConstructorUsedError;
  DateTime get targetDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this SavingsGoal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavingsGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavingsGoalCopyWith<SavingsGoal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavingsGoalCopyWith<$Res> {
  factory $SavingsGoalCopyWith(
    SavingsGoal value,
    $Res Function(SavingsGoal) then,
  ) = _$SavingsGoalCopyWithImpl<$Res, SavingsGoal>;
  @useResult
  $Res call({
    String id,
    String name,
    double targetAmount,
    double currentAmount,
    DateTime targetDate,
    DateTime createdAt,
    bool isActive,
  });
}

/// @nodoc
class _$SavingsGoalCopyWithImpl<$Res, $Val extends SavingsGoal>
    implements $SavingsGoalCopyWith<$Res> {
  _$SavingsGoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavingsGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? targetDate = null,
    Object? createdAt = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            targetAmount: null == targetAmount
                ? _value.targetAmount
                : targetAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            currentAmount: null == currentAmount
                ? _value.currentAmount
                : currentAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            targetDate: null == targetDate
                ? _value.targetDate
                : targetDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SavingsGoalImplCopyWith<$Res>
    implements $SavingsGoalCopyWith<$Res> {
  factory _$$SavingsGoalImplCopyWith(
    _$SavingsGoalImpl value,
    $Res Function(_$SavingsGoalImpl) then,
  ) = __$$SavingsGoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double targetAmount,
    double currentAmount,
    DateTime targetDate,
    DateTime createdAt,
    bool isActive,
  });
}

/// @nodoc
class __$$SavingsGoalImplCopyWithImpl<$Res>
    extends _$SavingsGoalCopyWithImpl<$Res, _$SavingsGoalImpl>
    implements _$$SavingsGoalImplCopyWith<$Res> {
  __$$SavingsGoalImplCopyWithImpl(
    _$SavingsGoalImpl _value,
    $Res Function(_$SavingsGoalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SavingsGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? targetDate = null,
    Object? createdAt = null,
    Object? isActive = null,
  }) {
    return _then(
      _$SavingsGoalImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        targetAmount: null == targetAmount
            ? _value.targetAmount
            : targetAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        currentAmount: null == currentAmount
            ? _value.currentAmount
            : currentAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        targetDate: null == targetDate
            ? _value.targetDate
            : targetDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SavingsGoalImpl implements _SavingsGoal {
  const _$SavingsGoalImpl({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.createdAt,
    this.isActive = true,
  });

  factory _$SavingsGoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavingsGoalImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double targetAmount;
  @override
  final double currentAmount;
  @override
  final DateTime targetDate;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'SavingsGoal(id: $id, name: $name, targetAmount: $targetAmount, currentAmount: $currentAmount, targetDate: $targetDate, createdAt: $createdAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavingsGoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    targetAmount,
    currentAmount,
    targetDate,
    createdAt,
    isActive,
  );

  /// Create a copy of SavingsGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavingsGoalImplCopyWith<_$SavingsGoalImpl> get copyWith =>
      __$$SavingsGoalImplCopyWithImpl<_$SavingsGoalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavingsGoalImplToJson(this);
  }
}

abstract class _SavingsGoal implements SavingsGoal {
  const factory _SavingsGoal({
    required final String id,
    required final String name,
    required final double targetAmount,
    required final double currentAmount,
    required final DateTime targetDate,
    required final DateTime createdAt,
    final bool isActive,
  }) = _$SavingsGoalImpl;

  factory _SavingsGoal.fromJson(Map<String, dynamic> json) =
      _$SavingsGoalImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get targetAmount;
  @override
  double get currentAmount;
  @override
  DateTime get targetDate;
  @override
  DateTime get createdAt;
  @override
  bool get isActive;

  /// Create a copy of SavingsGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavingsGoalImplCopyWith<_$SavingsGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
