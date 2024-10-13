// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
//
// class PDFViewer extends StatelessWidget {
//   final String filePath;
//
//   PDFViewer({required this.filePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: PDFView(
//         filePath: filePath,
//         enableSwipe: true,
//         swipeHorizontal: true,
//         autoSpacing: false,
//         pageFling: true,
//         onPageChanged: (int page, int total) {
//           print('Page $page of $total');
//         },
//       ),
//     );
//   }
// }
