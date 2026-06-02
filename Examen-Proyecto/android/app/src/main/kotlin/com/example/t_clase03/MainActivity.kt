package com.example.t_clase03

import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStoreFile
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {
    private val secureChannel = "t_clase05/secure_storage"
    private val dataStore by lazy {
        PreferenceDataStoreFactory.create(
            produceFile = { applicationContext.preferencesDataStoreFile("t_clase05_preferences") },
        )
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, secureChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "dataStorePut" -> {
                    val key = call.argument<String>("key") ?: ""
                    val value = call.argument<String>("value") ?: ""
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            dataStore.edit { preferences ->
                                preferences[stringPreferencesKey(key)] = value
                            }
                            runOnUiThread { result.success(null) }
                        } catch (error: Exception) {
                            runOnUiThread { result.error("DATASTORE_WRITE_ERROR", error.message, null) }
                        }
                    }
                }

                "dataStoreGet" -> {
                    val key = call.argument<String>("key") ?: ""
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            val preferences = dataStore.data.first()
                            val value = preferences[stringPreferencesKey(key)]
                            runOnUiThread { result.success(value) }
                        } catch (error: Exception) {
                            runOnUiThread { result.error("DATASTORE_READ_ERROR", error.message, null) }
                        }
                    }
                }

                "encryptedPut" -> {
                    val key = call.argument<String>("key") ?: ""
                    val value = call.argument<String>("value") ?: ""
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            val masterKey = MasterKey.Builder(applicationContext)
                                .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                                .build()
                            val preferences = EncryptedSharedPreferences.create(
                                applicationContext,
                                "t_clase05_encrypted_prefs",
                                masterKey,
                                EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                                EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM,
                            )
                            preferences.edit().putString(key, value).apply()
                            runOnUiThread { result.success(null) }
                        } catch (error: Exception) {
                            runOnUiThread { result.error("ENCRYPTED_WRITE_ERROR", error.message, null) }
                        }
                    }
                }

                "encryptedGet" -> {
                    val key = call.argument<String>("key") ?: ""
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            val masterKey = MasterKey.Builder(applicationContext)
                                .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                                .build()
                            val preferences = EncryptedSharedPreferences.create(
                                applicationContext,
                                "t_clase05_encrypted_prefs",
                                masterKey,
                                EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                                EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM,
                            )
                            val value = preferences.getString(key, null)
                            runOnUiThread { result.success(value) }
                        } catch (error: Exception) {
                            runOnUiThread { result.error("ENCRYPTED_READ_ERROR", error.message, null) }
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
