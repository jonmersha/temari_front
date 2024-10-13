import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'user_profile.dart';
class UserSignIn extends StatefulWidget {
  const UserSignIn({super.key});

  @override
  State<UserSignIn> createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkIfUserSignedIn();
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      setState(() {
        _user = user;
        _checkIfUserSignedIn();
      });

      return user;
    }
    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    setState(() {
      _user = null;
    });
  }

  Future<void> _checkIfUserSignedIn() async {
    // Check if a user is already signed in
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        _user = currentUser;
      });
    }
  }

  Widget headerWidget(){
    return  Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:  NetworkImage('${_user!.photoURL.toString()}'),
          ),
          SizedBox(width: 8),
          Text(_user!.displayName.toString()),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return (_user != null)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(_user!.displayName.toString()),
                accountEmail: Text(_user!.email.toString()),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      NetworkImage('${_user!.photoURL.toString()}'),
                ),
              ),
              if (_user != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfile(userData: _user!),
                                ),
                              );

                    }, child: const Text("Edit Profile",style: TextStyle(fontWeight:FontWeight.bold ))),
                    TextButton(onPressed: () {}, child: const Text("Sale Products",style: TextStyle(fontWeight:FontWeight.bold ))),
                    TextButton(
                        onPressed: signOutGoogle, child: const Text("SingOut",style: TextStyle(fontWeight:FontWeight.bold ,color: Colors.red),),),
                  ],
                )
            ],
          )
        : DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                    onPressed: signInWithGoogle, child: Text("Login")),
              ],
            ),
          );
  }
}
