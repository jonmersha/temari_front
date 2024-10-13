import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temari/core/auth/data/UserModel.dart';
import 'package:temari/core/auth/data/network_access.dart';
import 'package:temari/core/auth/edit_user.dart';

class UserProfile extends StatefulWidget {
  final User userData;

  const UserProfile({super.key, required this.userData});

  @override
  State<UserProfile> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<UserProfile> {
  bool isCurrencyLoaded = false;
  late Future<List<dynamic>> userData;

  //FirebaseAuth auth=FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if (!isCurrencyLoaded) {
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
                  userData = getUsers(widget.userData!.email);
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
            return const Center(child: Text('Error: Check Your Connection'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //Create user Accounts

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
                      register('post/data/19', userData);
                    },
                    child: const Text('Create Your Account')));
          }
          isCurrencyLoaded = true;
          final userData = snapshot.data!;
          List<UserModel> users =
              userData.map(((e) => UserModel.fromJson(e))).toList();
          UserModel user = users[0];

          return UpdateUserForm(userData: user,google:widget.userData); //SizedBox(child: Text('${user.email}'));
        },
      ),
    );
  }
}
