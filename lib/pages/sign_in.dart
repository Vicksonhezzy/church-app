import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:st_peters_chaplaincy_unn/pages/sign_up.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignIn extends StatefulWidget {
  @override
  SignInState createState() => new SignInState();
}

class SignInState extends State<SignIn> {
  bool _value = false;
  bool secure = true;
  MainModel model = MainModel();

  final formkey = new GlobalKey<FormState>();

  final TextEditingController _em = TextEditingController();

  final Map<String, dynamic> _infoData = {
    'email': null,
    'password': null,
  };

  _submit(Function login, MainModel model) async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      setState(() {
        model.setLoading(true);
      });
      final Map<String, dynamic> loginSuccess = await login(
        _infoData['email'],
        _infoData['password'],
      );
      if (loginSuccess['success'] == true) {
        User user = FirebaseAuth.instance.currentUser;
        if (!user.emailVerified) {
          if (user.email == 'vicksonhezzy@gmail.com') {
            model.setManager(true);
          }
          model.logOut();
          await user.sendEmailVerification();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Email not verified',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(
                      'Is this your email address? A verification link has been sent to this email address, please verify your account before sign-in'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        model.logOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                            (route) => false);
                      },
                      child: Text('Okay'),
                    )
                  ],
                );
              });
        } else {
          if (model.authentication == null) {
            if (user.email == 'vicksonhezzy@gmail.com') {
              model.setManager(true);
            }
            SafeArea(
                child: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ));
          }
          Navigator.pushReplacementNamed(context, 'dashBoard');
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
            onPressed: () => _submit(model.login, model),
            child: Text('SignIn'),
          );
  }

  double size = 400.0;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double _containerWidth =
        deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    // if (model.authentication != null) {
    //   model.logOut();
    // }
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: _containerWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Center(
                      child: Container(
                        child: Image.asset("assets/st_peters_logo.jpg"),
                        height: size,
                        width: size / 2,
                      ),
                    ),
                    Container(
                      child: Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          child: Icon(Icons.supervised_user_circle),
                        ),
                        label: Text(
                          'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: Colors.blueGrey,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: formkey,
                      child: new Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          new TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              icon: Icon(Icons.person_add),
                              hintText: 'Username/Email',
                            ),
                            validator: (value) => value.length == 0
                                ? 'Please enter username/email'
                                : null,
                            onSaved: (value) => _infoData['email'] = value,
                            controller: _em,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          new TextFormField(
                            obscureText: secure,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                icon: Icon(Icons.verified_user),
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
                                )),
                            validator: (value) =>
                                value.length == 0 || value.length < 6
                                    ? 'Password must be more than 6 characters'
                                    : null,
                            onSaved: (value) => _infoData['password'] = value,
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
                              "Don't Have An Account Yet?",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
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
      ),
    );
  }
}
