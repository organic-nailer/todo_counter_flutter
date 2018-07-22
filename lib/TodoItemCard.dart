import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget TodoItemCard(BuildContext context, DocumentSnapshot document){

	final List<dynamic> Tags = document["tag"];
	/*
	return new ListView.builder(
		itemCount: Tags.length,
		scrollDirection: Axis.horizontal,
		padding: const EdgeInsets.only(top: 1.0),
		itemBuilder: (context, int index) {
			return new Text(Tags[index]);
		});*/

	return new Card(
		color: Colors.white,
		child: new InkWell(
			onTap: () {
				Scaffold.of(context).showSnackBar(new SnackBar(
					content: new Text(
						document['title'] + " Tapped",
						style: new TextStyle(fontFamily: "NotoSansJP"),
					),
				));
			},/*
			child: new ListView.builder(
				itemCount: Tags.length,
				scrollDirection: Axis.horizontal,
				padding: const EdgeInsets.only(top: 1.0),
				itemBuilder: (context, int index) {
					return new Text(Tags[index]);
				}),*/
			child: new ListTile(
				leading: new CircleAvatar(
					backgroundColor: Colors.green,
					child: new Text(
						document['title'].substring(0,1),
						style: new TextStyle(fontFamily: "NotoSansJP"),
					),
				),
				title: new Text(
					document['title'],
					style: new TextStyle(
						fontSize: 25.0,
						fontFamily: "NotoSansJP"
					),
				),
				subtitle: new SizedBox(
					width: 100.0,
				  height: 40.0,
				  child: new ListView.builder(
				  	itemCount: Tags.length,
				  	scrollDirection: Axis.horizontal,
				  	padding: const EdgeInsets.only(top: 1.0),
				  	itemBuilder: (context, int index) {
				  		return Padding(
				  		  padding: const EdgeInsets.all(5.0),
				  		  child: new Card(//TODO: Tooltipも検討
				  		  	color: Colors.yellow,
				  		  	child: Padding(
				  		  	  padding: const EdgeInsets.all(4.0),
				  		  	  child: new Text(
								        Tags[index].toString(),
								        style: new TextStyle(
									        fontSize: 15.0,
								        ),
				  		  	  ),
				  		  	),
					        ),
				  		);
				  	}),
				),
				/*subtitle: new Text(
					document['description'],
					style: new TextStyle(fontFamily: "NotoSansJP"),
				),*/
				trailing: new Text(
					"残り"+document['vote'].toString()+"日",
					style: new TextStyle(
						fontSize: 30.0,
						fontFamily: "NotoSansJP",
					),
				),
				//trailing: new RemainingCounter(_todoitem.date),
			),
		),
	);
}