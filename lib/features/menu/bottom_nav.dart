import 'package:flutter/material.dart';
//import 'package:temari/core/auth/sign_in_header.dart';
import 'package:temari/core/auth/user_profile.dart';
import 'package:temari/features/home/home.dart';


class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  int _pageIndex = 0;
  //
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();
  // User? _user;
  //
  // Future<void> _checkIfUserSignedIn() async {
  //   // Check if a user is already signed in
  //   User? currentUser = _auth.currentUser;
  //   if (currentUser != null) {
  //     setState(() {
  //       _user = currentUser;
  //     });
  //   }
  //   else{
  //     //signInWithGoogle();
  //   }
  // }

  // Future<User?> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //   if (googleUser != null) {
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     final UserCredential userCredential = await _auth.signInWithCredential(credential);
  //     final User? user = userCredential.user;
  //
  //     setState(() {
  //       _user = user;
  //       print('User Signed in with google');
  //     });
  //
  //     return user;
  //   }
  //   return null;
  // }
  //
  // Future<void> signOutGoogle() async {
  //   await googleSignIn.signOut();
  //   setState(() {
  //     _user = null;
  //   });
  // }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_checkIfUserSignedIn();
  }


  List<BottomNavigationBarItem> _buildFourItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Banking',
        backgroundColor: Colors.blue,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.school),
        label: 'Courses',
        backgroundColor: Colors.blueGrey,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.group),
        label: 'Study Group',
        backgroundColor: Colors.green,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
        backgroundColor: Colors.yellow,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
        backgroundColor: Colors.purple,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (int index) {
          setState(
            () {
              _pageIndex = index;
            },
          );
        },
        children: _buildThreePageViewChildren(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _buildThreeItems(),
        onTap: (int index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        },
        currentIndex: _pageIndex,
        fixedColor: Theme.of(context).primaryColor,
      ),
    );
  }

  List<Widget> _buildThreePageViewChildren() {
    return <Widget>[
      Container(
        color: Colors.blue,
        child: Container(
          //margin: EdgeInsets.only(bottom: 100),

          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(1000),
              bottomLeft: Radius.circular(200),
            ),
          ),

          child: HomePage(),
        ),
      ),
      Container(color: Colors.blueGrey),
      Container(color: Colors.green),
      Container(

          color: Colors.yellow,
      //child:UserProfile(userData: ,)
      ),
      Container(

          color: Colors.purple,
        child: Container(
          //margin: EdgeInsets.only(bottom: 100),

          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(1000),
              bottomLeft: Radius.circular(200),
            ),
          ),

          child: SafeArea(child: Container()),
        ),

      ),
    ];
  }
  //MerchatProfilePage
  List<BottomNavigationBarItem> _buildThreeItems() {
    return _buildFourItems();
  }
}
