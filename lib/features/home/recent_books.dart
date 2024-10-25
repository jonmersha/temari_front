import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:temari/core/databse/databse_setting.dart';
import 'package:temari/core/utils/navigation.dart';
import 'package:temari/features/home/pdf_viewer_man.dart';

class RecentBooks extends StatefulWidget {
  const RecentBooks({super.key});

  @override
  State<RecentBooks> createState() => _RecentBooksState();
}

class _RecentBooksState extends State<RecentBooks> {
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
        //print("File deleted: $filePath");
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
          return const Center(
              child: Text(
                  'No Books Saved, Please go online and save it for offline use'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text(
                  'No Books Saved, Please go online and save it for offline use'));
        }
        List<dynamic> groupedBooks = snapshot.data!;
        return ListView.builder(
            shrinkWrap: true,
            physics:NeverScrollableScrollPhysics(),
            itemCount: groupedBooks.length,
            itemBuilder: (context, index) {
              return InkWell(
                onDoubleTap: (){
                  navigatePush(context: context, page: PdfViewerImp(fileName: groupedBooks[index]['book_name']));
                },
                child: Card(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${groupedBooks[index]['textbook_title']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                              Text('${groupedBooks[index]['textbook_grade']} ${groupedBooks[index]['region_name']} region'),
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: (){
                              navigatePush(context: context, page: PdfViewerImp(fileName: groupedBooks[index]['book_name']));
                            },
                              //_deleteFile('${groupedBooks[index]['book_name']}', groupedBooks[index]['textbook_id']);},
                            child: Icon(Icons.menu_book,size: 30,color:Colors.green))
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
