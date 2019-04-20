import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'CustomForm.dart';
import 'TodoItemCard.dart';
import 'AddPage.dart';
import 'AddTagPage.dart';
import 'DetailPage.dart';
import 'Todo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'LoginPage.dart';
import 'TimeLinePage.dart';

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
	      primaryColor: Colors.brown[500],
	      primaryColorDark: Colors.brown[700],
	      primaryColorLight: Colors.brown[100],
	      accentColor: Colors.teal,

	        fontFamily:  "NotoSansJP",
	        textTheme: TextTheme(

	        )

        ),
        //home: new ExpansionTileSample(),
        //home: new MyHomePage(title: "TodoSample",),
        routes: <String, WidgetBuilder>{
          '/': (_) => new MyHomePage(),
          '/add': (_) => new AddPage(),
          '/add/tag': (_) => new AddTagPage(),
          '/form': (_) => new MyCustomForm(),
          '/detail': (_) => new DetailPage(),
	        '/login': (_) => new LoginPage(),
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
			    //Navigator.of(context).pushNamed("/login");
			    //_showNotificationWithDefaultSound();
			    //_showNotificationInBackground();
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

  void _fcmSetup()
  {
	  FirebaseMessaging _fcm = new FirebaseMessaging();
	  _fcm.configure(
		  onMessage: (Map<String, dynamic> message)
		  async {
			  print("onMessage: $message");
			  _buildDialog(context, "onMessage");
		  },
		  onLaunch: (Map<String, dynamic> message)
		  async {
			  print("onLaunch: $message");
			  _buildDialog(context, "onLaunch");
		  },
		  onResume: (Map<String, dynamic> message)
		  async {
			  print("onResume: $message");
			  _buildDialog(context, "onResume");
		  },
	  );
	  _fcm.requestNotificationPermissions(
		  const IosNotificationSettings(sound: true, badge: true, alert: true));
	  _fcm.onIosSettingsRegistered
		  .listen((settings)
	  {
		  print("Settings resistered: $settings");
	  });
	  _fcm.subscribeToTopic("/topics/all");
  }

  void _buildDialog(BuildContext context, String message){
  	showDialog(
	    context: context,
	    barrierDismissible: false,
	    builder: (context) {
	    	return new AlertDialog(
			    content: new Text("Message: $message"),
			    actions: <Widget>[
			    	new FlatButton(
					    onPressed: () { Navigator.pop(context, false); },
					    child: const Text("CLOSE")),
				    new FlatButton(
					    onPressed: () { Navigator.pop(context, true); },
					    child: const Text("OK")),
			    ],
		    );
	    }
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

class SettingsPage extends StatefulWidget{
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;
  FirebaseUser _user;


  @override
  State createState () => new SettingsPageState();


}

class SettingsPageState extends State<SettingsPage>{

	FirebaseUser _user;
	GoogleSignInAccount _currentUser;
	String _username = "";
	String _userid = "";
	String _useremail = "";
	String _photo;

	@override
	Widget build(BuildContext context) {
		return new Container(
			child: _user == null
				? _buildGoogleSignInButton()
				: new Center(
				child: new Icon(Icons.add_shopping_cart),
			),
		);
	}

	Widget _buildGoogleSignInButton() {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: <Widget>[
				Center(
					child: RaisedButton(
						child: Text("Google Sign In"),
						onPressed: (){
							/*_handleGoogleSignIn().then((user){
								setState(() {
									_user = user;
								});
							}).catchError((error){
								print(error);
							});*/
							_handleSignIn();
						}
					),
				),
				Center(
					child: RaisedButton(
						child: Text(_currentUser != null
									? _currentUser.displayName
									: "No User"),
						onPressed: (){
							_handleSignOut();
						}),
				),
				Image.network(_photo != null ? _photo : "https://via.placeholder.com/150"),
				Text(_username),
				Text(_userid),
				Text(_useremail),

			],
		);
	}


	var _googleSignIn = new GoogleSignIn(
		scopes: [
			"email",
			"https://www.googleapis.com/auth/contacts.readonly",
		],
	);
	final _auth = FirebaseAuth.instance;

	@override
	void initState() {
        super.initState();
        _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account){
        	setState(() {
        	  _currentUser = account;
	          if(_currentUser != null){
		          _photo = _currentUser.photoUrl;
		          _userid = _currentUser.id;
		          _useremail = _currentUser.email;
		          _username = _currentUser.displayName;
	          }
        	});

	        print(_currentUser);
        });
        _googleSignIn.signInSilently();
  }

	Future<void> _handleSignIn() async{
		try{
			GoogleSignInAccount googleUser = await _googleSignIn.signIn();
			print("googleUser:");
			print(googleUser);
			GoogleSignInAuthentication googleAuth = await googleUser.authentication;
			AuthCredential credential = GoogleAuthProvider.getCredential(
				accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
			FirebaseUser user = await _auth.signInWithCredential(credential);
			print(user);
			setState(() {
			  _currentUser = googleUser;
			  _photo = user.photoUrl;
			  _userid = user.uid;
			  _useremail = user.email;
			  _username = user.displayName;
			});

		} catch(error) {
			print("error:");
			print(error);
		}
	}

	Future<void> _handleSignOut() async{
		_googleSignIn.disconnect();
		await FirebaseAuth.instance.signOut();
		setState(() {
		  _currentUser = null;
		  _photo = "https://via.placeholder.com/150";
		  _userid = "";
		  _useremail = "example@example.com";
		  _username = "NO DATA";
		});
	}
}