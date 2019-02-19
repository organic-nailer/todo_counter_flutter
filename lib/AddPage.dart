import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import "DateTimePicker.dart";

class AddPage extends StatefulWidget{
	@override
	State createState () => new AddPageState();
}

DateTime _date = new DateTime.now();
TimeOfDay _time = new TimeOfDay.now();

List<String> _selectedTags = [];

class AddPageState extends State<AddPage>{
	//const AddPage({Key key, this.title}) : super(key: key);

	final TextEditingController _titleTextController = new TextEditingController();
	final TextEditingController _descriptionTextControllder = new TextEditingController();
	final TextEditingController _tagsViewController = new TextEditingController();
	//final String title;
	String _tags = "タグを編集...";

	//DateTime _fromDate = new DateTime.now();
	//TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);


	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: new AppBar(
				leading: new IconButton(
					icon: new Icon(Icons.close),
					onPressed: (){
						Navigator.of(context).pop();
					}),
				title: new Text("Add"),
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
							Firestore.instance.collection("Todos").document().setData({
								"title": _titleTextController.text,
								"description": _descriptionTextControllder.text,
								"vote": _date.day,
								"deadline": new DateTime(_date.year,_date.month,_date.day,_time.hour,_time.minute),
								"tag": []
							});
							Navigator.of(context).pop();
						}
					),
				],
			),
			body: new ListView(
				children: <Widget>[

					new ListTile(
						leading: new Icon(Icons.schedule),
						title: new Text("タスク"),
						subtitle: new Text("hykwyuk0125@gmail.com"),
					),
					new Divider(color: Colors.grey,),
					new ListTile(
						leading: new Icon(Icons.date_range),
						title: DateTimePickerw(),
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
								hintText: "詳細",
								hintStyle: new TextStyle(
									color: Colors.black,
									fontFamily: "NotoSansJP",
								)
							),
						),
					),
					new Divider(color: Colors.grey,),
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
								var _result = (await Navigator.of(context).pushNamed("/add/tag")).toString();
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

class DateTimePickerw extends StatefulWidget{
	@override
	_DateTimePickerwState createState() => new _DateTimePickerwState();
}

class _DateTimePickerwState extends State<DateTimePickerw>{

	//DateTime _date = new DateTime.now();
	//TimeOfDay _time = TimeOfDay.now();

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

