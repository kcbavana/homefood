// REMOVE comment below before starting to code
// ignore_for_file: prefer_final_fields, unused_element

import 'package:home_food_delivery/src/interfaces/user.dart';
import 'package:home_food_delivery/src/driver/route.dart';

class Driver extends User {
  int driverID = 0;
  String _licenseID = "";
  double _avgRating = 0.0;
  String _VIN = "";
  List<Route> _routes = List<Route>.empty(growable: true);

  Driver(int useId, String fullName, String address, String phoneNumber,
      String emailAddress)
      : super(useId, fullName, address, phoneNumber, emailAddress);

  String getVIN() {
    return "";
  }

  String getLicenseID() {
    return "";
  }

  double getRating() {
    return 0.0;
  }

  String _updateDelivery() {
    return "";
  }

  void _addRoute() {}

  void _removeRoute(Route route) {}

  bool _marDelivered() {
    return false;
  }
}
