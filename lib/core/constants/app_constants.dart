class AppConstants {
  static const String dbName = 'nest_finance.db';
  static const int dbVersion = 13;

  static const List<String> transactionCategories = [
    'Food & Dining',
    'Shopping',
    'Transportation',
    'Bills & Utilities',
    'Entertainment',
    'Airtime & Data',
    'Mobile Money',
    'Interest & Fees',
    'Salary',
    'Transfer',
    'Other',
  ];

  // Default Settings
  static const String defaultCurrency = 'KSh';
  static const int defaultSmsDaysBack = 90;
  static const String defaultThemeMode = 'system';
  static const bool defaultAutoSync = true;
  static const List<String> supportedCurrencies = [
    'KSh',
    'USD',
    'EUR',
    'GBP',
    'TZS',
    'UGX',
  ];
  static const List<int> smsDaysBackOptions = [7, 14, 30, 60, 90, 180];
}
