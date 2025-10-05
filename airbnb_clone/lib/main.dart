import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AirbnbCloneApp());
}

class AirbnbCloneApp extends StatelessWidget {
  const AirbnbCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airbnb Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE31C5F)),
        useMaterial3: true,
        visualDensity: VisualDensity.comfortable,
      ),
      home: const HomeScreen(),
    );
  }
}
