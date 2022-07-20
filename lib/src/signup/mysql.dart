import 'package:mysql1/mysql1.dart';
import 'dart:async';

class Mysql {
  //connection info for AWS database
  static String host = '';
  static int port = 3306;

  Mysql(); //Example: var db = Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(settings);
  }
}

/* Example on how to use
var db = Mysql();
db.getConnection().then((conn) {
      String sql = 'sql statement you want to run';
      conn.query(sql).then((results) {
         //results is the return value of the sql statement
          (mostly useful for select statements)
        }
        for (var row in results) { //walk through the rows of results with this
          print(row[0]); //get specific columns with [], it is in the order
            specified with the sql statement
        }
      }, onError: (error) { //in case if there is an error
        print("oops");
      }).whenComplete(() => conn.close()); //always close the connection when done
    });
*/