import 'package:flutter/material.dart';
import 'package:temari/features/home_page.dart';
import 'package:temari/grade_grouped.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pdf Reader',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home:  NetworkPdfViewer(pdfUrl: 'https://fetena.net/books_asset/books_36/collection/grade%205-amharic_fetena_net_131d.pdf'),
   home:BooksPage(),
    );
  }
}

