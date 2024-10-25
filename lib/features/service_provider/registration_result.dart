import 'package:flutter/material.dart';

class RegistraionResult extends StatefulWidget {
  final dynamic result;
  const RegistraionResult({super.key,required this.result});

  @override
  State<RegistraionResult> createState() => _RegistraionResultState();
}

class _RegistraionResultState extends State<RegistraionResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 40,
                )),
            Text('updated'),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('to book list'),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.green,
                      size: 30,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.green,
                      size: 30,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.green,
                      size: 30,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
