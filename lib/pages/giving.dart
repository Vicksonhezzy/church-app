import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/book_mass.dart';
import 'package:st_peters_chaplaincy_unn/pages/donations.dart';

class Giving extends StatefulWidget {

  GivingState createState() => GivingState();
}

class GivingState extends State<Giving> {


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
              Donation(),
              BookMass(),
            ],
          ),
        ),
      ),
    );
  }
}
