import 'package:home_food_delivery/src/driver/location.dart';

class Route extends Location {
  Location pickupAddress;
  Location deliveryAddress;
  double cost;
  int distance;
  int time;
  String weather;
  String conditions;
  double gasPrice;

  Route(this.pickupAddress, this.deliveryAddress, this.cost, this.distance,
      this.time, this.weather, this.conditions, this.gasPrice)
      : super(0, 0, '', 0);

  double calculateCost() {
    return 0.0;
  }
}
