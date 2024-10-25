import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:temari/core/auth/user_profile.dart';
import 'package:temari/core/utils/network_access.dart';
import 'package:temari/core/settings/settings.dart';
import 'package:temari/core/utils/navigation.dart';
import 'package:temari/features/home/chaild/student_text_list.dart';
import 'package:temari/features/home/recent_books.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, List<Map<String, dynamic>>>>? groupedBooksFuture;

  //getting the users
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User? _user;

  Future<void> _checkIfUserSignedIn() async {
    // Check if a user is already signed in
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        _user = currentUser;
      });
    }
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

  @override
  void initState() {
    super.initState();
    _checkIfUserSignedIn();
    groupedBooksFuture = fetchAndGroupBooks('3');
  }

  Future<Future<Map<String, List<Map<String, dynamic>>>>?> _doRefresh() async {
    setState(() {
      groupedBooksFuture = fetchAndGroupBooks('3');
    });
    return groupedBooksFuture;
  }

  Widget headerWidget() {
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('${_user!.photoURL.toString()}'),
          ),
          SizedBox(width: 8),
          Text(_user!.displayName.toString()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          if (_user != null)
            InkWell(
                onTap: () {
                  navigatePush(
                      context: context, page: UserProfile(userData: _user!));
                },
                child: headerWidget()),
          (_user == null)
              ? IconButton(
                  onPressed: () {
                    signInWithGoogle();
                  },
                  icon: const Text('login'))
              : IconButton(
                  onPressed: () {
                    signOutGoogle();
                  },
                  icon: const Text('Logout')),
          Expanded(child: Container()),
          IconButton(
              onPressed: () {
                setState(() {
                  groupedBooksFuture = fetchAndGroupBooks('3');
                });
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.red,
              )),
          IconButton(
              onPressed: () {
                navigatePush(page: Settings(), context: context);
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.orange,
              )),
        ],
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: fetchAndGroupBooks('3'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Saved Books',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  RecentBooks(),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Saved Books',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  RecentBooks(),
                ],
              ),
            );
          }
          Map<String, List<Map<String, dynamic>>> groupedBooks = snapshot.data!;
          final screenWidth = MediaQuery.of(context).size.width;
          return RefreshIndicator(
            onRefresh: _doRefresh,
            strokeWidth: RefreshProgressIndicator.defaultStrokeWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const NewsHome(),
                  studentTextGridView(groupedBooks, screenWidth),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Saved Books',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(),
                  const RecentBooks(),
                  // Container(
                  //   height: 100,
                  //   margin: const EdgeInsets.all(10),
                  //   decoration: const BoxDecoration(color: Colors.yellow),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         'Exam and Other Future ',
                  //         style: TextStyle(color: Colors.red, fontSize: 20),
                  //       ),
                  //       Text('Comming Soon',style: TextStyle(color: Colors.red, fontSize: 10))
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
