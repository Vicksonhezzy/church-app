import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/edit_profile.dart';
import 'package:st_peters_chaplaincy_unn/pages/view_profile_Picture.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

image() async {
  final pref = await SharedPreferences.getInstance();
  final _image = pref.getString('pImage');
  print(_image);
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Color _color = Theme.of(context).primaryColor;
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              backgroundColor: _color,
            ),
            body: SafeArea(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 300,
                        color: _color,
                      ),
                      Positioned(
                        top: 10,
                        right: 30,
                        child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile(model)))),
                      ),
                      Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onDoubleTap: () => {
                                if (model.authentication.profileImage != null)
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewPicture(
                                                model.authentication.profileImage)))
                                  }
                                else
                                  null
                              },
                              child: CircleAvatar(
                                minRadius: 300,
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: model.authentication.profileImage ==
                                          null
                                          ? AssetImage('assets/profileAvatar.png')
                                          : NetworkImage(
                                        model.authentication.profileImage,
                                      ),
                                      scale: 6,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          Text(
                            model.authentication.userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 77,
                            ),
                            child: Card(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(
                                          bottom: 3,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${model.authentication.sname} ' +
                                                '${model.authentication.fname}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   padding: EdgeInsets.only(
                                      //     bottom: 3,
                                      //   ),
                                      //   child: Center(
                                      //       child: Row(children: [
                                      //         Icon(
                                      //           Icons.star,
                                      //           color: _color,
                                      //         ),
                                      //         Icon(
                                      //           Icons.star,
                                      //           color: _color,
                                      //         ),
                                      //         Icon(
                                      //           Icons.star,
                                      //           color: _color,
                                      //         ),
                                      //         Icon(
                                      //           Icons.star,
                                      //           color: _color,
                                      //         ),
                                      //         Icon(
                                      //           Icons.star_half,
                                      //           color: _color,
                                      //         ),
                                      //       ])),
                                      // ),
                                      // Container(
                                      //   padding: EdgeInsets.only(
                                      //     bottom: 15,
                                      //   ),
                                      //   child: Center(
                                      //     child: Text('ratings'),
                                      //   ),
                                      // ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  UserInfo(model),
                ],
              ),
            ),
          );
        });
  }
}

class UserInfo extends StatelessWidget {
  final MainModel model;
  UserInfo(this.model);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'User Information',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(Icons.my_location),
                          title: Text('Business location'),
                          subtitle: model.authentication.bAddress == null
                              ? Text('')
                              : Text(model.authentication.bAddress),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(Icons.email),
                          title: Text('Email'),
                          subtitle: model.authentication.email == null
                              ? Text('')
                              : Text(model.authentication.email),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(Icons.phone),
                          title: Text('Phone'),
                          subtitle: model.authentication.number == null
                              ? Text('')
                              : Text(model.authentication.number),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(Icons.person),
                          title: Text('Occupation/Skills'),
                          subtitle: model.authentication.occupation == null
                              ? Text('')
                              : Text(model.authentication.occupation),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
