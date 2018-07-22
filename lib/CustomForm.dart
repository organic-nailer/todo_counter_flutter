import 'package:flutter/material.dart';

class MyCustomForm extends StatefulWidget{
	@override
	_MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm>{
	final myController = TextEditingController();

	@override
	void dispose() {
		myController.removeListener(_printLatestValue);
		myController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Retrieve Text Input'),
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					children: <Widget>[
						TextField(
							onChanged: (text) {
								print("First text field: $text");
							},
						),
						TextField(
							controller: myController,
						),
					],
				),
			),
		);
	}

	_printLatestValue(){
		print("Second text field: ${myController.text}");
	}

	@override
  void initState() {
    // TODO: implement initState
    super.initState();

    myController.addListener(_printLatestValue);
  }
}