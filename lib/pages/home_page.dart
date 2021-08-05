import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/view_profile_Picture.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:st_peters_chaplaincy_unn/ui_widgets/random_bible.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:st_peters_chaplaincy_unn/managersEdits/leaders_update.dart';

class Home extends StatefulWidget {
  final MainModel model;

  Home(this.model);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int verse = Random().nextInt(139);

  fetchChatRoom(){
    if(widget.model.authentication == null){
      return;
    }
    widget.model.getChatRoom('${widget.model.authentication.id}');
    widget.model.getChatRoom(widget.model.authentication.id);
  }


  @override
  void initState() {
    widget.model.fetchSearch('');
    fetchChatRoom();
    // widget.model.authAthunticate();
    super.initState();
    Timer.periodic(Duration(seconds: 20), (timer) {
      verse = Random().nextInt(RandomBible.bibleList.length);
    });
    widget.model.fetchLeaders();
  }

  _iconButton(MainModel model, int index) {
    if (model.authentication.email == 'vicksonhezzy@gmail.com') {
      return IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            model.currentLeadersIndex(index);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LeadersUpdate(
                          leaderId: model.leaders[index].id,
                          leaderImage: model.leaders[index].picture,
                        )));
          });
    } else {
      return Container();
    }
  }

  Widget _gridBuilder(MainModel model, double height, double width) {
    while (model.leaders == null) {
      return Container();
    }
    return GridView.builder(
        itemCount: model.leaders.length,
        shrinkWrap: true,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewPicture(
                      model.leaders[index].picture,
                    ),
                  ));
            },
            child: Card(
              shadowColor: Theme.of(context).primaryColor,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              height: height,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    model.leaders[index].picture,
                                  ),
                                  onError: (exception, stackTrace) {
                                    return Container(
                                      child: Center(
                                        child: Text('Connect To Internet'),
                                      ),
                                    );
                                  },
                                  fit: BoxFit.cover,
                                  scale: 6,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: ListTile(
                                title: Text(model.leaders[index].post),
                                subtitle: Text(
                                  model.leaders[index].name,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            model.authentication == null
                                ? Container()
                                : _iconButton(model, index),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // widget.model.getChatRoom();

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceheight = MediaQuery.of(context).size.height;
    final double _containerWidth =
        deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    final double _containerheight =
        deviceheight > 768.0 ? 500.0 : deviceheight * 0.95;
    double no = 4.2;
    final width = _containerWidth / no;
    final height = _containerheight / no;
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 250,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("St Peter's Chaplaincy UNN"),
              background: Image.asset(
                'assets/st_peters_image.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Card(
                  margin: EdgeInsets.all(10),
                  shadowColor: Colors.blueGrey,
                  elevation: 5,
                  child: Container(
                    child: ListTile(
                      title: Text(
                        RandomBible.bibleList[verse],
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        RandomBible.verseList[verse],
                        style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                model.leaders.isEmpty
                    ? Container()
                    : _gridBuilder(model, height, width),
              ],
            ),
          )
        ],
      );
    });
  }
}
