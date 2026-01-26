import 'package:string_similarity/string_similarity.dart';

class CategorizationService {
  static final Map<String, List<String>> _categoryKeywords = {
    'groceries': ['walmart', 'grocery', 'supermarket', 'food', 'kroger', 'safeway'],
    'dining': ['restaurant', 'cafe', 'pizza', 'burger', 'starbucks', 'mcdonald'],
    'transportation': ['uber', 'lyft', 'gas', 'fuel', 'parking', 'transit'],
    'utilities': ['electric', 'water', 'internet', 'phone', 'bill'],
    'entertainment': ['netflix', 'spotify', 'movie', 'theater', 'game'],
    'shopping': ['amazon', 'target', 'mall', 'store', 'shop'],
    'healthcare': ['pharmacy', 'doctor', 'hospital', 'medical', 'cvs'],
  };

  static String categorizeExpense(String description) {
    final desc = description.toLowerCase();
    
    for (var entry in _categoryKeywords.entries) {
      for (var keyword in entry.value) {
        if (desc.contains(keyword) || desc.similarityTo(keyword) > 0.7) {
          return entry.key;
        }
      }
    }
    
    return 'other';
  }

  static List<String> getRecommendations(List<double> monthlySpending) {
    final recommendations = <String>[];
    
    if (monthlySpending.length >= 2) {
      final current = monthlySpending.last;
      final previous = monthlySpending[monthlySpending.length - 2];
      final increase = ((current - previous) / previous * 100);
      
      if (increase > 20) {
        recommendations.add('Spending increased by ${increase.toStringAsFixed(0)}% - consider reviewing expenses');
      }
    }
    
    return recommendations;
  }
}
