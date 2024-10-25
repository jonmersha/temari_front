import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temari/core/settings/settings.dart';

void navigatePush({required BuildContext context, required Widget page}){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

void navigateReplace({required BuildContext context, required Widget page}){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}