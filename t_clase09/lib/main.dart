import 'package:flutter/material.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const TelegramCloneApp());
}

class TelegramCloneApp extends StatelessWidget {
  const TelegramCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telegram EPN Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          surface: Color(0xFF1C1C1E),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
