import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/managersEdits/update_activities.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';

class Activities extends StatefulWidget {
  Activities({Key key}) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  MainModel model = MainModel();
  Stream<QuerySnapshot> activitiesSteam;

  @override
  void initState() {
    super.initState();
    model.authAthunticate();
    model.fetchActivities('activities').then((value) {
      setState(() {
        activitiesSteam = value;
      });
    });
  }

  editdata(QueryDocumentSnapshot e) {
    model.authAthunticate();
    return model.authentication.email == 'vicksonhezzy@gmail.com'
        ? Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActivitiesUpdate(
            activity: e['activities'],
            day: e['days'],
            time: e['time'],
            id: e.id,
          ),
        ))
        : null;
  }

  SingleChildScrollView dataTable(QuerySnapshot data) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('Activities'),
          ),
          DataColumn(
            label: Text('Days'),
          ),
          DataColumn(
            label: Text('Time'),
          ),
        ],
        rows: data.docs
            .map(
              (e) => DataRow(cells: [
            DataCell(
              Text(e['activities']),
              onTap: () => editdata(e),
            ),
            DataCell(
              Text(e['days']),
              onTap: () => editdata(e),
            ),
            DataCell(
              Text(e['time']),
              onTap: () => editdata(e),
            ),
          ]),
        )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: Container(
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: activitiesSteam,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return snapshot.hasData
                    ? dataTable(snapshot.data)
                    : Container(
                  child: Center(
                    child: Text('Activities will display here'),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
