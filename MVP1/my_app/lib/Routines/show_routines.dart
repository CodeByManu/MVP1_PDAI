// import 'dart:ffi';
// import '../main.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'routine_model.dart';
// import '../Extras/custom_colors.dart';
// import '../Extras/notification_service.dart';
import '../db/Database_helper.dart';
import '../User/user_model.dart';

class ShowRoutines extends StatefulWidget {
  @override
  _ShowRoutines createState() => _ShowRoutines();
}

class _ShowRoutines extends State<ShowRoutines> {
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

  @override
  Widget build(BuildContext context) {
    loadRoutines();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Rutinas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      
      body: ListView(
        
        children: <Widget>[
          const SizedBox(height: 40),
          ExpansionTile(
            title: const Text('Monday'),
            children: _buildRoutinesForDay('Monday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            title: const Text('Tuesday'),
            children: _buildRoutinesForDay('Tuesday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            title: const Text('Wednesday'),
            children: _buildRoutinesForDay('Wednesday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            title: const Text('Thursday'),
            children: _buildRoutinesForDay('Thursday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            title: const Text('Friday'),
            children: _buildRoutinesForDay('Friday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            title: const Text('Saturday'),
            children: _buildRoutinesForDay('Saturday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            title: const Text('Sunday'),
            children: _buildRoutinesForDay('Sunday'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoutinesForDay(String weekday) {
    final days = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    loadRoutines();
    int totalDuration = 0;
    for (var routine in routines) {
      if (int.parse(routine['weekday']) == days[weekday]) {
        totalDuration += int.parse(routine['duration'].toString());
      }
    }

    List<Widget> widgets = routines.map((routine) {
      if (int.parse(routine['weekday']) != days[weekday]) {
        return const SizedBox.shrink();
      }
      return ListTile(
        title: Text(routine['name'].toString()),
        subtitle: Text(
            '${routine['description'].toString()} - ${routine['duration'].toString()} min',
            style: TextStyle(color: Theme.of(context).primaryColor)),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            DatabaseHelper()
                .deleteRoutine(routine['id'], userSettings?.username);
            loadRoutines();
          },
        ),
      );
    }).toList();

    widgets.add(
      ListTile(
        title: Text('Total duration: $totalDuration min'),
      ),
    );
    widgets.add(
      ListTile(
        title: const Text('Add Routine'),
        onTap: () {
          loadRoutines();
          Navigator.pushNamed(context, '/main/show_routines/add_routine');
        },
      ),
    );

    return widgets;
  }
}
