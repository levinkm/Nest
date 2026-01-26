import '../../domain/entities/transaction.dart' as domain;
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/local_database.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final LocalDatabase localDatabase;

  TransactionRepositoryImpl(this.localDatabase);

  @override
  Future<List<domain.Transaction>> getTransactions() async {
    return await localDatabase.getTransactions();
  }

  @override
  Future<void> addTransaction(domain.Transaction transaction) async {
    await localDatabase.insertTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await localDatabase.deleteTransaction(id);
  }
}
