// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:dio/dio.dart';
// import 'package:temari/core/databse/databse_setting.dart';
// import 'package:url_launcher/url_launcher.dart';
// // import 'file_database_helper.dart'; // Import your database helper class
//
// class MyAppViewewr extends StatefulWidget {
//   @override
//   _MyAppViewewrState createState() => _MyAppViewewrState();
// }
//
// class _MyAppViewewrState extends State<MyAppViewewr> {
//   final Dio dio = Dio();
//   double totalProgress = 0.0;
//   List<Map<String, dynamic>> existingFiles = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchExistingFiles();
//   }
//
//   Future<void> _fetchExistingFiles() async {
//     FileDatabaseHelper dbHelper = FileDatabaseHelper();
//     List<Map<String, dynamic>> files = await dbHelper.getAllFiles();
//     setState(() {
//       existingFiles = files;
//     });
//   }
//
//   Future<void> startParallelDownload(String url, String fileName, int partCount) async {
//     try {
//       // Get the directory to save the file
//       var dir = await getExternalStorageDirectory();
//       String filePath = '${dir!.path}/$fileName';
//
//       // Make sure file does not exist before downloading
//       if (await File(filePath).exists()) {
//         print("File already exists: $filePath");
//         return; // Prevent downloading the existing file
//       }
//
//       // Download the file
//       Response response = await dio.download(url, filePath,
//           onReceiveProgress: (received, total) {
//             setState(() {
//               totalProgress = received / total;
//             });
//           });
//
//       if (response.statusCode == 200) {
//         // Save file info to the database after successful download
//         FileDatabaseHelper dbHelper = FileDatabaseHelper();
//         await dbHelper.insertFile({
//           'file_name': fileName,
//           'file_size': response.data.contentLength, // Use the content length from response
//           'download_date': DateTime.now().toString(),
//         });
//         print("Download completed: $filePath");
//
//         // Open the downloaded file
//         _openFile(filePath);
//       } else {
//         print("Download failed: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error downloading file: $e");
//     }
//   }
//
//   Future<void> _openFile(String filePath) async {
//     if (await File(filePath).exists()) {
//       // Use url_launcher to open the PDF file
//       final Uri uri = Uri.file(filePath);
//       if (await canLaunch(uri.toString())) {
//         await launch(uri.toString());
//       } else {
//         throw 'Could not launch $filePath';
//       }
//     } else {
//       print("File does not exist: $filePath");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('File Download Example')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 startParallelDownload(
//                   'https://example.com/sample.pdf', // Replace with your file URL
//                   'sample.pdf', // Desired file name
//                   4, // Number of parts (optional for this implementation)
//                 );
//               },
//               child: Text("Download File"),
//             ),
//             SizedBox(height: 20),
//             Text("Download Progress: ${(totalProgress * 100).toStringAsFixed(0)}%"),
//             // Display existing files...
//           ],
//         ),
//       ),
//     );
//   }
// }
