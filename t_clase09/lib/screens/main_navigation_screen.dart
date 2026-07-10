import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/chat_model.dart';
import 'tabs/chats_tab.dart';
import 'tabs/contacts_tab.dart';
import 'tabs/calls_tab.dart';
import 'tabs/settings_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with WidgetsBindingObserver {
  int _currentIndex = 2;
  String? _profileImagePath;

  late final List<ChatModel> _chatData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    developer.log(
      '=== CICLO DE VIDA NATIVO: onCreate / onStart Equivalente ===',
      name: 'TELESW_EPN',
    );

    // Base de datos gigante con conversaciones normales y cotidianas para simular un feed real extenso
    _chatData = [
      ChatModel(
        title: 'Adriana :3',
        msg: 'Outgoing Video Call (17 min)',
        time: '30/03/21',
        isPin: true,
        messages: [
          ChatMessage(sender: 'Tú', text: 'oe'),
          ChatMessage(sender: 'Tú', text: 'oe'),
          ChatMessage(sender: 'Adriana :3', text: 'Oe!!!'),
          ChatMessage(sender: 'Adriana :3', text: 'Confirma!'),
          ChatMessage(sender: 'Tú', text: 'confirma'),
          ChatMessage(sender: 'Adriana :3', text: 'Confirma.'),
          ChatMessage(sender: 'Tú', text: '529139314'),
        ],
      ),
      ChatModel(
        title: 'Alejandra Torres',
        msg: 'Dale, entonces nos vemos mañana en el centro.',
        time: '10:14',
        isPin: true,
        messages: [
          ChatMessage(
            sender: 'Alejandra',
            text: 'Holaaa cómo estás? Qué haces?',
          ),
          ChatMessage(
            sender: 'Tú',
            text:
                'Hola! Todo bien por suerte, descansando un rato en la casa. ¿Y tú?',
          ),
          ChatMessage(
            sender: 'Alejandra',
            text:
                'Bien también, saliendo de hacer unas compras. ¿Vas a salir más tarde?',
          ),
          ChatMessage(
            sender: 'Tú',
            text: 'No creo, pensaba quedarme viendo una película.',
          ),
          ChatMessage(
            sender: 'Alejandra',
            text: 'Ah bueno. ¿Mañana tienes tiempo para ir por un café?',
          ),
          ChatMessage(
            sender: 'Tú',
            text:
                'Siii de ley, a partir de las 3 de la tarde me queda perfecto.',
          ),
          ChatMessage(
            sender: 'Alejandra',
            text: 'Dale, entonces nos vemos mañana en el centro.',
          ),
        ],
      ),
      ChatModel(
        title: 'Andrés Cevallos',
        msg: 'Te aviso cuando ya vaya llegando.',
        time: '09:44',
        isPin: false,
        messages: [
          ChatMessage(sender: 'Andrés', text: 'Qué más! hola cómo estás?'),
          ChatMessage(sender: 'Tú', text: 'Hola Andrés! Qué tal todo?'),
          ChatMessage(
            sender: 'Andrés',
            text:
                'Todo bien tranquilo. Oye te iba a preguntar si me puedes prestar los audífonos grandes que tenías.',
          ),
          ChatMessage(
            sender: 'Tú',
            text: 'Sí de una, si quieres te los llevo mañana que salgamos.',
          ),
          ChatMessage(
            sender: 'Andrés',
            text: 'Buenísimo, me salvas full. ¿A qué hora vas a estar libre?',
          ),
          ChatMessage(sender: 'Tú', text: 'Yo creo que ya desde el mediodía.'),
          ChatMessage(
            sender: 'Andrés',
            text: 'De una, te aviso cuando ya vaya llegando.',
          ),
        ],
      ),
      ChatModel(
        title: 'Daniela Ríos',
        msg: 'Siii, estuvo larguísima y aburrida',
        time: '09:34',
        isPin: false,
        messages: [
          ChatMessage(
            sender: 'Daniela',
            text: 'Holaaa, cómo estás? Qué tal estuvo esa reunión de ayer?',
          ),
          ChatMessage(
            sender: 'Tú',
            text: 'Hola Dani! Cansada la verdad, duró como tres horas.',
          ),
          ChatMessage(
            sender: 'Daniela',
            text: 'Siii, estuvo larguísima y aburrida.',
          ),
        ],
      ),
      ChatModel(
        title: 'Carlos Mendoza',
        msg: 'Pasa el chisme completo pues jaja',
        time: '09:25',
        isPin: false,
        messages: [
          ChatMessage(
            sender: 'Carlos',
            text: 'Oye supiste lo que pasó el fin de semana?',
          ),
          ChatMessage(sender: 'Tú', text: 'Nooo, ¿qué pasó? Cuanta cuenta.'),
          ChatMessage(
            sender: 'Carlos',
            text: 'Pasa el chisme completo pues jaja, ya te llamo.',
          ),
        ],
      ),
      ChatModel(
        title: 'María José',
        msg: 'Ya mismo te paso la ubicación',
        time: '08:12',
        isPin: false,
        messages: [
          ChatMessage(
            sender: 'María José',
            text: 'Hola de ley vas a venir a almorzar acá?',
          ),
          ChatMessage(
            sender: 'Tú',
            text: 'Siii ya voy saliendo para allá, ¿qué pidieron?',
          ),
          ChatMessage(
            sender: 'María José',
            text: 'Pedimos pizza. Ya mismo te paso la ubicación.',
          ),
        ],
      ),
      ChatModel(
        title: 'Mateo Salazar',
        msg: 'Ahorita estoy jugando Fortnite, entras?',
        time: 'Ayer',
        isPin: false,
        messages: [
          ChatMessage(sender: 'Mateo', text: 'Qué haces?'),
          ChatMessage(
            sender: 'Tú',
            text: 'Nada aburrida, viendo videos. ¿Y tú?',
          ),
          ChatMessage(
            sender: 'Mateo',
            text: 'Ahorita estoy jugando Fortnite, entras?',
          ),
        ],
      ),
      ChatModel(
        title: 'Sofía Almeida',
        msg: 'Me encantó la canción que subiste',
        time: 'Ayer',
        isPin: false,
        messages: [
          ChatMessage(
            sender: 'Sofía',
            text:
                'Holaaa! Oye cómo se llamaba el artista que me recomendaste el otro día?',
          ),
          ChatMessage(
            sender: 'Tú',
            text:
                '¡Hola Sofi! Debe ser Michael Jackson o The Strokes, esos escucho full.',
          ),
          ChatMessage(
            sender: 'Sofía',
            text: '¡The Strokes era! Me encantó la canción que subiste.',
          ),
        ],
      ),
      ChatModel(
        title: 'Juan Pérez',
        msg: 'Ya le dije que sí vamos',
        time: 'Wed',
        isPin: false,
        messages: [
          ChatMessage(
            sender: 'Juan',
            text: 'Confirma para el partido de fútbol del viernes.',
          ),
          ChatMessage(
            sender: 'Tú',
            text: 'De ley, cuenta conmigo. Avísale a los demás.',
          ),
          ChatMessage(sender: 'Juan', text: 'Ya le dije que sí vamos.'),
        ],
      ),
      ChatModel(
        title: 'Esteban Muñoz',
        msg: 'Mañana te devuelvo el buzo',
        time: '05/07',
        isPin: false,
        messages: [
          ChatMessage(
            sender: 'Esteban',
            text:
                'Hola qué tal todo. Oye gracias por prestarme el buzo el otro día, me salvó del frío.',
          ),
          ChatMessage(
            sender: 'Tú',
            text: 'Jaja de nada, fresco. Estaba haciendo un viento horrible.',
          ),
          ChatMessage(
            sender: 'Esteban',
            text: 'Siii. Mañana te devuelvo el buzo bien lavado.',
          ),
        ],
      ),
      ChatModel(
        title: 'Kevin Quishpe',
        msg: 'Dale, nos vemos en la esquina a las 5',
        time: '04/07',
        isPin: false,
        messages: [
          ChatMessage(sender: 'Kevin', text: 'Vas a ir a entrenar hoy?'),
          ChatMessage(sender: 'Tú', text: 'Sí, a la misma hora de siempre.'),
          ChatMessage(
            sender: 'Kevin',
            text: 'Dale, nos vemos en la esquina a las 5.',
          ),
        ],
      ),
      ChatModel(
        title: 'Salma Morales',
        msg: 'Ya te mando las fotos del perrito',
        time: '02/07',
        isPin: false,
        messages: [
          ChatMessage(
            sender: 'Salma',
            text: 'No sabes el perrito hermoso que adoptó mi tía.',
          ),
          ChatMessage(
            sender: 'Tú',
            text: 'Aaaay en serio? Pasa fotos para verlo.',
          ),
          ChatMessage(
            sender: 'Salma',
            text: 'Ya te mando las fotos del perrito.',
          ),
        ],
      ),
      ChatModel(
        title: 'Sebastian Sarasti',
        msg: 'Jajaja qué buena',
        time: '30/06',
        isPin: false,
        messages: [
          ChatMessage(
            sender: 'Sebastian',
            text: 'Viste el meme que te etiqueté en Instagram?',
          ),
          ChatMessage(sender: 'Tú', text: 'Siii lo vi recién, me reí full.'),
          ChatMessage(sender: 'Sebastian', text: 'Jajaja qué buena.'),
        ],
      ),
      ChatModel(
        title: 'Nicole Velez',
        msg: 'Escríbeme cuando estés libre',
        time: '28/06',
        isPin: false,
        messages: [
          ChatMessage(
            sender: 'Nicole',
            text:
                'Hola Samira, estás libre para llamarte un ratito? Te quería contar algo.',
          ),
          ChatMessage(
            sender: 'Tú',
            text:
                'Hola! Ahorita ando ocupada haciendo el almuerzo, dame una media hora.',
          ),
          ChatMessage(
            sender: 'Nicole',
            text: 'Dale tranquilo, escríbeme cuando estés libre.',
          ),
        ],
      ),
      ChatModel(
        title: 'Yessy Cobacango',
        msg: 'Buen viaje, que te vaya súper bien!',
        time: '25/06',
        isPin: false,
        messages: [
          ChatMessage(
            sender: 'Yessy',
            text: 'Oye que te vaya excelente en tu viaje de fin de semana.',
          ),
          ChatMessage(
            sender: 'Tú',
            text: '¡Muchas gracias Yessy! Ahí te traigo algún dulce.',
          ),
          ChatMessage(
            sender: 'Yessy',
            text: 'Buen viaje, que te vaya súper bien!',
          ),
        ],
      ),
      ChatModel(
        title: 'Luis Villa',
        msg: 'A las 8 empieza la peli',
        time: '20/06',
        isPin: false,
        messages: [
          ChatMessage(
            sender: 'Luis',
            text: '¿A qué hora vamos al cine al final?',
          ),
          ChatMessage(
            sender: 'Tú',
            text:
                'Yo creo que compremos las entradas para la función de la noche.',
          ),
          ChatMessage(sender: 'Luis', text: 'De una, a las 8 empieza la peli.'),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    developer.log(
      '=== CICLO DE VIDA NATIVO: onDestroy Equivalente ===',
      name: 'TELESW_EPN',
    );
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      developer.log(
        '=== CICLO DE VIDA NATIVO: onResume ===',
        name: 'TELESW_EPN',
      );
    } else if (state == AppLifecycleState.paused) {
      developer.log(
        '=== CICLO DE VIDA NATIVO: onPause / onStop ===',
        name: 'TELESW_EPN',
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _profileImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      developer.log('Error seleccionando imagen: $e', name: 'TELESW_EPN');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const ContactsTab(),
      const CallsTab(),
      ChatsTab(chatData: _chatData),
      SettingsTab(profileImagePath: _profileImagePath, onPickImage: _pickImage),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_currentIndex]),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
        decoration: BoxDecoration(
          color: const Color(0xDD1C1C1E),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white12, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Contacts',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.phone), label: 'Calls'),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
