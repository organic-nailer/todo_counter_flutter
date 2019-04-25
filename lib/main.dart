import 'package:flutter/material.dart';
import 'dart:async';
import 'CustomForm.dart';
import 'AddPage.dart';
import 'AddTagPage.dart';
import 'DetailPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'LoginPage.dart';
import 'BottomNavigationFrame.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() => runApp(new TodoCounter());

class TodoCounter extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
	      primaryColor: Colors.brown[500],
	      primaryColorDark: Colors.brown[700],
	      primaryColorLight: Colors.brown[100],
	      accentColor: Colors.teal,

	        fontFamily:  "NotoSansJP",
	        textTheme: TextTheme(

	        )

        ),
        home: new RootPage(),
        routes: <String, WidgetBuilder>{
          '/add': (_) => new AddPage(),
          '/add/tag': (_) => new AddTagPage(),
          '/form': (_) => new MyCustomForm(),
          '/detail': (_) => new DetailPage(),
	        '/login': (_) => new LoginPage(),
        },
    );
  }
}

class RootPage extends StatefulWidget{
  @override
  State createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage>{
  @override
  Widget build(BuildContext context) {
    return new BottomNavigationFrame();
  }

  var flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    _initFLN();
    _fcmSetup();
  }

  void _initFLN(){

    var initializationSettingsAndroid = new AndroidInitializationSettings("app_icon");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: onSelectNotification);
  }

  void _fcmSetup()//通知周りの設定
  {
    FirebaseMessaging _fcm = new FirebaseMessaging();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message)
      async {
        initializeDateFormatting("ja_JP");
        print("onMessage: $message");
        _buildDialog(context, "onMessage");
        _initFLN();
        Map<dynamic, dynamic> _data = message["data"];
        print("data: $_data");
        print("DateTime: ${DateTime.parse(_data["notifytime"]).toLocal()}");
        print("date_now: ${DateTime.now()}");
        _showNotificationInBackground(_data["title"], "onMessage", DateTime.parse(_data["notifytime"]));
      },
      onLaunch: (Map<String, dynamic> message)
      async {
        print("onLaunch: $message");
        _buildDialog(context, "onLaunch");
      },
      onResume: (Map<String, dynamic> message)
      async {
        print("onResume: $message");
        _buildDialog(context, "onResume");
      },
    );
    _fcm.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered
        .listen((settings)
    {
      print("Settings resistered: $settings");
    });
    _fcm.subscribeToTopic("/topics/all");
  }

  void _buildDialog(BuildContext context, String message){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return new AlertDialog(
            content: new Text("Message: $message"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () { Navigator.pop(context, false); },
                  child: const Text("CLOSE")),
              new FlatButton(
                  onPressed: () { Navigator.pop(context, true); },
                  child: const Text("OK")),
            ],
          );
        }
    );
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  Future _showNotificationInBackground(String id, String title, DateTime date) async {
    print("id: $id, title: $title, date: $date");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        "notification_channel_id",
        "Channel Name",
        "Here we will put the description about the Channel",
        importance: Importance.Max, priority: Priority.High
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(1, "title", title,
        date, platformChannelSpecifics);
  }
}