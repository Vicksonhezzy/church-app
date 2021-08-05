import 'package:flutter/material.dart';

class ViewPicture extends StatelessWidget {
  final String profileImage;
  ViewPicture(this.profileImage);
  @override
  Widget build(BuildContext context) {
    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double _containerWidth =
    //     deviceHeight > 768.0 ? 500.0 : deviceWidth * 0.95;
    return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: NetworkImage(profileImage),
            ),
          ),
          child: Center(
              child: Container(
                // height: _containerWidth,
                // width: deviceWidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(profileImage),
                      fit: BoxFit.contain,
                    ),
                  ))),
        ));
  }
}
