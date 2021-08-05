import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/managersEdits/weddings_update.dart';

import 'announcement_update.dart';

class ManagersUpdates extends StatelessWidget {
  final String id;
  final String title;
  final String details;
  final String image;
  final String venue;
  final String infoHeader;
  final String info;

  const ManagersUpdates(
      {this.id, this.title, this.details, this.image, this.venue, this.infoHeader, this.info});
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
                  text: 'Update_Annoucement',
                ),
                Tab(
                  icon: Icon(Icons.cake),
                  text: 'Update_Weddings',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AnnouncementUpdate(
                details: info,
                id: id,
                title: infoHeader,
              ),
              WeddingsUpdate(
                details: details,
                id: id,
                image: image,
                title: title,
                venue: venue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
