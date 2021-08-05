import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileImageInput extends StatefulWidget {
  final Function setProfileImage;
  final String image;
  // final WeddingsInfo weddingsInfo;

  ProfileImageInput({this.setProfileImage, this.image});
  @override
  ProfileImageInputState createState() => ProfileImageInputState();
}

class ProfileImageInputState extends State<ProfileImageInput> {
  final picker = ImagePicker();

  Future _pickImage(MainModel model, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, maxWidth: 400);

    setState(() {
      if (pickedFile != null) {
        final File image = File(pickedFile.path);
        model.setProfileImage(image);
        widget.setProfileImage(image);
        Navigator.pop(context);
      } else {
        print('No image found');
      }
    });
  }

  _imagePicker(MainModel model) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          final Color _color = Theme.of(context).accentColor;
          return Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Choose',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () =>
                                _pickImage(model, ImageSource.camera),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.camera,
                                  color: _color,
                                ),
                                Text('Camera')
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                _pickImage(model, ImageSource.gallery),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.image,
                                  color: _color,
                                ),
                                Text('Gallery')
                              ],
                            ),
                          )
                        ])
                  ],
                ),
              ));
        });
  }

  _changeProfilePicture(MainModel model) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Warning',
            style: TextStyle(color: Colors.green),
          ),
          content: Text('Change profile picture?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _imagePicker(model);
                },
                child: Text('Continue')),
          ],
        );
      },
    );
  }

  _imageViewer(MainModel model) {
    if (model.profileImage == null) {
      if (widget.image != null) {
        return DecorationImage(
            image: NetworkImage(widget.image), fit: BoxFit.cover);
      } else {
        return DecorationImage(
            image: AssetImage('assets/profileAvatar.png'), fit: BoxFit.cover);
      }
    } else {
      return DecorationImage(
          image: FileImage(model.profileImage), fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Color _color = Theme.of(context).accentColor;
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
          return Row(children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: _imageViewer(model),
              ),
              height: 150,
              width: 150,
            ),
            SizedBox(width: 5),
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () {
                if (model.profileImage == null) {
                  _imagePicker(model);
                } else
                  _changeProfilePicture(model);
              },
            )
          ]);
        });
  }
}
