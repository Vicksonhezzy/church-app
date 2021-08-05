import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/conversation_room.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatList extends StatefulWidget {
  final MainModel model;
  ChatList(this.model);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  // MainModel model = MainModel();

  Stream<QuerySnapshot> chatStream;

  @override
  void initState() {
    super.initState();
    widget.model.getChatRoom(widget.model.authentication.id);
  }

  Widget listBuilder(int index, MainModel model) {
    // model.getChatRoom(widget.model.authentication.id);
    var _border = new Container(
      width: double.infinity,
      height: 1.0,
      color: Theme.of(context).primaryColor,
    );
    return Column(children: [
      ListTile(
        leading: CircleAvatar(
          backgroundImage: model.chatUsers[index].profileImage != null
              ? NetworkImage(model.chatUsers[index].profileImage)
              : AssetImage('assets/profileAvatar.png'),
        ),
        title: Text(
          model.chatUsers[index].fname,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(model.chatUsers[index].userName,
            style: TextStyle(fontWeight: FontWeight.w400)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConversationScreen(
                  userId: model.chatUsers[index].userId,
                  bAddress: model.chatUsers[index].bAddress,
                  chatRoomId: model.chatUsers[index].chatRoomId,
                  email: model.chatUsers[index].email,
                  fname: model.chatUsers[index].fname,
                  number: model.chatUsers[index].number,
                  occupation: model.chatUsers[index].occupation,
                  profileImage: model.chatUsers[index].profileImage,
                  sname: model.chatUsers[index].sname,
                  userName: model.chatUsers[index].userName,
                ),
              ));
        },
      ),
      _border,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // widget.model.getChatRoom(widget.model.authentication.id);
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, MainModel model) {
          return Container(
            child: SingleChildScrollView(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: model.chatUsers.length,
                itemBuilder: (context, index) {
                  return model.chatUsers.isNotEmpty
                      ? listBuilder(index, model)
                      : Container();
                },
              ),
            ),
          );
        });
  }
}
