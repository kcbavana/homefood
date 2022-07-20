import 'package:home_food_delivery/src/cook/fooditem.dart';
import 'package:home_food_delivery/src/customer/order.dart';
import 'package:home_food_delivery/src/interfaces/user.dart';

class Cook extends User {
  int cookID = 0;
  String _name = "";
  String _address = "";
  String _emailAddress = "";
  String _stateID = "";
  double _avgRating = 0.0;
  List<Order> _openOrders = List<Order>.empty(growable: true);
  List<Order> _completedOrders = List<Order>.empty(growable: true);
  List<FoodItem> _menu = List<FoodItem>.empty(growable: true);

  Cook(int useId, String fullName, String address, String phoneNumber,
      String emailAddress)
      : super(useId, fullName, address, phoneNumber, emailAddress);

  /*
  FoodItem addMenuItem() {
    return FoodItem();
  }

  FoodItem removeItem() {
    return FoodItem();
  }

  double getRating() {
    return 0.0;
  }

  Order _updateStatus() {
    return Order();
  }

  bool markCompleted() {
    return false;
  }
  */
}
