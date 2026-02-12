// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LedgerEntry _$LedgerEntryFromJson(Map<String, dynamic> json) {
  return _LedgerEntry.fromJson(json);
}

/// @nodoc
mixin _$LedgerEntry {
  String get id => throw _privateConstructorUsedError;
  String get transactionId => throw _privateConstructorUsedError;
  String get accountId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get debit => throw _privateConstructorUsedError;
  double get credit => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  double get fee => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;

  /// Serializes this LedgerEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LedgerEntryCopyWith<LedgerEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerEntryCopyWith<$Res> {
  factory $LedgerEntryCopyWith(
    LedgerEntry value,
    $Res Function(LedgerEntry) then,
  ) = _$LedgerEntryCopyWithImpl<$Res, LedgerEntry>;
  @useResult
  $Res call({
    String id,
    String transactionId,
    String accountId,
    DateTime date,
    String description,
    double debit,
    double credit,
    double balance,
    double fee,
    String? category,
    String? reference,
  });
}

/// @nodoc
class _$LedgerEntryCopyWithImpl<$Res, $Val extends LedgerEntry>
    implements $LedgerEntryCopyWith<$Res> {
  _$LedgerEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? accountId = null,
    Object? date = null,
    Object? description = null,
    Object? debit = null,
    Object? credit = null,
    Object? balance = null,
    Object? fee = null,
    Object? category = freezed,
    Object? reference = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionId: null == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                      as String,
            accountId: null == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            debit: null == debit
                ? _value.debit
                : debit // ignore: cast_nullable_to_non_nullable
                      as double,
            credit: null == credit
                ? _value.credit
                : credit // ignore: cast_nullable_to_non_nullable
                      as double,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as double,
            fee: null == fee
                ? _value.fee
                : fee // ignore: cast_nullable_to_non_nullable
                      as double,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            reference: freezed == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LedgerEntryImplCopyWith<$Res>
    implements $LedgerEntryCopyWith<$Res> {
  factory _$$LedgerEntryImplCopyWith(
    _$LedgerEntryImpl value,
    $Res Function(_$LedgerEntryImpl) then,
  ) = __$$LedgerEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String transactionId,
    String accountId,
    DateTime date,
    String description,
    double debit,
    double credit,
    double balance,
    double fee,
    String? category,
    String? reference,
  });
}

/// @nodoc
class __$$LedgerEntryImplCopyWithImpl<$Res>
    extends _$LedgerEntryCopyWithImpl<$Res, _$LedgerEntryImpl>
    implements _$$LedgerEntryImplCopyWith<$Res> {
  __$$LedgerEntryImplCopyWithImpl(
    _$LedgerEntryImpl _value,
    $Res Function(_$LedgerEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? accountId = null,
    Object? date = null,
    Object? description = null,
    Object? debit = null,
    Object? credit = null,
    Object? balance = null,
    Object? fee = null,
    Object? category = freezed,
    Object? reference = freezed,
  }) {
    return _then(
      _$LedgerEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionId: null == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String,
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        debit: null == debit
            ? _value.debit
            : debit // ignore: cast_nullable_to_non_nullable
                  as double,
        credit: null == credit
            ? _value.credit
            : credit // ignore: cast_nullable_to_non_nullable
                  as double,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as double,
        fee: null == fee
            ? _value.fee
            : fee // ignore: cast_nullable_to_non_nullable
                  as double,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        reference: freezed == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerEntryImpl implements _LedgerEntry {
  const _$LedgerEntryImpl({
    required this.id,
    required this.transactionId,
    required this.accountId,
    required this.date,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
    required this.fee,
    this.category,
    this.reference,
  });

  factory _$LedgerEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String transactionId;
  @override
  final String accountId;
  @override
  final DateTime date;
  @override
  final String description;
  @override
  final double debit;
  @override
  final double credit;
  @override
  final double balance;
  @override
  final double fee;
  @override
  final String? category;
  @override
  final String? reference;

  @override
  String toString() {
    return 'LedgerEntry(id: $id, transactionId: $transactionId, accountId: $accountId, date: $date, description: $description, debit: $debit, credit: $credit, balance: $balance, fee: $fee, category: $category, reference: $reference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.debit, debit) || other.debit == debit) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.fee, fee) || other.fee == fee) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.reference, reference) ||
                other.reference == reference));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    transactionId,
    accountId,
    date,
    description,
    debit,
    credit,
    balance,
    fee,
    category,
    reference,
  );

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerEntryImplCopyWith<_$LedgerEntryImpl> get copyWith =>
      __$$LedgerEntryImplCopyWithImpl<_$LedgerEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerEntryImplToJson(this);
  }
}

abstract class _LedgerEntry implements LedgerEntry {
  const factory _LedgerEntry({
    required final String id,
    required final String transactionId,
    required final String accountId,
    required final DateTime date,
    required final String description,
    required final double debit,
    required final double credit,
    required final double balance,
    required final double fee,
    final String? category,
    final String? reference,
  }) = _$LedgerEntryImpl;

  factory _LedgerEntry.fromJson(Map<String, dynamic> json) =
      _$LedgerEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get transactionId;
  @override
  String get accountId;
  @override
  DateTime get date;
  @override
  String get description;
  @override
  double get debit;
  @override
  double get credit;
  @override
  double get balance;
  @override
  double get fee;
  @override
  String? get category;
  @override
  String? get reference;

  /// Create a copy of LedgerEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LedgerEntryImplCopyWith<_$LedgerEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
