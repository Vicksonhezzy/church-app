import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:st_peters_chaplaincy_unn/pages/sign_in.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:st_peters_chaplaincy_unn/ui_widgets/profile_image.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUp extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  Color clr = Colors.deepPurple;
  Icon ic = new Icon(Icons.home);

  bool secure = true;
  bool secureConfirm = true;
  bool _value = false;

  TextEditingController _em = new TextEditingController();
  TextEditingController _ps = new TextEditingController();

  final formkey = GlobalKey<FormState>();

  final Map<String, dynamic> _infoData = {
    'profileImage': null,
    'email': null,
    'password': null,
    'userName': null,
    'surname': null,
    'firstName': null,
    'bAddress': null,
    'number': null,
    'occupation': null,
  };

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  // void _reloadTimer(User user) {
  //   // Timer._createTimer(duration, () { })
  //   if (!user.emailVerified) {
  //     Timer(Duration(seconds: 180), () {
  //       // User user = FirebaseAuth.instance.currentUser;
  //       user.refreshToken;
  //       user.reload();
  //       print(user.emailVerified);
  //     });
  //   }
  // }

  _submit(Function signUp, MainModel model) async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      setState(() {
        model.setLoading(true);
      });
      final Map<String, dynamic> loginSuccess = await signUp(
        _infoData['profileImage'],
        _infoData['email'],
        _infoData['password'],
        _infoData['userName'],
        _infoData['surname'],
        _infoData['firstName'],
        _infoData['bAddress'],
        _infoData['number'],
        _infoData['occupation'],
      );
      if (loginSuccess['success']) {
        User user = FirebaseAuth.instance.currentUser;
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          showDialog(
              context: context,
              builder: (context) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 350, horizontal: 50),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20),
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/images.jpeg"),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Email verification',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'A verification link has been sent to your email, please visit your email to verify your email address before clicking on continue',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Row(children: [
                        Container(),
                        TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignIn(),
                                ),
                              );
                            },
                            child: Text(
                              'Continue',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ])
                    ],
                  ),
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'An error occurred!',
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(loginSuccess['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Okay'),
                  )
                ],
              );
            });
      }
    }
  }

  void _setProfileImage(File image) {
    _infoData['profileImage'] = image;
  }

  Widget _buttonContent(MainModel model) {
    return model.isLoading == true
        ? Container(
        padding: EdgeInsets.only(top: 10),
        child: Center(child: CircularProgressIndicator()))
        : MaterialButton(
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      onPressed: () => _submit(model.signUp, model),
      child: Text('SignUp'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double _containerWidth =
    deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
          return Scaffold(
            appBar: AppBar(title: Text('Sign Up')),
            body: Container(
              // color: Colors.white,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.cover,
              //     colorFilter: ColorFilter.mode(
              //         Colors.black.withOpacity(0.7), BlendMode.dstATop),
              //     image: AssetImage("assets/images.jpeg"),
              //   ),
              // ),
              child: Center(
                child: Container(
                  width: _containerWidth,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: formkey,
                          child: new Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: ProfileImageInput(setProfileImage: _setProfileImage),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(Icons.person_add),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Surname',
                                ),
                                validator: (value) => value.length == 0
                                    ? 'Please enter Surname'
                                    : null,
                                onSaved: (value) => _infoData['surname'] = value,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(Icons.person),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'First Name',
                                ),
                                validator: (value) => value.length == 0
                                    ? 'Please enter first name'
                                    : null,
                                onSaved: (value) => _infoData['firstName'] = value,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(Icons.person_add),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Username',
                                ),
                                validator: (value) => value.length == 0
                                    ? 'Please enter username'
                                    : null,
                                onSaved: (value) => _infoData['userName'] = value,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(Icons.person),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Business address(optional)',
                                ),
                                // validator: (value) => value.length == 0
                                // ? 'Please enter last name'
                                // : null,
                                onSaved: (value) => _infoData['bAddress'] = value,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(Icons.alternate_email),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Email',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) =>
                                value.length == 0 ? 'Please enter email' : null,
                                onSaved: (value) => _infoData['email'] = value,
                                controller: _em,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(Icons.person_add),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Phone no: (Optional)',
                                ),
                                keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                                onSaved: (value) => _infoData['number'] = value,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                textCapitalization: TextCapitalization.words,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(Icons.person_add),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:
                                  'Occupation/skills (This will be accessible to people in need of your expertise(optional))',
                                ),
                                // validator: (value) => value.length == 0
                                //     ? 'Please enter username'
                                //     : null,
                                onSaved: (value) => _infoData['occupation'] = value,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                obscureText: secure,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(Icons.verified_user),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Password',
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        secure = !secure;
                                      });
                                    },
                                    child: secure
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                  ),
                                ),
                                controller: _ps,
                                validator: (value) =>
                                value.length == 0 || value.length < 6
                                    ? 'Password must be more than 6 characters'
                                    : null,
                                onSaved: (value) => _infoData['password'] = value,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              new TextFormField(
                                obscureText: secureConfirm,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30)),
                                    icon: Icon(Icons.verified_user),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'Confirm Password',
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          secureConfirm = !secureConfirm;
                                        });
                                      },
                                      child: secureConfirm
                                          ? Icon(Icons.visibility)
                                          : Icon(Icons.visibility_off),
                                    )),
                                validator: (value) => _ps.text != value
                                    ? 'Password do not much'
                                    : null,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SwitchListTile(
                                  activeColor: Colors.green,
                                  value: _value,
                                  title: Text(
                                    'Accept terms',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                    });
                                  }),
                              ScopedModelDescendant<MainModel>(
                                  builder: (context, child, MainModel model) {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: _buttonContent(model),
                                    );
                                  }),
                              TextButton(
                                child: Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignIn(),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
