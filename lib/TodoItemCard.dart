import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Todo.dart';
import 'DetailPage.dart';

// ignore: non_constant_identifier_names
Widget TodoItemCard(BuildContext context, DocumentSnapshot document){


	final List<dynamic> Tags = document["tag"];
	//final String _title = document['title'];
	final int _remain = document['vote'];
	//final List<dynamic> Tags = ["hoge","piyo","huga"];
	String _title = document['title'];
	//final String _remain = "2";

	if(_title == "") _title = "Null";

	return new Card(
		color: Colors.white,
		child: new InkWell(
			onTap: () {
				Navigator.push(
					context,
					MaterialPageRoute(
						builder: (context) => DetailPage(doc: new Todo.fromDoc(document),),
					),
				);
				Scaffold.of(context).showSnackBar(new SnackBar(
					content: new Text(
						document['title'] + " Tapped",
						style: new TextStyle(fontFamily: "NotoSansJP"),
					),
				));
			},
			child: new ListTile(
				//leading: new Text(_title.substring(0,1)),
				leading: new CircleAvatar(
					backgroundColor: Theme.of(context).primaryColor,
					child: new Text(
						//"Hi-Fi".substring(0,1),
						_title.substring(0,1),
						style: new TextStyle(
							fontFamily: "NotoSansJP",
							fontWeight: FontWeight.bold,
						),
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
				  		  child: new Container(
						      decoration: new BoxDecoration(
							      border: new Border.all(
								      width: 1.0,
								      color: Colors.black12,
							      ),
							      borderRadius: new BorderRadius.circular(8.0),
						      ),
						      child: Padding(
					              padding: const EdgeInsets.all(4.0),
					              child: new Text(
					                  Tags[index].toString(),
					                  style: new TextStyle(
						                  fontFamily: "NotoSansJP",
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
					"残り"+ _remain.toString() +"日",
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