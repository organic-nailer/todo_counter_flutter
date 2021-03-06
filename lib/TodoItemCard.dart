import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Todo.dart';
import 'DetailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
Widget TodoItemCard(BuildContext context, TaskItem todo){

	return new Card(
		color: MatchwithDeadColor(todo.time["deadline"].toDate()),
		child: new InkWell(
			onTap: (){_pushToEditPage(context, todo);},
			child: GestureDetector(
				onLongPress: () async {
					await showDialog(
						context: context,
						builder: (BuildContext context){
							return SimpleDialog(
								title: new Text("操作"),
								children: <Widget>[
									SimpleDialogOption(
										onPressed: () async {
											SharedPreferences prefs = await SharedPreferences.getInstance();
											if(prefs.containsKey("userid")){
												Firestore.instance.collection("Todos/${prefs.getString("userid")}/Tasks")
														.document(todo.id).setData({"done": true}, merge: true);
											}
											Navigator.pop(context);
										},
										child: new Text("完了とする"),
									),
									SimpleDialogOption(
										onPressed: (){
											Navigator.pop(context);
											_pushToEditPage(context, todo);
										},
										child: new Text("編集"),
									),
									SimpleDialogOption(
										onPressed: () async {
											SharedPreferences prefs = await SharedPreferences.getInstance();
											if(prefs.containsKey("userid")){
												Firestore.instance.collection("Users/${prefs.getString("userid")}/Tasks")
														.document(todo.id).delete();
											}
											Navigator.pop(context);
										},
										child: new Text("削除"),
									)
								],
							);
						}
					);
				},
			  child: new ListTile(
			  	leading: new CircleAvatar(
			  		backgroundColor: Theme.of(context).primaryColor,
			  		child: new Text(
			  			todo.title.substring(0,1),
			  			style: new TextStyle(
			  				fontWeight: FontWeight.bold,
			  			),
			  		),
			  	),
			  	title: new Text(
			  		todo.title,
			  		style: new TextStyle(
			  			fontSize: 25.0,
			  		),
			  	),
			  	subtitle: todo.tag.length != 0
			  	? new SizedBox(
			  		width: 100.0,
			  	  height: 40.0,
			  	  child: new ListView.builder(
			  	  	itemCount: todo.tag.length,
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
			  		                  todo.tag[index].toString(),
			  		                  style: new TextStyle(
			  		                      fontSize: 15.0,
			  		                  ),
			  		              ),
			  		          ),
			  		      ),
			  	  		);
			  	  	}),
			  	)
			  	: null,
			  	trailing: CountRemainView(context, todo.time["deadline"].toDate())
			  ),
			),
		),
	);
}

void _pushToEditPage(BuildContext context, TaskItem todo){
	Navigator.push(
		context,
		MaterialPageRoute(
			builder: (context) => DetailPage(doc: todo,),
		),
	);
}

Widget CountRemainView(BuildContext context, DateTime deadline){
	var Time_now = new DateTime.now();
	Duration differ = deadline.difference(Time_now);
	var txt = "残り";

	if(differ.inSeconds.abs() <= 60) txt += differ.inSeconds.toString() + "秒";
	else if(differ.inMinutes.abs() <= 60) txt += differ.inMinutes.toString() + "分";
	else if(differ.inHours.abs() <= 24) txt += differ.inHours.toString() + "時間";
	else if(differ.inDays.abs() <= 365) txt += differ.inDays.toString() + "日";
	else txt += (differ.inDays / 365.0).toStringAsFixed(2) + "年";

	return new Text(
		txt,
		style: new TextStyle(
			fontSize: 30.0,
		),
	);
}

Color MatchwithDeadColor(DateTime deadline){
	Duration differ = deadline.difference(new DateTime.now());

	if(differ.isNegative) return Color.fromARGB(255, 255, 0, 0);
	else if(differ.inDays <= 1) return Color.fromARGB(255, 255, 125, 0);
	else if(differ.inDays <= 7) return Color.fromARGB(255, 255, 255, 0);
	else if(differ.inDays <= 30) return Color.fromARGB(255, 255, 255, 125);
	else return Color.fromARGB(255, 255, 255, 255);
}