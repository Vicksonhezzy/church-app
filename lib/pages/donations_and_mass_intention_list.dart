import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/donations_list.dart';
import 'package:st_peters_chaplaincy_unn/pages/mass_intentions.dart';

class DonationsAndMasIntentionsList extends StatefulWidget {

  DonationsAndMasIntentionsListState createState() => DonationsAndMasIntentionsListState();
}

class DonationsAndMasIntentionsListState extends State<DonationsAndMasIntentionsList> {


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
                  icon: Icon(Icons.payment),
                  text: 'Donation',
                ),
                Tab(
                  icon: Icon(Icons.book),
                  text: 'BookMass',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              DonationsList(),
              MassIntentions(),
            ],
          ),
        ),
      ),
    );
  }
}
