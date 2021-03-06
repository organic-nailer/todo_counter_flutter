import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import "DateTimePicker.dart";
import 'Todo.dart';
import 'AddTagPage.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AddPage extends StatefulWidget{
	final TaskItem todo;
	AddPage({Key key, @required this.todo}) : super (key: key);

	@override
	State createState () => new AddPageState();
}

DateTime _date = new DateTime.now();
TimeOfDay _time = new TimeOfDay.now();

List<dynamic> _selectedTags = [];

class AddPageState extends State<AddPage>{
	//const AddPage({Key key, this.title}) : super(key: key);

	final TextEditingController _titleTextController = new TextEditingController();
	final TextEditingController _descriptionTextControllder = new TextEditingController();
	//final String title;
	String _tags = "タグを編集...";
	bool _iseditmode = false;
	String _title = "";

	FirebaseUser _user;

	@override
	void initState() {
		super.initState();
		if(widget.todo != null){
			_iseditmode = true;
			_titleTextController.text = widget.todo.title;
			_descriptionTextControllder.text = widget.todo.description["description"];
			_tags = widget.todo.tag.join(",");
			_selectedTags = widget.todo.tag;
			_date = widget.todo.time["deadline"];
			_time = TimeOfDay.fromDateTime(_date);
		}
		else{
			_selectedTags = [];
		}

		if(_iseditmode) _title = "編集";
		else _title = "追加";

		SigninFirebase();
	}

	void SigninFirebase() async {
		_user = await FirebaseAuth.instance.currentUser();
	}

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: new AppBar(
				leading: new IconButton(
					icon: new Icon(Icons.close),
					onPressed: (){
						Navigator.of(context).pop();
					}),
				title: new Text(_title),
				bottom: PreferredSize(
					preferredSize: const Size.fromHeight(48.0),
					child: Theme(
						data: Theme.of(context).copyWith(accentColor: Colors.white),
						child: Padding(
						  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2.0),
						  child: Container(
						  	height: 48.0,
						  	alignment: Alignment.center,
						  	child: new TextField(
						  		autofocus: true,
						  		style: new TextStyle(
						  			fontSize: 20.0,
						  			color: Colors.white,
						  			fontFamily: "NotoSansJP"
						  		),
						  		controller: _titleTextController,
						  		decoration: new InputDecoration(
						  			border: InputBorder.none,
						  			hintText: "タイトル",
						  			hintStyle: new TextStyle(
						  				fontSize: 20.0,
						  				color: Colors.white,
						  				fontFamily: "NotoSansJP",
						  			)
						  		),
						  	),
						  ),
						),
					),
				),
				actions: <Widget>[
					IconButton(
						icon: new Icon(Icons.check),
						onPressed: (){
							if(_titleTextController.text == ""){
								Scaffold.of(context).showSnackBar(new SnackBar(
									content: new Text("Input Title...")
								));
								return;
							}

							var item = {
								"title": _titleTextController.text,
								"description": {
									"description": _descriptionTextControllder.text,
								},
								"time": {
									"deadline": new DateTime(_date.year,_date.month,_date.day,_time.hour,_time.minute),
									"createdat": new DateTime.now(),
								},
								"tag": _selectedTags,
								"done": false,
								"notify": {},
								"genre": "TASK",
								"other_data": {},
							};

							if(_iseditmode){
								Firestore.instance
										 .collection("Todos")
										 .document(widget.todo.id)
										 .updateData(item);
								Firestore.instance
										.collection("Users")
										.document(_user.uid)
										.collection("Tasks")
										.document(widget.todo.id)
										.updateData(item);
								Navigator.of(context).pop();
							}
							else{
								Firestore.instance
										 .collection("Todos")
										 .document()
										 .setData(item);
								Firestore.instance.collection("Users/${_user.uid}/Tasks")
										.document().setData(item);
							}
							Navigator.of(context).pop();
						}
					),
				],
			),
			body: new ListView(
				children: <Widget>[

					new ListTile(
						leading: new Icon(Icons.info),
						title: new Text("タスク"),
						subtitle: new Text("example@example.com"),
					),
					new Divider(color: Colors.grey,),
					new ListTile(
						leading: new Icon(Icons.date_range),
						title: DateTimePicker_stateful(),
					),
					new Divider(color: Colors.grey,),
					new ListTile(
						leading: new Icon(Icons.description),
						title: new TextField(
							style: new TextStyle(
								color: Colors.black,
								fontFamily: "NotoSansJP"
							),
							controller: _descriptionTextControllder,
							decoration: new InputDecoration(
								border: InputBorder.none,
								hintText: "説明を追加...",
								hintStyle: new TextStyle(
									color: Colors.black,
									fontFamily: "NotoSansJP",
								)
							),
						),
					),
					new Divider(color: Colors.grey,),
					new ListTile(
						leading: new Icon(Icons.notifications),
						title: new Text("通知を追加..."),
					),
					new Divider(color: Colors.grey),
					new ListTile(
						leading: new Icon(Icons.label),
						title: new InkWell(
						  child: new Text(
							  "$_tags",
							  style: new TextStyle(
						  		color: Colors.black,
						  		fontFamily: "NotoSansJP"
						  	),
						  ),
							onTap: () async {
								var _result = (await Navigator.push(
									context,
									MaterialPageRoute(
										builder: (context) => AddTagPage(preselected: _selectedTags,)
									)
								)).toString();
								if(_result != ""){
									setState(() {
										_tags = _result;
									});
									_selectedTags = _result.split(',');
								}
								else{
									setState(() {
										_tags = "タグを追加...";
									});
									_selectedTags = [];
								}
							},
						),
					),
					new Divider(color: Colors.grey,),
				],
			)
		);
	}
}

class DateTimePicker_stateful extends StatefulWidget{
	@override
	_DateTimePickerState createState() => new _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker_stateful>{

	//DateTime _date = new DateTime.now();
	//TimeOfDay _time = TimeOfDay.now();


	@override
	void initState() {
    super.initState();
  }
	// TODO: 日付を現在時刻にする
	@override
	Widget build(BuildContext context) {
    // TODO: implement build
		return new DateTimePicker(
			labelText: "From",
			selectedDate: _date,
			selectedTime: _time,
			selectDate: (DateTime date){
				setState((){
					_date = date;
				});
			},
			selectTime: (TimeOfDay time){
				setState(() {
					_time = time;
				});
			},
		);
  }
}

