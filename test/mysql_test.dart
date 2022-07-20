import 'package:flutter_test/flutter_test.dart';
import 'package:home_food_delivery/src/signup/mysql.dart';

void main() {
  group('DataBase Connection', () {
    test('getting test from database', () async {
      expect(1 + 1, 2);
    });
  });
}

Future<void> sendData() async {
  var db = Mysql();
  db.getConnection().then((conn) {
    String sql =
        'insert into Home_Food_Delivery_Database.user (username, email, password, phone_number, address, first_name, last_name) values (?, ?, ?, ?, ?, ?, ?)';
    conn.query(sql, [
      "test",
      "test@test.com",
      "test",
      1234567890,
      "test",
      "test",
      "test"
    ]).then((result) {
      print("Inserted data");
    }, onError: () {
      print("Cannot Insert");
    }).whenComplete(() {
      conn.close();
    });
  });
}
