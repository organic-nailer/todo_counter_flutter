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

class TaskItem{
	String id; //Firebaseで自動生成されたものを使う
	String title;
	Map<String, dynamic> description;
	Map<String, dynamic> time;
	List<dynamic> tag;
	String genre; // [ Task, Habit, Goal, Schedule ]
	bool done;
	Map<String, dynamic> notify;
	Map<String, dynamic> other_data; //その他のデータを保存

	TaskItem(DocumentSnapshot doc){
		this.id = doc.documentID;
		this.title = doc["title"];
		this.description = {};
		this.time = {};
		this.tag = doc["tag"];
		this.done = doc["done"];
		this.notify = {};
		this.genre = doc["genre"];
		this.other_data = {};
	}
}