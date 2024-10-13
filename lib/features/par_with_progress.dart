import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ParallelDownloadScreenProgress extends StatefulWidget {
  @override
  _ParallelDownloadScreenProgressState createState() => _ParallelDownloadScreenProgressState();
}

class _ParallelDownloadScreenProgressState extends State<ParallelDownloadScreenProgress> {
  int totalFileSize = 0;
  List<int> downloadProgress = [];
  List<int> downloadSize = [];
  CancelToken cancelToken = CancelToken();

  Dio dio = Dio(); // Dio instance

  // Function to download a part of the file
  Future<void> downloadPart(String url, String savePath, int start, int end, int partIndex) async {
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

  // Main function to start the parallel download
  Future<void> startParallelDownload(String url, String fileName, int partCount) async {
    try {
      // Get the application's directory path
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = "${appDocDir.path}/$fileName";

      // Step 1: Get file size with a HEAD request
      Response response = await dio.head(url);
      totalFileSize = int.parse(response.headers.value(HttpHeaders.contentLengthHeader)!);

      // Step 2: Split the file into parts
      int partSize = totalFileSize ~/ partCount;

      // Initialize download progress and size for each part
      downloadProgress = List.filled(partCount, 0);
      downloadSize = List.filled(partCount, 0);

      // Step 3: Download each part in parallel
      List<Future> downloadFutures = [];
      for (int i = 0; i < partCount; i++) {
        int start = i * partSize;
        int end = (i == partCount - 1) ? totalFileSize - 1 : start + partSize - 1;

        downloadFutures.add(downloadPart(url, savePath, start, end, i));
      }

      // Wait for all downloads to complete
      await Future.wait(downloadFutures);

      // Step 4: Merge all parts into a single file
      await mergeParts(savePath, partCount);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download completed! File saved at $savePath")));

    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download failed: $e")));
    }
  }

  // Function to cancel the download
  void cancelDownload() {
    cancelToken.cancel("Download canceled by user.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parallel File Download')),
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
                  'https://temari.besheger.com/text_book/pdf/addis/grade5/en5.pdf', // Replace with your file URL
                  'beshgar.pdf', // Desired file name
                  4, // Number of parts
                );
              },
              child: Text("Download File"),
            ),
            SizedBox(height: 20),

            // Progress bars for each part
            Expanded(
              child: ListView.builder(
                itemCount: downloadProgress.length,
                itemBuilder: (context, index) {
                  double progress = downloadProgress[index] / downloadSize[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Part ${index + 1}: ${downloadProgress[index]}/${downloadSize[index]} bytes'),
                      LinearProgressIndicator(
                        value: progress,
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
            ElevatedButton(
              onPressed: cancelDownload,
              child: Text("Cancel Download"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
