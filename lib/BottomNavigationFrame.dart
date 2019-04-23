import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'CustomForm.dart';
import 'TodoItemCard.dart';
import 'AddPage.dart';
import 'AddTagPage.dart';
import 'DetailPage.dart';
import 'SettingsPage.dart';
import 'Todo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'LoginPage.dart';
import 'TimeLinePage.dart';
import 'GenrePage.dart';

class BottomNavigationFrame extends StatefulWidget {
  @override
  State createState() => new _BottomNavigationFrameState();
}

class _BottomNavigationFrameState extends State<BottomNavigationFrame>{
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("App$_page"),
      ),
      body: new PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          new TimeLinePage(),
          new GenrePage(),
          new SettingsPage(),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
          fixedColor: Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: _page,
          onTap: onTapBottomNavigation,
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.timeline),
              title: new Text("TimeLine"),),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.assignment),
              title: new Text("Genre"),),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.settings),
              title: new Text("Setting"),),
          ]
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).pushNamed("/add");
            //Navigator.of(context).pushNamed("/login");
            //_showNotificationWithDefaultSound();
            //_showNotificationInBackground();
          }),
    );
  }

  void onPageChanged(int page){
    setState(() {
      this._page = page;
    });
  }

  void onTapBottomNavigation(int page){
    _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = new PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _pageController.dispose();
  }
}