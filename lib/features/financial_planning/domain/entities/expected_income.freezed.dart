// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expected_income.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExpectedIncome _$ExpectedIncomeFromJson(Map<String, dynamic> json) {
  return _ExpectedIncome.fromJson(json);
}

/// @nodoc
mixin _$ExpectedIncome {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get frequency => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  DateTime get nextExpectedDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ExpectedIncome to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpectedIncome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpectedIncomeCopyWith<ExpectedIncome> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpectedIncomeCopyWith<$Res> {
  factory $ExpectedIncomeCopyWith(
    ExpectedIncome value,
    $Res Function(ExpectedIncome) then,
  ) = _$ExpectedIncomeCopyWithImpl<$Res, ExpectedIncome>;
  @useResult
  $Res call({
    String id,
    String name,
    double amount,
    String frequency,
    String category,
    DateTime nextExpectedDate,
    bool isActive,
  });
}

/// @nodoc
class _$ExpectedIncomeCopyWithImpl<$Res, $Val extends ExpectedIncome>
    implements $ExpectedIncomeCopyWith<$Res> {
  _$ExpectedIncomeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpectedIncome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? frequency = null,
    Object? category = null,
    Object? nextExpectedDate = null,
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
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            frequency: null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            nextExpectedDate: null == nextExpectedDate
                ? _value.nextExpectedDate
                : nextExpectedDate // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ExpectedIncomeImplCopyWith<$Res>
    implements $ExpectedIncomeCopyWith<$Res> {
  factory _$$ExpectedIncomeImplCopyWith(
    _$ExpectedIncomeImpl value,
    $Res Function(_$ExpectedIncomeImpl) then,
  ) = __$$ExpectedIncomeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double amount,
    String frequency,
    String category,
    DateTime nextExpectedDate,
    bool isActive,
  });
}

/// @nodoc
class __$$ExpectedIncomeImplCopyWithImpl<$Res>
    extends _$ExpectedIncomeCopyWithImpl<$Res, _$ExpectedIncomeImpl>
    implements _$$ExpectedIncomeImplCopyWith<$Res> {
  __$$ExpectedIncomeImplCopyWithImpl(
    _$ExpectedIncomeImpl _value,
    $Res Function(_$ExpectedIncomeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpectedIncome
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? frequency = null,
    Object? category = null,
    Object? nextExpectedDate = null,
    Object? isActive = null,
  }) {
    return _then(
      _$ExpectedIncomeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        frequency: null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        nextExpectedDate: null == nextExpectedDate
            ? _value.nextExpectedDate
            : nextExpectedDate // ignore: cast_nullable_to_non_nullable
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
class _$ExpectedIncomeImpl implements _ExpectedIncome {
  const _$ExpectedIncomeImpl({
    required this.id,
    required this.name,
    required this.amount,
    required this.frequency,
    required this.category,
    required this.nextExpectedDate,
    this.isActive = true,
  });

  factory _$ExpectedIncomeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpectedIncomeImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double amount;
  @override
  final String frequency;
  @override
  final String category;
  @override
  final DateTime nextExpectedDate;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'ExpectedIncome(id: $id, name: $name, amount: $amount, frequency: $frequency, category: $category, nextExpectedDate: $nextExpectedDate, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpectedIncomeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.nextExpectedDate, nextExpectedDate) ||
                other.nextExpectedDate == nextExpectedDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    amount,
    frequency,
    category,
    nextExpectedDate,
    isActive,
  );

  /// Create a copy of ExpectedIncome
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpectedIncomeImplCopyWith<_$ExpectedIncomeImpl> get copyWith =>
      __$$ExpectedIncomeImplCopyWithImpl<_$ExpectedIncomeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpectedIncomeImplToJson(this);
  }
}

abstract class _ExpectedIncome implements ExpectedIncome {
  const factory _ExpectedIncome({
    required final String id,
    required final String name,
    required final double amount,
    required final String frequency,
    required final String category,
    required final DateTime nextExpectedDate,
    final bool isActive,
  }) = _$ExpectedIncomeImpl;

  factory _ExpectedIncome.fromJson(Map<String, dynamic> json) =
      _$ExpectedIncomeImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get amount;
  @override
  String get frequency;
  @override
  String get category;
  @override
  DateTime get nextExpectedDate;
  @override
  bool get isActive;

  /// Create a copy of ExpectedIncome
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpectedIncomeImplCopyWith<_$ExpectedIncomeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
