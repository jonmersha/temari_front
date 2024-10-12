// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
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
// class NetworkPdfViewer extends StatefulWidget {
//   final Book book;
//
//   NetworkPdfViewer({required this.book});
//
//   @override
//   _NetworkPdfViewerState createState() => _NetworkPdfViewerState();
// }
//
// class _NetworkPdfViewerState extends State<NetworkPdfViewer> {
//   int? _totalPages = 0;
//   int? _currentPage = 0;
//   bool _isReady = false;
//   String _filePath = "";
//   late PDFViewController _pdfViewController;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPdf();
//     _loadLastPage();
//   }
//
//   Future<void> _loadPdf() async {
//     try {
//       var response = await http.get(Uri.parse(widget.book.pdfUrl));
//       var bytes = response.bodyBytes;
//       Directory tempDir = await getTemporaryDirectory();
//       File tempFile = File('${tempDir.path}/temp_${widget.book.title}.pdf');
//       await tempFile.writeAsBytes(bytes, flush: true);
//       setState(() {
//         _filePath = tempFile.path;
//       });
//     } catch (e) {
//       print('Error loading PDF: $e');
//     }
//   }
//
//   Future<void> _loadLastPage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? savedPage = prefs.getInt('lastPage_${widget.book.title}');
//     setState(() {
//       _currentPage = savedPage ?? 0;
//     });
//   }
//
//   Future<void> _saveLastPage(int page) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('lastPage_${widget.book.title}', page);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.book.title),
//       ),
//       body: _filePath.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : PDFView(
//         filePath: _filePath,
//         enableSwipe: true,
//         swipeHorizontal: true,
//         autoSpacing: false,
//         pageFling: false,
//         defaultPage: _currentPage!,
//         onRender: (_pages) {
//           setState(() {
//             _totalPages = _pages;
//             _isReady = true;
//           });
//         },
//         onViewCreated: (PDFViewController pdfViewController) {
//           _pdfViewController = pdfViewController;
//         },
//         onPageChanged: (page, total) {
//           setState(() {
//             _currentPage = page;
//           });
//           _saveLastPage(page!); // Save current page for this book
//         },
//       ),
//     );
//   }
// }
