enum SecretStoreKind {
  sharedPreferences,
  dataStore,
  encryptedSharedPreferences,
}

extension SecretStoreKindLabel on SecretStoreKind {
  String get label {
    switch (this) {
      case SecretStoreKind.sharedPreferences:
        return 'SharedPreferences';
      case SecretStoreKind.dataStore:
        return 'DataStore';
      case SecretStoreKind.encryptedSharedPreferences:
        return 'EncryptedSharedPreferences';
    }
  }

  String get description {
    switch (this) {
      case SecretStoreKind.sharedPreferences:
        return 'Clave-valor simple para preferencias no sensibles.';
      case SecretStoreKind.dataStore:
        return 'Persistencia moderna asíncrona para configuraciones.';
      case SecretStoreKind.encryptedSharedPreferences:
        return 'Clave-valor cifrado para secretos y tokens.';
    }
  }
}
