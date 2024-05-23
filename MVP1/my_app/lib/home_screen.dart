import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/routine_model.dart';
import 'custom_colors.dart';
import 'notification_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String data = '';
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', data);
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      data = prefs.getString('data') ?? '';
    });
  }

  void _addRoutine() {
    final name = _nameController.text;
    final duration = int.tryParse(_durationController.text) ?? 0;
    final description = _descriptionController.text;

    final routine =
        Routine(name: name, duration: duration, description: description);

    Provider.of<RoutineModel>(context, listen: false).addRoutine(routine);
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addRoutine,
              child: Text('Add Routine'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: Provider.of<RoutineModel>(context).routines.length,
                itemBuilder: (context, index) {
                  final routine = Provider.of<RoutineModel>(context).routines[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(routine.name,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      subtitle: Text(
                          '${routine.duration} minutes - ${routine.description}'),
                      tileColor: Theme.of(context).colorScheme.background,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Consumer<RoutineModel>(
              builder: (context, routineModel, child) {
                return Text(
                  'Total Duration: ${routineModel.routines.fold(0, (total, routine) => total + routine.duration)} minutes',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
