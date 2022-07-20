import 'package:home_food_delivery/src/cook/fooditem.dart';
import 'package:home_food_delivery/src/customer/customer.dart';
import 'package:home_food_delivery/src/customer/order.dart';
import 'package:home_food_delivery/src/interfaces/feedback.dart';

class FoodRating extends Feedback {
  Order order;
  Customer customer;
  FoodItem _food;
  String _category;
  int _rating;
  String? _comments;

  FoodRating(this.order, this.customer, this._food, this._category,
      this._rating, this._comments);
}
