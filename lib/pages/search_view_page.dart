import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/conversation_room.dart';
import 'package:st_peters_chaplaincy_unn/pages/view_profile_Picture.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SearchViewPage extends StatefulWidget {
  final String id;
  final String uname;
  final String sname;
  final String fname;
  final String bAddress;
  final String email;
  final String number;
  final String occupation;
  final String pImage;

  SearchViewPage({
    @required this.id,
    @required this.uname,
    @required this.sname,
    @required this.fname,
    @required this.bAddress,
    @required this.email,
    @required this.number,
    @required this.occupation,
    @required this.pImage,
  });

  @override
  SearchViewPageState createState() => SearchViewPageState();
}

class SearchViewPageState extends State<SearchViewPage> {

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
                      Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onDoubleTap: () => {
                                if (widget.pImage != null)
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewPicture(widget.pImage)))
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
                                      image: widget.pImage == null
                                          ? AssetImage('assets/profileAvatar.png')
                                          : NetworkImage(widget.pImage),
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
                            widget.uname,
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
                                        padding: EdgeInsets.only(
                                          bottom: 3,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${widget.sname} ' + '${widget.fname}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // padding: EdgeInsets.only(
                                        //   bottom: 3,
                                        // ),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Column(children: [
                                                IconButton(
                                                  icon: Icon(Icons.chat),
                                                  onPressed: () {
                                                    if (model.authentication.id !=
                                                        widget.id) {
                                                      List<String> _users = [
                                                        widget.id,
                                                        model.authentication.id
                                                      ];
                                                      Map<String, dynamic>
                                                      chatData = {
                                                        'users': _users,
                                                        'chatRoomId':
                                                        model.chatRoomId,
                                                      };
                                                      model.createChat(
                                                          model.chatRoomId,
                                                          chatData);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ConversationScreen(
                                                                userId: widget.id,
                                                                chatRoomId:
                                                                model.chatRoomId,
                                                                email: widget.email,
                                                                userName: widget.uname,
                                                                bAddress:
                                                                widget.bAddress,
                                                                fname: widget.fname,
                                                                number: widget.number,
                                                                occupation:
                                                                widget.occupation,
                                                                profileImage: widget.pImage,
                                                                sname: widget.sname,
                                                              ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  iconSize: 20,
                                                ),
                                                Text('chat'),
                                              ]),
                                            ],
                                          ),
                                        ),
                                      ),
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
                  UserInfo(
                      model: model,
                      bAddress: widget.bAddress,
                      email: widget.email,
                      number: widget.number,
                      occupation: widget.occupation),
                ],
              ),
            ),
          );
        });
  }
}

class UserInfo extends StatelessWidget {
  final String bAddress;
  final String email;
  final String number;
  final String occupation;
  final MainModel model;
  UserInfo({
    @required this.model,
    @required this.bAddress,
    @required this.email,
    @required this.number,
    @required this.occupation,
  });
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
                          subtitle:
                          bAddress == null ? Text('') : Text(bAddress),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(Icons.email),
                          title: Text('Email'),
                          subtitle: email == null ? Text('') : Text(email),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(Icons.phone),
                          title: Text('Phone'),
                          subtitle: number == null ? Text('') : Text(number),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(Icons.person),
                          title: Text('Occupation/Skills'),
                          subtitle:
                          occupation == null ? Text('') : Text(occupation),
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
