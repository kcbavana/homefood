import 'package:home_food_delivery/src/driver/location.dart';
import 'package:home_food_delivery/src/driver/route.dart';

// ignore: camel_case_types
class GasPricesAPI extends Route {
  GasPricesAPI(
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

  double getCurrentPrice() {
    return 0.0;
  }
}
