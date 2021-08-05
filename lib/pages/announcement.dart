import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:st_peters_chaplaincy_unn/pages/info_page.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:st_peters_chaplaincy_unn/managersEdits/manager_update.dart';

class Announcement extends StatefulWidget {
  final MainModel model;

  const Announcement(this.model);

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  // MainModel model = MainModel();
  Stream<QuerySnapshot> activitiesSteam;

  @override
  void initState() {
    super.initState();
    // model.authAthunticate();
    widget.model.fetchWedding('announcements').then((value) {
      setState(() {
        activitiesSteam = value;
      });
    });
  }

  IconButton _iconButton(Map<String, dynamic> data, MainModel model) {
    // model.authAthunticate();
    return model.authentication.email == 'vicksonhezzy@gmail.com'
        ? IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManagersUpdates(
                    info: data['details'],
                    infoHeader: data['title'],
                  ),
                ),
              );
            },
          )
        : null;
  }

  _buildlistTile(int index, QuerySnapshot data, MainModel model) {
    if (data.docs[index]['details'].isEmpty) {
      return ListTile(
        title: Text(
          data.docs[index]['title'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: _iconButton(data.docs[index].data(), model),
      );
    } else {
      return ListTile(
        title: Text(
          data.docs[index]['title'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Tap for more details',
            style: TextStyle(fontWeight: FontWeight.w400)),
        trailing: _iconButton(data.docs[index].data(), model),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => InfoPage(
                title: data.docs[index]['title'],
                details: data.docs[index]['details'],
              ),
            )),
      );
    }
  }

  Widget _addItemInfo(int index, QuerySnapshot data, MainModel model) {
    return Dismissible(
      key: Key(data.docs[index].id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        model.deleteWedding(data.docs[index].id, 'announcements');
      },
      background: Container(
        color: Colors.grey,
        padding: EdgeInsets.only(left: 100, top: 30),
        child: Text(
          'Delete',
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      child: Column(
        children: [
          _buildlistTile(index, data, model),
          Divider(),
        ],
      ),
    );
  }

  _listBuilder(QuerySnapshot data, MainModel model) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext contex, index) {
        return _addItemInfo(index, data, model);
      },
      itemCount: data.docs.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, MainModel model) =>
          StreamBuilder<QuerySnapshot>(
        stream: activitiesSteam,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? _listBuilder(snapshot.data, model)
              : Container(
                  child: Center(
                    child: Text('Announcments will display here'),
                  ),
                );
        },
      ),
    );
  }
}
