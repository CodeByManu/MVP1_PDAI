import 'package:flutter/material.dart';
import 'package:my_app/map/map.dart';
import 'user_model.dart';
import '../db/Database_helper.dart';
import 'package:latlong2/latlong.dart';


class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>();
  final UserSettings _userSettings = UserSettings(
    language: 'en',
    transportationType: 'car',
    alarmType: 'ring',
    password: '',
    email: '',
    username: '',
    latitude: 0,
    longitude: 0,
  );

  int prin(double? value) {
    print(value);
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
              onSaved: (value) {
                _userSettings.username = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              onSaved: (value) {
                _userSettings.email = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              onSaved: (value) {
                _userSettings.password = value!;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                LatLng? result = await Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const MapScreen(wid:0))
                );

                if (result != null) {
                  _userSettings.latitude = result.latitude;
                  _userSettings.longitude = result.longitude;
                }
              },
              child: const Text('Select location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await DatabaseHelper().insertUserSettings(_userSettings);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User created successfully')),
                  );
                  Navigator.pushNamed(context, '/');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}