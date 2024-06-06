import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'routine_model.dart';
// import '../Extras/custom_colors.dart';
// import '../Extras/notification_service.dart';
import '../db/Database_helper.dart';
import '../User/user_model.dart';
import '../Activities/add_activitie.dart';
import '../map/map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart' as vector;

class ShowRoutine extends StatefulWidget {
  final int routineId;

  ShowRoutine({required this.routineId});

  @override
  _ShowRoutine createState() => _ShowRoutine();
}

class _ShowRoutine extends State<ShowRoutine> {
  int minut = 0;
  @override
  void initState() {
    super.initState();
    loadModel().then((value) {});
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
    final fetchedActivities =
        await DatabaseHelper().getActivities(widget.routineId);
    if (mounted) {
      // Check if the widget is still mounted
      setState(() {
        activities = fetchedActivities;
      });
    }
  }

  void loadRoutines() async {
    routines = await DatabaseHelper().getRoutines(userSettings?.username);
    routine =
        routines.where((element) => element['routineId'] == _routineId).first;
    loadActivities();
    setState(() {});
  }
  void calculateTime() {
    if (activities != null) {
      for (var activity in activities??[]) {
        if (activity['duration'] != null && activity['duration'] is String) {
          minut += int.parse(activity['duration']);
        }
      }
    }
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
          ListTile(
            title: Text("Destination: ${routine['destination']}"),
          ),
          ListTile(
            title: Text(
                "Time of arrival: ${routine['timeofarrival'] ~/ 60} : ${routine['timeofarrival'] % 60}"),
          ),
          const SizedBox(height: 25),
          ListTile(
            title: const Text("View Routine Map"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
                      width: MediaQuery.of(context).size.width *
                          0.9, // 90% of screen width
                      height: MediaQuery.of(context).size.height *
                          0.7, // 70% of screen height
                      child: FlutterMap(
                        mapController: MapController(),
                        options: MapOptions(
                          initialCenter: LatLng(
                              (routine['dep_lat'] + routine['des_lat']) / 2,
                              (routine['dep_lon'] + routine['des_lon']) / 2),
                          initialZoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: LatLng(
                                    routine['dep_lat'], routine['dep_lon']),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 50.0,
                                ),
                              ),
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: LatLng(
                                    routine['des_lat'], routine['des_lon']),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 50.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          FutureBuilder<dynamic>(
            future: predict(routine['timeofarrival'], routine['dep_lat'],
                routine['dep_lon'], routine['des_lat'], routine['des_lon']),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data[0][0] != null) {
                String str = snapshot.data[0][0].toString().split(".")[0];
                String result = str.substring(0, str.length - 1);
                minut = int.parse(result);
                return Text("Predicted time on road: ${result} minutes");
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),

          Expanded(
            child: ListView.builder(
              itemCount: activities?.length,
              itemBuilder: (context, index) {

                if (activities?[index]['duration'] != null) {
                  minut += int.parse((activities?[index]['duration'] ?? 0).toString());
                }
                return Card(
                  child: ListTile(
                    title: Text(activities?[index]['name']),
                    subtitle: Text(
                        "${activities?[index]['description']} - ${(activities?[index]['duration'] ?? 0).toString()} minutes"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        DatabaseHelper()
                            .deleteActivitie(activities?[index]['id']);
                        loadRoutines();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          ListTile(
            title: Text(
                "Hora de salida: ${(routine['timeofarrival'] - minut) ~/ 60} : ${(routine['timeofarrival'] - minut) % 60}"),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the activity creation screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddActivitie(
                        routineId: routine[
                            'routineId'])), // Replace CreateActivityScreen with your activity creation widget
              );
            },
            child: const Text('Add Activity'),
          ),
        ],
      ),
    );
  }
}

Future loadModel() async {
  final interpreter = await Interpreter.fromAsset('assets/model_pdai.tflite');
  return (interpreter);
}

Uint8List binary(
    int input5, double lat1, double lon1, double lat2, double lon2) {
  Float32List data =
      Float32List.fromList([input5.toDouble(), lat1, lon1, lat2, lon2]);
  return data.buffer.asUint8List();
}

Future predict(
    int input5, double lat1, double lon1, double lat2, double lon2) async {
  // Cargar el modelo
  Interpreter interpreter = await loadModel();

  // Preparar los datos de entrada
  Uint8List inputData = binary(input5, lat1, lon1, lat2, lon2);
  var output = List.generate(1, (_) => List.filled(1, 0.0));

  // Hacer la predicción
  interpreter.run(inputData, output);


  // Cerrar el modelo
  return output;
}
