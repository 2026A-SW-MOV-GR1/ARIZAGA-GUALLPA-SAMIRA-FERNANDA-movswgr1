import 'package:flutter/material.dart';

class ContactsTab extends StatelessWidget {
  const ContactsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> contacts = [
      'Abuelita Lucy ❤️',
      'Alejandra Torres',
      'Andrés Cevallos',
      'Angelica Yangari',
      'Atelier',
      'Axel Compi',
      'Carlos Mendoza',
      'Daniela Ríos',
      'David Astudillo Itss',
      'Eduardo Stranger Grupis',
      'Esteban Muñoz',
      'Frabrizzio Desafio Clave',
      'Gatorium',
      'Green Hungry',
      'Isabella Hernandez',
      'Jhon',
      'Juan Pérez',
      'Kevin Quishpe',
      'Luis EDA Villa',
      'María José Ortiz',
      'Martin 29',
      'Mateo Salazar',
      'Primero BI',
      'Salma Morales (EPN)',
      'Sebastian Sarasti',
      'Sofía Almeida',
      'Yessy Cobacango',
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Sort',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
              const Text(
                'Contacts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.blue),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              fillColor: const Color(0xFF1C1C1E),
              filled: true,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.6),
                  child: Text(
                    contacts[index][0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  contacts[index],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'last seen recently',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
