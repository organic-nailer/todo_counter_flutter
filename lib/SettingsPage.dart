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


class SettingsPage extends StatefulWidget{
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;
  FirebaseUser _user;


  @override
  State createState () => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage>{

  FirebaseUser _user;
  GoogleSignInAccount _currentUser;
  String _username = "";
  String _userid = "";
  String _useremail = "";
  String _photo;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: _user == null
          ? _buildGoogleSignInButton()
          : new Center(
        child: new Icon(Icons.add_shopping_cart),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: RaisedButton(
              child: Text("Google Sign In"),
              onPressed: (){
                /*_handleGoogleSignIn().then((user){
								setState(() {
									_user = user;
								});
							}).catchError((error){
								print(error);
							});*/
                _handleSignIn();
              }
          ),
        ),
        Center(
          child: RaisedButton(
              child: Text(_currentUser != null
                  ? _currentUser.displayName
                  : "No User"),
              onPressed: (){
                _handleSignOut();
              }),
        ),
        Image.network(_photo != null ? _photo : "https://via.placeholder.com/150"),
        Text(_username),
        Text(_userid),
        Text(_useremail),

      ],
    );
  }


  var _googleSignIn = new GoogleSignIn(
    scopes: [
      "email",
      "https://www.googleapis.com/auth/contacts.readonly",
    ],
  );
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account){
      setState(() {
        _currentUser = account;
        if(_currentUser != null){
          _photo = _currentUser.photoUrl;
          _userid = _currentUser.id;
          _useremail = _currentUser.email;
          _username = _currentUser.displayName;
        }
      });

      print(_currentUser);
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async{
    try{
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      print("googleUser:");
      print(googleUser);
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      FirebaseUser user = await _auth.signInWithCredential(credential);
      print(user);
      setState(() {
        _currentUser = googleUser;
        _photo = user.photoUrl;
        _userid = user.uid;
        _useremail = user.email;
        _username = user.displayName;
      });

    } catch(error) {
      print("error:");
      print(error);
    }
  }

  Future<void> _handleSignOut() async{
    _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    setState(() {
      _currentUser = null;
      _photo = "https://via.placeholder.com/150";
      _userid = "";
      _useremail = "example@example.com";
      _username = "NO DATA";
    });
  }
}