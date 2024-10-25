import 'package:flutter/material.dart';
import 'package:temari/core/utils/navigation.dart';
//[{status: success, effectedRows: 1}]
class UpdateResult extends StatefulWidget {
  final dynamic response;
  const UpdateResult({super.key, required this.response});

  @override
  State<UpdateResult> createState() => _UpdateResultState();
}

class _UpdateResultState extends State<UpdateResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(widget.response['status']=='success')
            Column(
              children: [
                Center(
                    child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 40,
                )),
                Text('Success'),
              ],
            )
            else
              Column(
                children: [
                  Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 80,
                      )),
                  Text('Failure Please try again later'),
                ],
              ),

            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  //navigatePush(context: context, page: page)

                },
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.green,
                      size: 30,
                    ),
                    Text('Go Back'),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
