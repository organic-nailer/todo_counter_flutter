import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget{

	@override
	State createState () => new LoginPageState();
}

class LoginPageState extends State<LoginPage>{

	FirebaseUser _firebaseUser;
	GoogleSignInAccount _googleSignInAccount;
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
        _checkfirebasesignin();
    }

    void _checkfirebasesignin() async {
	    FirebaseUser user = await _auth.currentUser();
	    if (user != null) {
		    Navigator.pop(context);
		    print("Already login");
	    } else {
		    // No user is signed in
	    }
    }


	@override
	Widget build(BuildContext context) {
    return new Container(
	    color: Colors.white,
	    child: new Center(
		    child: Column(
			    mainAxisSize: MainAxisSize.min,
			    children: <Widget>[
				    Padding(
					    padding: const EdgeInsets.symmetric(horizontal: 175.0),
					    child: Image.asset("image/TDC_icon.png"),
				    ),
				    Padding(
					    padding: const EdgeInsets.all(8.0),
					    child: new Text(
						    "TodoCounter",
						    style: TextStyle(
							    color: Colors.black,
							    decoration: TextDecoration.underline,
						    ),
					    ),
				    ),
				    Padding(
					    padding: const EdgeInsets.all(8.0),
					    child: GoogleSignInButton(
						    onPressed: _handleSignIn,
					    ),
				    )
			    ],
		    ),
	    ),
    );
  }

  Future<void> _handleSignIn() async {
		try{
			GoogleSignInAccount googleUser = await _googleSignIn.signIn();
			GoogleSignInAuthentication googleAuth = await googleUser.authentication;

			AuthCredential credential = GoogleAuthProvider.getCredential(
				idToken: googleAuth.idToken,
				accessToken: googleAuth.accessToken,
			);
			FirebaseUser user = await _auth.signInWithCredential(credential);

			setState(() {
			  _firebaseUser = user;
			  _googleSignInAccount = googleUser;
			});
			print("signed in:");
			print(_firebaseUser);

			Navigator.pop(context);
		} catch(error){
			print(error);
		}
  }
}