import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget{
	@override
	State createState () => new DetailPageState();
}

class DetailPageState extends State<DetailPage>{
	double appBarHeight = 128.0;
	@override
	Widget build(BuildContext context) {
    // TODO: implement build
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
										    "HogeHogeHoge",
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
										    child: new IconButton(
											    icon: new Icon(
												    Icons.more_vert,
												    color: Colors.white,
											    ),
											    onPressed: null),
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
					        title: new Text("2019年8月16日2時59分"),
				        ),
				        new Divider(color: Colors.grey,),
				    ]
			    )
		    ),
		    new Positioned(
			    child: new FloatingActionButton(
				    child: new Icon(Icons.edit),
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