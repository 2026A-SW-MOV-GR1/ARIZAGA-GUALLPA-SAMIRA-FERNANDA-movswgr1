import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieEditorDialog extends StatefulWidget {
  const MovieEditorDialog({super.key, this.movie});

  final Movie? movie;

  @override
  State<MovieEditorDialog> createState() => _MovieEditorDialogState();
}

class _MovieEditorDialogState extends State<MovieEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _yearController;
  late final TextEditingController _directorController;
  late String _location;
  late DateTime _watchedOn;

  @override
  void initState() {
    super.initState();
    final movie = widget.movie;
    _titleController = TextEditingController(text: movie?.title ?? '');
    _yearController = TextEditingController(text: movie?.year.toString() ?? '');
    _directorController = TextEditingController(text: movie?.director ?? '');
    _location = movie?.location ?? 'Casa';
    _watchedOn = movie?.watchedOn ?? DateTime(2026, 3, 5);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _directorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
    );
    final isEditing = widget.movie != null;

    return AlertDialog(
      title: Text(isEditing ? 'Editar película' : 'Nueva película'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Año',
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el año';
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return 'Ingresa un año válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _directorController,
                  decoration: const InputDecoration(
                    labelText: 'Director',
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el director';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _location,
                  decoration: const InputDecoration(
                    labelText: 'Lugar',
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Casa', child: Text('Casa')),
                    DropdownMenuItem(value: 'Cine', child: Text('Cine')),
                    DropdownMenuItem(
                      value: 'Streaming',
                      child: Text('Streaming'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _location = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fecha vista'),
                  subtitle: Text(formatDate(_watchedOn)),
                  trailing: OutlinedButton(
                    onPressed: _pickDate,
                    child: const Text('Elegir'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _save, child: const Text('Guardar')),
      ],
    );
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _watchedOn,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (selected != null) {
      setState(() => _watchedOn = selected);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final movie = Movie(
      id: widget.movie?.id,
      title: _titleController.text.trim(),
      year: int.parse(_yearController.text.trim()),
      director: _directorController.text.trim(),
      location: _location,
      watchedOn: _watchedOn,
    );

    Navigator.of(context).pop(movie);
  }
}
