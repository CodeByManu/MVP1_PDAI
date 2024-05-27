import 'dart:ffi';

import 'package:flutter/material.dart';
import 'Routines/routine_model.dart';
import 'Extras/notification_service.dart';
import 'package:provider/provider.dart';
import'User/user_model.dart';

class PantallaPrincipal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  UserSettings? userSettings;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userSettings = Provider.of<UserSession>(context).getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal ${userSettings?.username}',
        style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 25),
          ListTile(
            title: const Text('Ver Rutinas'),
            onTap: () {
              Navigator.pushNamed(context, '/main/show_routines');
            },
            tileColor: Colors.blue,
            hoverColor: Colors.lightGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.all(10.0),
            minTileHeight: 50.0,
            minLeadingWidth: 60.0,
            horizontalTitleGap: 10,
          ),
          const SizedBox(height: 40),
          
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/main/settings');},
            tileColor: Colors.blue,
            hoverColor: Colors.lightGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.all(10.0),
            minTileHeight: 50.0,
            minLeadingWidth: 60.0,
            horizontalTitleGap: 10,
            
            
          
          ),
          const SizedBox(height: 40),
          
          //const SizedBox(height: 40),
          ListTile(
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
            tileColor: Colors.blue,
            hoverColor: Colors.lightGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.all(10.0),
            minTileHeight: 50.0,
            minLeadingWidth: 60.0,
            horizontalTitleGap: 10,
          
          ),

          // Agrega más ListTile aquí para más enlaces
        ],
      ),
    );
  }
}