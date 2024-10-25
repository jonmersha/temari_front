import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:temari/core/databse/databse_setting.dart';
import 'package:temari/features/home/chaild/student_text_list.dart';

class LocalData extends StatefulWidget {
  const LocalData({super.key});
  @override
  _LocalDataState createState() => _LocalDataState();
}

class _LocalDataState extends State<LocalData> {
  int totalFileSize = 0;
  int totalDownloadedBytes = 0;
  List<int> downloadProgress = [];
  List<int> downloadSize = [];
  CancelToken cancelToken = CancelToken();
  Dio dio = Dio();

  List<Map<String, dynamic>> existingFiles = [];
  Future<Map<String, List<Map<String, dynamic>>>>? groupedBooksFuture;


  double get totalProgress => totalDownloadedBytes / totalFileSize;

  // List of downloaded files
  List<String> downloadedFiles = [];
  Future<Map<String, List<Map<String, dynamic>>>> _fetchExistingFiles() async {
    FileDatabaseHelper dbHelper = FileDatabaseHelper();
    List<Map<String, dynamic>> files = await dbHelper.getAllFiles();
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    List<dynamic> books = files;

    for (var book in books) {
      String regionName = book['region_name'];
      if (groupedData.containsKey(regionName)) {
        groupedData[regionName]!.add(book);
      } else {
        groupedData[regionName] = [book];
      }
    }


    setState(() {
      existingFiles = files;
    });
    return groupedData;

  }
  Future<void> _deleteFile(String filePath, int id) async {
    try {
      // Delete the file from the file system
      if (await File(filePath).exists()) {
        await File(filePath).delete();
        print("File deleted: $filePath");
      }

      // Remove file info from the database
      FileDatabaseHelper dbHelper = FileDatabaseHelper();
      await dbHelper.deleteBook(id);

      // Refresh the file list
      _fetchExistingFiles();
    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      groupedBooksFuture=_fetchExistingFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:

      FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
          future: groupedBooksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('No Save Books Found, Please go online and save it for offline use'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Save Books Found, Please go online and save it for offline use'));
            }

            Map<String, List<Map<String, dynamic>>> groupedBooks = snapshot.data!;

            final screenWidth = MediaQuery.of(context).size.width;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saved Books, Connect to interntet and refresh for online content'),
                  studentTextGridView(groupedBooks,screenWidth),
                ],
              ),
            );


          },
        ),



      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //
      //       Text('${existingFiles.length}'),
      //       SizedBox(
      //         height: 200,
      //         child: Expanded(
      //           child: ListView.builder(
      //             shrinkWrap: true,
      //             itemCount: existingFiles.length,
      //             itemBuilder: (context, index) {
      //               final file = existingFiles[index];
      //               return Expanded(
      //                 child: Row(
      //                   children: [
      //                     Expanded(child: Text(file['book_name'])),
      //                     // Expanded(
      //                     //     child: Text(
      //                     //         "Size: ${(file['file_size'] / (1024 * 1024)).toStringAsFixed(2)} MB")),
      //                     // Expanded(child: Text(file['download_date'])),
      //                     IconButton(
      //                       onPressed: () async {
      //                         String filePath =
      //                             '${(await getExternalStorageDirectory())!.path}/${file['book_name']}';
      //                         _deleteFile(filePath, file['textbook_id']);
      //                       },
      //                       icon: Icon(Icons.delete),
      //                     ),
      //                     IconButton(
      //                       onPressed: () {
      //                         Navigator.push(
      //                           context,
      //                           MaterialPageRoute(
      //                             builder: (context) =>
      //                                 PdfViewerImp(fileName: file['book_name']),
      //                           ),
      //                         );
      //
      //                       },
      //                       icon: Icon(Icons.open_in_new_sharp),
      //                     ),
      //                   ],
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
