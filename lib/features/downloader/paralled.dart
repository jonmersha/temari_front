// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:temari/core/databse/databse_setting.dart';
//
// Future<void> startParallelDownload(String url, String fileName, int partCount) async {
//   try {
//     // Get the file's information from the database
//     FileDatabaseHelper dbHelper = FileDatabaseHelper();
//     final existingFile = await dbHelper.getFile(fileName);
//
//     if (existingFile != null) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File $fileName already downloaded")));
//       return; // Skip the download
//     }
//
//     // Get the application's directory path
//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     String savePath = "${appDocDir.path}/$fileName";
//
//     // Step 1: Get file size with a HEAD request
//     Response response = await dio.head(url);
//     totalFileSize = int.parse(response.headers.value(HttpHeaders.contentLengthHeader)!);
//
//     // Store file information in the database
//     await dbHelper.insertFile(fileName, totalFileSize, DateTime.now().toIso8601String());
//
//     // Step 2: Split the file into parts
//     int partSize = totalFileSize ~/ partCount;
//
//     // Initialize download progress and size for each part
//     downloadProgress = List.filled(partCount, 0);
//     downloadSize = List.filled(partCount, 0);
//
//     // Step 3: Download each part in parallel
//     List<Future> downloadFutures = [];
//     for (int i = 0; i < partCount; i++) {
//       int start = i * partSize;
//       int end = (i == partCount - 1) ? totalFileSize - 1 : start + partSize - 1;
//
//       downloadFutures.add(downloadPart(url, savePath, start, end, i));
//     }
//
//     // Wait for all downloads to complete
//     await Future.wait(downloadFutures);
//
//     // Step 4: Merge all parts into a single file
//     await mergeParts(savePath, partCount);
//
//     // Add the downloaded file to the list of downloaded files
//     setState(() {
//       downloadedFiles.add(fileName);
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download completed! File saved at $savePath")));
//
//   } catch (e) {
//     print("Error occurred: $e");
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download failed: $e")));
//   }
// }
