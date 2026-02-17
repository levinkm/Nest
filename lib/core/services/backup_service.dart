import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  static Future<String> exportToCSV() async {
    final prefs = await SharedPreferences.getInstance();
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${dir.path}/nest_backup_$timestamp.csv');

    final buffer = StringBuffer();
    buffer.writeln('Key,Value,Type');

    for (var key in prefs.getKeys()) {
      final value = prefs.get(key);
      buffer.writeln(
        '"$key","${_escapeCSV(value.toString())}","${value.runtimeType}"',
      );
    }

    await file.writeAsString(buffer.toString());
    return file.path;
  }

  static Future<String> exportToJSON() async {
    final prefs = await SharedPreferences.getInstance();
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${dir.path}/nest_backup_$timestamp.json');

    final backup = <String, dynamic>{};
    for (var key in prefs.getKeys()) {
      backup[key] = prefs.get(key);
    }

    await file.writeAsString(jsonEncode(backup));
    return file.path;
  }

  static Future<void> shareBackup(String format) async {
    final path = format == 'csv' ? await exportToCSV() : await exportToJSON();
    await Share.shareXFiles([XFile(path)], text: 'Nest App Backup');
  }

  static Future<bool> restoreFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return false;

      final content = await file.readAsString();
      final prefs = await SharedPreferences.getInstance();

      if (filePath.endsWith('.json')) {
        final data = jsonDecode(content) as Map<String, dynamic>;
        for (var entry in data.entries) {
          if (entry.value is bool) {
            await prefs.setBool(entry.key, entry.value);
          } else if (entry.value is int) {
            await prefs.setInt(entry.key, entry.value);
          } else if (entry.value is double) {
            await prefs.setDouble(entry.key, entry.value);
          } else if (entry.value is String) {
            await prefs.setString(entry.key, entry.value);
          } else if (entry.value is List) {
            await prefs.setStringList(
              entry.key,
              List<String>.from(entry.value),
            );
          }
        }
      } else if (filePath.endsWith('.csv')) {
        final lines = content.split('\n').skip(1);
        for (var line in lines) {
          if (line.trim().isEmpty) continue;
          final parts = _parseCSVLine(line);
          if (parts.length < 3) continue;

          final key = parts[0];
          final value = parts[1];
          final type = parts[2];

          if (type == 'bool') {
            await prefs.setBool(key, value.toLowerCase() == 'true');
          } else if (type == 'int') {
            await prefs.setInt(key, int.tryParse(value) ?? 0);
          } else if (type == 'double') {
            await prefs.setDouble(key, double.tryParse(value) ?? 0.0);
          } else {
            await prefs.setString(key, value);
          }
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static String _escapeCSV(String value) {
    return value.replaceAll('"', '""');
  }

  static List<String> _parseCSVLine(String line) {
    final result = <String>[];
    var current = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          current.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(current.toString());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }
    result.add(current.toString());
    return result;
  }
}
