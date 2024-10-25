import 'package:flutter/material.dart';

class HomeLocalData extends StatefulWidget {
  const HomeLocalData({super.key});

  @override
  State<HomeLocalData> createState() => _HomeLocalDataState();
}

class _HomeLocalDataState extends State<HomeLocalData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Data Home'),),
      body: Center(child: Text('Local Data Ahome'),),
    );
  }
}
