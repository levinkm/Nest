import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_filter_bloc.freezed.dart';

// Events
@freezed
class TransactionFilterEvent with _$TransactionFilterEvent {
  const factory TransactionFilterEvent.loadTransactions(
    List<Transaction> transactions,
  ) = LoadTransactionsFilter;
  const factory TransactionFilterEvent.updateSearch(String query) =
      UpdateSearch;
  const factory TransactionFilterEvent.toggleCategory(String category) =
      ToggleCategory;
  const factory TransactionFilterEvent.toggleType(String type) = ToggleType;
  const factory TransactionFilterEvent.togglePaymentMethod(String method) =
      TogglePaymentMethod;
  const factory TransactionFilterEvent.updateDateRange(DateTimeRange? range) =
      UpdateDateRange;
  const factory TransactionFilterEvent.updateAmountRange(
    double? min,
    double? max,
  ) = UpdateAmountRange;
  const factory TransactionFilterEvent.updateSort(String sortBy) = UpdateSort;
  const factory TransactionFilterEvent.toggleFiltersVisibility() =
      ToggleFiltersVisibility;
  const factory TransactionFilterEvent.toggleStatistics() = ToggleStatistics;
  const factory TransactionFilterEvent.toggleChart() = ToggleChart;
  const factory TransactionFilterEvent.toggleBulkSelect() = ToggleBulkSelect;
  const factory TransactionFilterEvent.toggleTransactionSelection(String id) =
      ToggleTransactionSelection;
  const factory TransactionFilterEvent.clearSelections() = ClearSelections;
  const factory TransactionFilterEvent.clearFilters() = ClearFilters;
  const factory TransactionFilterEvent.expandTransaction(String? id) =
      ExpandTransaction;
}

// State
@freezed
class TransactionFilterState with _$TransactionFilterState {
  const factory TransactionFilterState({
    @Default([]) List<Transaction> allTransactions,
    @Default([]) List<Transaction> filteredTransactions,
    @Default('') String searchQuery,
    @Default({}) Set<String> selectedCategories,
    @Default({}) Set<String> selectedTypes,
    @Default({}) Set<String> selectedPaymentMethods,
    DateTimeRange? dateRange,
    double? minAmount,
    double? maxAmount,
    @Default('date_desc') String sortBy,
    @Default(false) bool showFilters,
    @Default(true) bool showStatistics,
    @Default(false) bool showChart,
    @Default(false) bool bulkSelectMode,
    @Default({}) Set<String> selectedTransactionIds,
    String? expandedTransactionId,
    @Default(false) bool loading,
  }) = _TransactionFilterState;
}

// BLoC
class TransactionFilterBloc
    extends Bloc<TransactionFilterEvent, TransactionFilterState> {
  TransactionFilterBloc() : super(const TransactionFilterState()) {
    on<LoadTransactionsFilter>(_onLoadTransactions);
    on<UpdateSearch>(_onUpdateSearch);
    on<ToggleCategory>(_onToggleCategory);
    on<ToggleType>(_onToggleType);
    on<TogglePaymentMethod>(_onTogglePaymentMethod);
    on<UpdateDateRange>(_onUpdateDateRange);
    on<UpdateAmountRange>(_onUpdateAmountRange);
    on<UpdateSort>(_onUpdateSort);
    on<ToggleFiltersVisibility>(_onToggleFiltersVisibility);
    on<ToggleStatistics>(_onToggleStatistics);
    on<ToggleChart>(_onToggleChart);
    on<ToggleBulkSelect>(_onToggleBulkSelect);
    on<ToggleTransactionSelection>(_onToggleTransactionSelection);
    on<ClearSelections>(_onClearSelections);
    on<ClearFilters>(_onClearFilters);
    on<ExpandTransaction>(_onExpandTransaction);
  }

  void _onLoadTransactions(
    LoadTransactionsFilter event,
    Emitter<TransactionFilterState> emit,
  ) {
    emit(state.copyWith(allTransactions: event.transactions));
    _applyFilters(emit);
  }

  void _onUpdateSearch(
    UpdateSearch event,
    Emitter<TransactionFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
    _applyFilters(emit);
  }

  void _onToggleCategory(
    ToggleCategory event,
    Emitter<TransactionFilterState> emit,
  ) {
    final categories = Set<String>.from(state.selectedCategories);
    if (categories.contains(event.category)) {
      categories.remove(event.category);
    } else {
      categories.add(event.category);
    }
    emit(state.copyWith(selectedCategories: categories));
    _applyFilters(emit);
  }

  void _onToggleType(ToggleType event, Emitter<TransactionFilterState> emit) {
    final types = Set<String>.from(state.selectedTypes);
    if (types.contains(event.type)) {
      types.remove(event.type);
    } else {
      types.add(event.type);
    }
    emit(state.copyWith(selectedTypes: types));
    _applyFilters(emit);
  }

  void _onTogglePaymentMethod(
    TogglePaymentMethod event,
    Emitter<TransactionFilterState> emit,
  ) {
    final methods = Set<String>.from(state.selectedPaymentMethods);
    if (methods.contains(event.method)) {
      methods.remove(event.method);
    } else {
      methods.add(event.method);
    }
    emit(state.copyWith(selectedPaymentMethods: methods));
    _applyFilters(emit);
  }

  void _onUpdateDateRange(
    UpdateDateRange event,
    Emitter<TransactionFilterState> emit,
  ) {
    emit(state.copyWith(dateRange: event.range));
    _applyFilters(emit);
  }

  void _onUpdateAmountRange(
    UpdateAmountRange event,
    Emitter<TransactionFilterState> emit,
  ) {
    emit(state.copyWith(minAmount: event.min, maxAmount: event.max));
    _applyFilters(emit);
  }

  void _onUpdateSort(UpdateSort event, Emitter<TransactionFilterState> emit) {
    emit(state.copyWith(sortBy: event.sortBy));
    _applyFilters(emit);
  }

  void _onToggleFiltersVisibility(
    ToggleFiltersVisibility event,
    Emitter<TransactionFilterState> emit,
  ) {
    emit(state.copyWith(showFilters: !state.showFilters));
  }

  void _onToggleStatistics(
    ToggleStatistics event,
    Emitter<TransactionFilterState> emit,
  ) {
    emit(state.copyWith(showStatistics: !state.showStatistics));
  }

  void _onToggleChart(ToggleChart event, Emitter<TransactionFilterState> emit) {
    emit(state.copyWith(showChart: !state.showChart));
  }

  void _onToggleBulkSelect(
    ToggleBulkSelect event,
    Emitter<TransactionFilterState> emit,
  ) {
    emit(
      state.copyWith(
        bulkSelectMode: !state.bulkSelectMode,
        selectedTransactionIds: {},
      ),
    );
  }

  void _onToggleTransactionSelection(
    ToggleTransactionSelection event,
    Emitter<TransactionFilterState> emit,
  ) {
    final selections = Set<String>.from(state.selectedTransactionIds);
    if (selections.contains(event.id)) {
      selections.remove(event.id);
    } else {
      selections.add(event.id);
    }
    emit(state.copyWith(selectedTransactionIds: selections));
  }

  void _onClearSelections(
    ClearSelections event,
    Emitter<TransactionFilterState> emit,
  ) {
    emit(state.copyWith(bulkSelectMode: false, selectedTransactionIds: {}));
  }

  void _onClearFilters(
    ClearFilters event,
    Emitter<TransactionFilterState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: '',
        selectedCategories: {},
        selectedTypes: {},
        selectedPaymentMethods: {},
        dateRange: null,
        minAmount: null,
        maxAmount: null,
        sortBy: 'date_desc',
      ),
    );
    _applyFilters(emit);
  }

  void _onExpandTransaction(
    ExpandTransaction event,
    Emitter<TransactionFilterState> emit,
  ) {
    emit(state.copyWith(expandedTransactionId: event.id));
  }

  void _applyFilters(Emitter<TransactionFilterState> emit) {
    var filtered = state.allTransactions.where((t) {
      if (state.searchQuery.isNotEmpty &&
          !t.description.toLowerCase().contains(
            state.searchQuery.toLowerCase(),
          )) {
        return false;
      }
      if (state.selectedCategories.isNotEmpty &&
          !state.selectedCategories.contains(t.category)) {
        return false;
      }
      if (state.selectedTypes.isNotEmpty &&
          !state.selectedTypes.contains(t.type)) {
        return false;
      }
      if (state.selectedPaymentMethods.isNotEmpty && t.accountId != null) {
        if (!state.selectedPaymentMethods.contains(t.accountId)) return false;
      }
      if (state.dateRange != null &&
          (t.date.isBefore(state.dateRange!.start) ||
              t.date.isAfter(
                state.dateRange!.end.add(const Duration(days: 1)),
              ))) {
        return false;
      }
      if (state.minAmount != null && t.amount < state.minAmount!) return false;
      if (state.maxAmount != null && t.amount > state.maxAmount!) return false;
      return true;
    }).toList();

    switch (state.sortBy) {
      case 'date_desc':
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'date_asc':
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'amount_desc':
        filtered.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'amount_asc':
        filtered.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    emit(state.copyWith(filteredTransactions: filtered));
  }
}
