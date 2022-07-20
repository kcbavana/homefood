import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_food_delivery/src/customer/cook_menu_items.dart';
import 'package:home_food_delivery/src/signup/mysql.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const GoogleMapImplementation());

Future<void> saveSelectedCookID(String name, var context) async {
  //save cook_id so menu page can get cook's menu items
  var db = Mysql();
  final prefs = await SharedPreferences.getInstance();
  db.getConnection().then((conn) {
    String sql = // checking if the cookid is in the database, for validating
        'select cook_id from cook where buisness_name = "$name"';
    conn.query(sql).then((results) async {
      for (var row in results) {
        await prefs.setInt('selected_cook', row[0]);
      }
    }, onError: (error) {
      print("$error");
    }).whenComplete(() {
      conn.close();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => cookitems(
                title: "cookitems",
              )));
    });
  });
  //go to menu page
}

class GoogleMapImplementation extends StatefulWidget {
  const GoogleMapImplementation({Key? key}) : super(key: key);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<GoogleMapImplementation> {
  late GoogleMapController mapController;
  final Set<Marker> markers = new Set(); //markers for google map
  bool gotMarkers = false;
  int markerNumCtr = 0; //counter to tell where marker is in Set

  // Initial view set to at UIC
  final LatLng _center = const LatLng(41.869148559793835, -87.64910465683184);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  getAddresses() {
    //only grab addresses from users that are registered as cooks
    List<List<String>> addresses = <List<String>>[];
    var db = Mysql();
    db.getConnection().then((conn) {
      String sql =
          'select Home_Food_Delivery_Database.user.address, cook.buisness_name from cook join user ON cook.user_id = user.user_id';
      conn.query(sql).then((results) async {
        for (var row in results) {
          //grabs the results and puts it into addresses
          List<Location> location =
              await locationFromAddress(row[0].toString());
          List<String> data = [
            location[0].latitude.toString(),
            location[0].longitude.toString(),
            row[1].toString()
          ];
          addresses.insert(0, data);
          setState(() {
            //add address data to markers
            markers.add(Marker(
              markerId: MarkerId(row[1].toString()),
              position: LatLng(location[0].latitude, location[0].longitude),
              infoWindow: InfoWindow(
                  //popup info
                  title: row[1].toString(),
                  snippet: '',
                  onTap: () {
                    saveSelectedCookID(row[1].toString(), context);
                  }),
              icon: BitmapDescriptor.defaultMarker, //Icon for Marker
            ));
          });
        }
      }, onError: (error) {
        print("$error");
      }).whenComplete(() => conn.close());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.0,
          ),
          markers: getmarkers(), //markers to show on map
          mapType: MapType.normal,
          onMapCreated: (controller) {
            //method called when map is created
            setState(() {
              mapController = controller;
            });
          },
        ),
      ),
    );
  }

// Markers
  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(_center.toString()),
        position: _center, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'UIC',
          snippet: 'Marker 1',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      markerNumCtr++;

      markers.add(Marker(
        //add second marker
        markerId: MarkerId(_center.toString()),
        position:
            const LatLng(41.866317476827746, -87.64723688260864), //TBH location
        infoWindow: InfoWindow(
          //popup info
          title: 'Thomas Beckham Hall',
          snippet: 'Marker 2',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      markerNumCtr++;

      markers.add(Marker(
        //add third marker
        markerId: MarkerId(_center.toString()),
        position: LatLng(41.8729330082422, -87.64608825987263), //The REC
        infoWindow: InfoWindow(
          //popup info
          title: 'UIC Student Recreation Center',
          snippet: 'Marker 3',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      markerNumCtr++;

      if (gotMarkers == false) {
        //only get addresses from database once
        getAddresses();
        gotMarkers = true;
      }
    });

    return markers;
  }
}
