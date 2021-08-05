import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/view_profile_Picture.dart';

class SponsorsPage extends StatelessWidget {
  final String logo;
  final String name;
  final String services;
  final String location;
  final String number;
  SponsorsPage(
      {this.logo, this.name, this.services, this.location, this.number});

  @override
  Widget build(BuildContext context) {
    Color _color = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ListView(
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
                        if (logo != null)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewPicture(logo)))
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
                              image: logo == null
                                  ? AssetImage('assets/profileAvatar.png')
                                  : NetworkImage(
                                logo,
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
                    name,
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
                ],
              ),
            ],
          ),
          UserInfo(),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final String location;
  final String number;
  final String services;
  UserInfo({this.location, this.number, this.services});

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
                      'Other Info',
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
                          title: Text('Address'),
                          subtitle: location == null
                              ? Text('')
                              : Text(location),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(Icons.phone),
                          title: Text('Phone'),
                          subtitle: number == null
                              ? Text('')
                              : Text(number),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(Icons.person),
                          title: Text('Services'),
                          subtitle: services == null
                              ? Text('')
                              : Text(services),
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