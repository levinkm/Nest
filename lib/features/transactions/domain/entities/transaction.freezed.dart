// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  String get id => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  bool get isTransfer => throw _privateConstructorUsedError;
  double get fee => throw _privateConstructorUsedError;
  String? get accountId => throw _privateConstructorUsedError;
  String? get toAccountId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get counterparty => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  double? get accountBalance => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
    Transaction value,
    $Res Function(Transaction) then,
  ) = _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call({
    String id,
    double amount,
    String category,
    String description,
    DateTime date,
    String type,
    String? transactionId,
    bool isTransfer,
    double fee,
    String? accountId,
    String? toAccountId,
    String? notes,
    String? counterparty,
    List<String> tags,
    double? accountBalance,
  });
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? category = null,
    Object? description = null,
    Object? date = null,
    Object? type = null,
    Object? transactionId = freezed,
    Object? isTransfer = null,
    Object? fee = null,
    Object? accountId = freezed,
    Object? toAccountId = freezed,
    Object? notes = freezed,
    Object? counterparty = freezed,
    Object? tags = null,
    Object? accountBalance = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
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
            accountId: freezed == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String?,
            toAccountId: freezed == toAccountId
                ? _value.toAccountId
                : toAccountId // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            counterparty: freezed == counterparty
                ? _value.counterparty
                : counterparty // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            accountBalance: freezed == accountBalance
                ? _value.accountBalance
                : accountBalance // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
    _$TransactionImpl value,
    $Res Function(_$TransactionImpl) then,
  ) = __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    double amount,
    String category,
    String description,
    DateTime date,
    String type,
    String? transactionId,
    bool isTransfer,
    double fee,
    String? accountId,
    String? toAccountId,
    String? notes,
    String? counterparty,
    List<String> tags,
    double? accountBalance,
  });
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
    _$TransactionImpl _value,
    $Res Function(_$TransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? category = null,
    Object? description = null,
    Object? date = null,
    Object? type = null,
    Object? transactionId = freezed,
    Object? isTransfer = null,
    Object? fee = null,
    Object? accountId = freezed,
    Object? toAccountId = freezed,
    Object? notes = freezed,
    Object? counterparty = freezed,
    Object? tags = null,
    Object? accountBalance = freezed,
  }) {
    return _then(
      _$TransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
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
        accountId: freezed == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        toAccountId: freezed == toAccountId
            ? _value.toAccountId
            : toAccountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        counterparty: freezed == counterparty
            ? _value.counterparty
            : counterparty // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        accountBalance: freezed == accountBalance
            ? _value.accountBalance
            : accountBalance // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.type,
    this.transactionId,
    this.isTransfer = false,
    this.fee = 0.0,
    this.accountId,
    this.toAccountId,
    this.notes,
    this.counterparty,
    final List<String> tags = const [],
    this.accountBalance,
  }) : _tags = tags;

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final String id;
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
  final String? accountId;
  @override
  final String? toAccountId;
  @override
  final String? notes;
  @override
  final String? counterparty;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final double? accountBalance;

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, category: $category, description: $description, date: $date, type: $type, transactionId: $transactionId, isTransfer: $isTransfer, fee: $fee, accountId: $accountId, toAccountId: $toAccountId, notes: $notes, counterparty: $counterparty, tags: $tags, accountBalance: $accountBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
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
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.toAccountId, toAccountId) ||
                other.toAccountId == toAccountId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.counterparty, counterparty) ||
                other.counterparty == counterparty) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.accountBalance, accountBalance) ||
                other.accountBalance == accountBalance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    amount,
    category,
    description,
    date,
    type,
    transactionId,
    isTransfer,
    fee,
    accountId,
    toAccountId,
    notes,
    counterparty,
    const DeepCollectionEquality().hash(_tags),
    accountBalance,
  );

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(this);
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction({
    required final String id,
    required final double amount,
    required final String category,
    required final String description,
    required final DateTime date,
    required final String type,
    final String? transactionId,
    final bool isTransfer,
    final double fee,
    final String? accountId,
    final String? toAccountId,
    final String? notes,
    final String? counterparty,
    final List<String> tags,
    final double? accountBalance,
  }) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  String get id;
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
  String? get accountId;
  @override
  String? get toAccountId;
  @override
  String? get notes;
  @override
  String? get counterparty;
  @override
  List<String> get tags;
  @override
  double? get accountBalance;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
