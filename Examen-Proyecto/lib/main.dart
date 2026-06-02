import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'src/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taller Clase 05',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2F80ED),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      home: const AppShell(),
    );
  }
}
