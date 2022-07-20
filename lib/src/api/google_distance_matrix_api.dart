import 'package:home_food_delivery/src/driver/location.dart';
import 'package:home_food_delivery/src/driver/route.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: camel_case_types
class GoogleDistanceMatrixAPI extends Route {
  GoogleDistanceMatrixAPI(
      Location pickupAddress,
      Location deliveryAddress,
      double cost,
      int distance,
      int time,
      String weather,
      String conditions,
      double gasPrice)
      : super(pickupAddress, deliveryAddress, cost, distance, time, weather,
            conditions, gasPrice);

  int getDistance() {
    return 0;
  }

  int getEstimatedTime() {
    return 0;
  }
}
