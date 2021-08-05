import 'package:flutter/material.dart';

class WeddingPage extends StatelessWidget {
  final String title;
  final String details;
  final String image;
  final String venue;

  const WeddingPage({this.title, this.details, this.image, this.venue});

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
                    Container(
                      child: Image.network(
                        image,
                        fit: BoxFit.fitHeight,
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.info,
                          color: Theme.of(context).accentColor),
                      title: Text(
                        'Wedding details:',
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: details == null
                          ? Text('no details')
                          : Text(
                        details,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'Venue:',
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: venue == null
                          ? Text('no details on venue')
                          : Text(
                        venue,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
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
