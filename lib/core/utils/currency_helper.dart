import 'package:shared_preferences/shared_preferences.dart';

class CurrencyHelper {
  static Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency') ?? 'KSh';
  }

  static Future<void> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
  }

  static String formatAmount(double amount, String currency) {
    return '$currency ${amount.toStringAsFixed(2)}';
  }
}
