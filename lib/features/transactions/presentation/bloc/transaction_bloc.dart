import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

part 'transaction_bloc.freezed.dart';

// Events
@freezed
class TransactionEvent with _$TransactionEvent {
  const factory TransactionEvent.loadTransactions() = LoadTransactions;
  const factory TransactionEvent.addTransaction(Transaction transaction) = AddTransaction;
  const factory TransactionEvent.deleteTransaction(String id) = DeleteTransaction;
}

// States
@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = TransactionInitial;
  const factory TransactionState.loading() = TransactionLoading;
  const factory TransactionState.loaded(List<Transaction> transactions) = TransactionLoaded;
  const factory TransactionState.error(String message) = TransactionError;
}

// BLoC
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc(this.repository) : super(const TransactionState.initial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(const TransactionState.loading());
    try {
      final transactions = await repository.getTransactions();
      emit(TransactionState.loaded(transactions));
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  }

  Future<void> _onAddTransaction(AddTransaction event, Emitter<TransactionState> emit) async {
    try {
      await repository.addTransaction(event.transaction);
      add(const TransactionEvent.loadTransactions());
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  }

  Future<void> _onDeleteTransaction(DeleteTransaction event, Emitter<TransactionState> emit) async {
    try {
      await repository.deleteTransaction(event.id);
      add(const TransactionEvent.loadTransactions());
    } catch (e) {
      emit(TransactionState.error(e.toString()));
    }
  }
}
