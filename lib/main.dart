import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:st_peters_chaplaincy_unn/pages/splash_screen.dart';
import 'package:st_peters_chaplaincy_unn/scoped_models/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'pages/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _showNotification(message);
  print('Handling a background message ${message.messageId}');
  // if (message.containsKey('data')) {
  //   // Handle data message
  //   // final dynamic data = message['data'];
  //   // _showNotification(data);
  // }
  //
  // if (message.containsKey('notification')) {
  //   // Handle notification message
  //   final dynamic notification = message['notification'];
  //   _showNotification(notification);
  // }

  // Or do other work.
}

// Future<void> onClickNotification(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   if (message != null) {
//     CollectionReference ref = FirebaseFirestore.instance.collection('users');
//     await ref.doc(message.data['userId']).get().then(
//           (value) => ConversationScreen(
//             email: value['email'],
//             number: value['number'],
//             userName: value['userName'],
//             chatRoomId: value['chatRoomId'],
//             bAddress: value['bAddress'],
//             fname: value['fname'],
//             occupation: value['occupation'],
//             profileImage: value['profileImage'],
//             sname: value['sname'],
//             userId: value['userId'],
//           ),
//         );
//     // _showNotification(message);
//     // setState(() {
//     //   chatRoomId = message.data['chatRoomId'];
//     //   fName = message.data['senderId'];
//     // });
//     // Navigator.pushNamed(context, '/message',
//     //     arguments: MessageArguments(message, true));
//   }
// }

AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
Future<void> _createNotificationChannel(
    String id, String name, String description) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var androidNotificationChannel = AndroidNotificationChannel(
    id,
    name,
    description,
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
}

// Future<void> _firebaseMessaging() async {
//   // await Firebase.initializeApp();
//   firebaseMessaging.requestPermission();
//   FirebaseMessaging.onMessage.listen((event) {
//     _showNotification(event.data['notification']);
//   });
//   FirebaseMessaging.onBackgroundMessage((message) {
//     return _showNotification(message.data['notification']);
//   });
//   FirebaseMessaging.onMessageOpenedApp.listen((event) {
//     if (event.data['notification'] != null) {
//       _showNotification(event.data['notification']);
//       print('onLaunch: ${event.data}');
//     }
//   });
// }

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future _showNotification(RemoteMessage message) async {
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'com.example.st_peters_chaplaincy_unn',
    'St-Peters-Chaplaincy-UNN',
    'St-Peters-Chaplaincy-UNN Mobile App',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    icon: 'launch_background',
    enableVibration: true,
    // color: Colors.deepPurple,
    channelShowBadge: true,
    groupKey: message.notification.title,
  );

  var iosPlatformChannelSpecifics = IOSNotificationDetails();

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosPlatformChannelSpecifics,
  );

  await _createNotificationChannel(
    'com.example.st_peters_chaplaincy_unn',
    'St-Peters-Chaplaincy-UNN',
    'St-Peters-Chaplaincy-UNN Mobile App',
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification.title,
    message.notification.body,
    notificationDetails,
    payload: json.encode(message.data),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.instance
  //     .getInitialMessage()
  //     .then(onClickNotification);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final model = MainModel();
  bool _error = false;
  bool _initialized = false;

  Future onSelectNotification(String payload) async {
    return DashboardScreen(loadPage: 3, model: model);
  }

  androidNotification(RemoteNotification notification) {
    return flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
            channelShowBadge: true,
          ),
        ));
  }

  @override
  void initState() {
    initializeflutter();
    model.authAthunticate();
    super.initState();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print(message.notification);
        // _showNotification(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      // AndroidNotification android = message.notification.android;
      if (notification != null) {
        _showNotification(message);
        // androidNotification(notification);
      }
    });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   // print('A new onMessageOpenedApp event was published!');
    //   // Navigator.pushNamed(context, '/dashBoard');
    //   androidNotification(message.notification);
    // });
    // var initializeSettingsAndriod = AndroidInitializationSettings('images');
    //
    // var initializeSettingsIOS = IOSInitializationSettings();
    //
    // var initializationSettings = InitializationSettings(
    //   android: initializeSettingsAndriod,
    //   iOS: initializeSettingsIOS,
    // );
    //
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    //
    // flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    //   onSelectNotification: onSelectNotification,
    // );
    // _firebaseMessaging();
    // model.fetchLeaders();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeflutter() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print('something went wrong');
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error Message'),
              content: Text('Something went wrong'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Okay'),
                ),
              ],
            );
          });
      return null;
    }
    if (!_initialized) {
      return MaterialApp(
        home: Scaffold(
          body: Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    changetheme() {
      if (model.themeColor == true) {
        setState(() {
          model.setTheme(false);
        });
      } else {
        setState(() {
          model.setTheme(true);
        });
      }
    }

    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
        title: "St. Peter's UNN",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          brightness:
              model.themeColor == true ? Brightness.dark : Brightness.light,
        ),
        routes: {
          '/': (BuildContext context) => ScopedModelDescendant<MainModel>(
                  builder: (context, child, MainModel model) {
                    // model.authAthunticate();
                return MySplashScreen(changetheme, model.themeColor, model);
              }),
          'dashBoard': (BuildContext context) =>
              ScopedModelDescendant<MainModel>(
                  builder: (context, child, MainModel snapshot) {
                return DashboardScreen(
                  model: model,
                  changetheme: changetheme,
                  brightness: model.themeColor,
                );
              }),
        },
      ),
    );
  }
}
