import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/dynamic_home_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/property_provider.dart';

void main() {
  runApp(const AirbnbCloneApp());
}

class AirbnbCloneApp extends StatelessWidget {
  const AirbnbCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
      ],
      child: MaterialApp(
        title: 'Airbnb Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE31C5F)),
          useMaterial3: true,
          visualDensity: VisualDensity.comfortable,
        ),
        home: const DynamicHomeScreen(),
      ),
    );
  }
}
