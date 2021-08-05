import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/dashboard.dart';
import 'package:st_peters_chaplaincy_unn/pages/sign_in.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  final Function changetheme;
  final bool brightness;
  final MainModel model;

  MySplashScreen(this.changetheme, this.brightness, this.model);

  @override
  _MySplashScreenState createState() => new _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  // MainModel model = MainModel();

  @override
  void initState() {
    super.initState();
    // model.authAthunticate();
  }

  Widget authenticationState(bool brightness) {
    if (widget.model.authentication == null) {
      return SignIn();
    } else {
      if (widget.model.tokenExpired == true) {
        widget.model.setTokenExpired(false);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      }
      Future.delayed(Duration(seconds: 3));
      // widget.model.authAthunticate();
      return DashboardScreen(
        model: widget.model,
          changetheme: widget.changetheme, brightness: widget.brightness);
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: authenticationState(widget.brightness),
      title: widget.model.authentication == null
          ? Text(
              "Welcome To St Peter's Chaplaincy UNN",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).primaryColor),
            )
          : Text(
              "Welcome To St Peter's Chaplaincy UNN\n ${widget.model.authentication.sname} ${widget.model.authentication.fname}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).primaryColor),
            ),
      image: Image.asset(
        "assets/st_peters_logo.jpg",
      ),
      photoSize: _height / 5,
      backgroundColor: Colors.white,
      loaderColor: Theme.of(context).primaryColor,
      loadingText: Text(
        'About time...',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      // imageBackground: AssetImage("assets/images.jpeg"),
    );
  }
}
