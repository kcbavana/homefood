import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/signup/login_view.dart';
import 'package:home_food_delivery/src/signup/mysql.dart';

//TODO: add hash function for password

class SignUpView extends StatelessWidget {
  static const String _title = "Home Food Delivery";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
      theme: FlexColorScheme.light(scheme: FlexScheme.mandyRed).toTheme,
      //darkTheme: FlexColorScheme.dark(scheme: FlexScheme.mandyRed).toTheme,
      themeMode: ThemeMode.system,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

Widget _buildPopupDialog(BuildContext context) {
  //can make different ones for password and username if wanted
  return new AlertDialog(
    title: const Text('Error'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Username already exists"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}

/*TODO add validators to text fields to make sure database doesn't freak out with strange data
like phonenumber can't be longer than 10 digits, none of the fields are empty, etc*/
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  //connection to MySql database
  var db = Mysql();
  //takes data from the fields and sends it to the database and ends the connection
  Future<void> sendData(userName, email, password, phoneNumber, address,
      firstName, lastName) async {
    db.getConnection().then((conn) {
      String sql =
          'select * from Home_Food_Delivery_Database.user where username = \'$userName\'';
      conn.query(sql).then((results) {
        if (results.isNotEmpty) {
          //means username does exist in database (cannot have duplicate usernames)
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        } else {
          sql =
              'insert into Home_Food_Delivery_Database.user (username, email, password, phone_number, address, first_name, last_name) values (?, ?, ?, ?, ?, ?, ?)';
          conn.query(sql, [
            userName,
            email,
            password,
            phoneNumber,
            address,
            firstName,
            lastName
          ]).then((result) {
            //after signing up go to login screen
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => loginView()));
          }, onError: () {
            print("Cannot Insert");
          }).whenComplete(() {
            conn.close();
          });
        }
      }).whenComplete(() => conn.close());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formkey,
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Image.asset('assets/images/circle logo.png',
                    height: 250, width: 250)),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Sign Up as a Customer!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red.shade900,
                  ),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                  // updated to text form field
                  validator: (value) {
                    // if the values are null, means the user needs to add values
                    if (value == null || value.isEmpty) {
                      return "Please enter the First Name";
                    } else {
                      return null; // else returns null
                    }
                  },
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                  ),
                  maxLength: 20),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                  // updated to text form field
                  validator: (value) {
                    // if the values are null, means the user needs to add values
                    if (value == null || value.isEmpty) {
                      return "Please enter the Last Name";
                    } else {
                      return null; // else returns null
                    }
                  },
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                  ),
                  maxLength: 20),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                  // updated to text form field
                  validator: (value) {
                    // if the values are null, means the user needs to add values
                    if (value == null || value.isEmpty) {
                      return "Please Enter the Email";
                    } else {
                      return null; // else returns null
                    }
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email Address',
                  ),
                  maxLength: 225),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                  // updated to text form field
                  validator: (value) {
                    // if the values are null, means the user needs to add values
                    if (value == null || value.isEmpty) {
                      return "Please enter the Phone Number";
                    } else {
                      return null; // else returns null
                    }
                  },
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number ',
                  ),
                  maxLength: 10),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                // updated to text form field
                validator: (value) {
                  // if the values are null, means the user needs to add values
                  if (value == null || value.isEmpty) {
                    return "Please enter the Address";
                  } else {
                    return null; // else returns null
                  }
                },
                controller: addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                  // updated to text form field
                  validator: (value) {
                    // if the values are null, means the user needs to add values
                    if (value == null || value.isEmpty) {
                      return "Please Enter the Username";
                    } else {
                      return null; // else returns null
                    }
                  },
                  controller: userNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                  maxLength: 16),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                  // updated to text form field
                  validator: (value) {
                    // if the values are null, means the user needs to add values
                    if (value == null || value.isEmpty) {
                      return "Please Enter the Password";
                    } else {
                      return null; // else returns null
                    }
                  },
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  maxLength: 32),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => loginView()));
              },
              child: const Text(
                'Already have a account? Log In',
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Sign Up'),
                  //figure out how to handle database insertion error (same username)
                  onPressed: () {
                    // if the form state is activated by the widget
                    if (formkey.currentState != null) {
                      // then check the validate status
                      // if no validator issues, then proced
                      if (formkey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    } else {
                      sendData(
                          userNameController.text,
                          emailController.text,
                          passwordController.text,
                          phoneController.text,
                          addressController.text,
                          firstNameController.text,
                          lastNameController.text);
                    }

                    print(userNameController.text);
                    print(passwordController.text);
                    //Navigator moved to sendData function
                  },
                )),
          ],
        ));
  }
}
