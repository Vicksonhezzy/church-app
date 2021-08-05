import 'package:flutter/material.dart';
import 'package:st_peters_chaplaincy_unn/pages/search_view_page.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SearchSkills extends StatefulWidget {
  // final MainModel models;
  //
  // SearchSkills(
  //   this.models,
  // );

  @override
  _SearchSkillsState createState() => _SearchSkillsState();
}

class _SearchSkillsState extends State<SearchSkills> {
  TextEditingController controller = TextEditingController();

  Stream<QuerySnapshot> stream;

  search(String search, MainModel model) {
    setState(() {
      model.fetchSearch(search);
    });
  }

  onTapFunction(MainModel model, int index) {
    model.getChatRoomId(model.searchList[index].id, model.authentication.id);
    // model.currentSearchIndex(index);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => navigate(model, index)),
    );
  }

  Widget navigate(MainModel model, int index) {
    return SearchViewPage(
      id: model.searchList[index].id,
      uname: model.searchList[index].userName,
      sname: model.searchList[index].sname,
      fname: model.searchList[index].fname,
      bAddress: model.searchList[index].bAddress,
      email: model.searchList[index].email,
      number: model.searchList[index].number,
      occupation: model.searchList[index].occupation,
      pImage: model.searchList[index].profileImage,
    );
  }

  Widget _container(text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 100),
      child: Center(child: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, MainModel model) {
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 10,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.only(left: 8),
                      child: TextFormField(
                        controller: controller,
                        onFieldSubmitted: (value) => search(controller.text, model),
                        // style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          if (value.length < 4) {
                            search(controller.text, model);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Search for skills here...',
                          suffixIcon: controller.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      controller.clear();
                                      search('', model);
                                    });
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.red,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    search(controller.text, model);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.blue,
                                      )),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 55),
                ScopedModelDescendant<MainModel>(
                    builder: (context, child, MainModel model) {
                  return controller.text.isNotEmpty &&
                          (model.searchLoading == true ||
                              controller.text.length < 3)
                      ? _container('Loading...')
                      : model.searchList.isEmpty
                          ? _container('No skills found')
                          : controller.text.isEmpty &&
                                  model.searchList.isNotEmpty &&
                                  model.searchLoading != true
                              ? GridView.builder(
                                  itemCount: model.searchList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () => onTapFunction(model, index),
                                      child: Container(
                                          margin: EdgeInsets.all(8),
                                          child: Material(
                                            elevation: 10,
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              padding:
                                                  EdgeInsets.symmetric(vertical: 5),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Image(
                                                      fit: BoxFit.fitWidth,
                                                      image: model.searchList[index]
                                                              .profileImage.isEmpty
                                                          ? AssetImage(
                                                              'assets/profileAvatar.png')
                                                          : NetworkImage(
                                                              model
                                                                  .searchList[index]
                                                                  .profileImage,
                                                            ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      model.searchList[index]
                                                          .occupation,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    );
                                  },
                                )
                              : model.searchLoading == false &&
                                      model.searchList.isEmpty &&
                                      controller.text.length >= 3
                                  ? _container(
                                      'No skills found! Make Sure You Are connected To The Internet?')
                                  : model.searchLoading == false &&
                                          controller.text.length >= 3 &&
                                          model.searchList.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: model.searchList.length,
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () =>
                                                  onTapFunction(model, index),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                      title: Text(
                                                          '${model.searchList[index].sname} ' +
                                                              model
                                                                  .searchList[index]
                                                                  .fname),
                                                      subtitle: Text(
                                                        model.searchList[index]
                                                            .occupation,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                      autofocus: false,
                                                      onTap: () {
                                                        onTapFunction(model, index);
                                                      }),
                                                  Divider(),
                                                ],
                                              ),
                                            );
                                          })
                                      : _container(
                                          'Poor or No Data Connection! Check Your Internet Connection');
                })
              ],
            )
          ],
        );
      }
    );
  }
}
