import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:temari/core/databse/databse_setting.dart';
import 'package:temari/features/home/pdf_viewer_man.dart';

class ParallelDownloadScreenWithOveral extends StatefulWidget {
  @override
  _ParallelDownloadScreenWithOveralState createState() =>
      _ParallelDownloadScreenWithOveralState();
}

class _ParallelDownloadScreenWithOveralState
    extends State<ParallelDownloadScreenWithOveral> {
  int totalFileSize = 0;
  int totalDownloadedBytes = 0;
  List<int> downloadProgress = [];
  List<int> downloadSize = [];
  CancelToken cancelToken = CancelToken();
  Dio dio = Dio();

  List<Map<String, dynamic>> existingFiles = [];

  //final Dio dio = Dio();
  //double totalProgress = 0.0;
  //int totalFileSize = 0;

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
      String url, String fileName, int partCount) async {try {
      // Get the file's information from the database
      FileDatabaseHelper dbHelper = FileDatabaseHelper();
      final existingFile = await dbHelper.getFile(fileName);

      if (existingFile != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("File $fileName already downloaded")));
        return; // Skip the download
      }

      // Get the application's directory path
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = "${appDocDir.path}/$fileName";

      // Step 1: Get file size with a HEAD request
      Response response = await dio.head(url);
      totalFileSize =
          int.parse(response.headers.value(HttpHeaders.contentLengthHeader)!);

      // Store file information in the database
      await dbHelper.insertFile(
          fileName, totalFileSize, DateTime.now().toIso8601String());

      // Step 2: Split the file into parts
      int partSize = totalFileSize ~/ partCount;

      // Initialize download progress and size for each part
      downloadProgress = List.filled(partCount, 0);
      downloadSize = List.filled(partCount, 0);

      // Step 3: Download each part in parallel
      List<Future> downloadFutures = [];
      for (int i = 0; i < partCount; i++) {
        int start = i * partSize;
        int end =
            (i == partCount - 1) ? totalFileSize - 1 : start + partSize - 1;

        downloadFutures.add(downloadPart(url, savePath, start, end, i));
      }

      // Wait for all downloads to complete
      await Future.wait(downloadFutures);

      // Step 4: Merge all parts into a single file
      await mergeParts(savePath, partCount);

      // Add the downloaded file to the list of downloaded files
      setState(() {
        downloadedFiles.add(fileName);
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
            ElevatedButton(
              onPressed: () {
                // Start parallel download with 4 parts
                startParallelDownload(
                  'https://fetena.net/books_asset/books_29/collection/grade%2012-chemistry_fetena_net_ef88.pdf',
                  // Replace with your file URL
                  'sample243.pdf', // Desired file name
                  4, // Number of parts
                );
              },
              child: Text("Download File"),
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

            // Cancel button
            // ElevatedButton(
            //   onPressed: cancelDownload,
            //   child: Text("Cancel Download"),
            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            // ),

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
                            onPressed: ()  {
                              //print(file['file_name']);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfViewerImp(fileName:file['file_name']),
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

                    ListTile(
                      title: Text(file['file_name']),
                      subtitle: Text(
                          "Size: ${(file['file_size'] / (1024 * 1024)).toStringAsFixed(2)} MB"),
                      trailing: Text(file['download_date']),
                    );
                  },
                ),
              ),
            ),

            // List of downloaded files
            // if (downloadedFiles.isNotEmpty) ...[
            //   SizedBox(height: 20),
            //   Text("Downloaded Files:"),
            //   Expanded(
            //     child: ListView.builder(
            //       itemCount: downloadedFiles.length,
            //       itemBuilder: (context, index) {
            //         return ListTile(
            //           title: Text(downloadedFiles[index]),
            //         );
            //       },
            //     ),
            //   ),
            // ]
          ],
        ),
      ),
    );
  }
}
