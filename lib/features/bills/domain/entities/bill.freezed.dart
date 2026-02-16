// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Bill _$BillFromJson(Map<String, dynamic> json) {
  return _Bill.fromJson(json);
}

/// @nodoc
mixin _$Bill {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  String get frequency => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String? get merchant => throw _privateConstructorUsedError;
  bool get isVariable => throw _privateConstructorUsedError;
  double? get averageAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get paidDate => throw _privateConstructorUsedError;
  String? get paidTransactionId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get autoDetected => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Bill to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillCopyWith<Bill> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillCopyWith<$Res> {
  factory $BillCopyWith(Bill value, $Res Function(Bill) then) =
      _$BillCopyWithImpl<$Res, Bill>;
  @useResult
  $Res call({
    String id,
    String name,
    double amount,
    DateTime dueDate,
    String frequency,
    String category,
    String? paymentMethod,
    String? merchant,
    bool isVariable,
    double? averageAmount,
    String status,
    DateTime? paidDate,
    String? paidTransactionId,
    bool isActive,
    bool autoDetected,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$BillCopyWithImpl<$Res, $Val extends Bill>
    implements $BillCopyWith<$Res> {
  _$BillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? frequency = null,
    Object? category = null,
    Object? paymentMethod = freezed,
    Object? merchant = freezed,
    Object? isVariable = null,
    Object? averageAmount = freezed,
    Object? status = null,
    Object? paidDate = freezed,
    Object? paidTransactionId = freezed,
    Object? isActive = null,
    Object? autoDetected = null,
    Object? createdAt = freezed,
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
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            frequency: null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            merchant: freezed == merchant
                ? _value.merchant
                : merchant // ignore: cast_nullable_to_non_nullable
                      as String?,
            isVariable: null == isVariable
                ? _value.isVariable
                : isVariable // ignore: cast_nullable_to_non_nullable
                      as bool,
            averageAmount: freezed == averageAmount
                ? _value.averageAmount
                : averageAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            paidDate: freezed == paidDate
                ? _value.paidDate
                : paidDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            paidTransactionId: freezed == paidTransactionId
                ? _value.paidTransactionId
                : paidTransactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            autoDetected: null == autoDetected
                ? _value.autoDetected
                : autoDetected // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BillImplCopyWith<$Res> implements $BillCopyWith<$Res> {
  factory _$$BillImplCopyWith(
    _$BillImpl value,
    $Res Function(_$BillImpl) then,
  ) = __$$BillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double amount,
    DateTime dueDate,
    String frequency,
    String category,
    String? paymentMethod,
    String? merchant,
    bool isVariable,
    double? averageAmount,
    String status,
    DateTime? paidDate,
    String? paidTransactionId,
    bool isActive,
    bool autoDetected,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$BillImplCopyWithImpl<$Res>
    extends _$BillCopyWithImpl<$Res, _$BillImpl>
    implements _$$BillImplCopyWith<$Res> {
  __$$BillImplCopyWithImpl(_$BillImpl _value, $Res Function(_$BillImpl) _then)
    : super(_value, _then);

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? dueDate = null,
    Object? frequency = null,
    Object? category = null,
    Object? paymentMethod = freezed,
    Object? merchant = freezed,
    Object? isVariable = null,
    Object? averageAmount = freezed,
    Object? status = null,
    Object? paidDate = freezed,
    Object? paidTransactionId = freezed,
    Object? isActive = null,
    Object? autoDetected = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$BillImpl(
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
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        frequency: null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        merchant: freezed == merchant
            ? _value.merchant
            : merchant // ignore: cast_nullable_to_non_nullable
                  as String?,
        isVariable: null == isVariable
            ? _value.isVariable
            : isVariable // ignore: cast_nullable_to_non_nullable
                  as bool,
        averageAmount: freezed == averageAmount
            ? _value.averageAmount
            : averageAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        paidDate: freezed == paidDate
            ? _value.paidDate
            : paidDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        paidTransactionId: freezed == paidTransactionId
            ? _value.paidTransactionId
            : paidTransactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        autoDetected: null == autoDetected
            ? _value.autoDetected
            : autoDetected // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BillImpl extends _Bill {
  const _$BillImpl({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.frequency,
    required this.category,
    this.paymentMethod,
    this.merchant,
    this.isVariable = false,
    this.averageAmount,
    this.status = 'upcoming',
    this.paidDate,
    this.paidTransactionId,
    this.isActive = true,
    this.autoDetected = false,
    this.createdAt,
  }) : super._();

  factory _$BillImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double amount;
  @override
  final DateTime dueDate;
  @override
  final String frequency;
  @override
  final String category;
  @override
  final String? paymentMethod;
  @override
  final String? merchant;
  @override
  @JsonKey()
  final bool isVariable;
  @override
  final double? averageAmount;
  @override
  @JsonKey()
  final String status;
  @override
  final DateTime? paidDate;
  @override
  final String? paidTransactionId;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool autoDetected;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Bill(id: $id, name: $name, amount: $amount, dueDate: $dueDate, frequency: $frequency, category: $category, paymentMethod: $paymentMethod, merchant: $merchant, isVariable: $isVariable, averageAmount: $averageAmount, status: $status, paidDate: $paidDate, paidTransactionId: $paidTransactionId, isActive: $isActive, autoDetected: $autoDetected, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            (identical(other.isVariable, isVariable) ||
                other.isVariable == isVariable) &&
            (identical(other.averageAmount, averageAmount) ||
                other.averageAmount == averageAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paidDate, paidDate) ||
                other.paidDate == paidDate) &&
            (identical(other.paidTransactionId, paidTransactionId) ||
                other.paidTransactionId == paidTransactionId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.autoDetected, autoDetected) ||
                other.autoDetected == autoDetected) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    amount,
    dueDate,
    frequency,
    category,
    paymentMethod,
    merchant,
    isVariable,
    averageAmount,
    status,
    paidDate,
    paidTransactionId,
    isActive,
    autoDetected,
    createdAt,
  );

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillImplCopyWith<_$BillImpl> get copyWith =>
      __$$BillImplCopyWithImpl<_$BillImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillImplToJson(this);
  }
}

abstract class _Bill extends Bill {
  const factory _Bill({
    required final String id,
    required final String name,
    required final double amount,
    required final DateTime dueDate,
    required final String frequency,
    required final String category,
    final String? paymentMethod,
    final String? merchant,
    final bool isVariable,
    final double? averageAmount,
    final String status,
    final DateTime? paidDate,
    final String? paidTransactionId,
    final bool isActive,
    final bool autoDetected,
    final DateTime? createdAt,
  }) = _$BillImpl;
  const _Bill._() : super._();

  factory _Bill.fromJson(Map<String, dynamic> json) = _$BillImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get amount;
  @override
  DateTime get dueDate;
  @override
  String get frequency;
  @override
  String get category;
  @override
  String? get paymentMethod;
  @override
  String? get merchant;
  @override
  bool get isVariable;
  @override
  double? get averageAmount;
  @override
  String get status;
  @override
  DateTime? get paidDate;
  @override
  String? get paidTransactionId;
  @override
  bool get isActive;
  @override
  bool get autoDetected;
  @override
  DateTime? get createdAt;

  /// Create a copy of Bill
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillImplCopyWith<_$BillImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
