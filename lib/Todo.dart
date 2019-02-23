import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
	String id;
	String title;
	String description;
	DateTime deadline;
	List<dynamic> tag;

	Todo(this.id, this.title, this.description, this.deadline, this.tag);

	Todo.fromDoc(DocumentSnapshot document){
		this.id = document.documentID;
		this.title = document['title'];
		this.description = document['description'];
		this.deadline = document['deadline'];
		this.tag = document['tag'];
	}
}