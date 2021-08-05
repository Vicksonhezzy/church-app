import 'dart:io';

import 'package:st_peters_chaplaincy_unn/ui_widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class EditProfile extends StatefulWidget {
  final MainModel model;
  EditProfile(this.model);
  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final Map<String, dynamic> _infoData = {
    'uname': null,
    'bAddress': null,
    'image': null,
    'number': null,
    'occupation': null
  };

  _onSubmit(Function update, [MainModel model]) {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      update(
        _infoData['uname'],
        _infoData['bAddress'],
        _infoData['profileImage'],
        _infoData['number'],
        _infoData['occupation'],
      ).then((_) => Navigator.pop(context));
    }
  }

  void _editProfileImage(File image) {
    _infoData['profileImage'] = image;
  }

  Widget _buttonContent(MainModel model) {
    return model.isUpdating == true
        ? Container(
        padding: EdgeInsets.only(top: 10),
        child: Center(child: CircularProgressIndicator()))
        : MaterialButton(
      color: Theme.of(context).accentColor,
      onPressed: () => {_onSubmit(model.updateProfile, model)},
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double _containerWidth =
    deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
          final image = model.authentication.profileImage;
          return Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
            ),
            body: Container(
              child: Form(
                key: _key,
                child: Container(
                  width: _containerWidth,
                  margin: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Container(
                        alignment: Alignment.center,
                        child: ProfileImageInput(
                          setProfileImage: _editProfileImage,
                          image: image,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.edit),
                          hintText: 'Edit Username',
                          alignLabelWithHint: true,
                        ),
                        initialValue: model.authentication.userName == null
                            ? ''
                            : model.authentication.userName,
                        onSaved: (value) {
                          _infoData['uname'] = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.edit),
                          hintText: 'Edit business address',
                          alignLabelWithHint: true,
                        ),
                        initialValue: model.authentication.bAddress == null
                            ? ''
                            : model.authentication.bAddress,
                        onSaved: (value) {
                          _infoData['bAddress'] = value;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.edit),
                          hintText: 'Edit phone no.',
                          alignLabelWithHint: true,
                        ),
                        initialValue: model.authentication.number == null
                            ? ''
                            : model.authentication.number,
                        onSaved: (value) {
                          _infoData['number'] = value;
                        },
                      ),
                      TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          icon: Icon(Icons.edit),
                          hintText: 'Edit occupation/skills',
                          alignLabelWithHint: true,
                        ),
                        initialValue: model.authentication.occupation == null
                            ? ''
                            : model.authentication.occupation,
                        onSaved: (value) {
                          _infoData['occupation'] = value;
                        },
                      ),
                      _buttonContent(model),
                    ]),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
