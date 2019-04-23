import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'CustomForm.dart';
import 'TodoItemCard.dart';
import 'AddPage.dart';
import 'AddTagPage.dart';
import 'DetailPage.dart';
import 'Todo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'LoginPage.dart';
import 'TimeLinePage.dart';
import 'BottomNavigationFrame.dart';

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

  @override
  void initState() {
    super.initState();

    _fcmSetup();
  }

  void _fcmSetup()//通知周りの設定
  {
    FirebaseMessaging _fcm = new FirebaseMessaging();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message)
      async {
        print("onMessage: $message");
        _buildDialog(context, "onMessage");
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
}