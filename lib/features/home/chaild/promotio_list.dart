import 'package:flutter/material.dart';

Widget promotionList(){
  return Container(
    height: 150,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5, // Example item count
      itemBuilder: (context, index) {
        return Container(
          width: 120,
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text('Promo $index', style: TextStyle(color: Colors.white))),
        );
      },
    ),
  );

}