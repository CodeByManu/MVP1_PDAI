import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'routine_model.dart';
// import '../Extras/custom_colors.dart';
// import '../Extras/notification_service.dart';
import '../db/Database_helper.dart';
import '../User/user_model.dart';
import '../Activities/add_activitie.dart';

class ShowRoutine extends StatefulWidget {
  final int routineId;

  ShowRoutine({required this.routineId});

  @override
  _ShowRoutine createState() => _ShowRoutine();
}

class _ShowRoutine extends State<ShowRoutine> {
  @override
  void initState() {
    super.initState();
  }

  List<Map<String, dynamic>> routines = [];
  Map<String, dynamic> routine = {};
  List<Map<String, dynamic>>? activities = [];
  UserSettings? userSettings;
  int get _routineId => widget.routineId;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userSettings = Provider.of<UserSession>(context).getUser();
  }

void loadActivities() async {
  final fetchedActivities = await DatabaseHelper().getActivities(widget.routineId);
  if (mounted) { // Check if the widget is still mounted
    setState(() {
      activities = fetchedActivities;
    });
  }
}


  void loadRoutines() async {
    routines = await DatabaseHelper().getRoutines(userSettings?.username);
    routine = routines.where((element) => element['routineId'] == _routineId).first;
    loadActivities();
    setState(() {});
  }

  

  @override
  Widget build(BuildContext context) {
    loadRoutines();
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutina ${routine['name'].toString()}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: activities?.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(activities?[index]['name']),
                    subtitle: Text(activities?[index]['description']),
                    trailing: Text((activities?[index]['duration'] ?? 0).toString()),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the activity creation screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddActivitie(routineId: routine['routineId'])), // Replace CreateActivityScreen with your activity creation widget
              );
            },
            child: const Text('Add Activity'),
          ),
        ],
      ),
    );
  }
}
      