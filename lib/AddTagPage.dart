import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTagPage extends StatefulWidget{
	@override
	State createState () => new AddTagPageState();
}

class AddTagPageState extends State<AddTagPage>{

	var _selected = new List<String>();

	final TextEditingController _AddTagDialogController = new TextEditingController();

	@override
	Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
	    //検索ボックス
	    appBar: new AppBar(
		    title: new Text("タグ"),
		    actions: <Widget>[
		    	new IconButton(
				    icon: new Icon(
					    Icons.add,
					    color: Colors.white,
				    ),
				    onPressed: _showdialog),
		    	new IconButton(
				    icon: new Icon(Icons.check),
				    onPressed: (){
				    	Navigator.of(context).pop(_selected.join(","));
				    }),
		    ],
	    ),
	    body: new StreamBuilder(
		    stream: Firestore.instance.collection("Tags").snapshots(),
		    builder: (context,snapshot){
			    if(!snapshot.hasData) return const Text("Loading...");
			    return new ListView.builder(
				    itemCount: snapshot.data.documents.length,
				    padding: const EdgeInsets.only(top: 10.0),
				    itemBuilder: (context, index) => TagItemView(snapshot.data.documents[index]),
			    );
		    }
	    )
    );
	}

	///タグを表示させるリストのアイテム
	Widget TagItemView(DocumentSnapshot document){
		return _TagItemViewByTxt(document["tag"]);
	}
	Widget _TagItemViewByTxt(String _tag){
		bool _isSelect = _selected.contains(_tag);

		return new CheckboxListTile(
			title: new Text(_tag),
			value: _isSelect,
			onChanged: (next){
				if(next) _selected.add(_tag);
				else _selected.remove(_tag);

				setState(() {
					_isSelect = next;
				});
			}
		);
	}

	_showdialog() async {
		await showDialog(
			context: context,
			builder: (BuildContext context){
				return AlertDialog(
					title: new Text("タグを追加"),
					content: new Row(
						children: <Widget>[
							new Expanded(
								child: new TextField(
									autofocus: true,
									controller: _AddTagDialogController,
									decoration: new InputDecoration(
										hintText: 'Tag'),
								),
							)
						],
					),
					actions: <Widget>[
						FlatButton(
							child: const Text("キャンセル"),
							onPressed: () { Navigator.pop(context); }
						),
						FlatButton(
							child: const Text("追加"),
							onPressed: _AddTagDialogController.text == ""
								? null
								: () {
								Navigator.pop(context, _AddTagDialogController.text);
							}
						)
					]
				);
			}

		).then<void>((value) {
			if (value != null && value != "") {
				Firestore.instance.collection("Tags").document().setData({
					"tag": value,
				});
			}

			setState(() {
				_AddTagDialogController.text = "";
			});
		});
	}
}
