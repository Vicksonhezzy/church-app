import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/info_page.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';

class MassIntentions extends StatefulWidget {
  @override
  _MassIntentionsState createState() => _MassIntentionsState();
}

class _MassIntentionsState extends State<MassIntentions> {
  MainModel model = MainModel();
  Stream<QuerySnapshot> activitiesSteam;

  @override
  void initState() {
    super.initState();
    model.authAthunticate();
    model.fetchWedding('massIntentions').then((value) {
      setState(() {
        activitiesSteam = value;
      });
    });
  }

  _buildlistTile(int index, QuerySnapshot data) {
    return ListTile(
      title: Text(
        data.docs[index]['title'],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Tap for more details',
          style: TextStyle(fontWeight: FontWeight.w400)),
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

  Widget _addItemInfo(int index, QuerySnapshot data) {
    return Dismissible(
      key: Key(data.docs[index].id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        model.deleteWedding(data.docs[index].id, 'massIntentions');
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
          _buildlistTile(index, data),
          Divider(),
        ],
      ),
    );
  }

  _listBuilder(QuerySnapshot data) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext contex, index) {
        return _addItemInfo(index, data);
      },
      itemCount: data.docs.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: activitiesSteam,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? _listBuilder(snapshot.data)
            : Container(
          child: Center(
            child: Text('Mass intentions will display here'),
          ),
        );
      },
    );
  }
}
