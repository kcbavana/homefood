import 'package:home_food_delivery/src/cook/cook.dart';
import 'package:home_food_delivery/src/customer/customer.dart';
import 'package:home_food_delivery/src/customer/order.dart';
import 'package:home_food_delivery/src/interfaces/feedback.dart';

class CookFeedback extends Feedback {
  Order order;
  Cook cook;
  Customer customer;
  int _rating;
  String? _comments;
  CookFeedback(
      this.order, this.cook, this.customer, this._rating, this._comments);
}
