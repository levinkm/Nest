// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SmsTransaction _$SmsTransactionFromJson(Map<String, dynamic> json) {
  return _SmsTransaction.fromJson(json);
}

/// @nodoc
mixin _$SmsTransaction {
  double get amount => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  bool get isTransfer => throw _privateConstructorUsedError;
  double get fee => throw _privateConstructorUsedError;
  double? get recordedBalance => throw _privateConstructorUsedError;
  double? get fulizaBalance => throw _privateConstructorUsedError;
  DateTime? get fulizaDueDate => throw _privateConstructorUsedError;
  double? get ziidiBalance => throw _privateConstructorUsedError;
  String? get counterparty => throw _privateConstructorUsedError;

  /// Serializes this SmsTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmsTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmsTransactionCopyWith<SmsTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmsTransactionCopyWith<$Res> {
  factory $SmsTransactionCopyWith(
    SmsTransaction value,
    $Res Function(SmsTransaction) then,
  ) = _$SmsTransactionCopyWithImpl<$Res, SmsTransaction>;
  @useResult
  $Res call({
    double amount,
    String category,
    String description,
    DateTime date,
    String type,
    String? transactionId,
    bool isTransfer,
    double fee,
    double? recordedBalance,
    double? fulizaBalance,
    DateTime? fulizaDueDate,
    double? ziidiBalance,
    String? counterparty,
  });
}

/// @nodoc
class _$SmsTransactionCopyWithImpl<$Res, $Val extends SmsTransaction>
    implements $SmsTransactionCopyWith<$Res> {
  _$SmsTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmsTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? category = null,
    Object? description = null,
    Object? date = null,
    Object? type = null,
    Object? transactionId = freezed,
    Object? isTransfer = null,
    Object? fee = null,
    Object? recordedBalance = freezed,
    Object? fulizaBalance = freezed,
    Object? fulizaDueDate = freezed,
    Object? ziidiBalance = freezed,
    Object? counterparty = freezed,
  }) {
    return _then(
      _value.copyWith(
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionId: freezed == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isTransfer: null == isTransfer
                ? _value.isTransfer
                : isTransfer // ignore: cast_nullable_to_non_nullable
                      as bool,
            fee: null == fee
                ? _value.fee
                : fee // ignore: cast_nullable_to_non_nullable
                      as double,
            recordedBalance: freezed == recordedBalance
                ? _value.recordedBalance
                : recordedBalance // ignore: cast_nullable_to_non_nullable
                      as double?,
            fulizaBalance: freezed == fulizaBalance
                ? _value.fulizaBalance
                : fulizaBalance // ignore: cast_nullable_to_non_nullable
                      as double?,
            fulizaDueDate: freezed == fulizaDueDate
                ? _value.fulizaDueDate
                : fulizaDueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            ziidiBalance: freezed == ziidiBalance
                ? _value.ziidiBalance
                : ziidiBalance // ignore: cast_nullable_to_non_nullable
                      as double?,
            counterparty: freezed == counterparty
                ? _value.counterparty
                : counterparty // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SmsTransactionImplCopyWith<$Res>
    implements $SmsTransactionCopyWith<$Res> {
  factory _$$SmsTransactionImplCopyWith(
    _$SmsTransactionImpl value,
    $Res Function(_$SmsTransactionImpl) then,
  ) = __$$SmsTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double amount,
    String category,
    String description,
    DateTime date,
    String type,
    String? transactionId,
    bool isTransfer,
    double fee,
    double? recordedBalance,
    double? fulizaBalance,
    DateTime? fulizaDueDate,
    double? ziidiBalance,
    String? counterparty,
  });
}

/// @nodoc
class __$$SmsTransactionImplCopyWithImpl<$Res>
    extends _$SmsTransactionCopyWithImpl<$Res, _$SmsTransactionImpl>
    implements _$$SmsTransactionImplCopyWith<$Res> {
  __$$SmsTransactionImplCopyWithImpl(
    _$SmsTransactionImpl _value,
    $Res Function(_$SmsTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SmsTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? category = null,
    Object? description = null,
    Object? date = null,
    Object? type = null,
    Object? transactionId = freezed,
    Object? isTransfer = null,
    Object? fee = null,
    Object? recordedBalance = freezed,
    Object? fulizaBalance = freezed,
    Object? fulizaDueDate = freezed,
    Object? ziidiBalance = freezed,
    Object? counterparty = freezed,
  }) {
    return _then(
      _$SmsTransactionImpl(
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionId: freezed == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isTransfer: null == isTransfer
            ? _value.isTransfer
            : isTransfer // ignore: cast_nullable_to_non_nullable
                  as bool,
        fee: null == fee
            ? _value.fee
            : fee // ignore: cast_nullable_to_non_nullable
                  as double,
        recordedBalance: freezed == recordedBalance
            ? _value.recordedBalance
            : recordedBalance // ignore: cast_nullable_to_non_nullable
                  as double?,
        fulizaBalance: freezed == fulizaBalance
            ? _value.fulizaBalance
            : fulizaBalance // ignore: cast_nullable_to_non_nullable
                  as double?,
        fulizaDueDate: freezed == fulizaDueDate
            ? _value.fulizaDueDate
            : fulizaDueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        ziidiBalance: freezed == ziidiBalance
            ? _value.ziidiBalance
            : ziidiBalance // ignore: cast_nullable_to_non_nullable
                  as double?,
        counterparty: freezed == counterparty
            ? _value.counterparty
            : counterparty // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SmsTransactionImpl extends _SmsTransaction {
  const _$SmsTransactionImpl({
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.type,
    this.transactionId,
    this.isTransfer = false,
    this.fee = 0.0,
    this.recordedBalance,
    this.fulizaBalance,
    this.fulizaDueDate,
    this.ziidiBalance,
    this.counterparty,
  }) : super._();

  factory _$SmsTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmsTransactionImplFromJson(json);

  @override
  final double amount;
  @override
  final String category;
  @override
  final String description;
  @override
  final DateTime date;
  @override
  final String type;
  @override
  final String? transactionId;
  @override
  @JsonKey()
  final bool isTransfer;
  @override
  @JsonKey()
  final double fee;
  @override
  final double? recordedBalance;
  @override
  final double? fulizaBalance;
  @override
  final DateTime? fulizaDueDate;
  @override
  final double? ziidiBalance;
  @override
  final String? counterparty;

  @override
  String toString() {
    return 'SmsTransaction(amount: $amount, category: $category, description: $description, date: $date, type: $type, transactionId: $transactionId, isTransfer: $isTransfer, fee: $fee, recordedBalance: $recordedBalance, fulizaBalance: $fulizaBalance, fulizaDueDate: $fulizaDueDate, ziidiBalance: $ziidiBalance, counterparty: $counterparty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmsTransactionImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.isTransfer, isTransfer) ||
                other.isTransfer == isTransfer) &&
            (identical(other.fee, fee) || other.fee == fee) &&
            (identical(other.recordedBalance, recordedBalance) ||
                other.recordedBalance == recordedBalance) &&
            (identical(other.fulizaBalance, fulizaBalance) ||
                other.fulizaBalance == fulizaBalance) &&
            (identical(other.fulizaDueDate, fulizaDueDate) ||
                other.fulizaDueDate == fulizaDueDate) &&
            (identical(other.ziidiBalance, ziidiBalance) ||
                other.ziidiBalance == ziidiBalance) &&
            (identical(other.counterparty, counterparty) ||
                other.counterparty == counterparty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    amount,
    category,
    description,
    date,
    type,
    transactionId,
    isTransfer,
    fee,
    recordedBalance,
    fulizaBalance,
    fulizaDueDate,
    ziidiBalance,
    counterparty,
  );

  /// Create a copy of SmsTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmsTransactionImplCopyWith<_$SmsTransactionImpl> get copyWith =>
      __$$SmsTransactionImplCopyWithImpl<_$SmsTransactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SmsTransactionImplToJson(this);
  }
}

abstract class _SmsTransaction extends SmsTransaction {
  const factory _SmsTransaction({
    required final double amount,
    required final String category,
    required final String description,
    required final DateTime date,
    required final String type,
    final String? transactionId,
    final bool isTransfer,
    final double fee,
    final double? recordedBalance,
    final double? fulizaBalance,
    final DateTime? fulizaDueDate,
    final double? ziidiBalance,
    final String? counterparty,
  }) = _$SmsTransactionImpl;
  const _SmsTransaction._() : super._();

  factory _SmsTransaction.fromJson(Map<String, dynamic> json) =
      _$SmsTransactionImpl.fromJson;

  @override
  double get amount;
  @override
  String get category;
  @override
  String get description;
  @override
  DateTime get date;
  @override
  String get type;
  @override
  String? get transactionId;
  @override
  bool get isTransfer;
  @override
  double get fee;
  @override
  double? get recordedBalance;
  @override
  double? get fulizaBalance;
  @override
  DateTime? get fulizaDueDate;
  @override
  double? get ziidiBalance;
  @override
  String? get counterparty;

  /// Create a copy of SmsTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmsTransactionImplCopyWith<_$SmsTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
