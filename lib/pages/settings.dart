import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: MaterialButton(
              child: Text("change"),
              onPressed: () {}
          ),
        ));
  }
}
