// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TransactionEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadTransactions,
    required TResult Function(Transaction transaction) addTransaction,
    required TResult Function(String id) deleteTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadTransactions,
    TResult? Function(Transaction transaction)? addTransaction,
    TResult? Function(String id)? deleteTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadTransactions,
    TResult Function(Transaction transaction)? addTransaction,
    TResult Function(String id)? deleteTransaction,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactions value) loadTransactions,
    required TResult Function(AddTransaction value) addTransaction,
    required TResult Function(DeleteTransaction value) deleteTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactions value)? loadTransactions,
    TResult? Function(AddTransaction value)? addTransaction,
    TResult? Function(DeleteTransaction value)? deleteTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactions value)? loadTransactions,
    TResult Function(AddTransaction value)? addTransaction,
    TResult Function(DeleteTransaction value)? deleteTransaction,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionEventCopyWith<$Res> {
  factory $TransactionEventCopyWith(
    TransactionEvent value,
    $Res Function(TransactionEvent) then,
  ) = _$TransactionEventCopyWithImpl<$Res, TransactionEvent>;
}

/// @nodoc
class _$TransactionEventCopyWithImpl<$Res, $Val extends TransactionEvent>
    implements $TransactionEventCopyWith<$Res> {
  _$TransactionEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadTransactionsImplCopyWith<$Res> {
  factory _$$LoadTransactionsImplCopyWith(
    _$LoadTransactionsImpl value,
    $Res Function(_$LoadTransactionsImpl) then,
  ) = __$$LoadTransactionsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadTransactionsImplCopyWithImpl<$Res>
    extends _$TransactionEventCopyWithImpl<$Res, _$LoadTransactionsImpl>
    implements _$$LoadTransactionsImplCopyWith<$Res> {
  __$$LoadTransactionsImplCopyWithImpl(
    _$LoadTransactionsImpl _value,
    $Res Function(_$LoadTransactionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadTransactionsImpl implements LoadTransactions {
  const _$LoadTransactionsImpl();

  @override
  String toString() {
    return 'TransactionEvent.loadTransactions()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadTransactionsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadTransactions,
    required TResult Function(Transaction transaction) addTransaction,
    required TResult Function(String id) deleteTransaction,
  }) {
    return loadTransactions();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadTransactions,
    TResult? Function(Transaction transaction)? addTransaction,
    TResult? Function(String id)? deleteTransaction,
  }) {
    return loadTransactions?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadTransactions,
    TResult Function(Transaction transaction)? addTransaction,
    TResult Function(String id)? deleteTransaction,
    required TResult orElse(),
  }) {
    if (loadTransactions != null) {
      return loadTransactions();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactions value) loadTransactions,
    required TResult Function(AddTransaction value) addTransaction,
    required TResult Function(DeleteTransaction value) deleteTransaction,
  }) {
    return loadTransactions(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactions value)? loadTransactions,
    TResult? Function(AddTransaction value)? addTransaction,
    TResult? Function(DeleteTransaction value)? deleteTransaction,
  }) {
    return loadTransactions?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactions value)? loadTransactions,
    TResult Function(AddTransaction value)? addTransaction,
    TResult Function(DeleteTransaction value)? deleteTransaction,
    required TResult orElse(),
  }) {
    if (loadTransactions != null) {
      return loadTransactions(this);
    }
    return orElse();
  }
}

abstract class LoadTransactions implements TransactionEvent {
  const factory LoadTransactions() = _$LoadTransactionsImpl;
}

/// @nodoc
abstract class _$$AddTransactionImplCopyWith<$Res> {
  factory _$$AddTransactionImplCopyWith(
    _$AddTransactionImpl value,
    $Res Function(_$AddTransactionImpl) then,
  ) = __$$AddTransactionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Transaction transaction});

  $TransactionCopyWith<$Res> get transaction;
}

/// @nodoc
class __$$AddTransactionImplCopyWithImpl<$Res>
    extends _$TransactionEventCopyWithImpl<$Res, _$AddTransactionImpl>
    implements _$$AddTransactionImplCopyWith<$Res> {
  __$$AddTransactionImplCopyWithImpl(
    _$AddTransactionImpl _value,
    $Res Function(_$AddTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? transaction = null}) {
    return _then(
      _$AddTransactionImpl(
        null == transaction
            ? _value.transaction
            : transaction // ignore: cast_nullable_to_non_nullable
                  as Transaction,
      ),
    );
  }

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionCopyWith<$Res> get transaction {
    return $TransactionCopyWith<$Res>(_value.transaction, (value) {
      return _then(_value.copyWith(transaction: value));
    });
  }
}

/// @nodoc

class _$AddTransactionImpl implements AddTransaction {
  const _$AddTransactionImpl(this.transaction);

  @override
  final Transaction transaction;

  @override
  String toString() {
    return 'TransactionEvent.addTransaction(transaction: $transaction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddTransactionImpl &&
            (identical(other.transaction, transaction) ||
                other.transaction == transaction));
  }

  @override
  int get hashCode => Object.hash(runtimeType, transaction);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddTransactionImplCopyWith<_$AddTransactionImpl> get copyWith =>
      __$$AddTransactionImplCopyWithImpl<_$AddTransactionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadTransactions,
    required TResult Function(Transaction transaction) addTransaction,
    required TResult Function(String id) deleteTransaction,
  }) {
    return addTransaction(transaction);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadTransactions,
    TResult? Function(Transaction transaction)? addTransaction,
    TResult? Function(String id)? deleteTransaction,
  }) {
    return addTransaction?.call(transaction);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadTransactions,
    TResult Function(Transaction transaction)? addTransaction,
    TResult Function(String id)? deleteTransaction,
    required TResult orElse(),
  }) {
    if (addTransaction != null) {
      return addTransaction(transaction);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactions value) loadTransactions,
    required TResult Function(AddTransaction value) addTransaction,
    required TResult Function(DeleteTransaction value) deleteTransaction,
  }) {
    return addTransaction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactions value)? loadTransactions,
    TResult? Function(AddTransaction value)? addTransaction,
    TResult? Function(DeleteTransaction value)? deleteTransaction,
  }) {
    return addTransaction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactions value)? loadTransactions,
    TResult Function(AddTransaction value)? addTransaction,
    TResult Function(DeleteTransaction value)? deleteTransaction,
    required TResult orElse(),
  }) {
    if (addTransaction != null) {
      return addTransaction(this);
    }
    return orElse();
  }
}

abstract class AddTransaction implements TransactionEvent {
  const factory AddTransaction(final Transaction transaction) =
      _$AddTransactionImpl;

  Transaction get transaction;

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddTransactionImplCopyWith<_$AddTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteTransactionImplCopyWith<$Res> {
  factory _$$DeleteTransactionImplCopyWith(
    _$DeleteTransactionImpl value,
    $Res Function(_$DeleteTransactionImpl) then,
  ) = __$$DeleteTransactionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$DeleteTransactionImplCopyWithImpl<$Res>
    extends _$TransactionEventCopyWithImpl<$Res, _$DeleteTransactionImpl>
    implements _$$DeleteTransactionImplCopyWith<$Res> {
  __$$DeleteTransactionImplCopyWithImpl(
    _$DeleteTransactionImpl _value,
    $Res Function(_$DeleteTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$DeleteTransactionImpl(
        null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeleteTransactionImpl implements DeleteTransaction {
  const _$DeleteTransactionImpl(this.id);

  @override
  final String id;

  @override
  String toString() {
    return 'TransactionEvent.deleteTransaction(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteTransactionImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteTransactionImplCopyWith<_$DeleteTransactionImpl> get copyWith =>
      __$$DeleteTransactionImplCopyWithImpl<_$DeleteTransactionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadTransactions,
    required TResult Function(Transaction transaction) addTransaction,
    required TResult Function(String id) deleteTransaction,
  }) {
    return deleteTransaction(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadTransactions,
    TResult? Function(Transaction transaction)? addTransaction,
    TResult? Function(String id)? deleteTransaction,
  }) {
    return deleteTransaction?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadTransactions,
    TResult Function(Transaction transaction)? addTransaction,
    TResult Function(String id)? deleteTransaction,
    required TResult orElse(),
  }) {
    if (deleteTransaction != null) {
      return deleteTransaction(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactions value) loadTransactions,
    required TResult Function(AddTransaction value) addTransaction,
    required TResult Function(DeleteTransaction value) deleteTransaction,
  }) {
    return deleteTransaction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactions value)? loadTransactions,
    TResult? Function(AddTransaction value)? addTransaction,
    TResult? Function(DeleteTransaction value)? deleteTransaction,
  }) {
    return deleteTransaction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactions value)? loadTransactions,
    TResult Function(AddTransaction value)? addTransaction,
    TResult Function(DeleteTransaction value)? deleteTransaction,
    required TResult orElse(),
  }) {
    if (deleteTransaction != null) {
      return deleteTransaction(this);
    }
    return orElse();
  }
}

abstract class DeleteTransaction implements TransactionEvent {
  const factory DeleteTransaction(final String id) = _$DeleteTransactionImpl;

  String get id;

  /// Create a copy of TransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteTransactionImplCopyWith<_$DeleteTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TransactionState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Transaction> transactions) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Transaction> transactions)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Transaction> transactions)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransactionInitial value) initial,
    required TResult Function(TransactionLoading value) loading,
    required TResult Function(TransactionLoaded value) loaded,
    required TResult Function(TransactionError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransactionInitial value)? initial,
    TResult? Function(TransactionLoading value)? loading,
    TResult? Function(TransactionLoaded value)? loaded,
    TResult? Function(TransactionError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransactionInitial value)? initial,
    TResult Function(TransactionLoading value)? loading,
    TResult Function(TransactionLoaded value)? loaded,
    TResult Function(TransactionError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionStateCopyWith<$Res> {
  factory $TransactionStateCopyWith(
    TransactionState value,
    $Res Function(TransactionState) then,
  ) = _$TransactionStateCopyWithImpl<$Res, TransactionState>;
}

/// @nodoc
class _$TransactionStateCopyWithImpl<$Res, $Val extends TransactionState>
    implements $TransactionStateCopyWith<$Res> {
  _$TransactionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TransactionInitialImplCopyWith<$Res> {
  factory _$$TransactionInitialImplCopyWith(
    _$TransactionInitialImpl value,
    $Res Function(_$TransactionInitialImpl) then,
  ) = __$$TransactionInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TransactionInitialImplCopyWithImpl<$Res>
    extends _$TransactionStateCopyWithImpl<$Res, _$TransactionInitialImpl>
    implements _$$TransactionInitialImplCopyWith<$Res> {
  __$$TransactionInitialImplCopyWithImpl(
    _$TransactionInitialImpl _value,
    $Res Function(_$TransactionInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TransactionInitialImpl implements TransactionInitial {
  const _$TransactionInitialImpl();

  @override
  String toString() {
    return 'TransactionState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TransactionInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Transaction> transactions) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Transaction> transactions)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Transaction> transactions)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransactionInitial value) initial,
    required TResult Function(TransactionLoading value) loading,
    required TResult Function(TransactionLoaded value) loaded,
    required TResult Function(TransactionError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransactionInitial value)? initial,
    TResult? Function(TransactionLoading value)? loading,
    TResult? Function(TransactionLoaded value)? loaded,
    TResult? Function(TransactionError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransactionInitial value)? initial,
    TResult Function(TransactionLoading value)? loading,
    TResult Function(TransactionLoaded value)? loaded,
    TResult Function(TransactionError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class TransactionInitial implements TransactionState {
  const factory TransactionInitial() = _$TransactionInitialImpl;
}

/// @nodoc
abstract class _$$TransactionLoadingImplCopyWith<$Res> {
  factory _$$TransactionLoadingImplCopyWith(
    _$TransactionLoadingImpl value,
    $Res Function(_$TransactionLoadingImpl) then,
  ) = __$$TransactionLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TransactionLoadingImplCopyWithImpl<$Res>
    extends _$TransactionStateCopyWithImpl<$Res, _$TransactionLoadingImpl>
    implements _$$TransactionLoadingImplCopyWith<$Res> {
  __$$TransactionLoadingImplCopyWithImpl(
    _$TransactionLoadingImpl _value,
    $Res Function(_$TransactionLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TransactionLoadingImpl implements TransactionLoading {
  const _$TransactionLoadingImpl();

  @override
  String toString() {
    return 'TransactionState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TransactionLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Transaction> transactions) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Transaction> transactions)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Transaction> transactions)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransactionInitial value) initial,
    required TResult Function(TransactionLoading value) loading,
    required TResult Function(TransactionLoaded value) loaded,
    required TResult Function(TransactionError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransactionInitial value)? initial,
    TResult? Function(TransactionLoading value)? loading,
    TResult? Function(TransactionLoaded value)? loaded,
    TResult? Function(TransactionError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransactionInitial value)? initial,
    TResult Function(TransactionLoading value)? loading,
    TResult Function(TransactionLoaded value)? loaded,
    TResult Function(TransactionError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class TransactionLoading implements TransactionState {
  const factory TransactionLoading() = _$TransactionLoadingImpl;
}

/// @nodoc
abstract class _$$TransactionLoadedImplCopyWith<$Res> {
  factory _$$TransactionLoadedImplCopyWith(
    _$TransactionLoadedImpl value,
    $Res Function(_$TransactionLoadedImpl) then,
  ) = __$$TransactionLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Transaction> transactions});
}

/// @nodoc
class __$$TransactionLoadedImplCopyWithImpl<$Res>
    extends _$TransactionStateCopyWithImpl<$Res, _$TransactionLoadedImpl>
    implements _$$TransactionLoadedImplCopyWith<$Res> {
  __$$TransactionLoadedImplCopyWithImpl(
    _$TransactionLoadedImpl _value,
    $Res Function(_$TransactionLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? transactions = null}) {
    return _then(
      _$TransactionLoadedImpl(
        null == transactions
            ? _value._transactions
            : transactions // ignore: cast_nullable_to_non_nullable
                  as List<Transaction>,
      ),
    );
  }
}

/// @nodoc

class _$TransactionLoadedImpl implements TransactionLoaded {
  const _$TransactionLoadedImpl(final List<Transaction> transactions)
    : _transactions = transactions;

  final List<Transaction> _transactions;
  @override
  List<Transaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  String toString() {
    return 'TransactionState.loaded(transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionLoadedImpl &&
            const DeepCollectionEquality().equals(
              other._transactions,
              _transactions,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_transactions),
  );

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionLoadedImplCopyWith<_$TransactionLoadedImpl> get copyWith =>
      __$$TransactionLoadedImplCopyWithImpl<_$TransactionLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Transaction> transactions) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(transactions);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Transaction> transactions)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(transactions);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Transaction> transactions)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(transactions);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransactionInitial value) initial,
    required TResult Function(TransactionLoading value) loading,
    required TResult Function(TransactionLoaded value) loaded,
    required TResult Function(TransactionError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransactionInitial value)? initial,
    TResult? Function(TransactionLoading value)? loading,
    TResult? Function(TransactionLoaded value)? loaded,
    TResult? Function(TransactionError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransactionInitial value)? initial,
    TResult Function(TransactionLoading value)? loading,
    TResult Function(TransactionLoaded value)? loaded,
    TResult Function(TransactionError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class TransactionLoaded implements TransactionState {
  const factory TransactionLoaded(final List<Transaction> transactions) =
      _$TransactionLoadedImpl;

  List<Transaction> get transactions;

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionLoadedImplCopyWith<_$TransactionLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TransactionErrorImplCopyWith<$Res> {
  factory _$$TransactionErrorImplCopyWith(
    _$TransactionErrorImpl value,
    $Res Function(_$TransactionErrorImpl) then,
  ) = __$$TransactionErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$TransactionErrorImplCopyWithImpl<$Res>
    extends _$TransactionStateCopyWithImpl<$Res, _$TransactionErrorImpl>
    implements _$$TransactionErrorImplCopyWith<$Res> {
  __$$TransactionErrorImplCopyWithImpl(
    _$TransactionErrorImpl _value,
    $Res Function(_$TransactionErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$TransactionErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TransactionErrorImpl implements TransactionError {
  const _$TransactionErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'TransactionState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionErrorImplCopyWith<_$TransactionErrorImpl> get copyWith =>
      __$$TransactionErrorImplCopyWithImpl<_$TransactionErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Transaction> transactions) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Transaction> transactions)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Transaction> transactions)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransactionInitial value) initial,
    required TResult Function(TransactionLoading value) loading,
    required TResult Function(TransactionLoaded value) loaded,
    required TResult Function(TransactionError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransactionInitial value)? initial,
    TResult? Function(TransactionLoading value)? loading,
    TResult? Function(TransactionLoaded value)? loaded,
    TResult? Function(TransactionError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransactionInitial value)? initial,
    TResult Function(TransactionLoading value)? loading,
    TResult Function(TransactionLoaded value)? loaded,
    TResult Function(TransactionError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class TransactionError implements TransactionState {
  const factory TransactionError(final String message) = _$TransactionErrorImpl;

  String get message;

  /// Create a copy of TransactionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionErrorImplCopyWith<_$TransactionErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
