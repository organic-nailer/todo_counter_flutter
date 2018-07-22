import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTagPage extends StatefulWidget{
	@override
	State createState () => new AddTagPageState();
}

class AddTagPageState extends State<AddTagPage>{

	var _selected = new Set<String>();

	List<String> _searchResult = [];

	final TextEditingController _SearchTextController = new TextEditingController();

	@override
	Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
	    appBar: new AppBar(
		    title: new Text("Tag"),
		    actions: <Widget>[
		    	new IconButton(
				    icon: new Icon(Icons.check),
				    onPressed: (){

				    }),
		    ],
		    bottom: new PreferredSize(
			    preferredSize:  const Size.fromHeight(48.0),
		      child: Padding(
		        padding: const EdgeInsets.all(8.0),
		        child: new ListTile(
					leading: new Icon(Icons.search),
					title: new TextField(
						controller: _SearchTextController,
						decoration: new InputDecoration(
					        hintText: 'Search', border: InputBorder.none),
				        onChanged: onSearchTextChanged,),
			        trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
			        	_SearchTextController.clear();
				        onSearchTextChanged('');},),
		        ),
		      ),
		    ),
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

	onSearchTextChanged(String text) async {
		_searchResult.clear();
		if (text.isEmpty) {
			setState(() {});
			return;
		}

		_userDetails.forEach((userDetail) {
			if (userDetail.firstName.contains(text) || userDetail.lastName.contains(text))
				_searchResult.add(userDetail);
		});

		setState(() {});
	}


	Widget TagItemView(DocumentSnapshot document){
		bool IsSelect = _selected.contains(document["tag"]);

		return new CheckboxListTile(
			title: new Text(document["tag"]),
			value: IsSelect,
			onChanged: (next){
				if(next) _selected.add(document["tag"]);
				else _selected.remove(document["tag"]);

				setState(() {
					IsSelect = next;
				});
			}
		);
	}
}

