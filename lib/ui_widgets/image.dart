import 'dart:io';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  // final WeddingsInfo weddingsInfo;

  ImageInput(this.setImage);
  @override
  ImageInputState createState() => ImageInputState();
}

class ImageInputState extends State<ImageInput> {
  final picker = ImagePicker();

  Future _pickImage(MainModel model, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, maxWidth: 400);

    setState(() {
      if (pickedFile != null) {
        final File image = File(pickedFile.path);
        model.setImage(image);
        widget.setImage(image);
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
                            onPressed: () => _pickImage(model, ImageSource.camera),
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
                            onPressed: () => _pickImage(model, ImageSource.gallery),
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

  @override
  Widget build(BuildContext context) {
    final Color _color = Theme.of(context).accentColor;
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
          return Container(
            child: TextButton(
              onPressed: () => _imagePicker(model),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: _color,
                  ),
                  Text(
                    'Add Image',
                    style: TextStyle(color: _color),
                  )
                ],
              ),
            ),
          );
        });
  }
}
