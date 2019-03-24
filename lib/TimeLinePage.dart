import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'CustomForm.dart';
import 'TodoItemCard.dart';
import 'AddPage.dart';
import 'AddTagPage.dart';
import 'DetailPage.dart';
import 'Todo.dart';


class TimeLinePage extends StatelessWidget{

	const TimeLinePage({Key key, this.title}) : super(key: key);

	final String title;

	@override
	Widget build(BuildContext context) {
		return new StreamBuilder(
			stream: Firestore.instance.collection('Todos').where("done", isEqualTo: false).snapshots(),
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
	}
}