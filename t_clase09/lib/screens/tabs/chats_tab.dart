import 'package:flutter/material.dart';
import '../../models/chat_model.dart';
import '../chat_detail_screen.dart';

class ChatsTab extends StatelessWidget {
  final List<ChatModel> chatData;

  const ChatsTab({super.key, required this.chatData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cabecera principal estilo iOS de Telegram
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
              const Text(
                'Chats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_note, color: Colors.blue),
              ),
            ],
          ),
        ),
        // Barra de búsqueda nativa
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
        // Listado optimizado para alto rendimiento (60 FPS estables)
        Expanded(
          child: ListView.builder(
            itemCount: chatData.length,
            itemBuilder: (context, index) {
              final chat = chatData[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueGrey[700],
                  child: Text(
                    chat.title[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  chat.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  chat.msg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                trailing: Text(
                  chat.time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(
                        title: chat.title,
                        messages: chat.messages,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
