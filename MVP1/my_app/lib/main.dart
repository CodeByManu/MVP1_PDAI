import 'package:flutter/material.dart';
import 'Activities/add_activitie.dart';
import 'Extras/notification_service.dart';
import 'pantallaprincipal.dart';
import 'Extras/custom_colors.dart'; // Importa el archivo de colores
// import 'Routines/routine_model.dart'; // Importa el modelo de rutinas
import 'package:provider/provider.dart';
import 'Extras/settings.dart';
import 'Routines/show_routines.dart';
import 'login_screen.dart';
import 'User/user_model.dart';
import 'User/create_user.dart';
import 'package:alarm/alarm.dart';
import 'alarm/alarm_setter.dart';
// import 'db/Database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //NotificationService().initNotification();
  await Alarm.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserSession()),
      ],
      child: MaterialApp(
        //debugShowCheckedModeBanner: false,
        title: 'Mi Aplicación',
        initialRoute: '/', // Esta es la ruta que se carga primero
        routes: {
          '/': (context) => LoginScreen(), // Esta es tu pantalla principal
          '/create_user': (context) =>
              CreateUser(), // Esta es la ruta para la pantalla de crear usuario
          '/main': (context) =>
              PantallaPrincipal(), // Esta es la ruta para la pantalla principal
          '/main/settings': (context) =>
              SettingsScreen(), // Esta es la ruta para la pantalla de configuración
          '/main/show_routines': (context) =>
              ShowRoutines(), // Esta es la ruta para la pantalla de rutinas
          //'/main/show_routines/add_routine': (context) =>
          //    AdRoutine(), // Esta es la ruta para la pantalla de agregar rutinas
          '/main/alarms': (context) =>
              ExampleAlarmHomeScreen(), // Esta es la ruta para la pantalla de alarmas
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routine Manager',
      theme: ThemeData(
        primarySwatch: customPrimarySwatch,
        primaryColor: customPrimarySwatch,
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: customPrimarySwatch).copyWith(
          secondary: Color(0xFFD7CCC8), // Beige claro
          background: Color(0xFFEFEBE9), // Beige claro
          surface: Color(0xFFBCAAA4), // Beige medio
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onBackground: Colors.black,
          onSurface: Colors.black,
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
              color: Color(0xFF3E2723),
              fontWeight: FontWeight.bold), // Marrón oscuro
          bodyMedium: TextStyle(color: Color(0xFF3E2723)), // Marrón oscuro
        ),
        buttonTheme: const ButtonThemeData(
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
      home: PantallaPrincipal(),
    );
  }
}
