import 'package:flutter/material.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Routines/routine_model.dart';
import 'custom_colors.dart';
import 'notification_service.dart';
import 'package:provider/provider.dart';

// Define a model for your user settings


// Define a screen where the user can change their settings
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Language'),
            onTap: () {
              // Navigate to a new screen where the user can change their language
            },
          ),
          // Add similar ListTiles for other settings...
        ],
      ),
    );
  }
}