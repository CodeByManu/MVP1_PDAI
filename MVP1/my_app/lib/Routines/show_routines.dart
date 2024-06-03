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
import 'add_routine.dart';
import 'show_routine.dart';

class ShowRoutines extends StatefulWidget {
  @override
  _ShowRoutines createState() => _ShowRoutines();
}

class _ShowRoutines extends State<ShowRoutines> {
  @override
  void initState() {
    super.initState();
  }

  List<Map<String, dynamic>> routines = [];
  UserSettings? userSettings;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userSettings = Provider.of<UserSession>(context).getUser();
  }

  void loadRoutines() async {
    routines = await DatabaseHelper().getRoutines(userSettings?.username);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Rutinas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.lightBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context,
                  "/main"); // Replace MainMenu with your main menu widget
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 40),
          ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.red[100],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Monday'),
              ),
            ),
            backgroundColor: Colors.red[100],
            children: _buildRoutinesForDay('Monday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.orange[100],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Tuesday'),
              ),
            ),
            backgroundColor: Colors.orange[100],
            children: _buildRoutinesForDay('Tuesday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Wednesday'),
              ),
            ),
            backgroundColor: Colors.yellow[100],
            children: _buildRoutinesForDay('Wednesday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.purple[100],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Thursday'),
              ),
            ),
            backgroundColor: Colors.purple[100],
            children: _buildRoutinesForDay('Thursday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.green[100],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Friday'),
              ),
            ),
            backgroundColor: Colors.green[100],
            children: _buildRoutinesForDay('Friday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Saturday'),
              ),
            ),
            backgroundColor: Colors.blue[100],
            children: _buildRoutinesForDay('Saturday'),
          ),
          const SizedBox(height: 5),
          ExpansionTile(
            tilePadding: const EdgeInsets.all(0),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Sunday'),
              ),
            ),
            backgroundColor: Colors.grey[100],
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

    int weekdayInde = days[weekday]!;

    loadRoutines();

    List<Widget> widgets = routines.map((routine) {
      const SizedBox.shrink();
      if (routine['weekday'] != days[weekday]) {
        return const SizedBox.shrink();
      }
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: ListTile(
          title: Text(routine['name']),
          subtitle: Text(routine['destination']),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              DatabaseHelper()
                  .deleteRoutine(routine['routineId'], userSettings?.username);
              loadRoutines();
            },
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShowRoutine(routineId: routine['routineId'])),
          ),
        ),
      );
    }).toList();



    // widgets.add(
    //   Container(
    //     decoration: BoxDecoration(
    //       border: Border(
    //         bottom: BorderSide(color: Colors.grey[300]!),
    //       ),
    //     ),
    //     child:
    //   ListTile(
    //     title: Text('Total duration: $totalDuration min'),
    //   ),
    // ),
    // );
    widgets.add(
      ListTile(
        title: const Text('Add Routine'),
        onTap: () {
          loadRoutines();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddRoutine(weekdayIndex: weekdayInde)));
        },
      ),
    );

    return widgets;
  }
}
