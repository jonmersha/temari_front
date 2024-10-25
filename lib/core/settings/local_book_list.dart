import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:temari/core/databse/databse_setting.dart';

class SavedBookList extends StatefulWidget {
  const SavedBookList({super.key});

  @override
  State<SavedBookList> createState() => _SavedBookListState();
}

class _SavedBookListState extends State<SavedBookList> {
  //fetching data from local repository
  int totalFileSize = 0;
  int totalDownloadedBytes = 0;
  List<int> downloadProgress = [];
  List<int> downloadSize = [];
  CancelToken cancelToken = CancelToken();
  Dio dio = Dio();

  List<Map<String, dynamic>> existingFiles = [];
  Future<List<dynamic>>? groupedBooksFuture;

  double get totalProgress => totalDownloadedBytes / totalFileSize;

// List of downloaded files
  List<String> downloadedFiles = [];

  Future<List<dynamic>> _fetchExistingFiles() async {
    FileDatabaseHelper dbHelper = FileDatabaseHelper();
    List<Map<String, dynamic>> files = await dbHelper.getAllFiles();
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    List<dynamic> books = files;

    return books;
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
      setState(() {
        groupedBooksFuture = _fetchExistingFiles();
      });

    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      groupedBooksFuture = _fetchExistingFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: groupedBooksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text(
                  'No Save Books Found, Please go online and save it for offline use'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
                  'No Save Books Found, Please go online and save it for offline use'));
        }

        List<dynamic> groupedBooks = snapshot.data!;

        // final screenWidth = MediaQuery.of(context).size.width;
        return SingleChildScrollView(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: groupedBooks.length,
              itemBuilder: (context, index) {
                return Card(

                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.menu_book,size: 30,color: Colors.blueGrey,),
                        SizedBox(width: 20,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${groupedBooks[index]['textbook_title']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              Text('${groupedBooks[index]['textbook_grade']} ${groupedBooks[index]['region_name']} Region'),
                             // Text('${groupedBooks[index]['textbook_grade']}'),

                            ],
                          ),
                        ),
                        InkWell(
                            onTap: (){_deleteFile('${groupedBooks[index]['book_name']}', groupedBooks[index]['textbook_id']);},
                            child: Icon(Icons.delete,size: 30,color:Colors.red))
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
