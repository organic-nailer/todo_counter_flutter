import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import 'CustomForm.dart';
import 'TodoItemCard.dart';
import 'AddPage.dart';
import 'AddTagPage.dart';
import 'DetailPage.dart';
import 'Todo.dart';


class TimeLinePage extends StatefulWidget{
	const TimeLinePage({Key key, this.title}) : super(key: key);

	final String title;

	@override
	State<StatefulWidget> createState() => new TimeLinePageState();
}

class TimeLinePageState extends State<TimeLinePage>{

	FirebaseUser _user;
	FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
	var _fcmtoken;

	@override
	void initState() {
        super.initState();
        firebaseCloudMessaging_Listeners();
        _checksignedin();
    }

    void _checksignedin() async {
	    _user = await FirebaseAuth.instance.currentUser();
		setState(() {
			_user = _user;
		});
		if(_user == null){
			Navigator.of(context).pushNamed("/login");
		}
		else{
			print("logged in as" + _user.displayName);

			var _userdata = await Firestore.instance.collection("Users").document(_user.uid).get();
			if(_userdata.data == null) _createDocs(_user.uid);
		}
    }

    void _createDocs(String id) async {
		print("create: $id");
		Firestore.instance.collection("Users").document(id).setData({
			"plan": "Standard",
			"username": _user.displayName,
		});

		Firestore.instance.collection("/Users/$id/Devices").document().setData({
			"deviceID": _fcmtoken,
			"name": "",
			"createdAt": DateTime.now(),
		});

		Firestore.instance.collection("/Users/$id/Tags").document().setData({
			"name": "重要"
		});

		Firestore.instance.collection("/Users/$id/Tasks").document().setData(
			TaskItem.create("サンプル",
							{ "description": "詳細" },
							{ "deadline": DateTime.now() },
							[],
							false,
							{},
							"TASK",
							{}).ToMap());
    }

    void firebaseCloudMessaging_Listeners(){
		//if(Platform.isIOS) iOS_Permission();

		_firebaseMessaging.getToken().then((token) {
			setState(() {
				_fcmtoken = token;
			});
			print(_fcmtoken);
		});
    }

	@override
	Widget build(BuildContext context) {
		try{
			return new StreamBuilder(
				stream: Firestore.instance
					.collection("Users").document(_user.uid)
					.collection("Tasks").snapshots(),
				builder: (context, snapshot) {
					if (!snapshot.hasData) return const Text('Loading...');
					return new ListView.builder(
						itemCount: snapshot.data.documents.length,
						padding: const EdgeInsets.only(top: 10.0),
						//itemExtent: 100.0,
						itemBuilder: (context, index){
							return TodoItemCard(context, new TaskItem(snapshot.data.documents[index]));
						},
					);
				});
		} catch(error){
			print(error);
			return new Container(color: Colors.lightBlueAccent,);
		}
	}

	//TODO: うまくデバイス名を取得できない
	Future<String> _getDeviceInfo() async {
		DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

		var _name = "";
		if(Theme.of(context).platform == TargetPlatform.android){
			deviceInfo.androidInfo.then((AndroidDeviceInfo info){
				print("brand: ${info.brand}");
				print("model: ${info.model}");
				_name = info.brand + " " + info.model;

			});
		}
		else {
			deviceInfo.iosInfo.then((IosDeviceInfo info){
				_name = info.name;
			});
		}

		return _name;
	}
}