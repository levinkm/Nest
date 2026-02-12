import '../../domain/entities/transaction.dart' as domain;

class TransactionModel {
  static domain.Transaction fromJson(Map<String, dynamic> json) {
    return domain.Transaction(
      id: json['id'],
      amount: json['amount'],
      category: json['category'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      transactionId: json['transactionId'],
      fee: json['fee'] ?? 0.0,
      accountId: json['accountId'],
      toAccountId: json['toAccountId'],
    );
  }

  static Map<String, dynamic> toJson(domain.Transaction transaction) {
    return {
      'id': transaction.id,
      'amount': transaction.amount,
      'category': transaction.category,
      'description': transaction.description,
      'date': transaction.date.toIso8601String(),
      'type': transaction.type,
      'transactionId': transaction.transactionId,
      'fee': transaction.fee,
      'accountId': transaction.accountId,
      'toAccountId': transaction.toAccountId,
    };
  }
}
