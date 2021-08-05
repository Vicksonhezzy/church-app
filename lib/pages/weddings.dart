import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:st_peters_chaplaincy_unn/managersEdits/manager_update.dart';
import 'package:st_peters_chaplaincy_unn/pages/wedding_page.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';

class Weddings extends StatefulWidget {
  final MainModel model;

  Weddings({this.model});

  @override
  _WeddingsState createState() => _WeddingsState();
}

class _WeddingsState extends State<Weddings> {
  // MainModel model = MainModel();
  Stream<QuerySnapshot> activitiesSteam;

  @override
  void initState() {
    super.initState();
    // model.authAthunticate();
    widget.model.fetchWedding('weddings').then((value) {
      setState(() {
        activitiesSteam = value;
      });
    });
  }

  _buildlistTile(int index, QuerySnapshot data, MainModel model) {
    // model.authAthunticate();
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(data.docs[index]['imageUrl']),
      ),
      title: Text(
        data.docs[index]['title'],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Tap for more details',
          style: TextStyle(fontWeight: FontWeight.w400)),
      trailing: model.authentication.email == 'vicksonhezzy@gmail.com'
          ? IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManagersUpdates(
                      details: data.docs[index]['details'],
                      id: data.docs[index].id,
                      image: data.docs[index]['imageUrl'],
                      title: data.docs[index]['title'],
                      venue: data.docs[index]['venue'],
                    ),
                  ),
                );
              },
            )
          : null,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeddingPage(
              details: data.docs[index]['details'],
              image: data.docs[index]['imageUrl'],
              title: data.docs[index]['title'],
              venue: data.docs[index]['venue'],
            ),
          )),
    );
  }

  Widget _addItemInfo(int index, QuerySnapshot data, MainModel model) {
    return Dismissible(
      key: Key(data.docs[index].id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        model.deleteWedding(data.docs[index].id, 'weddings');
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
                    child: Text('Weddings will display here'),
                  ),
                );
        },
      ),
    );
  }
}
