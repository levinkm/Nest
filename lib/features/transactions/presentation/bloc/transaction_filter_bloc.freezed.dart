// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_filter_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TransactionFilterEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionFilterEventCopyWith<$Res> {
  factory $TransactionFilterEventCopyWith(
    TransactionFilterEvent value,
    $Res Function(TransactionFilterEvent) then,
  ) = _$TransactionFilterEventCopyWithImpl<$Res, TransactionFilterEvent>;
}

/// @nodoc
class _$TransactionFilterEventCopyWithImpl<
  $Res,
  $Val extends TransactionFilterEvent
>
    implements $TransactionFilterEventCopyWith<$Res> {
  _$TransactionFilterEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadTransactionsFilterImplCopyWith<$Res> {
  factory _$$LoadTransactionsFilterImplCopyWith(
    _$LoadTransactionsFilterImpl value,
    $Res Function(_$LoadTransactionsFilterImpl) then,
  ) = __$$LoadTransactionsFilterImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Transaction> transactions});
}

/// @nodoc
class __$$LoadTransactionsFilterImplCopyWithImpl<$Res>
    extends
        _$TransactionFilterEventCopyWithImpl<$Res, _$LoadTransactionsFilterImpl>
    implements _$$LoadTransactionsFilterImplCopyWith<$Res> {
  __$$LoadTransactionsFilterImplCopyWithImpl(
    _$LoadTransactionsFilterImpl _value,
    $Res Function(_$LoadTransactionsFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? transactions = null}) {
    return _then(
      _$LoadTransactionsFilterImpl(
        null == transactions
            ? _value._transactions
            : transactions // ignore: cast_nullable_to_non_nullable
                  as List<Transaction>,
      ),
    );
  }
}

/// @nodoc

class _$LoadTransactionsFilterImpl implements LoadTransactionsFilter {
  const _$LoadTransactionsFilterImpl(final List<Transaction> transactions)
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
    return 'TransactionFilterEvent.loadTransactions(transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadTransactionsFilterImpl &&
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

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadTransactionsFilterImplCopyWith<_$LoadTransactionsFilterImpl>
  get copyWith =>
      __$$LoadTransactionsFilterImplCopyWithImpl<_$LoadTransactionsFilterImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return loadTransactions(transactions);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return loadTransactions?.call(transactions);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (loadTransactions != null) {
      return loadTransactions(transactions);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return loadTransactions(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return loadTransactions?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (loadTransactions != null) {
      return loadTransactions(this);
    }
    return orElse();
  }
}

abstract class LoadTransactionsFilter implements TransactionFilterEvent {
  const factory LoadTransactionsFilter(final List<Transaction> transactions) =
      _$LoadTransactionsFilterImpl;

  List<Transaction> get transactions;

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadTransactionsFilterImplCopyWith<_$LoadTransactionsFilterImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateSearchImplCopyWith<$Res> {
  factory _$$UpdateSearchImplCopyWith(
    _$UpdateSearchImpl value,
    $Res Function(_$UpdateSearchImpl) then,
  ) = __$$UpdateSearchImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$UpdateSearchImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$UpdateSearchImpl>
    implements _$$UpdateSearchImplCopyWith<$Res> {
  __$$UpdateSearchImplCopyWithImpl(
    _$UpdateSearchImpl _value,
    $Res Function(_$UpdateSearchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? query = null}) {
    return _then(
      _$UpdateSearchImpl(
        null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UpdateSearchImpl implements UpdateSearch {
  const _$UpdateSearchImpl(this.query);

  @override
  final String query;

  @override
  String toString() {
    return 'TransactionFilterEvent.updateSearch(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSearchImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSearchImplCopyWith<_$UpdateSearchImpl> get copyWith =>
      __$$UpdateSearchImplCopyWithImpl<_$UpdateSearchImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return updateSearch(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return updateSearch?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (updateSearch != null) {
      return updateSearch(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return updateSearch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return updateSearch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (updateSearch != null) {
      return updateSearch(this);
    }
    return orElse();
  }
}

abstract class UpdateSearch implements TransactionFilterEvent {
  const factory UpdateSearch(final String query) = _$UpdateSearchImpl;

  String get query;

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSearchImplCopyWith<_$UpdateSearchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ToggleCategoryImplCopyWith<$Res> {
  factory _$$ToggleCategoryImplCopyWith(
    _$ToggleCategoryImpl value,
    $Res Function(_$ToggleCategoryImpl) then,
  ) = __$$ToggleCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String category});
}

/// @nodoc
class __$$ToggleCategoryImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$ToggleCategoryImpl>
    implements _$$ToggleCategoryImplCopyWith<$Res> {
  __$$ToggleCategoryImplCopyWithImpl(
    _$ToggleCategoryImpl _value,
    $Res Function(_$ToggleCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null}) {
    return _then(
      _$ToggleCategoryImpl(
        null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ToggleCategoryImpl implements ToggleCategory {
  const _$ToggleCategoryImpl(this.category);

  @override
  final String category;

  @override
  String toString() {
    return 'TransactionFilterEvent.toggleCategory(category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleCategoryImpl &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToggleCategoryImplCopyWith<_$ToggleCategoryImpl> get copyWith =>
      __$$ToggleCategoryImplCopyWithImpl<_$ToggleCategoryImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return toggleCategory(category);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return toggleCategory?.call(category);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleCategory != null) {
      return toggleCategory(category);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return toggleCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return toggleCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleCategory != null) {
      return toggleCategory(this);
    }
    return orElse();
  }
}

abstract class ToggleCategory implements TransactionFilterEvent {
  const factory ToggleCategory(final String category) = _$ToggleCategoryImpl;

  String get category;

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToggleCategoryImplCopyWith<_$ToggleCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ToggleTypeImplCopyWith<$Res> {
  factory _$$ToggleTypeImplCopyWith(
    _$ToggleTypeImpl value,
    $Res Function(_$ToggleTypeImpl) then,
  ) = __$$ToggleTypeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String type});
}

/// @nodoc
class __$$ToggleTypeImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$ToggleTypeImpl>
    implements _$$ToggleTypeImplCopyWith<$Res> {
  __$$ToggleTypeImplCopyWithImpl(
    _$ToggleTypeImpl _value,
    $Res Function(_$ToggleTypeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null}) {
    return _then(
      _$ToggleTypeImpl(
        null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ToggleTypeImpl implements ToggleType {
  const _$ToggleTypeImpl(this.type);

  @override
  final String type;

  @override
  String toString() {
    return 'TransactionFilterEvent.toggleType(type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleTypeImpl &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToggleTypeImplCopyWith<_$ToggleTypeImpl> get copyWith =>
      __$$ToggleTypeImplCopyWithImpl<_$ToggleTypeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return toggleType(type);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return toggleType?.call(type);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleType != null) {
      return toggleType(type);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return toggleType(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return toggleType?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleType != null) {
      return toggleType(this);
    }
    return orElse();
  }
}

abstract class ToggleType implements TransactionFilterEvent {
  const factory ToggleType(final String type) = _$ToggleTypeImpl;

  String get type;

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToggleTypeImplCopyWith<_$ToggleTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TogglePaymentMethodImplCopyWith<$Res> {
  factory _$$TogglePaymentMethodImplCopyWith(
    _$TogglePaymentMethodImpl value,
    $Res Function(_$TogglePaymentMethodImpl) then,
  ) = __$$TogglePaymentMethodImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String method});
}

/// @nodoc
class __$$TogglePaymentMethodImplCopyWithImpl<$Res>
    extends
        _$TransactionFilterEventCopyWithImpl<$Res, _$TogglePaymentMethodImpl>
    implements _$$TogglePaymentMethodImplCopyWith<$Res> {
  __$$TogglePaymentMethodImplCopyWithImpl(
    _$TogglePaymentMethodImpl _value,
    $Res Function(_$TogglePaymentMethodImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? method = null}) {
    return _then(
      _$TogglePaymentMethodImpl(
        null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TogglePaymentMethodImpl implements TogglePaymentMethod {
  const _$TogglePaymentMethodImpl(this.method);

  @override
  final String method;

  @override
  String toString() {
    return 'TransactionFilterEvent.togglePaymentMethod(method: $method)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TogglePaymentMethodImpl &&
            (identical(other.method, method) || other.method == method));
  }

  @override
  int get hashCode => Object.hash(runtimeType, method);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TogglePaymentMethodImplCopyWith<_$TogglePaymentMethodImpl> get copyWith =>
      __$$TogglePaymentMethodImplCopyWithImpl<_$TogglePaymentMethodImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return togglePaymentMethod(method);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return togglePaymentMethod?.call(method);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (togglePaymentMethod != null) {
      return togglePaymentMethod(method);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return togglePaymentMethod(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return togglePaymentMethod?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (togglePaymentMethod != null) {
      return togglePaymentMethod(this);
    }
    return orElse();
  }
}

abstract class TogglePaymentMethod implements TransactionFilterEvent {
  const factory TogglePaymentMethod(final String method) =
      _$TogglePaymentMethodImpl;

  String get method;

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TogglePaymentMethodImplCopyWith<_$TogglePaymentMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateDateRangeImplCopyWith<$Res> {
  factory _$$UpdateDateRangeImplCopyWith(
    _$UpdateDateRangeImpl value,
    $Res Function(_$UpdateDateRangeImpl) then,
  ) = __$$UpdateDateRangeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTimeRange<DateTime>? range});
}

/// @nodoc
class __$$UpdateDateRangeImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$UpdateDateRangeImpl>
    implements _$$UpdateDateRangeImplCopyWith<$Res> {
  __$$UpdateDateRangeImplCopyWithImpl(
    _$UpdateDateRangeImpl _value,
    $Res Function(_$UpdateDateRangeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? range = freezed}) {
    return _then(
      _$UpdateDateRangeImpl(
        freezed == range
            ? _value.range
            : range // ignore: cast_nullable_to_non_nullable
                  as DateTimeRange<DateTime>?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateDateRangeImpl implements UpdateDateRange {
  const _$UpdateDateRangeImpl(this.range);

  @override
  final DateTimeRange<DateTime>? range;

  @override
  String toString() {
    return 'TransactionFilterEvent.updateDateRange(range: $range)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateDateRangeImpl &&
            (identical(other.range, range) || other.range == range));
  }

  @override
  int get hashCode => Object.hash(runtimeType, range);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateDateRangeImplCopyWith<_$UpdateDateRangeImpl> get copyWith =>
      __$$UpdateDateRangeImplCopyWithImpl<_$UpdateDateRangeImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return updateDateRange(range);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return updateDateRange?.call(range);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (updateDateRange != null) {
      return updateDateRange(range);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return updateDateRange(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return updateDateRange?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (updateDateRange != null) {
      return updateDateRange(this);
    }
    return orElse();
  }
}

abstract class UpdateDateRange implements TransactionFilterEvent {
  const factory UpdateDateRange(final DateTimeRange<DateTime>? range) =
      _$UpdateDateRangeImpl;

  DateTimeRange<DateTime>? get range;

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateDateRangeImplCopyWith<_$UpdateDateRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateAmountRangeImplCopyWith<$Res> {
  factory _$$UpdateAmountRangeImplCopyWith(
    _$UpdateAmountRangeImpl value,
    $Res Function(_$UpdateAmountRangeImpl) then,
  ) = __$$UpdateAmountRangeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double? min, double? max});
}

/// @nodoc
class __$$UpdateAmountRangeImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$UpdateAmountRangeImpl>
    implements _$$UpdateAmountRangeImplCopyWith<$Res> {
  __$$UpdateAmountRangeImplCopyWithImpl(
    _$UpdateAmountRangeImpl _value,
    $Res Function(_$UpdateAmountRangeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? min = freezed, Object? max = freezed}) {
    return _then(
      _$UpdateAmountRangeImpl(
        freezed == min
            ? _value.min
            : min // ignore: cast_nullable_to_non_nullable
                  as double?,
        freezed == max
            ? _value.max
            : max // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateAmountRangeImpl implements UpdateAmountRange {
  const _$UpdateAmountRangeImpl(this.min, this.max);

  @override
  final double? min;
  @override
  final double? max;

  @override
  String toString() {
    return 'TransactionFilterEvent.updateAmountRange(min: $min, max: $max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateAmountRangeImpl &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max));
  }

  @override
  int get hashCode => Object.hash(runtimeType, min, max);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateAmountRangeImplCopyWith<_$UpdateAmountRangeImpl> get copyWith =>
      __$$UpdateAmountRangeImplCopyWithImpl<_$UpdateAmountRangeImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return updateAmountRange(min, max);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return updateAmountRange?.call(min, max);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (updateAmountRange != null) {
      return updateAmountRange(min, max);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return updateAmountRange(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return updateAmountRange?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (updateAmountRange != null) {
      return updateAmountRange(this);
    }
    return orElse();
  }
}

abstract class UpdateAmountRange implements TransactionFilterEvent {
  const factory UpdateAmountRange(final double? min, final double? max) =
      _$UpdateAmountRangeImpl;

  double? get min;
  double? get max;

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateAmountRangeImplCopyWith<_$UpdateAmountRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateSortImplCopyWith<$Res> {
  factory _$$UpdateSortImplCopyWith(
    _$UpdateSortImpl value,
    $Res Function(_$UpdateSortImpl) then,
  ) = __$$UpdateSortImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sortBy});
}

/// @nodoc
class __$$UpdateSortImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$UpdateSortImpl>
    implements _$$UpdateSortImplCopyWith<$Res> {
  __$$UpdateSortImplCopyWithImpl(
    _$UpdateSortImpl _value,
    $Res Function(_$UpdateSortImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sortBy = null}) {
    return _then(
      _$UpdateSortImpl(
        null == sortBy
            ? _value.sortBy
            : sortBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UpdateSortImpl implements UpdateSort {
  const _$UpdateSortImpl(this.sortBy);

  @override
  final String sortBy;

  @override
  String toString() {
    return 'TransactionFilterEvent.updateSort(sortBy: $sortBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSortImpl &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sortBy);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSortImplCopyWith<_$UpdateSortImpl> get copyWith =>
      __$$UpdateSortImplCopyWithImpl<_$UpdateSortImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return updateSort(sortBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return updateSort?.call(sortBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (updateSort != null) {
      return updateSort(sortBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return updateSort(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return updateSort?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (updateSort != null) {
      return updateSort(this);
    }
    return orElse();
  }
}

abstract class UpdateSort implements TransactionFilterEvent {
  const factory UpdateSort(final String sortBy) = _$UpdateSortImpl;

  String get sortBy;

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSortImplCopyWith<_$UpdateSortImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ToggleFiltersVisibilityImplCopyWith<$Res> {
  factory _$$ToggleFiltersVisibilityImplCopyWith(
    _$ToggleFiltersVisibilityImpl value,
    $Res Function(_$ToggleFiltersVisibilityImpl) then,
  ) = __$$ToggleFiltersVisibilityImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ToggleFiltersVisibilityImplCopyWithImpl<$Res>
    extends
        _$TransactionFilterEventCopyWithImpl<
          $Res,
          _$ToggleFiltersVisibilityImpl
        >
    implements _$$ToggleFiltersVisibilityImplCopyWith<$Res> {
  __$$ToggleFiltersVisibilityImplCopyWithImpl(
    _$ToggleFiltersVisibilityImpl _value,
    $Res Function(_$ToggleFiltersVisibilityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ToggleFiltersVisibilityImpl implements ToggleFiltersVisibility {
  const _$ToggleFiltersVisibilityImpl();

  @override
  String toString() {
    return 'TransactionFilterEvent.toggleFiltersVisibility()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleFiltersVisibilityImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return toggleFiltersVisibility();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return toggleFiltersVisibility?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleFiltersVisibility != null) {
      return toggleFiltersVisibility();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return toggleFiltersVisibility(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return toggleFiltersVisibility?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleFiltersVisibility != null) {
      return toggleFiltersVisibility(this);
    }
    return orElse();
  }
}

abstract class ToggleFiltersVisibility implements TransactionFilterEvent {
  const factory ToggleFiltersVisibility() = _$ToggleFiltersVisibilityImpl;
}

/// @nodoc
abstract class _$$ToggleStatisticsImplCopyWith<$Res> {
  factory _$$ToggleStatisticsImplCopyWith(
    _$ToggleStatisticsImpl value,
    $Res Function(_$ToggleStatisticsImpl) then,
  ) = __$$ToggleStatisticsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ToggleStatisticsImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$ToggleStatisticsImpl>
    implements _$$ToggleStatisticsImplCopyWith<$Res> {
  __$$ToggleStatisticsImplCopyWithImpl(
    _$ToggleStatisticsImpl _value,
    $Res Function(_$ToggleStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ToggleStatisticsImpl implements ToggleStatistics {
  const _$ToggleStatisticsImpl();

  @override
  String toString() {
    return 'TransactionFilterEvent.toggleStatistics()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ToggleStatisticsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return toggleStatistics();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return toggleStatistics?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleStatistics != null) {
      return toggleStatistics();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return toggleStatistics(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return toggleStatistics?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleStatistics != null) {
      return toggleStatistics(this);
    }
    return orElse();
  }
}

abstract class ToggleStatistics implements TransactionFilterEvent {
  const factory ToggleStatistics() = _$ToggleStatisticsImpl;
}

/// @nodoc
abstract class _$$ToggleChartImplCopyWith<$Res> {
  factory _$$ToggleChartImplCopyWith(
    _$ToggleChartImpl value,
    $Res Function(_$ToggleChartImpl) then,
  ) = __$$ToggleChartImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ToggleChartImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$ToggleChartImpl>
    implements _$$ToggleChartImplCopyWith<$Res> {
  __$$ToggleChartImplCopyWithImpl(
    _$ToggleChartImpl _value,
    $Res Function(_$ToggleChartImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ToggleChartImpl implements ToggleChart {
  const _$ToggleChartImpl();

  @override
  String toString() {
    return 'TransactionFilterEvent.toggleChart()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ToggleChartImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return toggleChart();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return toggleChart?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleChart != null) {
      return toggleChart();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return toggleChart(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return toggleChart?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleChart != null) {
      return toggleChart(this);
    }
    return orElse();
  }
}

abstract class ToggleChart implements TransactionFilterEvent {
  const factory ToggleChart() = _$ToggleChartImpl;
}

/// @nodoc
abstract class _$$ToggleBulkSelectImplCopyWith<$Res> {
  factory _$$ToggleBulkSelectImplCopyWith(
    _$ToggleBulkSelectImpl value,
    $Res Function(_$ToggleBulkSelectImpl) then,
  ) = __$$ToggleBulkSelectImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ToggleBulkSelectImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$ToggleBulkSelectImpl>
    implements _$$ToggleBulkSelectImplCopyWith<$Res> {
  __$$ToggleBulkSelectImplCopyWithImpl(
    _$ToggleBulkSelectImpl _value,
    $Res Function(_$ToggleBulkSelectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ToggleBulkSelectImpl implements ToggleBulkSelect {
  const _$ToggleBulkSelectImpl();

  @override
  String toString() {
    return 'TransactionFilterEvent.toggleBulkSelect()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ToggleBulkSelectImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return toggleBulkSelect();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return toggleBulkSelect?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleBulkSelect != null) {
      return toggleBulkSelect();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return toggleBulkSelect(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return toggleBulkSelect?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleBulkSelect != null) {
      return toggleBulkSelect(this);
    }
    return orElse();
  }
}

abstract class ToggleBulkSelect implements TransactionFilterEvent {
  const factory ToggleBulkSelect() = _$ToggleBulkSelectImpl;
}

/// @nodoc
abstract class _$$ToggleTransactionSelectionImplCopyWith<$Res> {
  factory _$$ToggleTransactionSelectionImplCopyWith(
    _$ToggleTransactionSelectionImpl value,
    $Res Function(_$ToggleTransactionSelectionImpl) then,
  ) = __$$ToggleTransactionSelectionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$ToggleTransactionSelectionImplCopyWithImpl<$Res>
    extends
        _$TransactionFilterEventCopyWithImpl<
          $Res,
          _$ToggleTransactionSelectionImpl
        >
    implements _$$ToggleTransactionSelectionImplCopyWith<$Res> {
  __$$ToggleTransactionSelectionImplCopyWithImpl(
    _$ToggleTransactionSelectionImpl _value,
    $Res Function(_$ToggleTransactionSelectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      _$ToggleTransactionSelectionImpl(
        null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ToggleTransactionSelectionImpl implements ToggleTransactionSelection {
  const _$ToggleTransactionSelectionImpl(this.id);

  @override
  final String id;

  @override
  String toString() {
    return 'TransactionFilterEvent.toggleTransactionSelection(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleTransactionSelectionImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToggleTransactionSelectionImplCopyWith<_$ToggleTransactionSelectionImpl>
  get copyWith =>
      __$$ToggleTransactionSelectionImplCopyWithImpl<
        _$ToggleTransactionSelectionImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return toggleTransactionSelection(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return toggleTransactionSelection?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleTransactionSelection != null) {
      return toggleTransactionSelection(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return toggleTransactionSelection(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return toggleTransactionSelection?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (toggleTransactionSelection != null) {
      return toggleTransactionSelection(this);
    }
    return orElse();
  }
}

abstract class ToggleTransactionSelection implements TransactionFilterEvent {
  const factory ToggleTransactionSelection(final String id) =
      _$ToggleTransactionSelectionImpl;

  String get id;

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToggleTransactionSelectionImplCopyWith<_$ToggleTransactionSelectionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearSelectionsImplCopyWith<$Res> {
  factory _$$ClearSelectionsImplCopyWith(
    _$ClearSelectionsImpl value,
    $Res Function(_$ClearSelectionsImpl) then,
  ) = __$$ClearSelectionsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearSelectionsImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$ClearSelectionsImpl>
    implements _$$ClearSelectionsImplCopyWith<$Res> {
  __$$ClearSelectionsImplCopyWithImpl(
    _$ClearSelectionsImpl _value,
    $Res Function(_$ClearSelectionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearSelectionsImpl implements ClearSelections {
  const _$ClearSelectionsImpl();

  @override
  String toString() {
    return 'TransactionFilterEvent.clearSelections()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearSelectionsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return clearSelections();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return clearSelections?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (clearSelections != null) {
      return clearSelections();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return clearSelections(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return clearSelections?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (clearSelections != null) {
      return clearSelections(this);
    }
    return orElse();
  }
}

abstract class ClearSelections implements TransactionFilterEvent {
  const factory ClearSelections() = _$ClearSelectionsImpl;
}

/// @nodoc
abstract class _$$ClearFiltersImplCopyWith<$Res> {
  factory _$$ClearFiltersImplCopyWith(
    _$ClearFiltersImpl value,
    $Res Function(_$ClearFiltersImpl) then,
  ) = __$$ClearFiltersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearFiltersImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$ClearFiltersImpl>
    implements _$$ClearFiltersImplCopyWith<$Res> {
  __$$ClearFiltersImplCopyWithImpl(
    _$ClearFiltersImpl _value,
    $Res Function(_$ClearFiltersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearFiltersImpl implements ClearFilters {
  const _$ClearFiltersImpl();

  @override
  String toString() {
    return 'TransactionFilterEvent.clearFilters()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearFiltersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return clearFilters();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return clearFilters?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (clearFilters != null) {
      return clearFilters();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return clearFilters(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return clearFilters?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (clearFilters != null) {
      return clearFilters(this);
    }
    return orElse();
  }
}

abstract class ClearFilters implements TransactionFilterEvent {
  const factory ClearFilters() = _$ClearFiltersImpl;
}

/// @nodoc
abstract class _$$ExpandTransactionImplCopyWith<$Res> {
  factory _$$ExpandTransactionImplCopyWith(
    _$ExpandTransactionImpl value,
    $Res Function(_$ExpandTransactionImpl) then,
  ) = __$$ExpandTransactionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? id});
}

/// @nodoc
class __$$ExpandTransactionImplCopyWithImpl<$Res>
    extends _$TransactionFilterEventCopyWithImpl<$Res, _$ExpandTransactionImpl>
    implements _$$ExpandTransactionImplCopyWith<$Res> {
  __$$ExpandTransactionImplCopyWithImpl(
    _$ExpandTransactionImpl _value,
    $Res Function(_$ExpandTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed}) {
    return _then(
      _$ExpandTransactionImpl(
        freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ExpandTransactionImpl implements ExpandTransaction {
  const _$ExpandTransactionImpl(this.id);

  @override
  final String? id;

  @override
  String toString() {
    return 'TransactionFilterEvent.expandTransaction(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpandTransactionImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpandTransactionImplCopyWith<_$ExpandTransactionImpl> get copyWith =>
      __$$ExpandTransactionImplCopyWithImpl<_$ExpandTransactionImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<Transaction> transactions) loadTransactions,
    required TResult Function(String query) updateSearch,
    required TResult Function(String category) toggleCategory,
    required TResult Function(String type) toggleType,
    required TResult Function(String method) togglePaymentMethod,
    required TResult Function(DateTimeRange<DateTime>? range) updateDateRange,
    required TResult Function(double? min, double? max) updateAmountRange,
    required TResult Function(String sortBy) updateSort,
    required TResult Function() toggleFiltersVisibility,
    required TResult Function() toggleStatistics,
    required TResult Function() toggleChart,
    required TResult Function() toggleBulkSelect,
    required TResult Function(String id) toggleTransactionSelection,
    required TResult Function() clearSelections,
    required TResult Function() clearFilters,
    required TResult Function(String? id) expandTransaction,
  }) {
    return expandTransaction(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<Transaction> transactions)? loadTransactions,
    TResult? Function(String query)? updateSearch,
    TResult? Function(String category)? toggleCategory,
    TResult? Function(String type)? toggleType,
    TResult? Function(String method)? togglePaymentMethod,
    TResult? Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult? Function(double? min, double? max)? updateAmountRange,
    TResult? Function(String sortBy)? updateSort,
    TResult? Function()? toggleFiltersVisibility,
    TResult? Function()? toggleStatistics,
    TResult? Function()? toggleChart,
    TResult? Function()? toggleBulkSelect,
    TResult? Function(String id)? toggleTransactionSelection,
    TResult? Function()? clearSelections,
    TResult? Function()? clearFilters,
    TResult? Function(String? id)? expandTransaction,
  }) {
    return expandTransaction?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<Transaction> transactions)? loadTransactions,
    TResult Function(String query)? updateSearch,
    TResult Function(String category)? toggleCategory,
    TResult Function(String type)? toggleType,
    TResult Function(String method)? togglePaymentMethod,
    TResult Function(DateTimeRange<DateTime>? range)? updateDateRange,
    TResult Function(double? min, double? max)? updateAmountRange,
    TResult Function(String sortBy)? updateSort,
    TResult Function()? toggleFiltersVisibility,
    TResult Function()? toggleStatistics,
    TResult Function()? toggleChart,
    TResult Function()? toggleBulkSelect,
    TResult Function(String id)? toggleTransactionSelection,
    TResult Function()? clearSelections,
    TResult Function()? clearFilters,
    TResult Function(String? id)? expandTransaction,
    required TResult orElse(),
  }) {
    if (expandTransaction != null) {
      return expandTransaction(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadTransactionsFilter value) loadTransactions,
    required TResult Function(UpdateSearch value) updateSearch,
    required TResult Function(ToggleCategory value) toggleCategory,
    required TResult Function(ToggleType value) toggleType,
    required TResult Function(TogglePaymentMethod value) togglePaymentMethod,
    required TResult Function(UpdateDateRange value) updateDateRange,
    required TResult Function(UpdateAmountRange value) updateAmountRange,
    required TResult Function(UpdateSort value) updateSort,
    required TResult Function(ToggleFiltersVisibility value)
    toggleFiltersVisibility,
    required TResult Function(ToggleStatistics value) toggleStatistics,
    required TResult Function(ToggleChart value) toggleChart,
    required TResult Function(ToggleBulkSelect value) toggleBulkSelect,
    required TResult Function(ToggleTransactionSelection value)
    toggleTransactionSelection,
    required TResult Function(ClearSelections value) clearSelections,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(ExpandTransaction value) expandTransaction,
  }) {
    return expandTransaction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadTransactionsFilter value)? loadTransactions,
    TResult? Function(UpdateSearch value)? updateSearch,
    TResult? Function(ToggleCategory value)? toggleCategory,
    TResult? Function(ToggleType value)? toggleType,
    TResult? Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult? Function(UpdateDateRange value)? updateDateRange,
    TResult? Function(UpdateAmountRange value)? updateAmountRange,
    TResult? Function(UpdateSort value)? updateSort,
    TResult? Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult? Function(ToggleStatistics value)? toggleStatistics,
    TResult? Function(ToggleChart value)? toggleChart,
    TResult? Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult? Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult? Function(ClearSelections value)? clearSelections,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(ExpandTransaction value)? expandTransaction,
  }) {
    return expandTransaction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadTransactionsFilter value)? loadTransactions,
    TResult Function(UpdateSearch value)? updateSearch,
    TResult Function(ToggleCategory value)? toggleCategory,
    TResult Function(ToggleType value)? toggleType,
    TResult Function(TogglePaymentMethod value)? togglePaymentMethod,
    TResult Function(UpdateDateRange value)? updateDateRange,
    TResult Function(UpdateAmountRange value)? updateAmountRange,
    TResult Function(UpdateSort value)? updateSort,
    TResult Function(ToggleFiltersVisibility value)? toggleFiltersVisibility,
    TResult Function(ToggleStatistics value)? toggleStatistics,
    TResult Function(ToggleChart value)? toggleChart,
    TResult Function(ToggleBulkSelect value)? toggleBulkSelect,
    TResult Function(ToggleTransactionSelection value)?
    toggleTransactionSelection,
    TResult Function(ClearSelections value)? clearSelections,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(ExpandTransaction value)? expandTransaction,
    required TResult orElse(),
  }) {
    if (expandTransaction != null) {
      return expandTransaction(this);
    }
    return orElse();
  }
}

abstract class ExpandTransaction implements TransactionFilterEvent {
  const factory ExpandTransaction(final String? id) = _$ExpandTransactionImpl;

  String? get id;

  /// Create a copy of TransactionFilterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpandTransactionImplCopyWith<_$ExpandTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TransactionFilterState {
  List<Transaction> get allTransactions => throw _privateConstructorUsedError;
  List<Transaction> get filteredTransactions =>
      throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  Set<String> get selectedCategories => throw _privateConstructorUsedError;
  Set<String> get selectedTypes => throw _privateConstructorUsedError;
  Set<String> get selectedPaymentMethods => throw _privateConstructorUsedError;
  DateTimeRange<DateTime>? get dateRange => throw _privateConstructorUsedError;
  double? get minAmount => throw _privateConstructorUsedError;
  double? get maxAmount => throw _privateConstructorUsedError;
  String get sortBy => throw _privateConstructorUsedError;
  bool get showFilters => throw _privateConstructorUsedError;
  bool get showStatistics => throw _privateConstructorUsedError;
  bool get showChart => throw _privateConstructorUsedError;
  bool get bulkSelectMode => throw _privateConstructorUsedError;
  Set<String> get selectedTransactionIds => throw _privateConstructorUsedError;
  String? get expandedTransactionId => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionFilterStateCopyWith<TransactionFilterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionFilterStateCopyWith<$Res> {
  factory $TransactionFilterStateCopyWith(
    TransactionFilterState value,
    $Res Function(TransactionFilterState) then,
  ) = _$TransactionFilterStateCopyWithImpl<$Res, TransactionFilterState>;
  @useResult
  $Res call({
    List<Transaction> allTransactions,
    List<Transaction> filteredTransactions,
    String searchQuery,
    Set<String> selectedCategories,
    Set<String> selectedTypes,
    Set<String> selectedPaymentMethods,
    DateTimeRange<DateTime>? dateRange,
    double? minAmount,
    double? maxAmount,
    String sortBy,
    bool showFilters,
    bool showStatistics,
    bool showChart,
    bool bulkSelectMode,
    Set<String> selectedTransactionIds,
    String? expandedTransactionId,
    bool loading,
  });
}

/// @nodoc
class _$TransactionFilterStateCopyWithImpl<
  $Res,
  $Val extends TransactionFilterState
>
    implements $TransactionFilterStateCopyWith<$Res> {
  _$TransactionFilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allTransactions = null,
    Object? filteredTransactions = null,
    Object? searchQuery = null,
    Object? selectedCategories = null,
    Object? selectedTypes = null,
    Object? selectedPaymentMethods = null,
    Object? dateRange = freezed,
    Object? minAmount = freezed,
    Object? maxAmount = freezed,
    Object? sortBy = null,
    Object? showFilters = null,
    Object? showStatistics = null,
    Object? showChart = null,
    Object? bulkSelectMode = null,
    Object? selectedTransactionIds = null,
    Object? expandedTransactionId = freezed,
    Object? loading = null,
  }) {
    return _then(
      _value.copyWith(
            allTransactions: null == allTransactions
                ? _value.allTransactions
                : allTransactions // ignore: cast_nullable_to_non_nullable
                      as List<Transaction>,
            filteredTransactions: null == filteredTransactions
                ? _value.filteredTransactions
                : filteredTransactions // ignore: cast_nullable_to_non_nullable
                      as List<Transaction>,
            searchQuery: null == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedCategories: null == selectedCategories
                ? _value.selectedCategories
                : selectedCategories // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            selectedTypes: null == selectedTypes
                ? _value.selectedTypes
                : selectedTypes // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            selectedPaymentMethods: null == selectedPaymentMethods
                ? _value.selectedPaymentMethods
                : selectedPaymentMethods // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            dateRange: freezed == dateRange
                ? _value.dateRange
                : dateRange // ignore: cast_nullable_to_non_nullable
                      as DateTimeRange<DateTime>?,
            minAmount: freezed == minAmount
                ? _value.minAmount
                : minAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxAmount: freezed == maxAmount
                ? _value.maxAmount
                : maxAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            sortBy: null == sortBy
                ? _value.sortBy
                : sortBy // ignore: cast_nullable_to_non_nullable
                      as String,
            showFilters: null == showFilters
                ? _value.showFilters
                : showFilters // ignore: cast_nullable_to_non_nullable
                      as bool,
            showStatistics: null == showStatistics
                ? _value.showStatistics
                : showStatistics // ignore: cast_nullable_to_non_nullable
                      as bool,
            showChart: null == showChart
                ? _value.showChart
                : showChart // ignore: cast_nullable_to_non_nullable
                      as bool,
            bulkSelectMode: null == bulkSelectMode
                ? _value.bulkSelectMode
                : bulkSelectMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            selectedTransactionIds: null == selectedTransactionIds
                ? _value.selectedTransactionIds
                : selectedTransactionIds // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            expandedTransactionId: freezed == expandedTransactionId
                ? _value.expandedTransactionId
                : expandedTransactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            loading: null == loading
                ? _value.loading
                : loading // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionFilterStateImplCopyWith<$Res>
    implements $TransactionFilterStateCopyWith<$Res> {
  factory _$$TransactionFilterStateImplCopyWith(
    _$TransactionFilterStateImpl value,
    $Res Function(_$TransactionFilterStateImpl) then,
  ) = __$$TransactionFilterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Transaction> allTransactions,
    List<Transaction> filteredTransactions,
    String searchQuery,
    Set<String> selectedCategories,
    Set<String> selectedTypes,
    Set<String> selectedPaymentMethods,
    DateTimeRange<DateTime>? dateRange,
    double? minAmount,
    double? maxAmount,
    String sortBy,
    bool showFilters,
    bool showStatistics,
    bool showChart,
    bool bulkSelectMode,
    Set<String> selectedTransactionIds,
    String? expandedTransactionId,
    bool loading,
  });
}

/// @nodoc
class __$$TransactionFilterStateImplCopyWithImpl<$Res>
    extends
        _$TransactionFilterStateCopyWithImpl<$Res, _$TransactionFilterStateImpl>
    implements _$$TransactionFilterStateImplCopyWith<$Res> {
  __$$TransactionFilterStateImplCopyWithImpl(
    _$TransactionFilterStateImpl _value,
    $Res Function(_$TransactionFilterStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allTransactions = null,
    Object? filteredTransactions = null,
    Object? searchQuery = null,
    Object? selectedCategories = null,
    Object? selectedTypes = null,
    Object? selectedPaymentMethods = null,
    Object? dateRange = freezed,
    Object? minAmount = freezed,
    Object? maxAmount = freezed,
    Object? sortBy = null,
    Object? showFilters = null,
    Object? showStatistics = null,
    Object? showChart = null,
    Object? bulkSelectMode = null,
    Object? selectedTransactionIds = null,
    Object? expandedTransactionId = freezed,
    Object? loading = null,
  }) {
    return _then(
      _$TransactionFilterStateImpl(
        allTransactions: null == allTransactions
            ? _value._allTransactions
            : allTransactions // ignore: cast_nullable_to_non_nullable
                  as List<Transaction>,
        filteredTransactions: null == filteredTransactions
            ? _value._filteredTransactions
            : filteredTransactions // ignore: cast_nullable_to_non_nullable
                  as List<Transaction>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedCategories: null == selectedCategories
            ? _value._selectedCategories
            : selectedCategories // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        selectedTypes: null == selectedTypes
            ? _value._selectedTypes
            : selectedTypes // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        selectedPaymentMethods: null == selectedPaymentMethods
            ? _value._selectedPaymentMethods
            : selectedPaymentMethods // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        dateRange: freezed == dateRange
            ? _value.dateRange
            : dateRange // ignore: cast_nullable_to_non_nullable
                  as DateTimeRange<DateTime>?,
        minAmount: freezed == minAmount
            ? _value.minAmount
            : minAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxAmount: freezed == maxAmount
            ? _value.maxAmount
            : maxAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        sortBy: null == sortBy
            ? _value.sortBy
            : sortBy // ignore: cast_nullable_to_non_nullable
                  as String,
        showFilters: null == showFilters
            ? _value.showFilters
            : showFilters // ignore: cast_nullable_to_non_nullable
                  as bool,
        showStatistics: null == showStatistics
            ? _value.showStatistics
            : showStatistics // ignore: cast_nullable_to_non_nullable
                  as bool,
        showChart: null == showChart
            ? _value.showChart
            : showChart // ignore: cast_nullable_to_non_nullable
                  as bool,
        bulkSelectMode: null == bulkSelectMode
            ? _value.bulkSelectMode
            : bulkSelectMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        selectedTransactionIds: null == selectedTransactionIds
            ? _value._selectedTransactionIds
            : selectedTransactionIds // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        expandedTransactionId: freezed == expandedTransactionId
            ? _value.expandedTransactionId
            : expandedTransactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        loading: null == loading
            ? _value.loading
            : loading // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$TransactionFilterStateImpl implements _TransactionFilterState {
  const _$TransactionFilterStateImpl({
    final List<Transaction> allTransactions = const [],
    final List<Transaction> filteredTransactions = const [],
    this.searchQuery = '',
    final Set<String> selectedCategories = const {},
    final Set<String> selectedTypes = const {},
    final Set<String> selectedPaymentMethods = const {},
    this.dateRange,
    this.minAmount,
    this.maxAmount,
    this.sortBy = 'date_desc',
    this.showFilters = false,
    this.showStatistics = true,
    this.showChart = false,
    this.bulkSelectMode = false,
    final Set<String> selectedTransactionIds = const {},
    this.expandedTransactionId,
    this.loading = false,
  }) : _allTransactions = allTransactions,
       _filteredTransactions = filteredTransactions,
       _selectedCategories = selectedCategories,
       _selectedTypes = selectedTypes,
       _selectedPaymentMethods = selectedPaymentMethods,
       _selectedTransactionIds = selectedTransactionIds;

  final List<Transaction> _allTransactions;
  @override
  @JsonKey()
  List<Transaction> get allTransactions {
    if (_allTransactions is EqualUnmodifiableListView) return _allTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allTransactions);
  }

  final List<Transaction> _filteredTransactions;
  @override
  @JsonKey()
  List<Transaction> get filteredTransactions {
    if (_filteredTransactions is EqualUnmodifiableListView)
      return _filteredTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredTransactions);
  }

  @override
  @JsonKey()
  final String searchQuery;
  final Set<String> _selectedCategories;
  @override
  @JsonKey()
  Set<String> get selectedCategories {
    if (_selectedCategories is EqualUnmodifiableSetView)
      return _selectedCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedCategories);
  }

  final Set<String> _selectedTypes;
  @override
  @JsonKey()
  Set<String> get selectedTypes {
    if (_selectedTypes is EqualUnmodifiableSetView) return _selectedTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedTypes);
  }

  final Set<String> _selectedPaymentMethods;
  @override
  @JsonKey()
  Set<String> get selectedPaymentMethods {
    if (_selectedPaymentMethods is EqualUnmodifiableSetView)
      return _selectedPaymentMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedPaymentMethods);
  }

  @override
  final DateTimeRange<DateTime>? dateRange;
  @override
  final double? minAmount;
  @override
  final double? maxAmount;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final bool showFilters;
  @override
  @JsonKey()
  final bool showStatistics;
  @override
  @JsonKey()
  final bool showChart;
  @override
  @JsonKey()
  final bool bulkSelectMode;
  final Set<String> _selectedTransactionIds;
  @override
  @JsonKey()
  Set<String> get selectedTransactionIds {
    if (_selectedTransactionIds is EqualUnmodifiableSetView)
      return _selectedTransactionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedTransactionIds);
  }

  @override
  final String? expandedTransactionId;
  @override
  @JsonKey()
  final bool loading;

  @override
  String toString() {
    return 'TransactionFilterState(allTransactions: $allTransactions, filteredTransactions: $filteredTransactions, searchQuery: $searchQuery, selectedCategories: $selectedCategories, selectedTypes: $selectedTypes, selectedPaymentMethods: $selectedPaymentMethods, dateRange: $dateRange, minAmount: $minAmount, maxAmount: $maxAmount, sortBy: $sortBy, showFilters: $showFilters, showStatistics: $showStatistics, showChart: $showChart, bulkSelectMode: $bulkSelectMode, selectedTransactionIds: $selectedTransactionIds, expandedTransactionId: $expandedTransactionId, loading: $loading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionFilterStateImpl &&
            const DeepCollectionEquality().equals(
              other._allTransactions,
              _allTransactions,
            ) &&
            const DeepCollectionEquality().equals(
              other._filteredTransactions,
              _filteredTransactions,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality().equals(
              other._selectedCategories,
              _selectedCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._selectedTypes,
              _selectedTypes,
            ) &&
            const DeepCollectionEquality().equals(
              other._selectedPaymentMethods,
              _selectedPaymentMethods,
            ) &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.showFilters, showFilters) ||
                other.showFilters == showFilters) &&
            (identical(other.showStatistics, showStatistics) ||
                other.showStatistics == showStatistics) &&
            (identical(other.showChart, showChart) ||
                other.showChart == showChart) &&
            (identical(other.bulkSelectMode, bulkSelectMode) ||
                other.bulkSelectMode == bulkSelectMode) &&
            const DeepCollectionEquality().equals(
              other._selectedTransactionIds,
              _selectedTransactionIds,
            ) &&
            (identical(other.expandedTransactionId, expandedTransactionId) ||
                other.expandedTransactionId == expandedTransactionId) &&
            (identical(other.loading, loading) || other.loading == loading));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_allTransactions),
    const DeepCollectionEquality().hash(_filteredTransactions),
    searchQuery,
    const DeepCollectionEquality().hash(_selectedCategories),
    const DeepCollectionEquality().hash(_selectedTypes),
    const DeepCollectionEquality().hash(_selectedPaymentMethods),
    dateRange,
    minAmount,
    maxAmount,
    sortBy,
    showFilters,
    showStatistics,
    showChart,
    bulkSelectMode,
    const DeepCollectionEquality().hash(_selectedTransactionIds),
    expandedTransactionId,
    loading,
  );

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionFilterStateImplCopyWith<_$TransactionFilterStateImpl>
  get copyWith =>
      __$$TransactionFilterStateImplCopyWithImpl<_$TransactionFilterStateImpl>(
        this,
        _$identity,
      );
}

abstract class _TransactionFilterState implements TransactionFilterState {
  const factory _TransactionFilterState({
    final List<Transaction> allTransactions,
    final List<Transaction> filteredTransactions,
    final String searchQuery,
    final Set<String> selectedCategories,
    final Set<String> selectedTypes,
    final Set<String> selectedPaymentMethods,
    final DateTimeRange<DateTime>? dateRange,
    final double? minAmount,
    final double? maxAmount,
    final String sortBy,
    final bool showFilters,
    final bool showStatistics,
    final bool showChart,
    final bool bulkSelectMode,
    final Set<String> selectedTransactionIds,
    final String? expandedTransactionId,
    final bool loading,
  }) = _$TransactionFilterStateImpl;

  @override
  List<Transaction> get allTransactions;
  @override
  List<Transaction> get filteredTransactions;
  @override
  String get searchQuery;
  @override
  Set<String> get selectedCategories;
  @override
  Set<String> get selectedTypes;
  @override
  Set<String> get selectedPaymentMethods;
  @override
  DateTimeRange<DateTime>? get dateRange;
  @override
  double? get minAmount;
  @override
  double? get maxAmount;
  @override
  String get sortBy;
  @override
  bool get showFilters;
  @override
  bool get showStatistics;
  @override
  bool get showChart;
  @override
  bool get bulkSelectMode;
  @override
  Set<String> get selectedTransactionIds;
  @override
  String? get expandedTransactionId;
  @override
  bool get loading;

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionFilterStateImplCopyWith<_$TransactionFilterStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
