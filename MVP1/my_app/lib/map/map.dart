import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_app/Routines/add_routine.dart';
import 'package:my_app/User/create_user.dart';
import '../User/user_model.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final int wid;
  @override
  const MapScreen({Key? key, required this.wid}) : super(key: key);

  _MapScreen createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  final mapController = MapController();
  LatLng poin = LatLng(0, 0);
  double lat = 0;
  double long = 0;
  int get wid => widget.wid;
  UserSettings? userSettings;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userSettings = Provider.of<UserSession>(context).getUser();
  }

  late Marker marker;
  
  @override
  void initState() {
    super.initState();
    poin = LatLng(0, 0);
    lat = 0;
    long = 0;
    
  }

  Marker _addMarker() {
    if(wid == 4){
      marker = Marker(
        width: 80.0,
        height: 80.0,
        point: poin,
        child: Container(
          child: const Icon(
            Icons.location_on,
            size: 50.0,
            color: Colors.red,
          ),
        ),
      );
    }
    else if (userSettings != null) {
      marker = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(userSettings?.latitude ?? 0, userSettings?.longitude ?? 0),
        child: Container(
          child: const Icon(
            Icons.home,
            size: 50.0,
            color: Colors.red,
          ),
        ),
      );
    }
    else {
      marker = Marker(
        width: 80.0,
        height: 80.0,
        point: const LatLng(-33.45694, -70.64827),
        child: Container(
          child: const Icon(
            Icons.location_city,
            size: 50.0,
            color: Colors.red,
          ),
        ),
      );
    }
    return marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa ${userSettings?.username}'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push((context),
                  MaterialPageRoute(builder: (context) => CreateUser()));
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: const LatLng(-33.45694, -70.64827),
          initialZoom: 13.0,
          onMapReady: () {
            if (wid == 0) {
              mapController.mapEventStream.listen((event) {
                if (event is MapEventLongPress) {
                  poin = event.tapPosition;
                  lat = poin.latitude;
                  long = poin.longitude;

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmación'),
                        content: const Text(
                            '¿Estás seguro de que esta es tu ubicación?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          // En tu widget MapScreen
                          TextButton(
                            child: const Text('Aceptar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop(LatLng(lat, long));
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              
              _addMarker(),
            ],
          ),
        ],
      ),
    );
  }
}
