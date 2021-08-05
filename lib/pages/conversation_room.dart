import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/search_view_page.dart';
import 'package:st_peters_chaplaincy_unn/pages/view_profile_Picture.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:st_peters_chaplaincy_unn/ui_widgets/chat_image.dart';
import 'package:scoped_model/scoped_model.dart';

class ConversationScreen extends StatefulWidget {
  final String userId;
  final String chatRoomId;
  final String userName;
  final String email;
  final String sname;
  final String fname;
  final String number;
  final String bAddress;
  final String occupation;
  final String profileImage;

  ConversationScreen(
      {this.userId,
      this.chatRoomId,
      this.userName,
      this.bAddress,
      this.email,
      this.fname,
      this.number,
      this.occupation,
      this.profileImage,
      this.sname});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Stream<QuerySnapshot> chatStream;
  TextEditingController controller;
  MainModel model = MainModel();
  File _image;
  bool _connection = false;

  @override
  void initState() {
    controller = TextEditingController();
    model.getConversations(widget.chatRoomId).then((value) {
      setState(() {
        chatStream = value;
      });
    });
    super.initState();
  }

  void _setChatImage(File image) {
    setState(() {
      _image = image;
    });
  }

  sendMessage(MainModel model) {
    if (controller.text.isNotEmpty || _image != null) {
      model.addConversations(widget.chatRoomId, controller.text);
      setState(() {
        controller.text = '';
      });
    }
  }

  Widget chatMessageBuilder(MainModel model) {
    return StreamBuilder<QuerySnapshot>(
        stream: chatStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
          return snapShot.hasData
                  ? ListView.builder(
                      controller: ScrollController(keepScrollOffset: true),
                      addAutomaticKeepAlives: true,
                      addRepaintBoundaries: true,
                      addSemanticIndexes: true,
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: snapShot.data.docs.length,
                      itemBuilder: (context, index) {
                        int time = snapShot.data.docs[index]['time'];
                        DateTime _time =
                            DateTime.fromMillisecondsSinceEpoch(time);
                        String messageTime = '${_time.hour}:${_time.minute}';
                        if (snapShot.connectionState ==
                            ConnectionState.waiting) {
                          setState(() {
                            _connection = true;
                          });
                        }
                        return MessageTile(
                          time: messageTime,
                          isImage:
                              snapShot.data.docs[index]['chatImageUrl'] != null,
                          image: snapShot.data.docs[index]['chatImageUrl'],
                          message: snapShot.data.docs[index]['message'],
                          sentByMe: snapShot.data.docs[index]['sender'] ==
                              model.authentication.id,
                          connectionState: _connection,
                        );
                      },
                    )
                  : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height / 25;
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchViewPage(
                        id: widget.userId,
                        uname: widget.userName,
                        sname: widget.sname,
                        fname: widget.fname,
                        bAddress: widget.bAddress,
                        email: widget.email,
                        number: widget.number,
                        occupation: widget.occupation,
                        pImage: widget.profileImage),
                  ));
            },
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundImage: widget.profileImage != null
                    ? NetworkImage(widget.profileImage)
                    : AssetImage('assets/profileAvatar.png'),
              ),
            ),
          ),
          title: Text(widget.userName),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          color: Colors.black12,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width / 5.5),
                child: chatMessageBuilder(model),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        height: _height,
                        child: ChatImage(_setChatImage, widget.chatRoomId),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Theme.of(context).primaryColor,
                          ),
                          height: MediaQuery.of(context).size.height / 15,
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                          child: TextField(
                            autocorrect: true,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            autofocus: false,
                            cursorColor: Colors.white,
                            controller: controller,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 3),
                              fillColor: Colors.blue,
                              hintText: 'Message...',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                textBaseline: TextBaseline.ideographic,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: GestureDetector(
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          ),
                          onTap: () => sendMessage(model),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class MessageTile extends StatelessWidget {
  final String time;
  final bool isImage;
  final String image;
  final String message;
  final bool sentByMe;
  final bool connectionState;

  MessageTile({
    this.time,
    this.isImage,
    this.image,
    this.message,
    this.sentByMe,
    this.connectionState,
  });

  final model = MainModel();

  @override
  Widget build(BuildContext context) {
    // File fileImage = image != null ? File(image) : null;
    return Container(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sentByMe ? 100 : 0,
          right: sentByMe ? 0 : 100),
      padding:
          EdgeInsets.only(left: sentByMe ? 0 : 12, right: sentByMe ? 12 : 0),
      child: Column(
        crossAxisAlignment:
            sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: sentByMe ? Theme.of(context).primaryColor : Colors.white,
              border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 0.5,
                  style: BorderStyle.solid),
              borderRadius: sentByMe
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(23),
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                    )
                  : BorderRadius.only(
                      bottomRight: Radius.circular(23),
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                    ),
            ),
            padding: EdgeInsets.all(8),
            child: isImage == true
                ? connectionState
                    ? Text('Connect To Internet')
                    : GestureDetector(
                        onDoubleTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPicture(image),
                              ));
                        },
                        child: Image(
                          image: NetworkImage(
                            image,
                          ),
                          filterQuality: FilterQuality.high,
                          errorBuilder: (context, error, stackTrace) {
                            return Text('Connect To Internet');
                          },
                        ),
                      )
                : Text(
                    message,
                    style: TextStyle(
                        color: sentByMe
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                        fontSize: 16),
                  ),
          ),
          Container(
            alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
            padding: EdgeInsets.only(top: 2),
            child: Text(
              '$time',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color:
                      sentByMe ? Colors.black : Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
