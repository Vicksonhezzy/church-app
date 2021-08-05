import 'dart:io';

import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:st_peters_chaplaincy_unn/ui_widgets/image.dart';
import 'package:scoped_model/scoped_model.dart';

class LeadersUpdate extends StatefulWidget {
  final String leaderId;
  final String leaderImage;

  const LeadersUpdate({Key key, this.leaderId, this.leaderImage})
      : super(key: key);

  @override
  LeadersUpdateState createState() => LeadersUpdateState();
}

class LeadersUpdateState extends State<LeadersUpdate> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final Map<String, dynamic> _infoData = {
    'post': null,
    'name': null,
    'image': null,
  };

  _onSubmit(Function add, Function update, MainModel model) {
    if (_key.currentState.validate()) {
      _key.currentState.save();

      if (widget.leaderId == null) {
        add(_infoData['post'], _infoData['name'], _infoData['image'])
            .then((_) => Navigator.pop(context));
      } else {
        update(_infoData['post'], _infoData['name'], _infoData['image'],
            widget.leaderId)
            .then((_) => Navigator.pop(context));
      }
    }
  }

  void _setProfileImage(File image) {
    setState(() {
      _infoData['image'] = image;
    });
  }

  Widget _imageContainer(MainModel model) {
    while (model.image == null && widget.leaderId == null) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Container(
          child: Center(
            child: Text('Image will display here'),
          ),
        ),
      );
    }
    if (widget.leaderId == null) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Container(
          child: Center(
            child: Text('Image will display here'),
          ),
        ),
      );
    }
    // model.fetchLeaders();
    if (model.image != null && widget.leaderId != null) {
      return Card(
        child: Image.file(
          model.image,
          fit: BoxFit.cover,
          height: 400,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
        ),
      );
    } else if (model.image == null && widget.leaderImage != null) {
      return Card(
        child: Image.network(
          widget.leaderImage,
          fit: BoxFit.cover,
          height: 400,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
        ),
      );
    } else if (model.image != null && widget.leaderId == null) {
      return Card(
        child: Image.file(
          model.image,
          fit: BoxFit.cover,
          height: 400,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
        ),
      );
    } else {
      return Card(
        child: Image.network(
          model.selectedLeader.picture,
          fit: BoxFit.cover,
          height: 400,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
        ),
      );
    }
  }

  Widget _buttonContent(MainModel model) {
    return model.leadersLoading == true
        ? Container(
        padding: EdgeInsets.only(top: 10),
        child: Center(child: CircularProgressIndicator()))
        : MaterialButton(
      color: Theme.of(context).accentColor,
      onPressed: () =>
      {_onSubmit(model.addLeaders, model.updateLeaders, model)},
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
                title: Text('Update Church Leaders'),
              ),
              body: SingleChildScrollView(
                child: Column(children: [
                  Form(
                    key: _key,
                    child: Column(
                      children: [
                        _imageContainer(model),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.edit),
                            hintText: 'Enter Leader Post',
                            alignLabelWithHint: true,
                          ),
                          initialValue: widget.leaderId == null
                              ? ''
                              : model.selectedLeader.post,
                          validator: (value) =>
                          value.length < 1 ? 'Please enter post' : null,
                          onSaved: (value) {
                            setState(() {
                              _infoData['post'] = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.edit),
                            hintText: 'Enter Leader Name',
                            alignLabelWithHint: true,
                          ),
                          initialValue: widget.leaderId == null
                              ? ''
                              : model.selectedLeader.name,
                          validator: (value) =>
                          value.length < 1 ? 'Please enter name' : null,
                          onSaved: (value) {
                            setState(() {
                              _infoData['name'] = value;
                            });
                          },
                        ),
                        ImageInput(_setProfileImage),
                        _buttonContent(model),
                      ],
                    ),
                  ),
                ]),
              ));
        });
  }
}
