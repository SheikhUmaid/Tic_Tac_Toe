import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tic_tac_toe/gamescreen.dart';
import 'package:tic_tac_toe/landingscreen.dart';

void main() async {
  await Hive.initFlutter();
  var db = await Hive.openBox('dbBox');
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const LandingPage(),
      routes: {"Game/": (context) => const Game()},
    );
  }
}
