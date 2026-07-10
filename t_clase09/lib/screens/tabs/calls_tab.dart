import 'package:flutter/material.dart';

class CallsTab extends StatefulWidget {
  const CallsTab({super.key});

  @override
  State<CallsTab> createState() => _CallsTabState();
}

class _CallsTabState extends State<CallsTab> {
  bool _isEditing = false;

  // Base de datos de llamadas editable
  final List<Map<String, dynamic>> _calls = [
    {
      'name': 'Adriana :3',
      'type': 'Outgoing',
      'duration': '17 min',
      'date': '30/03/21',
      'missed': false,
    },
    {
      'name': 'Salma Morales (EPN)',
      'type': 'Incoming',
      'duration': '5 min',
      'date': 'Hoy',
      'missed': false,
    },
    {
      'name': 'Kevin Quishpe',
      'type': 'Missed',
      'duration': '',
      'date': 'Hoy',
      'missed': true,
    },
    {
      'name': 'Sebastian Sarasti',
      'type': 'Incoming',
      'duration': '12 min',
      'date': 'Ayer',
      'missed': false,
    },
    {
      'name': 'Carlos Mendoza',
      'type': 'Outgoing',
      'duration': '2 min',
      'date': '08/07',
      'missed': false,
    },
    {
      'name': 'María José Ortiz',
      'type': 'Missed',
      'duration': '',
      'date': '07/07',
      'missed': true,
    },
    {
      'name': 'Juan Pérez',
      'type': 'Incoming',
      'duration': '45 min',
      'date': '05/07',
      'missed': false,
    },
    {
      'name': 'Abuelita Lucy ❤️',
      'type': 'Outgoing',
      'duration': '10 min',
      'date': '01/07',
      'missed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                child: Text(
                  _isEditing ? 'Done' : 'Edit',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(
                'Calls',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 15, 16, 8),
          child: Text(
            'RECENT CALLS',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _calls.length,
            itemBuilder: (context, index) {
              final c = _calls[index];
              return ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isEditing)
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            _calls.removeAt(index);
                          });
                        },
                      ),
                    if (_isEditing) const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: c['missed']
                          ? Colors.red.withOpacity(0.2)
                          : Colors.grey[800],
                      child: Icon(
                        c['missed'] ? Icons.call_missed : Icons.call,
                        color: c['missed'] ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  c['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: c['missed'] ? Colors.red : Colors.white,
                  ),
                ),
                subtitle: Text(
                  c['missed'] ? 'Missed' : '${c['type']} (${c['duration']})',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      c['date'],
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 22,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
