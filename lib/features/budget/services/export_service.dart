import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/models/budget_model.dart';

class ExportService {
  static Future<void> exportToPdf(Budget budget) async {
    final buffer = StringBuffer();
    buffer.writeln('Budget Report: ${budget.category}');
    buffer.writeln('Period: ${budget.startDate} to ${budget.endDate}');
    buffer.writeln('Total Budget: \$${budget.limit}');
    buffer.writeln('Spent: \$${budget.spent}');
    buffer.writeln('Remaining: \$${budget.remaining}');
    buffer.writeln('Progress: ${budget.percentage.toStringAsFixed(1)}%');

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/budget_report_${DateTime.now().millisecondsSinceEpoch}.txt',
    );
    await file.writeAsString(buffer.toString());

    await Share.shareXFiles([XFile(file.path)], text: 'Budget Report');
  }
}
