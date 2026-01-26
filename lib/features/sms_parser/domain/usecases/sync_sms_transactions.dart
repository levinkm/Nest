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
    
    int addedCount = 0;
    for (var sms in smsTransactions) {
      // Create unique ID from SMS content and timestamp to prevent duplicates
      final transactionId = '${sms.description.hashCode}_${sms.amount}_${sms.date.millisecondsSinceEpoch}';
      final transaction = Transaction(
        id: const Uuid().v4(),
        amount: sms.amount,
        category: sms.category,
        description: sms.description,
        date: sms.date,
        type: sms.type,
        transactionId: transactionId,
      );
      await transactionRepository.addTransaction(transaction);
      addedCount++;
    }

    return addedCount;
  }
}
