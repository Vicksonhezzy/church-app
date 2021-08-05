import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ActivitiesUpdate extends StatefulWidget {
  final String activity;
  final String day;
  final String time;
  final String id;

  const ActivitiesUpdate({this.activity, this.day, this.time, this.id});
  @override
  ActivitiesUpdateState createState() => ActivitiesUpdateState();
}

class ActivitiesUpdateState extends State<ActivitiesUpdate> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final Map<String, dynamic> _infoData = {
    'activities': null,
    'days': null,
    'time': null,
  };

  _onSubmit(Function add, Function update) {
    if (_key.currentState.validate()) {
      _key.currentState.save();

      CollectionReference users =
      FirebaseFirestore.instance.collection('activities');

      if (widget.id != null) {
        update(_infoData['activities'], _infoData['days'], _infoData['time'],
            users, widget.id)
            .then((_) => Navigator.pop(context));
      } else {
        add(_infoData['activities'], _infoData['days'], _infoData['time'],
            users)
            .then((_) => Navigator.pop(context));
      }
    }
  }

  Widget _buttonContent(MainModel model) {
    return model.activitiesUpdateloading == true
        ? Container(
        padding: EdgeInsets.only(top: 10),
        child: Center(child: CircularProgressIndicator()))
        : MaterialButton(
      color: Theme.of(context).accentColor,
      onPressed: () =>
      {_onSubmit(model.addActivities, model.updateActivities)},
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Update Church Activities'),
              ),
              body: SingleChildScrollView(
                child: Column(children: [
                  Form(
                    key: _key,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.edit),
                            hintText: 'Enter activity',
                            alignLabelWithHint: true,
                          ),
                          initialValue:
                          widget.activity == null ? '' : widget.activity,
                          validator: (value) =>
                          value.length < 1 ? 'Please enter activity' : null,
                          onSaved: (value) {
                            setState(() {
                              _infoData['activities'] = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.edit),
                            hintText: 'Enter activity day',
                            alignLabelWithHint: true,
                          ),
                          initialValue: widget.day == null ? '' : widget.day,
                          validator: (value) =>
                          value.length < 1 ? 'Please enter activity day' : null,
                          onSaved: (value) {
                            setState(() {
                              _infoData['days'] = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.edit),
                            hintText: 'Enter activity time',
                            alignLabelWithHint: true,
                          ),
                          initialValue: widget.time == null ? '' : widget.time,
                          validator: (value) => value.length < 1
                              ? 'Please enter activity time'
                              : null,
                          onSaved: (value) {
                            setState(() {
                              _infoData['time'] = value;
                            });
                          },
                        ),
                        _buttonContent(model),
                      ],
                    ),
                  ),
                ]),
              ));
        });
  }
}
