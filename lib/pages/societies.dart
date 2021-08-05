import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/managersEdits/societies_update.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';

class Societies extends StatefulWidget {
  Societies({Key key}) : super(key: key);

  @override
  _SocietiesState createState() => _SocietiesState();
}

class _SocietiesState extends State<Societies> {
  MainModel model = MainModel();
  Stream<QuerySnapshot> societiesStream;

  @override
  void initState() {
    super.initState();
    model.authAthunticate();
    model.fetchActivities('societies').then((value) {
      setState(() {
        societiesStream = value;
      });
    });
  }

  editdata(QueryDocumentSnapshot e) {
    model.authAthunticate();
    return model.authentication.email == 'vicksonhezzy@gmail.com'
        ? Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SocietiesUpdate(
            society: e['activities'],
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
            label: Text('Society'),
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
        title: Text('Societies'),
      ),
      body: Container(
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: societiesStream,
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
