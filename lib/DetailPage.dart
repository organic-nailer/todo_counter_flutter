import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Todo.dart';


class DetailPage extends StatelessWidget{
	double appBarHeight = 128.0;
	Todo doc;

	DetailPage({Key key, @required this.doc}) : super(key: key);

	@override
	Widget build(BuildContext context) {
    return new Stack(
	    children: <Widget>[
		    new Scaffold(
			    appBar: new PreferredSize(
				    preferredSize: new Size(MediaQuery.of(context).size.width, appBarHeight),
				    child: new Container(
					    color: Theme.of(context).primaryColor,
					    child: new Container(
						    margin: const EdgeInsets.only(top: 30.0),
						    child: new Stack(
							    children: <Widget>[
							    	new Positioned(
									    left: 0.0,
									    top: 0.0,
									    child: new Row(
											children: <Widget>[
											new IconButton(
												icon: new Icon(
													Icons.arrow_back,
													color: Colors.white,
												),
												onPressed: () {
													Navigator.pop(context, false);
												}
											),
											new Text(
												"詳細",
												style: new TextStyle(
													color: Colors.white,
													fontWeight: FontWeight.bold,
													fontSize: 20.0,
													fontFamily: "NotoSansJP",
												),
											)]
										)
								    ),
								    new Positioned(
									    left: 0.0,
									    bottom: 0.0,
									    child: Padding(
									      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
									      child: new Text(
										    doc.title,
										    style: new TextStyle(
											    color: Colors.white,
											    fontSize: 20.0,
											    fontFamily: "NotoSansJP",
										    ),
									      ),
									    )
								    ),
								    new Positioned(
									    right: 0.0,
									    top: 0.0,
									    child: Padding(
										    padding: const EdgeInsets.all(0.0),
										    child: Row(
										      children: <Widget>[
										      	new IconButton(
											        icon: new Icon(
												        Icons.edit,
												        color: Colors.white,
											        ),
											        onPressed: null),
										        new IconButton(
											        icon: new Icon(
												        Icons.more_vert,
												        color: Colors.white,
											        ),
											        onPressed: null),
										      ],
										    ),
									    ))
							    ],
						    ),
					    )
				    )
			    ),
			    body: new ListView(
				    children: <Widget>[
				        new ListTile(
						    leading: new Icon(Icons.schedule),
					        title: new Text("タスク"),
					        subtitle: new Text("example@example.com"),
				        ),
				        new Divider(color: Colors.grey,),
				        new ListTile(
					        leading: new Icon(Icons.calendar_today),
					        title: new Text(doc.deadline.toString()),
				        ),
				        new Divider(color: Colors.grey,),
					    new ListTile(
						    leading: new Icon(Icons.description),
						    title: new Text(doc.description),
					    ),
					    new Divider(color: Colors.grey,),
					    new ListTile(
						    leading: new Icon(Icons.label),
						    title: new Text(doc.tag.join(",")),
					    ),
					    new Divider(color: Colors.grey,),
				    ]
			    )
		    ),
		    new Positioned(
			    child: new FloatingActionButton(
				    child: new Icon(Icons.check),
				    onPressed: () {
					    print('FAB tapped!');
				    },
				    backgroundColor: Theme.of(context).accentColor,
			    ),
			    right: 10.0,
			    top: appBarHeight - 5.0,
		    )
	    ],
    );
  }
}