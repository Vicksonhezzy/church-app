import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/weddings.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import './announcement.dart';

class Media extends StatefulWidget {
  // final MainModel model;
  //
  // Media(this.model);

  MediaState createState() => MediaState();
}

class MediaState extends State<Media> {
  MainModel models = MainModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.announcement),
                  text: 'Annoucement',
                ),
                Tab(
                  icon: Icon(Icons.cake),
                  text: 'Weddings',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Announcement(models),
              Weddings(model: models),
            ],
          ),
        ),
      ),
    );
  }
}
