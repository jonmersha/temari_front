import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:temari/core/constants.dart';
import 'package:temari/core/databse/databse_setting.dart';
import 'package:temari/features/home/pdf_viewer_man.dart';

class SaveFile extends StatefulWidget {
 final dynamic book;

  const SaveFile({super.key, required this.book});

  @override
  _SaveFileState createState() => _SaveFileState();
}

class _SaveFileState extends State<SaveFile> {
  int totalFileSize = 0;
  int totalDownloadedBytes = 0;
  List<int> downloadProgress = [];
  List<int> downloadSize = [];
  CancelToken cancelToken = CancelToken();
  Dio dio = Dio();

  List<Map<String, dynamic>> existingFiles = [];

  double get totalProgress => totalDownloadedBytes / totalFileSize;

  // List of downloaded files
  List<String> downloadedFiles = [];

  Future<void> _fetchExistingFiles() async {
    FileDatabaseHelper dbHelper = FileDatabaseHelper();
    List<Map<String, dynamic>> files = await dbHelper.getAllFiles();
    setState(() {
      existingFiles = files;
    });
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
      await dbHelper.deleteFile(id);

      // Refresh the file list
      _fetchExistingFiles();
    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  Future<void> startParallelDownload(
       String fileName,String url, int partCount) async {
    try {
      // Get the file's information from the database
      FileDatabaseHelper dbHelper = FileDatabaseHelper();
      final existingFile = await dbHelper.getFile(fileName);

      if (existingFile != null) {
        //ScaffoldMessenger.of(context).showSnackBar(
           // SnackBar(content: Text("File $fileName already downloaded")));
        //Navigator.push(context, MaterialPageRoute(builder: builder));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PdfViewerImp(fileName: fileName),
          ),
        );
        return; // Skip the download
      }

      // Get the application's directory path
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = "${appDocDir.path}/$fileName";
      //print(' URL: $base/$url');

      Response response = await dio.head('$url');
      totalFileSize =
          int.parse(response.headers.value(HttpHeaders.contentLengthHeader)!);
      await dbHelper.insertFile(
          fileName, totalFileSize, DateTime.now().toIso8601String());
      int partSize = totalFileSize ~/ partCount;
      downloadProgress = List.filled(partCount, 0);
      downloadSize = List.filled(partCount, 0);
      List<Future> downloadFutures = [];
      for (int i = 0; i < partCount; i++) {
        int start = i * partSize;
        int end =
            (i == partCount - 1) ? totalFileSize - 1 : start + partSize - 1;

        downloadFutures.add(downloadPart(url, savePath, start, end, i));
      }
      await Future.wait(downloadFutures);
      await mergeParts(savePath, partCount);
      setState(() {
        downloadedFiles.add(fileName);
        _fetchExistingFiles();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PdfViewerImp(fileName: fileName),
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Download completed! File saved at $savePath")));
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Download failed: $e")));
    }
  }

  // Function to download a part of the file
  Future<void> downloadPart(
      String url, String savePath, int start, int end, int partIndex) async {
    String partFilePath = '$savePath.part$partIndex';
    downloadProgress[partIndex] = 0; // Reset progress for this part
    downloadSize[partIndex] = end - start + 1; // Store total size for this part

    try {
      await dio.download(
        url,
        partFilePath,
        cancelToken: cancelToken,
        options: Options(
          headers: {'Range': 'bytes=$start-$end'}, // Specify the byte range
        ),
        onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloadProgress[partIndex] = receivedBytes;
            totalDownloadedBytes = downloadProgress.reduce((a, b) => a + b);
          });
        },
      );
    } catch (e) {
      if (e is DioError && e.type == DioErrorType.cancel) {
        print("Download canceled");
      } else {
        print("Error downloading part $partIndex: $e");
      }
    }
  }

  // Function to merge parts into a single file
  Future<void> mergeParts(String savePath, int partCount) async {
    File outputFile = File(savePath);
    IOSink sink = outputFile.openWrite();

    for (int i = 0; i < partCount; i++) {
      String partFilePath = '$savePath.part$i';
      File partFile = File(partFilePath);
      await sink.addStream(partFile.openRead());
      await partFile.delete(); // Remove the part file after merging
    }

    await sink.close();
  }

  void cancelDownload() {
    cancelToken.cancel("Download canceled by user.");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchExistingFiles();
      startParallelDownload('${widget.book['book_name']}', '$base/${widget.book['textbook_url']}', 4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _fetchExistingFiles();
                });
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button to start parallel download
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    cancelDownload;
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Total Progress Bar
            if (totalFileSize > 0) ...[
              Text(
                  "Total Progress: ${(totalProgress * 100).toStringAsFixed(2)}%"),
              Text(
                  "Total Size: ${(totalFileSize / (1024 * 1024)).toStringAsFixed(2)} MB"),
              LinearProgressIndicator(
                value: totalProgress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              SizedBox(height: 20),
            ],

            // Progress bars for each part
            Expanded(
              child: ListView.builder(
                itemCount: downloadProgress.length,
                itemBuilder: (context, index) {
                  double partProgress =
                      downloadProgress[index] / downloadSize[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Part ${index + 1}: ${downloadProgress[index]}/${downloadSize[index]} bytes (${(partProgress * 100).toStringAsFixed(2)}%)'),
                      LinearProgressIndicator(
                        value: partProgress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),

            //Cancel button

            //MyAppDb(),

            SizedBox(
              height: 200,
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: existingFiles.length,
                  itemBuilder: (context, index) {
                    final file = existingFiles[index];
                    return Expanded(
                      child: Row(
                        children: [
                          Expanded(child: Text(file['file_name'])),
                          Expanded(
                              child: Text(
                                  "Size: ${(file['file_size'] / (1024 * 1024)).toStringAsFixed(2)} MB")),
                          Expanded(child: Text(file['download_date'])),
                          IconButton(
                            onPressed: () async {
                              String filePath =
                                  '${(await getExternalStorageDirectory())!.path}/${file['file_name']}';
                              _deleteFile(filePath, file['id']);
                            },
                            icon: Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: () {
                              //print(file['file_name']);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PdfViewerImp(fileName: file['file_name']),
                                ),
                              );

                              //   String filePath =
                              //       '${(await getExternalStorageDirectory())!.path}/${file['file_name']}';
                              //   _deleteFile(filePath, file['id']);
                            },
                            icon: Icon(Icons.open_in_new_sharp),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
