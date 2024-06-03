// import '../main.dart';
// import 'package:shared_preferences/shared_preferences.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../Extras/custom_colors.dart';
// import '../Extras/notification_service.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
import '../db/Database_helper.dart';
import '../User/user_model.dart';

class AddActivitie extends StatefulWidget {
  final int routineId;

  AddActivitie({required this.routineId});

  @override
  _AddActivitie createState() => _AddActivitie();
}

class _AddActivitie extends State<AddActivitie> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();
  int get _routineId => widget.routineId;
  List<Map<String, dynamic>> routin = [];
  List<Map<String, dynamic>> routines = [];
  UserSettings? userSettings;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userSettings = Provider.of<UserSession>(context).getUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routine Manager',
            style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Activity Name',
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(
                labelText: 'Duration (minutes)',
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().saveActivitie(
                  _nameController.text,
                  _descriptionController.text,
                  int.parse(_durationController.text),
                  _routineId,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Routine saved successfully')),
                );
                Navigator.pushNamed(context, "/main/show_routines");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Routine'),
            ),
          ],
        ),
      ),
    );
  }
}
