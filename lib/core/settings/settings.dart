import 'package:flutter/material.dart';
import 'package:temari/core/settings/local_book_list.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,

        title: Text('Settings'),),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: SavedBookList(),
          )
        
      ],),
    );
  }
}
