import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_api_service.dart';

class PostApiScreen extends StatefulWidget {
  const PostApiScreen({super.key});

  @override
  State<PostApiScreen> createState() => _PostApiScreenState();
}

class _PostApiScreenState extends State<PostApiScreen> {
  final _apiService = PostApiService();
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  ApiPost? _post;
  bool _busy = false;
  String? _message;

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _fetchPost() async {
    final id = int.tryParse(_idController.text.trim());
    if (id == null || id <= 0) {
      _showMessage('Ingresa un ID numérico válido.');
      return;
    }

    setState(() {
      _busy = true;
      _message = null;
    });

    try {
      final post = await _apiService.fetchPost(id);
      if (!mounted) {
        return;
      }

      setState(() {
        _post = post;
        _titleController.text = post.title;
        _bodyController.text = post.body;
        _message = 'Post $id cargado correctamente.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _post = null;
        _message = 'No se pudo obtener el recurso solicitado.';
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _updatePost() async {
    final post = _post;
    if (post == null) {
      _showMessage('Primero carga un post con Obtener.');
      return;
    }

    setState(() {
      _busy = true;
      _message = null;
    });

    try {
      final updatedPost = await _apiService.updatePost(
        post.copyWith(
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _post = updatedPost;
        _titleController.text = updatedPost.title;
        _bodyController.text = updatedPost.body;
        _message = 'La respuesta de la API confirmó el cambio.';
      });
    } catch (_) {
      _showMessage('No se pudo actualizar el post.');
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _showMessage(String message) {
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
      appBar: AppBar(title: const Text('Conectividad REST')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9FBFF), Color(0xFFEFF6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _InfoBanner(
                title: 'JSONPlaceholder',
                subtitle:
                    'Ingresa un ID, obtén title y body, modifica el formulario y envía un PUT para confirmar la respuesta.',
              ),
              const SizedBox(height: 18),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _idController,
                      enabled: !_busy,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'ID del post',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: _busy ? null : _fetchPost,
                      icon: const Icon(Icons.download),
                      label: const Text('Obtener'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (_message != null) ...[
                _MessageStrip(message: _message!),
                const SizedBox(height: 18),
              ],
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Formulario editable',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        if (_busy)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _titleController,
                      enabled: !_busy && _post != null,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _bodyController,
                      enabled: !_busy && _post != null,
                      minLines: 5,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: 'Body',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: _busy || _post == null ? null : _updatePost,
                      icon: const Icon(Icons.upload),
                      label: const Text('Actualizar'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (_post != null)
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Respuesta actual',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text('ID: ${_post!.id}'),
                      Text('Usuario: ${_post!.userId}'),
                      const SizedBox(height: 10),
                      Text(
                        _post!.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(_post!.body),
                    ],
                  ),
                ),
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

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F9D58), Color(0xFF56C596)],
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

class _MessageStrip extends StatelessWidget {
  const _MessageStrip({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBFE6C8)),
      ),
      child: Text(message),
    );
  }
}
