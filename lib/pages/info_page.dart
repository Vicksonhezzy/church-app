import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  final String title;
  final String details;
  final String amount;

  InfoPage({this.title, this.details, this.amount});

  Widget donationAmount() {
    return amount != null
        ? ListTile(
            title: Text('Amount'),
            subtitle: Text(amount),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              margin: EdgeInsets.all(10),
              shadowColor: Theme.of(context).accentColor,
              elevation: 6,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.info,
                          color: Theme.of(context).accentColor),
                      title: Text(
                        title + ':',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                        details,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    donationAmount(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
