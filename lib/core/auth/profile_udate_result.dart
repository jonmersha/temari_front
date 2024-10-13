import 'package:flutter/material.dart';
import 'package:temari/core/auth/data/UserModel.dart';


class ProfileUpdateResulty extends StatefulWidget {
  final UserModel userData;

  const ProfileUpdateResulty({super.key, required this.userData});

  @override
  State<ProfileUpdateResulty> createState() => _ProfileUpdateResultyState();
}

class _ProfileUpdateResultyState extends State<ProfileUpdateResulty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
