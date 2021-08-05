import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class AnnouncementUpdate extends StatefulWidget {
  final String id;
  final String title;
  final String details;
  final String image;
  final String venue;

  const AnnouncementUpdate(
      {this.id, this.title, this.details, this.image, this.venue});

  @override
  AnnouncementUpdateState createState() => AnnouncementUpdateState();
}

class AnnouncementUpdateState extends State<AnnouncementUpdate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _infoData = {'info': null, 'details': null};

  _onSubmit(Function add, Function update, [MainModel model]) {
    if (_formKey.currentState.validate()) {
      setState(() {
        model.setWedding(true);
      });
      _formKey.currentState.save();
      if (widget.id == null) {
        add(
          _infoData['info'],
          _infoData['details'],
          null,
          null,
          'announcements',
        ).then((_) {
          model.setWedding(false);
          Navigator.pop(context);
        });
      } else {
        update(
          _infoData['info'],
          _infoData['details'],
          null,
          null,
          widget.id,
          'announcements',
        ).then((_) {
          model.setWedding(false);
          Navigator.pop(context);
        });
      }
    }
  }

  Widget _buttonContent(MainModel model) {
    return model.isLoadingWedding == true
        ? Container(
        padding: EdgeInsets.only(top: 10),
        child: Center(child: CircularProgressIndicator()))
        : MaterialButton(
      color: Theme.of(context).accentColor,
      onPressed: () =>
      {_onSubmit(model.addWedding, model.updateWedding, model)},
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double _containerWidth =
    deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
          model.setLoading(false);
          return Container(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: _containerWidth,
                    margin: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.edit),
                              hintText: 'Enter announcement header',
                              alignLabelWithHint: true,
                            ),
                            initialValue: widget.title == null
                                ? ''
                                : widget.title,
                            validator: (value) =>
                            value.length < 1 ? 'Please enter header' : null,
                            onSaved: (value) {
                              _infoData['info'] = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.edit),
                              hintText:
                              'Enter Details of the announcement if any (Optional)',
                              alignLabelWithHint: true,
                            ),
                            initialValue: widget.details == null
                                ? ''
                                : widget.details,
                            maxLines: 6,
                            onSaved: (value) {
                              _infoData['details'] = value;
                            },
                          ),
                          _buttonContent(model),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
