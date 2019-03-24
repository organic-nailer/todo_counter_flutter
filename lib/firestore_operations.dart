import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Todo.dart';

class operate_todo_firestore {

	var _notification;
	var _context;

	operate_todo_firestore(context){
		_context = context;
		_notification = new local_notify(_context);
	}

	final _collection_name = "Todos";

	Future Add(TaskItem item) async {
		Firestore.instance.collection("Todos").add(item.ToMap()).then((id) => {
			_notification.scheduled(id, item.time["deadline"])
		});
	}

	void Update(String id, Map<String, dynamic> item){
		Firestore.instance.collection("Todos").document(id).updateData(item);
		if(item.containsKey("time")
			&& (item["time"] as Map<String, dynamic>).containsKey("deadline")){
			_notification.cancel(id);
			_notification.schedule(id, (item["time"] as Map<String, dynamic>)["deadline"]);
		}
	}

	void Delete(String id){
		Firestore.instance.collection("Todos").document(id).delete();
		_notification.cancel(id);
	}
}

class local_notify{
	var flutterLocalNotificationsPlugin;
	var _context;

	local_notify(context){
		_context = context;
		var initializationSettingsAndroid = new AndroidInitializationSettings("app_icon");
		var initializationSettingsIOS = new IOSInitializationSettings();
		var initializationSettings = new InitializationSettings(
			initializationSettingsAndroid, initializationSettingsIOS);
		flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
		flutterLocalNotificationsPlugin.initialize(
			initializationSettings, onSelectNotification: _onSelect);
	}

	Future _onSelect(String payload) async {
		showDialog(
			context: _context,
			builder: (_) {
				return new AlertDialog(
					title: Text("PayLoad"),
					content: Text("Payload : $payload"),
				);
			},
		);
	}

	Future show() async {
		var androidPlatformChannelSpecifics = new AndroidNotificationDetails("master", "master", "master");
		var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
		var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
		await flutterLocalNotificationsPlugin.show();
	}

	Future scheduled(String id, date) async {
		var android = new AndroidNotificationDetails("master", "master", "master");
		var iOS = new IOSNotificationDetails();
		var platformChannelSpecifics = new NotificationDetails(android, iOS);
		await flutterLocalNotificationsPlugin.schedule(id, "hoge", "hoge", date, platformChannelSpecifics);
	}

	Future cancel(String id) async {
		await flutterLocalNotificationsPlugin.cancel(id);
	}
}