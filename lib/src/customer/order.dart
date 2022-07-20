import 'package:home_food_delivery/src/customer/customer.dart'; // to use customer instance
import 'package:home_food_delivery/src/driver/driver.dart';
import 'package:home_food_delivery/src/cook/fooditem.dart';
import 'package:home_food_delivery/src/driver/location.dart';
import 'package:home_food_delivery/src/driver/route.dart';
import 'package:home_food_delivery/src/interfaces/payment.dart'; // enables extend
import 'package:home_food_delivery/src/cook/cook.dart'; // to use cook instance

class Order extends Payment {
  int orderID = 0;
  // late is the way telling dart we will update the values later
  late Customer customer;
  late Cook cook;
  late Driver driver;
  List<FoodItem> food = List<FoodItem>.empty(growable: true);
  late Location pickupAddress; // if error, get rid of late
  late Location deliveryAddress; // if error, get rid of late
  String timeOrdered = "";
  String status = "";
  bool orderCompleted = false;
  bool outForDelivery = false;
  bool delivered = false;
  String timeDelivered = "";
  bool paymentMade = false;
  double orderTotal = 0.0;

  /*
  * TO DO: 
  */
  void _uploadOrder() {
    // uploads the order into the database
    return;
  }

  /*
  * TO DO: 
  */
  Route sendRoute() {
    // Returns the Route
    throw (cook);
  }

  /*
  * TO DO: 
  */
  bool orderPaid() {
    return true; // needs to be updated
  }
}
