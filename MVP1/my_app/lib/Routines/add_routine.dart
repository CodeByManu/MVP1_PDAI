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
import '../map/map.dart';
import 'package:latlong2/latlong.dart';

class AddRoutine extends StatefulWidget {
  final int weekdayIndex;

  AddRoutine({required this.weekdayIndex});
  @override
  _AddRoutine createState() => _AddRoutine();
}

class _AddRoutine extends State<AddRoutine> {
  final _nameController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  final _destinationController = TextEditingController();
  ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);
  ValueNotifier<bool> isExpanded1 = ValueNotifier<bool>(false);
  double _departureControllerlat = 0.0;
  double _departureControllerlon = 0.0;
  double _destinationControllerlat = 0.0;
  double _destinationControllerlon = 0.0;
  int get _weekdayIndex => widget.weekdayIndex;
  UserSettings? userSettings;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userSettings = Provider.of<UserSession>(context).getUser();
  }
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
            TextField(
              readOnly: true,
              controller: hourController,
              decoration: const InputDecoration(
                labelText: 'Hour of arrival',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  int minutes = pickedTime.hour * 60 + pickedTime.minute;
                  hourController.text = minutes.toString();
                }
              },
            ),
            const SizedBox(height: 25),
            ExpansionTile(
              initiallyExpanded: isExpanded.value,
              onExpansionChanged: (bool expanded) {
                isExpanded.value = expanded;
              },
              title: const Text("Select a departure location"),
             children: [
                ListTile(
                  title: const Text("Home"),
                  onTap: () {
                    _departureControllerlat = userSettings?.latitude ?? 0.0;
                    _departureControllerlon = userSettings?.longitude ?? 0.0;
                    isExpanded.value = false;
                  },
                ),
                ListTile(
                  title: const Text("Other"),
                  onTap: () async{
                    LatLng? result = await Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const MapScreen(wid:0))
                );

                if (result != null) {
                  _departureControllerlat = result.latitude;
                  _departureControllerlon = result.longitude;
                }
                isExpanded.value = false;
              },
                  
                ),
             ]
              ),
            const SizedBox(height: 25),
            ExpansionTile(
              initiallyExpanded: isExpanded1.value,
              onExpansionChanged: (bool expanded) {
                isExpanded1.value = expanded;
              },
              title: const Text("Select a destination location", selectionColor: Colors.lightBlueAccent,),
             children: [
                ListTile(
                  title: const Text("Home"),
                  onTap: () {
                    _destinationControllerlat = userSettings?.latitude ?? 0.0;
                    _destinationControllerlon = userSettings?.longitude ?? 0.0;
                    isExpanded1.value = false;
                  },
                  
                ),
                ListTile(
                  title: const Text("Other"),
                  onTap: () async{
                    LatLng? result = await Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const MapScreen(wid:0))
                );

                if (result != null) {
                  _destinationControllerlat = result.latitude;
                  _destinationControllerlon = result.longitude;
                }
                isExpanded1.value = false;
              },
                  
                ),
             ]
              ),
            
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper().saveRoutine(
                    Provider.of<UserSession>(context, listen: false).getUser()?.username,
                    _nameController.text,
                    _weekdayIndex,
                    _destinationController.text,
                    _destinationControllerlat,
                    _destinationControllerlon,
                    _departureControllerlat,
                    _departureControllerlon,
                    int.parse(hourController.text)
                    );
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