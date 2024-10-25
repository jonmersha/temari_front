// import 'package:flutter/material.dart';
// import 'package:temari/core/databse/databse_setting.dart';
// import 'package:dio/dio.dart';
//
// class MyAppDb extends StatefulWidget {
//   @override
//   _MyAppDbState createState() => _MyAppDbState();
// }
//
// class _MyAppDbState extends State<MyAppDb> {
//   List<Map<String, dynamic>> existingFiles = [];
//   final Dio dio = Dio();
//   double totalProgress = 0.0;
//   int totalFileSize = 0;
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
//     // Download logic as previously defined
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return //Scaffold(
//       //appBar: AppBar(title: Text('File Download Example')),
//       //body:
//       Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             // ElevatedButton(
//             //   onPressed: () {
//             //     // Start the download process
//             //     startParallelDownload(
//             //       'https://temari.besheger.com/text_book/pdf/addis/grade5/en5.pdf',
//             //       'sample.pdf', // Desired file name
//             //       4, // Number of parts
//             //     );
//             //   },
//             //   child: Text("Download File"),
//             // ),
//             SizedBox(height: 20),
//
//             Text("Existing Files:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Expanded(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: existingFiles.length,
//                 itemBuilder: (context, index) {
//                   final file = existingFiles[index];
//                   return ListTile(
//                     title: Text(file['file_name']),
//                     subtitle: Text("Size: ${(file['file_size'] / (1024 * 1024)).toStringAsFixed(2)} MB"),
//                     trailing: Text(file['download_date']),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     //);
//   }
// }
