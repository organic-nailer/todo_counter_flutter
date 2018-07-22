import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'CustomForm.dart';
import 'TodoItemCard.dart';
import 'AddPage.dart';
import 'AddTagPage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.green,
      ),
      //home: new ExpansionTileSample(),
      //home: new MyHomePage(title: "TodoSample",),
      routes: <String, WidgetBuilder>{
        '/': (_) => new MyHomePage(),
        '/add': (_) => new AddPage(),
        '/add/tag': (_) => new AddTagPage(),
        '/form': (_) => new MyCustomForm(),

      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  State createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
	    appBar: new AppBar(
		    title: new Text("App$_page"),
	    ),
      body: new PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          new TimeLinePage(),
          new GenrePage(),
          new SettingsPage(),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
	      fixedColor: Theme.of(context).primaryColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: _page,
          onTap: onTapBottomNavigation,
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.timeline),
                title: new Text("TimeLine"),),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.assignment),
              title: new Text("Genre"),),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.settings),
              title: new Text("Setting"),),
          ]
      ),
	    floatingActionButton: new FloatingActionButton(
		    child: new Icon(Icons.add),
		    onPressed: (){
              Navigator.of(context).pushNamed("/add");
            }),
    );
  }

  void onPageChanged(int page){
    setState(() {
      this._page = page;
    });
  }

  void onTapBottomNavigation(int page){
    _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = new PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _pageController.dispose();
  }
}

class TimeLinePage extends StatelessWidget{

  const TimeLinePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('Todos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return new ListView.builder(
            itemCount: snapshot.data.documents.length,
            padding: const EdgeInsets.only(top: 10.0),
            //itemExtent: 100.0,
            itemBuilder: (context, index) => TodoItemCard(context, snapshot.data.documents[index]),
            /*
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  return new Text(" ${ds['title']},${ds['description']},${ds['vote']}");
                }*/
          );
        });
  }
}

class GenrePage extends StatelessWidget{
  const GenrePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Icon(Icons.description),
    );
  }
}

class SettingsPage extends StatelessWidget{
  const SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Icon(Icons.settings),
    );
  }
}
/*
class ExpansionTileSample extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("TodoCounter"),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          backgroundColor: Colors.green,
          onPressed: (){}),
      body: new TodoList(),
      /*
      body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) => new EntryItem(data[index]),
      itemCount: data.length,),*/
    );
  }
}*/

class TodoItem{
  final String title;
  final String description;
  final DateTime date;
  final List<String> tag;
  final String type;

  const TodoItem({this.title,this.date,this.description,this.tag,this.type});
}

//残り○日の部分のUI
class RemainingCounter extends StatelessWidget{
  final DateTime _date;
  RemainingCounter(this._date);

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Text(
          "残り"
        ),
        new Text(
          _date.day.toString(),
          style: new TextStyle(fontSize: 20.0),
        ),
        new Text(
          "日"
        ),
      ],
    );
  }
}

//サンプルのリスト
/*
class TodoList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: new EdgeInsets.symmetric(vertical: 8.0),
      children: <Widget>[
        new TodoListItem(new TodoItem(
          title: "PTA書類提出",
          description: "HR",
          date: new DateTime.now()
        )),
        new TodoListItem(new TodoItem(
            title: "化学レポ",
            description: "化学準備室",
            date: new DateTime.now()
        )),
        new TodoListItem(new TodoItem(
            title: "ダイエー志木店",
            description: "閉店セール",
            date: new DateTime.now()
        )),
        new TodoListItem(new TodoItem(
            title: "AQUOS R",
            description: "SH-03J",
            date: new DateTime.now()
        )),
        new TodoListItem(new TodoItem(
            title: "Google Home",
            description: "Google Assistant",
            date: new DateTime.now()
        )),
        new TodoListItem(new TodoItem(
            title: "Google",
            description: "Assistant",
            date: new DateTime.now()
        )),
        new TodoListItem(new TodoItem(
            title: "Google",
            description: "Assistant",
            date: new DateTime.now()
        )),
        new TodoListItem(new TodoItem(
            title: "Google",
            description: "Assistant",
            date: new DateTime.now()
        )),
        new TodoListItem(new TodoItem(
            title: "Google",
            description: "Assistant",
            date: new DateTime.now()
        )),
        new TodoListItem(new TodoItem(
            title: "Google",
            description: "Assistant",
            date: new DateTime.now()
        )),
        new TodoListItem(new TodoItem(
            title: "Google",
            description: "Assistant",
            date: new DateTime.now()
        )),
      ],
    );
  }
}*/