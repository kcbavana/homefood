import 'package:home_food_delivery/src/cook/cook.dart';

class FoodItem extends Cook {
  int foodID = 0;
  String? _name;
  String? _category;
  double _avgRating = 0.0; // dart doesnt have
  double _price = 0.0;

  FoodItem(int useId, String fullName, String address, String phoneNumber,
      String emailAddress)
      : super(useId, fullName, address, phoneNumber, emailAddress);
  /*
  * TO DO: 
  */
  String getName() {
    return "";
  }

  /*
  * TO DO: 
  */
  String getCategory() {
    return "";
  }

  /*
  * TO DO: 
  */
  double getAvgRating() {
    return 0.0;
  }

  /*
  * TO DO: 
  */
  double getPrice() {
    return 0.0;
  }
}
