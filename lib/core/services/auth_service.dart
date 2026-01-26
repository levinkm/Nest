import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const _pinKey = 'user_pin_hash';
  static const _attemptsKey = 'login_attempts';
  static const _maxAttempts = 5;

  static Future<bool> isPinSet() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null;
  }

  static Future<void> setPin(String pin) async {
    final hash = _hashPin(pin);
    await _storage.write(key: _pinKey, value: hash);
    await _resetAttempts();
  }

  static Future<bool> verifyPin(String pin) async {
    final attempts = await _getAttempts();
    if (attempts >= _maxAttempts) {
      return false;
    }

    final storedHash = await _storage.read(key: _pinKey);
    final inputHash = _hashPin(pin);

    if (storedHash == inputHash) {
      await _resetAttempts();
      return true;
    } else {
      await _incrementAttempts();
      return false;
    }
  }

  static Future<int> getRemainingAttempts() async {
    final attempts = await _getAttempts();
    return _maxAttempts - attempts;
  }

  static Future<bool> isLocked() async {
    final attempts = await _getAttempts();
    return attempts >= _maxAttempts;
  }

  static Future<void> deleteAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _storage.deleteAll();
  }

  static String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static Future<int> _getAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_attemptsKey) ?? 0;
  }

  static Future<void> _incrementAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final current = await _getAttempts();
    await prefs.setInt(_attemptsKey, current + 1);
  }

  static Future<void> _resetAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_attemptsKey, 0);
  }

  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometric_enabled') ?? false;
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', enabled);
  }
}
