import 'package:flutter/material.dart';
//import 'Extras/notification_service.dart';
import 'package:provider/provider.dart';
import 'User/user_model.dart';
import 'package:flutter/services.dart';
import '../map/map.dart';

class PantallaPrincipal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  UserSettings? userSettings;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userSettings = Provider.of<UserSession>(context).getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal ${userSettings?.username}',
            style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Colors.lightBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Column(
    children: <Widget>[
      const SizedBox(height: 25),
      Row(
        children: <Widget>[
          Expanded(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Ver Rutinas'),
                onTap: () {
                  Navigator.pushNamed(context, '/main/show_routines');
                },
                hoverColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pushNamed(context, '/main/settings');
                },
                hoverColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // Add your onTap function here
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 15),
      Row(
        children: <Widget>[
          Expanded(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.alarm),
                title: const Text('Alarm'),
                onTap: () {
                  Navigator.pushNamed(context, '/main/alarms');
                },
                hoverColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // Add your onTap function here
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Calendar'),
                onTap: () {
                  Navigator.pushNamed(context, '/main/calendar');
                },
                hoverColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // Add your onTap function here
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 15),
      Row(
        children: <Widget>[
          Expanded(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                onTap: () {
                  Navigator.pushNamed(context, '/main/notifications');
                },
                hoverColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // Add your onTap function here
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pushNamed(context, '/main/profile');
                },
                hoverColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // Add your onTap function here
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 15),
      Row(children: <Widget>[
        Expanded(
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Map'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen(wid:1)));
                },
                hoverColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // Add your onTap function here
              ),
            ),
          ),
        Expanded(
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
              Provider.of<UserSession>(context, listen: false).removeUser();
                Navigator.pushNamed(context, '/');
              },
              hoverColor: Colors.lightGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              // Add your onTap function here
            ),
          ),
        ),


      ],
      )
    ],
    
  ),
),
    );
  }
}



