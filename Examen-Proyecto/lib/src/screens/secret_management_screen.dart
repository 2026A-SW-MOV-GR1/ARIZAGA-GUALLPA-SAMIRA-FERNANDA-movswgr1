import 'package:flutter/material.dart';

import '../models/secret_store_kind.dart';
import '../services/secret_storage_service.dart';

class SecretManagementScreen extends StatefulWidget {
  const SecretManagementScreen({super.key});

  @override
  State<SecretManagementScreen> createState() => _SecretManagementScreenState();
}

class _SecretManagementScreenState extends State<SecretManagementScreen> {
  final _service = SecretStorageService();
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();

  SecretStoreKind _selectedKind = SecretStoreKind.sharedPreferences;
  bool _busy = false;
  String? _result;

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _saveSecret() async {
    final key = _keyController.text.trim();
    final value = _valueController.text.trim();
    if (key.isEmpty || value.isEmpty) {
      _showSnack('La llave y el valor son obligatorios para guardar.');
      return;
    }

    setState(() {
      _busy = true;
      _result = null;
    });

    try {
      await _service.save(kind: _selectedKind, key: key, value: value);
      if (!mounted) {
        return;
      }

      setState(() {
        _result = 'Se guardó "$key" en ${_selectedKind.label}.';
      });
    } catch (_) {
      _showSnack('No se pudo guardar el secreto.');
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _readSecret() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      _showSnack('Ingresa la llave para recuperar el valor.');
      return;
    }

    setState(() {
      _busy = true;
      _result = null;
    });

    try {
      final value = await _service.read(kind: _selectedKind, key: key);
      if (!mounted) {
        return;
      }

      if (value == null) {
        setState(() {
          _result = 'El secreto no fue encontrado en ${_selectedKind.label}.';
        });
      } else {
        _valueController.text = value;
        setState(() {
          _result = 'Se recuperó "$key" desde ${_selectedKind.label}.';
        });
      }
    } catch (_) {
      _showSnack('No se pudo recuperar el secreto.');
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de secretos y configuración')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFBF2), Color(0xFFFFF3E0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _HeroCard(
                title: 'Almacenamiento seguro',
                subtitle:
                    'Selecciona entre SharedPreferences, DataStore o EncryptedSharedPreferences para guardar o recuperar un secreto por su llave.',
              ),
              const SizedBox(height: 18),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _keyController,
                      enabled: !_busy,
                      decoration: const InputDecoration(
                        labelText: 'Llave',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _valueController,
                      enabled: !_busy,
                      decoration: const InputDecoration(
                        labelText: 'Valor',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<SecretStoreKind>(
                      value: _selectedKind,
                      decoration: const InputDecoration(
                        labelText: 'Mecanismo de almacenamiento',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                      items: SecretStoreKind.values
                          .map(
                            (kind) => DropdownMenuItem(
                              value: kind,
                              child: Text(kind.label),
                            ),
                          )
                          .toList(),
                      onChanged: _busy
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() => _selectedKind = value);
                              }
                            },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selectedKind.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black.withOpacity(0.66),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          onPressed: _busy ? null : _saveSecret,
                          icon: const Icon(Icons.save),
                          label: const Text('Guardar'),
                        ),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _readSecret,
                          icon: const Icon(Icons.search),
                          label: const Text('Recuperar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (_result != null) _ResultPanel(message: _result!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF2994A), Color(0xFFFFB36B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.92),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFD79A)),
      ),
      child: Text(message),
    );
  }
}
