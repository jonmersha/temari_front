// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//

// import 'dart:async';
// import 'package:path_provider/path_provider.dart';
//
// // Book model
// class Book {
//   final String title;
//   final String pdfUrl;
//
//   Book({required this.title, required this.pdfUrl});
// }
//
// class PdfViewerApp extends StatefulWidget {
//   @override
//   _PdfViewerAppState createState() => _PdfViewerAppState();
// }
//
// class _PdfViewerAppState extends State<PdfViewerApp> {
//   List<Book> books = [
//     Book(title: 'English Grade 5', pdfUrl: 'https://fetena.net/books_asset/books_36/collection/grade%205-english_fetena_net_eef5.pdf'),
//     Book(title: 'Amharic Grade 5', pdfUrl: 'https://fetena.net/books_asset/books_36/collection/grade%205-amharic_fetena_net_131d.pdf'),
//     Book(title: 'Mathematics grade 5', pdfUrl: 'https://fetena.net/books_asset/books_36/collection/grade%205-environmental%20science_fetena_net_15b0.pdf'),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select a Book'),
//       ),
//       body: ListView.builder(
//         itemCount: books.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(books[index].title),
//             onTap: () {
//               // Navigate to PDF viewer and pass selected book
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => NetworkPdfViewer(book: books[index]),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//

