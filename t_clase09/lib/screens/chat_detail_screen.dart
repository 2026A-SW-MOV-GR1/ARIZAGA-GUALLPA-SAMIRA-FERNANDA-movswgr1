import 'package:flutter/material.dart';
import '../models/chat_model.dart';

// Definición limpia del enum de tipos interactivos nativos
enum CustomMsgType { text, image, audio }

class InteractiveMessage {
  final String sender;
  final String? text;
  final CustomMsgType type;
  final String? mediaInfo;

  InteractiveMessage({
    required this.sender,
    this.text,
    this.type = CustomMsgType.text,
    this.mediaInfo,
  });
}

class ChatDetailScreen extends StatefulWidget {
  final String title;
  final List<ChatMessage> messages;

  const ChatDetailScreen({
    super.key,
    required this.title,
    required this.messages,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<InteractiveMessage> _currentMessages;

  @override
  void initState() {
    super.initState();
    // CORRECCIÓN CLAVE: Mapeamos respetando el tipo dinámico original de la base de datos
    _currentMessages = widget.messages.map((m) {
      CustomMsgType calculatedType = CustomMsgType.text;
      if (m.type == MessageType.call) {
        calculatedType = CustomMsgType
            .audio; // Mapeamos registros antiguos a burbujas de audio
      }
      return InteractiveMessage(
        sender: m.sender,
        text: m.text,
        type: calculatedType,
        mediaInfo: m.subText,
      );
    }).toList();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _currentMessages.add(
        InteractiveMessage(
          sender: 'Tú',
          text: _textController.text.trim(),
          type: CustomMsgType.text,
        ),
      );
    });

    _textController.clear();
    _scrollToBottom();
  }

  void _sendSimulatedImage(int imageIndex) {
    Navigator.pop(context);
    setState(() {
      _currentMessages.add(
        InteractiveMessage(
          sender: 'Tú',
          type: CustomMsgType.image,
          mediaInfo: 'Foto #$imageIndex',
        ),
      );
    });
    _scrollToBottom();
  }

  // FUNCIÓN CORREGIDA: Fuerza la inserción reactiva en el árbol de widgets
  void _sendSimulatedAudio() {
    setState(() {
      _currentMessages.add(
        InteractiveMessage(
          sender: 'Tú',
          type: CustomMsgType.audio,
          mediaInfo: '0:14',
        ),
      );
    });
    _scrollToBottom();
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 10),
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Recents',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => _sendSimulatedImage(index + 1),
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.blueGrey[900],
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                color: Colors.white38,
                                size: 45,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: const Color(0xFF121214),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAttachmentItem(
                      Icons.image,
                      'Gallery',
                      isSelected: true,
                      onTap: () {},
                    ),
                    _buildAttachmentItem(
                      Icons.card_giftcard,
                      'Gift',
                      onTap: () {},
                    ),
                    _buildAttachmentItem(
                      Icons.insert_drive_file,
                      'File',
                      onTap: () {},
                    ),
                    _buildAttachmentItem(
                      Icons.location_on,
                      'Location',
                      onTap: () {},
                    ),
                    _buildAttachmentItem(
                      Icons.check_circle_outline,
                      'Checklist',
                      onTap: () {},
                    ),
                    // ACCIÓN DEL BOTÓN DE AUDIO DENTRO DEL MENU DEL CLIP
                    _buildAttachmentItem(
                      Icons.audiotrack,
                      'Audio',
                      onTap: () {
                        Navigator.pop(context); // Cierra modal
                        _sendSimulatedAudio(); // Dispara el render
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentItem(
    IconData icon,
    String label, {
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2B2B2D) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey[400],
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey[400],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'last seen recently',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        color: const Color(0xFF0F0F10),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.07,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) =>
                      const Icon(Icons.draw, size: 80, color: Colors.white),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    itemCount: _currentMessages.length,
                    itemBuilder: (context, index) {
                      final m = _currentMessages[index];
                      final bool isMe = m.sender == 'Tú';

                      // CONDICIONAL 1: BURBUJA DE IMAGEN
                      if (m.type == CustomMsgType.image) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            width: 220,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent[700],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    color: Colors.blueGrey[800],
                                    child: const Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.white30,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text(
                                            '10:53 ',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Icon(
                                            Icons.done_all,
                                            size: 12,
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      // CONDICIONAL 2: BURBUJA DE NOTA DE VOZ / AUDIO CORREGIDA
                      if (m.type == CustomMsgType.audio) {
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color(0xFF007AFF)
                                  : const Color(0xFF1F3A60),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '••••••••••••••••••••',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    Text(
                                      'Voice message (${m.mediaInfo ?? "0:14"})',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.done_all,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // CONDICIONAL 3: TEXTO NORMAL
                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xFF007AFF)
                                : const Color(0xFF262628),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(isMe ? 18 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 18),
                            ),
                          ),
                          child: Text(
                            m.text ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Input Bar inferior con disparadores interactivos garantizados
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                  color: const Color(0xFF1C1C1E),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.blue,
                          size: 26,
                        ),
                        onPressed: _showAttachmentMenu,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: _textController,
                            onChanged: (text) => setState(() {}),
                            decoration: const InputDecoration(
                              hintText: 'Message',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      _textController.text.trim().isNotEmpty
                          ? CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.blue,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onPressed: _sendMessage,
                              ),
                            )
                          // El botón del micrófono del input bar ahora está linkeado de forma reactiva
                          : IconButton(
                              icon: const Icon(
                                Icons.mic,
                                color: Colors.blue,
                                size: 26,
                              ),
                              onPressed: _sendSimulatedAudio,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
