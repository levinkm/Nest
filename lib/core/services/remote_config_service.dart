import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../features/transactions/data/models/categorization_models.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._();

  FirebaseRemoteConfig? _remoteConfig;

  Future<void> initialize() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await _remoteConfig!.fetchAndActivate();
    } catch (e) {
      if (kDebugMode) {
        print('Remote Config initialization failed: $e');
      }
    }
  }

  Future<List<CategorizationRule>?> getClassificationRules() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return null;
      }

      if (_remoteConfig == null) {
        await initialize();
      }

      final rulesJson = _remoteConfig!.getString('classification_rules');
      if (rulesJson.isEmpty) return null;

      final List<dynamic> rulesList = json.decode(rulesJson);
      return rulesList
          .map((json) => CategorizationRule.fromJson(json))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch classification rules: $e');
      }
      return null;
    }
  }
}
