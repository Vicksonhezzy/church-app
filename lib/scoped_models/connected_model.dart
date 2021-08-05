import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendPushNotifications {
  static final Uri postUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');

  static Future<bool> sendNotifications(userId, msg) async {
    String userToken = await getToken(userId);
    // 'badge': '1',
    //     'sound': 'default',
    final data = {
      'notification': {
        'body': '${msg['message']}',
        'title': '${msg['uname']}',
      },
      'priority': 'high',
      'data': {
        'userId': userId,
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
      },
      'to': '$userToken',
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
      'enter authorization key',
    };

    try {
      http.Response response =
      await http.post(postUrl, body: json.encode(data), headers: headers);

      print(json.decode(response.body));
      print('Push Notification Success');
      return true;
    } on HttpException catch (e) {
      print('push error= ${e.message}');
      return false;
    }
  }

  static Future<String> getToken(userId) async {
    String token;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      token = value.data()['token'];
    });
    return token;
  }
}

class Users {
  final String id;
  final String email;
  final dynamic password;
  final String token;
  final String userName;
  final String sname;
  final String fname;
  final String number;
  final String bAddress;
  final String occupation;
  final String profileImage;

  Users({@required this.id,
    @required this.email,
    this.password,
    @required this.token,
    @required this.userName,
    this.sname,
    this.fname,
    this.number,
    this.bAddress,
    this.occupation,
    this.profileImage});
}

class ChatUsers {
  final String userId;
  final String chatRoomId;
  final String email;
  final String userName;
  final String sname;
  final String fname;
  final String number;
  final String bAddress;
  final String occupation;
  final String profileImage;
  final String lastMessage;

  ChatUsers({@required this.userId,
    @required this.chatRoomId,
    @required this.email,
    @required this.userName,
    this.sname,
    this.fname,
    this.number,
    this.bAddress,
    this.occupation,
    this.profileImage,
    this.lastMessage});
}

class ParishLeaders {
  final String id;
  final String post;
  final String picture;
  final String name;

  ParishLeaders({@required this.id,
    @required this.post,
    @required this.picture,
    @required this.name});
}

class SearchList {
  final String id;
  final String email;
  final String userName;
  final String sname;
  final String fname;
  final String number;
  final String bAddress;
  final String occupation;
  final String profileImage;

  SearchList({@required this.id,
    @required this.email,
    @required this.userName,
    this.sname,
    this.fname,
    this.number,
    this.bAddress,
    this.occupation,
    this.profileImage});
}

mixin ConnectedModel on Model {
  List<ParishLeaders> _leaders = [];
  List<SearchList> _searchList = [];
  int _leadersIndex;
  bool _leadersLoading;
  Users _authentication;
  bool _isLoading = false;
  Timer _autTimer;
  String _token;
  File _image;
  File _profileImage;
  User _user;
  String _profileImagePath;
  String _profileImageUrl;
  bool _isUpdating;
  bool _isManager = false;
  String _chatRoomId;
  bool _themeColor;
  List<ChatUsers> _chatUsers = [];
  File chatImage;

  List<ChatUsers> get chatUsers {
    return List.from(_chatUsers);
  }

  int book = Random().nextInt(65);

  setManager(bool _bool) {
    _isManager = _bool;
    notifyListeners();
  }

  String get chatRoomId {
    return _chatRoomId;
  }

  bool get isManager {
    return _isManager;
  }

  List<SearchList> get searchList {
    return List.from(_searchList);
  }

  List<ParishLeaders> get leaders {
    return List.from(_leaders);
  }

  int get leadersIndex {
    return _leadersIndex;
  }

  bool get leadersLoading {
    return _leadersLoading;
  }

  void currentLeadersIndex(int index) {
    _leadersIndex = index;
    notifyListeners();
  }

  ParishLeaders get selectedLeader {
    if (_leadersIndex == null) {
      return null;
    }
    return _leaders[_leadersIndex];
  }

  setTheme(bool change) async {
    _themeColor = change;
    notifyListeners();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('theme', change);
    notifyListeners();
    return _themeColor;
  }

  bool get themeColor {
    return _themeColor;
  }

  bool _searchLoading;

  bool get searchLoading {
    return _searchLoading;
  }

  Future<List<SearchList>> fetchSearch(String text) async {
    final List<SearchList> fetchedList = [];
    if (text.isEmpty) {
      CollectionReference ref = FirebaseFirestore.instance.collection('users');
      await ref.snapshots().forEach((element) {
        element.docs.forEach((element) {
          final _uploadedleaders = SearchList(
            id: element['userId'],
            email: element['email'],
            userName: element['uname'],
            sname: element['sname'],
            fname: element['fname'],
            bAddress: element['bAddress'],
            number: element['number'],
            occupation: element['occupation'],
            profileImage: element['pImageUrl'],
          );
          fetchedList.add(_uploadedleaders);
          _searchList = fetchedList;
          _searchLoading = false;
          notifyListeners();
        });
      });
    } else {
      print('me');
      _searchLoading = true;
      notifyListeners();
      CollectionReference ref = FirebaseFirestore.instance.collection('users');
      await ref.snapshots().forEach((element) {
        element.docs.forEach((element) {
          final _uploadedleaders = SearchList(
            id: element['userId'],
            email: element['email'],
            userName: element['uname'],
            sname: element['sname'],
            fname: element['fname'],
            bAddress: element['bAddress'],
            number: element['number'],
            occupation: element['occupation'],
            profileImage: element['pImageUrl'],
          );
          fetchedList.add(_uploadedleaders);
          notifyListeners();
        });
        print('done');
        print('fetchedList = ${fetchedList.length}');
        List<SearchList> newList = fetchedList.where((element) {
          return element.occupation.toLowerCase().contains(text.toLowerCase());
        }).toList();
        print('newList = ${newList.asMap()}');
        _searchList = newList;
        print('searchLength = ${_searchList.length}');
        _searchLoading = false;
        notifyListeners();
      });
    }
    return _searchList;
  }

  String sponsorsImageUrl;
  String sponsorsImagePath;

  Future sponsorsImage(File uploadedImage, String path) async {
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    FirebaseStorage firebaseStorage = FirebaseStorage.instanceFor(
        bucket: 'gs://holy-cross-parish-iji-ni-474ab.appspot.com');
    final imagePath = File(uploadedImage.path);
    try {
      Reference reference = firebaseStorage.ref('$path/$imagePath');
      UploadTask uploadTask =
      firebaseStorage.ref('$path/$imagePath').putFile(imagePath);
      TaskSnapshot taskSnapshot = await uploadTask;
      print('Uploaded ${taskSnapshot.bytesTransferred} bytes.');
      String downloadURL = await reference.getDownloadURL();
      try {
        print(downloadURL);
      } on FirebaseException catch (e) {
        print('downloadError= $e');
      }
      sponsorsImagePath = uploadedImage.path;
      print('profileImagePath= $_profileImagePath');
      sponsorsImageUrl = downloadURL;
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<Null> addSponsors(File logo, String name, String services,
      String location, String number, File images) async {
    _activitiesUpdateloading = true;
    notifyListeners();

    await uploadProfilePicture(logo, 'sponsors');
    await sponsorsImage(images, 'sponsors');

    CollectionReference users =
    FirebaseFirestore.instance.collection('sponsors');

    users.doc().set({
      'logo': _profileImageUrl,
      'logoPath': _profileImagePath,
      'name': name,
      'services': services,
      'location': location,
      'number': number,
    }).then((value) {
      _activitiesUpdateloading = false;
      notifyListeners();
    }).catchError((e) {
      print('_activitiesUpdateloading error= ' + e);
    });
  }

  Future<Map<String, String>> updatePassword(String email, String code,
      String newPassword) async {
    String message = 'something went wrong';
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      message = 'A password reset email have been sent to this email address';
      return {'message': message};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        message = 'invalid email address';
        notifyListeners();
      }
      if (e.code == 'user-not-found') {
        message = 'user not found';
        notifyListeners();
      }

      return {'message': message};
    }
    // await FirebaseAuth.instance.confirmPasswordReset(code: code, newPassword: newPassword);
  }

  Future<Stream<QuerySnapshot>> fetchSponsors() async {
    CollectionReference users =
    FirebaseFirestore.instance.collection('sponsors');
    return users.snapshots();
  }

  bool _activitiesUpdateloading;

  bool get activitiesUpdateloading {
    return _activitiesUpdateloading;
  }

  Future<Null> addActivities(String activities, String days, String time,
      CollectionReference users) async {
    _activitiesUpdateloading = true;
    notifyListeners();

    users.doc().set({
      'activities': activities,
      'days': days,
      'time': time,
    }).then((value) {
      _activitiesUpdateloading = false;
      notifyListeners();
    }).catchError((e) {
      print('_activitiesUpdateloading error= ' + e);
    });
  }

  Future<Null> updateActivities(String activities, String days, String time,
      CollectionReference users, String id) async {
    _activitiesUpdateloading = true;
    notifyListeners();

    users.doc(id).update({
      'activities': activities,
      'days': days,
      'time': time,
    }).then((value) {
      _activitiesUpdateloading = false;
      notifyListeners();
    }).catchError((e) {
      print('_activitiesUpdateloading error= ' + e);
    });
  }

  Future<Stream<QuerySnapshot>> fetchActivities(String user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('$user');
    return users.snapshots();
  }

  Future<Null> addLeaders(String post, String name, File image) async {
    _leadersLoading = true;
    notifyListeners();

    CollectionReference users =
    FirebaseFirestore.instance.collection('leaders');

    await uploadProfilePicture(image, 'leadersPictures');

    users.doc().set({
      'id': name,
      'pImageUrl': _profileImageUrl,
      'pImagePath': _profileImagePath,
      'post': post,
      'name': name,
    }).then((value) {
      print('was successful');
      _leadersLoading = false;
      notifyListeners();
    }).catchError((onError) {
      _leadersLoading = false;
      notifyListeners();
      print(onError);
    });
  }

  Future<Null> updateLeaders(String post, String name, File image,
      String id) async {
    _leadersLoading = true;
    notifyListeners();

    CollectionReference users =
    FirebaseFirestore.instance.collection('leaders');

    if (image != null) {
      await uploadProfilePicture(image, 'leadersPictures');
      users.doc().update({
        'pImageUrl': _profileImageUrl,
        'pImagePath': _profileImagePath,
        'post': post,
        'name': name,
      }).then((value) {
        print('was successful');
        _leadersLoading = false;
        notifyListeners();
      }).catchError((onError) {
        _leadersLoading = false;
        notifyListeners();
        print(onError);
      });
    } else {
      users.doc(id).update({
        'id': name,
        'post': post,
        'name': name,
      }).then((value) {
        print('was successful');
        _leadersLoading = false;
        notifyListeners();
      }).catchError((onError) {
        _leadersLoading = false;
        notifyListeners();
        print(onError);
      });
    }
  }

  Future<Null> fetchLeaders() async {
    ParishLeaders(id: '', post: '', picture: '', name: '');
    notifyListeners();
    final List<ParishLeaders> fetchedLeaders = [];
    try {
      FirebaseFirestore.instance
          .collection('leaders')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final _uploadedleaders = ParishLeaders(
              id: doc.id,
              post: doc['post'],
              picture: doc['pImageUrl'],
              name: doc['name']);
          fetchedLeaders.add(_uploadedleaders);
          _leaders = fetchedLeaders;
          notifyListeners();
        });
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      _chatRoomId = '$b\_$a';
      notifyListeners();
      return _chatRoomId;
    } else {
      _chatRoomId = '$a\_$b';
      notifyListeners();
      return _chatRoomId;
    }

    // Another method of achieving this is
    // if (currentId.hashCode <= peerId.hashCode) {
    //     groupChatId = '$currentId-$peerId';
    // } else {
    //     groupChatId = '$peerId-$currentId';
    // }
  }

  createChat(String chatId, Map<String, dynamic> chatData) async {
    CollectionReference users =
    FirebaseFirestore.instance.collection('chatRoom');

    users.doc(chatId).set(chatData).catchError((e) {
      print(e);
    });
  }

  setChatImage(File image, String chatId) async {
    chatImage = image;
    notifyListeners();
    if (image != null) {
      await uploadProfilePicture(chatImage, 'chatImages');
    }

    Map<String, dynamic> messageMap = {
      'message': null,
      'chatImagePath': _profileImagePath,
      'chatImageUrl': _profileImageUrl,
      'sender': _authentication.id,
      'uname': _authentication.userName,
      'time': DateTime
          .now()
          .millisecondsSinceEpoch,
    };
    CollectionReference users =
    FirebaseFirestore.instance.collection('chatRoom');
    return users
        .doc(chatId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print('message error= ' + e);
      chatImage = null;
      notifyListeners();
    });
  }

  Future<bool> addConversations(String chatId, String message) async {
    Map<String, dynamic> messageMap = {
      'chatImagePath': null,
      'chatImageUrl': null,
      'message': message,
      'sender': _authentication.id,
      'uname': _authentication.userName,
      'time': DateTime
          .now()
          .millisecondsSinceEpoch,
    };
    CollectionReference users =
    FirebaseFirestore.instance.collection('chatRoom');

    String userId = chatId
        .toString()
        .replaceAll('_', '')
        .replaceAll(_authentication.id, '');

    Map<String, dynamic> msg = {
      'uname': _authentication.userName,
      'message': message,
    };

    users.doc(chatId).collection('chats').add(messageMap);
    return SendPushNotifications.sendNotifications(userId, msg);
    // SendNotifications.sendNotification(userId, msg);
  }

  Future<Stream<QuerySnapshot>> getConversations(String chatId) async {
    CollectionReference users =
    FirebaseFirestore.instance.collection('chatRoom');
    return users
        .doc(chatId)
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<dynamic> getChatRoom(String myId) async {
    // final pref = await SharedPreferences.getInstance();
    CollectionReference users =
    FirebaseFirestore.instance.collection('chatRoom');
    // String myId = pref.getString('userId');
    final List<ChatUsers> _getChatUsers = [];
    Stream<QuerySnapshot> future =
    users.where('users', arrayContains: myId).snapshots();
    future.forEach((element) async {
      element.docs.forEach((element) async {
        String chatRoomId = element['chatRoomId'];
        String userId =
        chatRoomId.toString().replaceAll('_', '').replaceAll(myId, '');
        FirebaseFirestore.instance
            .collection('users')
            .where('userId', isEqualTo: '$userId')
            .get()
            .asStream()
            .listen((event) async {
          event.docs.forEach((element) async {
            final fetchedChatUsers = ChatUsers(
              userId: element['userId'],
              chatRoomId: chatRoomId,
              email: element['email'],
              userName: element['uname'],
              bAddress: element['bAddress'],
              fname: element['fname'],
              number: element['number'],
              occupation: element['occupation'],
              profileImage: element['pImageUrl'],
              sname: element['sname'],
            );
            _getChatUsers.add(fetchedChatUsers);
            _chatUsers = _getChatUsers;
            notifyListeners();
          });
        });
        return _chatUsers;
      });
    }).catchError((e) => print('firebaseError= $e'));
  }

  // ignore: close_sinks

  PublishSubject<bool> _usersSubject = PublishSubject();

  User get currentUser {
    return _user;
  }

  setImage(File image) {
    _image = image;
    notifyListeners();
  }

  setProfileImage(File image) {
    _profileImage = image;
    notifyListeners();
  }

  File get image {
    return _image;
  }

  bool get isUpdating {
    return _isUpdating;
  }

  File get profileImage {
    return _profileImage;
  }

  PublishSubject<bool> get usersSubject {
    return _usersSubject;
  }

  updateProfile(String userName, String bAddress, File pImage, String number,
      String occupation) async {
    _isUpdating = true;
    notifyListeners();
    Map<String, dynamic> updateData = {};
    final pref = await SharedPreferences.getInstance();
    String _sname = pref.getString('sname');
    String _fname = pref.getString('fname');
    String _pImage = pref.getString('pImage');
    String _email = pref.getString('email');
    String _id = pref.getString('userId');
    if (pImage != null) {
      await uploadProfilePicture(pImage, 'profilePictures');
      updateData = {
        'pImageUrl': _profileImageUrl,
        'pImagePath': _profileImagePath,
        'userId': _id,
        'email': _email,
        'sname': _sname,
        'fname': _fname,
        'uname': userName,
        'number': number,
        'bAddress': bAddress,
        'occupation': occupation,
      };
      notifyListeners();
    } else {
      updateData = {
        'userId': _id,
        'pImageUrl': _pImage,
        'sname': _sname,
        'fname': _fname,
        'uname': userName,
        'number': number,
        'bAddress': bAddress,
        'occupation': occupation,
        'email': _email,
      };
      notifyListeners();
    }

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final user = firebaseAuth.currentUser;
    users.doc(user.uid).update(updateData).then((value) {
      _isUpdating = false;
      notifyListeners();
      print('user added');
    }).catchError((onError) => print(onError));
    Future<DocumentSnapshot> future = users.doc(user.uid).get();
    future.asStream().listen((event) async {
      Map<String, dynamic> data = event.data();
      await pref.setString('userId', data['userId']);
      await pref.setString('userName', data['uname']);
      await pref.setString('bAddress', data['bAddress']);
      await pref.setString('number', data['number']);
      await pref.setString('occupation', data['occupation']);
      await pref.setString('sname', data['sname']);
      await pref.setString('fname', data['fname']);
      await pref.setString('algoliaId', data['algoliaId']);
      await pref.setString('pImage', data['pImageUrl']);
      String _bAddress = pref.getString('bAddress');
      // String _algoliaId = pref.getString('algoliaId');
      String _pImage = pref.getString('pImage');
      String _number = pref.getString('number').toString();
      String _occupation = pref.getString('occupation');
      String _id = pref.getString('userId');
      String _email = pref.getString('email');
      String _userName = pref.getString('userName');
      String _currentToken = pref.getString('token');
      _authentication = Users(
        id: _id,
        email: _email,
        token: _currentToken,
        sname: _sname,
        fname: _fname,
        userName: _userName,
        bAddress: _bAddress,
        number: _number,
        occupation: _occupation,
        profileImage: _pImage,
      );
      notifyListeners();
    });
  }

  Future<Map<String, dynamic>> login(String email, dynamic password) async {
    Users(id: '', email: '', token: '', userName: '');
    _isLoading = true;
    notifyListeners();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    bool haserror = true;
    String message = 'Something went wrong, invalid password or userName/email';
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email.toString().trim(), password: password);

      String fcmToken = await firebaseMessaging.getToken();

      firebaseAuth.authStateChanges().listen((user) async {
        Future<DocumentSnapshot> future = users.doc(user.uid).get();
        future.asStream().listen((event) async {
          Map<String, dynamic> data = event.data();
          await pref.setString('userName', data['uname']);
          await pref.setString('bAddress', data['bAddress']);
          await pref.setString('number', data['number']);
          await pref.setString('occupation', data['occupation']);
          await pref.setString('sname', data['sname']);
          await pref.setString('fname', data['fname']);
          await pref.setString('algoliaId', data['algoliaId']);
          await pref.setString('pImage', data['pImageUrl']);
          await pref.setString('userId', data['userId']);

          print(data['occupation']);
          String _bAddress = pref.getString('bAddress');
          String _userId = pref.getString('userId');
          String _pImage = pref.getString('pImage');
          String _number = pref.getString('number').toString();
          String _sname = pref.getString('sname');
          String _fname = pref.getString('fname');
          // String _algoliaId = pref.getString('algoliaId');
          String _occupation = pref.getString('occupation');
          String _email = pref.getString('email');
          String _userName = pref.getString('userName');
          String _currentToken = pref.getString('token');
          _authentication = Users(
              id: _userId,
              email: _email,
              token: _currentToken,
              sname: _sname,
              fname: _fname,
              userName: _userName,
              bAddress: _bAddress,
              number: _number,
              occupation: _occupation,
              profileImage: _pImage);
          notifyListeners();

          await users.doc(_userId).update({
            'token': fcmToken,
          });
        });
        String token = await user.getIdToken();
        _user = user;
        notifyListeners();
        setAuthTime(55, user);
        final currentime = DateTime.now();
        final expiryTime = currentime.add(Duration(minutes: 55));
        await pref.setString('expiryTime', expiryTime.toIso8601String());
        await pref.setString('timeToken', token);
        await pref.setString('email', user.email);
        _token = pref.getString('id');
      });
      haserror = false;
    } on FirebaseAuthException catch (e) {
      if (pref.getString('userName') == null) {
        _tokenExpired = true;
        logOut();
        message =
        'Something went wrong.\n Please try closing and opening the app again.';
      }
      if (e.code == 'user-not-found') {
        message = 'Email not found';
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password';
        print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else if (e.code == 'network-request-failed') {
        message = 'Poor or No Data Connection! Check Your Data Connection';
      } else {
        print('error= ${e.code}');
        message = 'something went wrong';
      }
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !haserror, 'message': message};
  }

  Future uploadProfilePicture(File uploadedImage, String path) async {
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    FirebaseStorage firebaseStorage = FirebaseStorage.instanceFor(
        bucket: 'gs://holy-cross-parish-iji-ni-474ab.appspot.com');
    final imagePath = File(uploadedImage.path);
    try {
      Reference reference = firebaseStorage.ref('$path/$imagePath');
      UploadTask uploadTask =
      firebaseStorage.ref('$path/$imagePath').putFile(imagePath);
      TaskSnapshot taskSnapshot = await uploadTask;
      print('Uploaded ${taskSnapshot.bytesTransferred} bytes.');
      String downloadURL = await reference.getDownloadURL();
      try {
        print(downloadURL);
      } on FirebaseException catch (e) {
        print('downloadError= $e');
      }
      _profileImagePath = uploadedImage.path;
      print('profileImagePath= $_profileImagePath');
      _profileImageUrl = downloadURL;
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> signUp([File profileImage,
    String email,
    String password,
    String userName,
    String sname,
    String fname,
    String bAddress,
    String number,
    String occupation]) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    String _occupation = occupation.replaceFirst(
        occupation.characters.first, occupation.characters.first.toUpperCase());

    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String fcmToken = await firebaseMessaging.getToken();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    _isLoading = true;
    bool haserror = true;
    String message = 'Something went wrong';
    notifyListeners();
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: '$email', password: '$password');
      // firebaseAuth.verifyPhoneNumber(phoneNumber: number, verificationCompleted: null, verificationFailed: null, codeSent: null, codeAutoRetrievalTimeout: null)
      firebaseAuth.authStateChanges().listen((user) async {
        if (profileImage != null) {
          await uploadProfilePicture(profileImage, 'profilePictures');
        }

        Map<String, dynamic> addData = {
          'userId': user.uid,
          'pImageUrl': _profileImageUrl,
          'pImagePath': _profileImagePath,
          'sname': sname,
          'token': fcmToken,
          'fname': fname,
          'uname': userName,
          'email': email.toString().trim(),
          'number': number,
          'bAddress': bAddress,
          'occupation': _occupation,
        };

        users.doc(user.uid).set(addData).then((value) {
          print('user added');
        });
      });
      haserror = false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already exist, try sign-in';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else {
        print(e.code.toString());
      }
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !haserror, 'message': message};
  }

  bool get isLoading {
    return _isLoading;
  }

  void loadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String get token {
    return _token;
  }

  bool _tokenExpired;

  bool get tokenExpired {
    return _tokenExpired;
  }

  setTokenExpired(bool _bool) {
    _tokenExpired = _bool;
    notifyListeners();
  }

  Future authAthunticate() async {
    // Users(id: '', email: '', token: '', userName: '');
    // notifyListeners();
    final pref = await SharedPreferences.getInstance();
    bool _theme = pref.getBool('theme');
    _themeColor = _theme;
    notifyListeners();
    String email = pref.getString('email');
    final token = pref.getString('timeToken');
    final expiryTime = pref.getString('expiryTime');
    if (expiryTime != null) {
      final now = DateTime.now();
      final parseExpiryTime = DateTime.parse(expiryTime);

      if (token != null) {
        if (parseExpiryTime.isBefore(now)) {
          _tokenExpired = true;
          _authentication = null;
          notifyListeners();
          return null;
        }
      } else {
        String id = pref.getString('userId');
        String userName = pref.getString('userName');
        String bAddress = pref.getString('bAddress');
        String number = pref.getString('number').toString();
        String sname = pref.getString('sname');
        String fname = pref.getString('fname');
        // String _algoliaId = pref.getString('algoliaId');
        String occupation = pref.getString('occupation');
        String _image = pref.getString('pImage');
        _authentication = Users(
            id: id,
            email: email,
            token: token,
            userName: userName,
            sname: sname,
            fname: fname,
            bAddress: bAddress,
            number: number,
            occupation: occupation,
            profileImage: _image);
        // _usersSubject.add(true);
        notifyListeners();
        return _authentication;
      }
    } else {
      _authentication = null;
      notifyListeners();
      return _authentication;
    }
  }

  void setAuthTime(int time, User user) async {
    final pref = await SharedPreferences.getInstance();
    _autTimer = Timer.periodic(Duration(minutes: time), (timer) {
      String token = user.refreshToken;
      pref.setString('token', token);
      notifyListeners();
      _usersSubject.add(false);
    });
    notifyListeners();
  }

  void logOut() async {
    _authentication = null;
    _chatUsers = null;
    _isManager = false;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await firebaseAuth.signOut();
    pref.remove('token');
    pref.remove('userName');
    pref.remove('id');
    pref.remove('email');
    pref.remove('sname');
    pref.remove('fname');
    pref.remove('number');
    pref.remove('bAddress');
    pref.remove('occupation');
    pref.remove('expiryTime');
    pref.remove('pImage');
    _authentication = null;
    // _autTimer.cancel();
    print(_authentication);
    _usersSubject.add(false);
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
  }

  Users get authentication {
    return _authentication;
  }
}

mixin WeddingsModel on ConnectedModel {
  bool _isLoadingWedding = false;

  void setWedding(bool loading) {
    _isLoadingWedding = loading;
    notifyListeners();
  }

  bool get isLoadingWedding {
    return _isLoadingWedding;
  }

  Future<Null> updateWedding(String title, String details, String venue,
      File image, String id, String where) async {
    _isLoadingWedding = true;
    notifyListeners();
    CollectionReference users = FirebaseFirestore.instance.collection('$where');
    if (image != null) {
      await uploadFile(image);
      await users.doc(id).update({
        'title': title,
        'details': details,
        'venue': venue,
        'imageUrl': _imageUrl,
      });
    } else {
      await users.doc(id).update({
        'title': title,
        'details': details,
        where == 'weddings' ? 'venue' : venue: null
      });
    }
  }

  Future<Stream<QuerySnapshot>> fetchWedding(String where) async {
    CollectionReference users = FirebaseFirestore.instance.collection('$where');
    return users.snapshots();
  }

  String _imageUrl;

  // String _imagePath;

  Future uploadFile(File uploadedImage) async {
    File imagePath = File(uploadedImage.path);
    try {
      FirebaseStorage firebaseStorage = FirebaseStorage.instanceFor(
          bucket: 'gs://holy-cross-parish-iji-ni-474ab.appspot.com');
      Reference reference = firebaseStorage.ref('weddingPictures/$imagePath');
      UploadTask uploadTask =
      firebaseStorage.ref('weddingPictures/$imagePath').putFile(imagePath);
      TaskSnapshot taskSnapshot = await uploadTask;
      print('Uploaded ${taskSnapshot.bytesTransferred} bytes.');
      String downloadURL = await reference.getDownloadURL();
      _imageUrl = downloadURL;
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<Null> addWedding(String title, String details, String venue,
      File image, String where) async {
    CollectionReference users = FirebaseFirestore.instance.collection('$where');
    _isLoadingWedding = true;
    notifyListeners();
    if (where == 'weddings') {
      if (image != null) {
        await uploadFile(image);
      }
      return await users.doc().set({
        'title': title,
        'details': details,
        'venue': venue,
        'imageUrl': _imageUrl,
      }).catchError((e) {
        print('weddingsUpdate error= ' + e.toString());
      });
    } else {
      String _amount = venue.toString().replaceAll(',', '');
      String amount = _amount.toString().replaceAll('000', ',000');
      return await users.doc().set({
        'title': title,
        'details': details,
        where == 'donations' ? 'amount' : amount: null
      }).catchError((e) {
        print('announcementUpdate error= ' + e.toString());
      });
    }
  }

  Future<Null> deleteWedding(String id, String where) async {
    CollectionReference users = FirebaseFirestore.instance.collection('$where');
    await users
        .doc(id)
        .delete()
        .catchError((e) => print('wedding delete error= $e'));
  }
}
