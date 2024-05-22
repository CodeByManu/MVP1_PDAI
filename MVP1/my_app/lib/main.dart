import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'notification_service.dart';
import 'custom_colors.dart'; // Importa el archivo de colores

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routine Manager',
      theme: ThemeData(
        primarySwatch: customPrimarySwatch,
        primaryColor: customPrimarySwatch,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: customPrimarySwatch).copyWith(
          secondary: Color(0xFFD7CCC8), // Beige claro
          background: Color(0xFFEFEBE9), // Beige claro
          surface: Color(0xFFBCAAA4), // Beige medio
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onBackground: Colors.black,
          onSurface: Colors.black,
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(color: Color(0xFF3E2723), fontWeight: FontWeight.bold), // Marrón oscuro
          bodyMedium: TextStyle(color: Color(0xFF3E2723)), // Marrón oscuro
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF795548), // Marrón
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: customPrimarySwatch,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
