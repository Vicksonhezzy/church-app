import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/managersEdits/manager_update.dart';
import 'package:st_peters_chaplaincy_unn/managersEdits/societies_update.dart';
import 'package:st_peters_chaplaincy_unn/managersEdits/update_activities.dart';
import 'package:st_peters_chaplaincy_unn/pages/activities.dart';
import 'package:st_peters_chaplaincy_unn/pages/chat_list.dart';
import 'package:st_peters_chaplaincy_unn/pages/donations_and_mass_intention_list.dart';
import 'package:st_peters_chaplaincy_unn/pages/giving.dart';
import 'package:st_peters_chaplaincy_unn/pages/home_page.dart';
import 'package:st_peters_chaplaincy_unn/pages/media.dart';
import 'package:st_peters_chaplaincy_unn/pages/profile.dart';
import 'package:st_peters_chaplaincy_unn/pages/search_skills.dart';
import 'package:st_peters_chaplaincy_unn/pages/societies.dart';
import 'package:st_peters_chaplaincy_unn/pages/sponsors_page.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:st_peters_chaplaincy_unn/managersEdits/leaders_update.dart';

Icon ic = new Icon(Icons.home);

String barTitle = 'Home';
PageController pageController;

class DashboardScreen extends StatefulWidget {
  final bool brightness;
  final Function changetheme;
  final int loadPage;
  final MainModel model;

  DashboardScreen(
      {@required this.model, this.changetheme, this.brightness, this.loadPage});

  @override
  _DashboardScreenstate createState() => new _DashboardScreenstate();
}

class _DashboardScreenstate extends State<DashboardScreen> {
  int _page;
  bool change = true;

  // MainModel model = MainModel();
  Stream<QuerySnapshot> sponsorsStream;


  @override
  void initState() {
    super.initState();
    // widget.model.fetchSearch('');
    _page = widget.loadPage == null ? 0 : widget.loadPage;
    widget.model.fetchLeaders();
    // model.authAthunticate();
    // model.fetchSearch();
    widget.model.fetchSponsors().then((value) {
      setState(() {
        sponsorsStream = value;
      });
    });
    pageController = new PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 1), curve: Curves.ease);
  }

  onPageChange(int page) {
    setState(() {
      if (page == 4) {
        ic = new Icon(Icons.announcement);
        barTitle = 'Media';
      } else if (page == 3) {
        ic = new Icon(Icons.chat);
        barTitle = 'Chats';
      } else if (page == 2) {
        ic = new Icon(Icons.search);
        barTitle = "Search";
      } else if (page == 1) {
        ic = new Icon(Icons.payment);
        barTitle = "Giving";
      } else if (page == 0) {
        ic = new Icon(Icons.home);
        barTitle = "Home";
      }

      return this._page = page;
    });
  }

  GestureDetector _circleAvatar(image) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5, left: 5),
        child: CircleAvatar(
          backgroundImage: image,
        ),
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(),
          )),
    );
  }

  Widget _profileAvatar(model) {
    // model.authAthunticate();
    if (model.authentication != null) {
      return _circleAvatar(
          NetworkImage(model.authentication.profileImage));
    } else {
      return _circleAvatar(AssetImage('assets/profileAvatar.png'));
    }
  }

  Text _displayUserName(MainModel model) {
    while (model.authentication == null) {
      return Text('');
    }
    return Text(model.authentication.userName);
  }

  Widget _managerWidget(MainModel model) {
    // model.authAthunticate();
    while (model.authentication == null) {
      return Container();
    }
    while (model.authentication.email == 'vicksonhezzy@gmail.com') {
      model.setManager(true);
      return Column(
        children: [
          ListTile(
            title: Text('Update announcement'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManagersUpdates(),
                ),
              ),
            },
          ),
          ListTile(
            title: Text('Update activities'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivitiesUpdate(),
                ),
              ),
            },
          ),
          ListTile(
            title: Text('Update societies'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SocietiesUpdate(),
                ),
              ),
            },
          ),
          ListTile(
              title: Text('UpdateLeaders'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeadersUpdate(),
                    ));
              }),
          ListTile(
            title: Text('Giving List'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DonationsAndMasIntentionsList(),
                ),
              ),
            },
          ),
        ],
      );
    }

    return Container();
  }

  Widget _sponsorsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: sponsorsStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? GridView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SponsorsPage(
                              location: snapshot.data.docs[index]['location'],
                              logo: snapshot.data.docs[index]['logo'],
                              name: snapshot.data.docs[index]['name'],
                              number: snapshot.data.docs[index]['number'],
                              services: snapshot.data.docs[index]['services'],
                            ),
                          ));
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data.docs[index]['logo']),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: Text(snapshot.data.docs[index]['name']),
                          ),
                        ],
                      ),
                    ),
                  );
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color clr = Theme.of(context).primaryColor;
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
      return
          Scaffold(
        drawer: Drawer(
            child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              leading: _profileAvatar(model),
              backgroundColor: clr,
              title: model.authentication == null? Text(''): Text('${model.authentication.userName}'),
              // _displayUserName(model),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(),
                ),
              ),
            ),
            ListTile(
              title: Text('Activities'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Activities(),
                ),
              ),
            ),
            ListTile(
              title: Text('Societies'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Societies(),
                ),
              ),
            ),
            _managerWidget(model),
            // ListTile(
            //   title: Text('Settings'),
            //   onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => Settings(),
            //     ),
            //   ),
            // ),
            ListTile(
              title: Text('Change Theme'),
              onTap: () {
                widget.changetheme();
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'SPONSORS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _sponsorsList(),
              ],
            ),
          ],
        )),
        appBar: new AppBar(
          backgroundColor: clr,
          // actions: [ic],
          title: new Text(
            barTitle,
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: PageView(
          children: [
            new Home(model),
            new Giving(),
            new SearchSkills(),
            new ChatList(model),
            new Media(),
          ],
          onPageChanged: onPageChange,
          controller: pageController,
        ),
        bottomNavigationBar: new BottomNavigationBar(
          showSelectedLabels: true,
          selectedItemColor: clr,
          type: BottomNavigationBarType.shifting,
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(
                Icons.home,
                color: clr,
              ),
              label: "Home",
            ),
            new BottomNavigationBarItem(
              icon: new Icon(
                Icons.payment,
                color: clr,
              ),
              label: "Giving",
            ),
            new BottomNavigationBarItem(
              icon: new Icon(
                Icons.search,
                color: clr,
              ),
              label: "Search",
            ),
            new BottomNavigationBarItem(
              icon: new Icon(
                Icons.chat_bubble_outline_rounded,
                color: clr,
              ),
              label: "Chats",
            ),
            new BottomNavigationBarItem(
              icon: new Icon(
                Icons.announcement,
                color: clr,
              ),
              label: "Media",
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
        // ),
      );
    });
  }
}
