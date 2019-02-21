import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
	String title;
	String description;
	DateTime deadline;
	List<dynamic> tag;

	Todo(String title, String description, DateTime deadline, List<dynamic> tag){
		this.title = title;
		this.description = description;
		this.deadline = deadline;
		this.tag = tag;
	}

	Todo.fromDoc(DocumentSnapshot document){
		this.title = document['title'];
		this.description = document['description'];
		this.deadline = document['deadline'];
		this.tag = document['tag'];
	}
}