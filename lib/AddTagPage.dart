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
				    	Navigator.of(context).pop(_searchResult);
				    }),
		    ],
		    bottom: new PreferredSize(
			    preferredSize:  const Size.fromHeight(48.0),
		      child: Padding(
		        padding: const EdgeInsets.all(0.0),
		        child: new ListTile(
					leading: new Icon(Icons.search, color: Colors.white,),
					title: new TextField(
						controller: _SearchTextController,
						style: new TextStyle(
							color: Colors.white,
						),
						decoration: new InputDecoration(
					        hintText: 'タグを検索...',
							border: InputBorder.none,
							hintStyle: new TextStyle(
								color: Colors.white,
							)
						),
				        onChanged: onSearchTextChanged,),
			        trailing: new IconButton(
				        icon: new Icon(
					        Icons.cancel,
					        color: Colors.white,
				        ),
				        onPressed: () {
				        	_SearchTextController.clear();
				        	onSearchTextChanged('');
				        	},
			        ),
		        ),
		      ),
		    ),
	    ),
	    //検索ボックスが空でないもしくは検索結果がある場合は検索結果を表示、それ以外は全部を表示
	    body: _searchResult.length != 0 || _SearchTextController.text.isNotEmpty
	    ? new ListView.builder(
		    itemCount: _searchResult.length,
		    padding: const EdgeInsets.only(top: 10.0),
		    itemBuilder: (context, index) => _TagItemViewByTxt(_searchResult[index]),
	    )
	    : new StreamBuilder(
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

		Firestore.instance.collection("Tags").where("tag",isGreaterThanOrEqualTo: text).snapshots().listen(
			(data) => _searchResult.add(data.documents[0]["tag"])
		);

		/*_userDetails.forEach((userDetail) {
			if (userDetail.firstName.contains(text) || userDetail.lastName.contains(text))
				_searchResult.add(userDetail);
		});*/

		setState(() {});
	}


	///タグを表示させるリストのアイテム
	Widget TagItemView(DocumentSnapshot document){
		return _TagItemViewByTxt(document["tag"]);
	}
	Widget _TagItemViewByTxt(String Tag){
		bool IsSelect = _selected.contains(Tag);

		return new CheckboxListTile(
			title: new Text(Tag),
			value: IsSelect,
			onChanged: (next){
				if(next) _selected.add(Tag);
				else _selected.remove(Tag);

				setState(() {
					IsSelect = next;
				});
			}
		);
	}
}

