// REMOVE Comment below before starting to code
// ignore_for_file: unused_field, prefer_final_fields

import 'package:home_food_delivery/src/customer/customer.dart';
import 'package:home_food_delivery/src/customer/order.dart';
import 'package:home_food_delivery/src/driver/driver.dart';
import 'package:home_food_delivery/src/interfaces/feedback.dart';

class DriverFeedback extends Feedback {
  Order order;
  Driver driver;
  Customer customer;
  int _rating;
  String? _comments; // can be null

  DriverFeedback(
      this.order, this.driver, this.customer, this._rating, this._comments);
}
