import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const HarvesterConnectApp());
}

class HarvesterConnectApp extends StatelessWidget {
  const HarvesterConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harvester Connect',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
    );
  }
}