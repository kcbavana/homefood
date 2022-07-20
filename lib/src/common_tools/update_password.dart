import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/common_tools/hamburger.dart';

class UpdatePassword extends StatelessWidget {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Hamburger(
          title: '',
        ),
        appBar: AppBar(
          // title bar
          title: const Text('Update Password'),
          toolbarHeight: 100,
          centerTitle: true,
        ),
        body: Form(
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: oldPasswordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Old Password',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New Password',
                  ),
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text("Change Password"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UpdatePassword()));
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
