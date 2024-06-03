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

class AddRoutine extends StatefulWidget {
  final int weekdayIndex;

  AddRoutine({required this.weekdayIndex});
  @override
  _AddRoutine createState() => _AddRoutine();
}

class _AddRoutine extends State<AddRoutine> {
  final _nameController = TextEditingController();
  final _destinationController = TextEditingController();
  int get _weekdayIndex => widget.weekdayIndex;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Routine',
            style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().saveRoutine(
                    Provider.of<UserSession>(context, listen: false).getUser()?.username,
                    _nameController.text,
                    _weekdayIndex,
                    _destinationController.text,);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Routine saved successfully')),
                );
                Navigator.pushNamed(context, "/main/show_routines");
              
              },
              
              child: const Text('Add Routine'),
            ),
          ],
        ),
      ),
    );
  }
  

}