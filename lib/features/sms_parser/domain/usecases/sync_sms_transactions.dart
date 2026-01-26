import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../data/datasources/sms_parser_datasource.dart';
import 'package:uuid/uuid.dart';

class SyncSmsTransactionsUseCase {
  final SmsParserDataSource smsParser;
  final TransactionRepository transactionRepository;

  SyncSmsTransactionsUseCase(this.smsParser, this.transactionRepository);

  Future<int> execute({int daysBack = 30}) async {
    final hasPermission = await smsParser.requestPermissions();
    if (!hasPermission) throw Exception('SMS permission denied');

    final smsTransactions = await smsParser.parseTransactionSms(daysBack: daysBack);
    
    for (var sms in smsTransactions) {
      final transaction = Transaction(
        id: const Uuid().v4(),
        amount: sms.amount,
        category: sms.category,
        description: sms.description,
        date: sms.date,
        type: sms.type,
      );
      await transactionRepository.addTransaction(transaction);
    }

    return smsTransactions.length;
  }
}
