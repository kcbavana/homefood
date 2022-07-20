// ignore_for_file: unused_element

import 'package:home_food_delivery/src/interfaces/user.dart';

class Customer extends User {
  int _customerID = 0;

  Customer(int useId, String fullName, String address, String phoneNumber,
      String emailAddress)
      : super(useId, fullName, address, phoneNumber, emailAddress);

  void setCustomerId(int customerId) {
    _customerID = customerId;
  }

  int getCustomerId() {
    return _customerID;
  }
  /*
  Payment _paymentInfo = Payment();
  List<Order> _orders = List<Order>.empty(growable: true);

  void _giveFeedback() {}

  void driverFeedback() {}

  void _sendRating() {}

  void cookFeedback() {}

  FoodRating _rateFood() {
    throw (_address);
  }

  Order _placeOrder() {
    return Order();
  }

  Payment _sendPayment() {
    return Payment();
  }
  */
}
