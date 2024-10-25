import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:temari/core/auth/data/UserModel.dart';
import 'package:temari/core/auth/data/network_access.dart';
import 'package:temari/core/auth/edit_user.dart';
import 'package:temari/features/service_provider/provider_home.dart';
import 'package:temari/features/service_provider/service_provider_customer.dart';

class UserProfile extends StatefulWidget {
  final User userData;
  const UserProfile({super.key, required this.userData});

  @override
  State<UserProfile> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<UserProfile> {
  bool isUserLoaded = false;
  late Future<List<dynamic>> userData;

  //getting the users
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User? _user;

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

  @override
  void initState() {
    super.initState();
    _checkIfUserSignedIn();
    if (!isUserLoaded) {
      userData = getUsers(widget.userData.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  userData = getUsers(widget.userData.email);
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Sorry but error connecting to your service please check you connection'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: ElevatedButton(
                    onPressed: () {
                      dynamic userData = {
                        "username": widget.userData.email.toString(),
                        "email": widget.userData.email.toString(),
                        "first_name": widget.userData.displayName.toString(),
                        "password_hash": 'lskjdfhoihntdouweyhbrpuqxw45',
                      };
                      // print(userData);
                      register('4', userData);
                      Navigator.pop(context);

                    },
                    child: const Text('Create Your Account')));
          }
          isUserLoaded = true;
          final userData = snapshot.data!;
          List<UserModel> users =
              userData.map(((e) => UserModel.fromJson(e))).toList();
          UserModel user = users[0];
          return SingleChildScrollView(child: Column(
            children: [
              UpdateUserForm(userData: user,google:widget.userData),
               ServiceProviderCustomer(email: user.email!,usermodel: userData,profileImage:widget.userData.photoURL!)

            ],
          )); //SizedBox(child: Text('${user.email}'));
        },
      ),
    );
  }
}
