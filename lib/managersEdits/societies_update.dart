import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SocietiesUpdate extends StatefulWidget {
  final String society;
  final String day;
  final String time;
  final String id;

  const SocietiesUpdate({this.society, this.day, this.time, this.id});
  @override
  SocietiesUpdateState createState() => SocietiesUpdateState();
}

class SocietiesUpdateState extends State<SocietiesUpdate> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final Map<String, dynamic> _infoData = {
    'societies': null,
    'days': null,
    'time': null,
  };

  _onSubmit(Function add, Function update) {
    if (_key.currentState.validate()) {
      _key.currentState.save();

      CollectionReference users =
      FirebaseFirestore.instance.collection('societies');

      if (widget.id != null) {
        update(_infoData['societies'], _infoData['days'], _infoData['time'],
            users, widget.id)
            .then((_) => Navigator.pop(context));
      } else {
        add(_infoData['societies'], _infoData['days'], _infoData['time'], users)
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
                title: Text('Update Church societies'),
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
                            hintText: 'Enter society',
                            alignLabelWithHint: true,
                          ),
                          initialValue:
                          widget.society == null ? '' : widget.society,
                          validator: (value) =>
                          value.length < 1 ? 'Please enter society' : null,
                          onSaved: (value) {
                            setState(() {
                              _infoData['societies'] = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.edit),
                            hintText: 'Enter society day',
                            alignLabelWithHint: true,
                          ),
                          initialValue: widget.day == null ? '' : widget.day,
                          validator: (value) =>
                          value.length < 1 ? 'Please enter society day' : null,
                          onSaved: (value) {
                            setState(() {
                              _infoData['days'] = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.edit),
                            hintText: 'Enter society time',
                            alignLabelWithHint: true,
                          ),
                          initialValue: widget.time == null ? '' : widget.time,
                          validator: (value) =>
                          value.length < 1 ? 'Please enter society time' : null,
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
