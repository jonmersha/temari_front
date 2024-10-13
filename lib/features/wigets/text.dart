import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String text;
  FontWeight fontWeight;
  Color textColor;
  double textSize;

  TextTitle(
      {super.key,
      required this.text,
      this.fontWeight = FontWeight.bold,
      this.textColor = Colors.black26,
      this.textSize = 16});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: textSize,
        color: textColor,
      ),
    );
  }
}
class BodyTitle extends StatelessWidget {
  final String text;
  FontWeight fontWeight;
  Color textColor;
  double textSize;
  TextDecoration decoration;

  BodyTitle(
      {super.key,
      required this.text,
      this.fontWeight = FontWeight.normal,
      this.textColor = Colors.black,
      this.textSize = 14, required ,
  this.decoration=TextDecoration.none
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: textSize,
        color: textColor,
        decoration: decoration,

      ),
      maxLines: 3, // Allows unlimited lines
      overflow: TextOverflow.ellipsis, // Text will wrap instead of being cut off
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}