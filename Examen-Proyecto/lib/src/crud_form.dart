import 'package:flutter/material.dart';
import 'models.dart';

class CrudFormPage extends StatefulWidget {
  const CrudFormPage({super.key, this.item});

  final CrudItem? item;

  @override
  State<CrudFormPage> createState() => _CrudFormPageState();
}

class _CrudFormPageState extends State<CrudFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _yearController;
  late final TextEditingController _directorController;
  late String _selectedLocation;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = TextEditingController(text: item?.title ?? '');
    _yearController = TextEditingController(text: item?.year.toString() ?? '');
    _directorController = TextEditingController(text: item?.director ?? '');
    _selectedLocation = item?.location ?? 'Casa';
    _selectedDate = item?.dateWatched ?? DateTime(2026, 3, 5);
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
    final isEditing = widget.item != null;
    const roundedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Editar película' : 'Nueva película'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing
                      ? 'Actualiza los datos de la película'
                      : 'Registra una película nueva',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título de la película',
                    border: roundedBorder,
                    enabledBorder: roundedBorder,
                    focusedBorder: roundedBorder,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el título de la película';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Año de la película',
                    border: roundedBorder,
                    enabledBorder: roundedBorder,
                    focusedBorder: roundedBorder,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el año de la película';
                    }
                    if (int.tryParse(value) == null) {
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
                    border: roundedBorder,
                    enabledBorder: roundedBorder,
                    focusedBorder: roundedBorder,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el nombre del director';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedLocation,
                  items: const [
                    DropdownMenuItem(value: 'Casa', child: Text('Casa')),
                    DropdownMenuItem(value: 'Cine', child: Text('Cine')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedLocation = value);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: '¿Dónde la viste?',
                    border: roundedBorder,
                    enabledBorder: roundedBorder,
                    focusedBorder: roundedBorder,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fecha que la viste'),
                  subtitle: Text(formatDate(_selectedDate)),
                  trailing: OutlinedButton(
                    onPressed: _pickDate,
                    child: const Text('Elegir fecha'),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(
                    isEditing ? 'Actualizar película' : 'Registrar película',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      initialDate: _selectedDate,
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final item = CrudItem(
      id: widget.item?.id ?? -1,
      title: _titleController.text.trim(),
      year: int.parse(_yearController.text.trim()),
      director: _directorController.text.trim(),
      location: _selectedLocation,
      dateWatched: _selectedDate,
      color: widget.item?.color ?? const Color(0xFF5DADE2),
    );

    Navigator.of(
      context,
    ).pop(CrudFormResult(item: item, isEditing: widget.item != null));
  }
}
