import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routine_model.dart';
import '../Extras/custom_colors.dart';
import '../Extras/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../db/Database_helper.dart';
import '../User/user_model.dart';



class AdRoutine extends StatefulWidget {
  @override
  _AdRoutine createState() => _AdRoutine();
}

class _AdRoutine extends State<AdRoutine> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRoutines();
  }

  List<Map<String, dynamic>> routines = [];
  UserSettings? userSettings;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userSettings = Provider.of<UserSession>(context).getUser();
    loadRoutines();
  }
  void loadRoutines() async {
    routines = await DatabaseHelper().getRoutines(userSettings?.username);
    setState(() {});
  }
  int _selectedDay = 1;

  void _handleDayChanged(int? newValue) {
    setState(() {
      _selectedDay = newValue ?? _selectedDay;
      loadRoutines();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    loadRoutines();
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
            Container(
                height: 40.0,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _selectedDay,
                  items: <int>[1, 2, 3, 4, 5, 6, 7].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('Day $value'),
                    );
                  }).toList(),
                  onChanged: _handleDayChanged,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                
                  await DatabaseHelper().saveRoutine(
                    Routine(
                      name: _nameController.text, 
                      duration: int.parse(_durationController.text), 
                      description: _descriptionController.text, 
                      weekday: _selectedDay
                    ).toMap(), 
                    userSettings?.username,
                  );
                
                loadRoutines();
              },
              
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Routine'),
            ),
            
            Expanded(
              child: ListView.builder(
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  final routine = routines[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(routine['name'].toString(),
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      subtitle: Text(
                          '${routine['duration'].toString()} minutes - ${routine['description'].toString()}- ${routine['weekday'].toString()} '),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          DatabaseHelper().deleteRoutine(routine['id'], userSettings?.username);
                          loadRoutines();
                        },
                      ),
                      tileColor: Theme.of(context).colorScheme.background,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Provider<List<Map<String, dynamic>>>(
              create: (_) => routines,
              child: Consumer<List<Map<String, dynamic>>>(
                builder: (context, routineList, child) {
                  int totalDuration = routineList.fold(0, (total, routine) => total + int.parse(routine['duration'].toString()));
                  return Text(
                    'Total Duration: $totalDuration minutes',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
