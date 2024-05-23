import 'package:flutter/material.dart';
import 'models/routine_model.dart';
import 'notification_service.dart';

class PantallaPrincipal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Agregar Rutina'),
            onTap: () {
              Navigator.pushNamed(context, '/home_screen');
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Navigator.pushNamed(context, '/settings');
            },
          )
          // Agrega más ListTile aquí para más enlaces
        ],
      ),
    );
  }
}