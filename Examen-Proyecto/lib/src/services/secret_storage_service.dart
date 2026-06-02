import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/secret_store_kind.dart';

class SecretStorageService {
  static const MethodChannel _channel = MethodChannel(
    't_clase05/secure_storage',
  );

  Future<void> save({
    required SecretStoreKind kind,
    required String key,
    required String value,
  }) async {
    if (kind == SecretStoreKind.sharedPreferences) {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(key, value);
      return;
    }

    final methodName = kind == SecretStoreKind.dataStore
        ? 'dataStorePut'
        : 'encryptedPut';
    await _channel.invokeMethod<void>(methodName, {'key': key, 'value': value});
  }

  Future<String?> read({
    required SecretStoreKind kind,
    required String key,
  }) async {
    if (kind == SecretStoreKind.sharedPreferences) {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getString(key);
    }

    final methodName = kind == SecretStoreKind.dataStore
        ? 'dataStoreGet'
        : 'encryptedGet';
    return _channel.invokeMethod<String>(methodName, {'key': key});
  }
}
