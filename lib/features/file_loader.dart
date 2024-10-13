import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloadScreen extends StatefulWidget {
  @override
  _FileDownloadScreenState createState() => _FileDownloadScreenState();
}

class _FileDownloadScreenState extends State<FileDownloadScreen> {
  double progress = 0.0;
  String progressText = '0 MB / 0 MB'; // To display the file size
  CancelToken cancelToken = CancelToken(); // Create a CancelToken

  // Function to start downloading the file
  Future<void> downloadFile(String url, String fileName) async {
    Dio dio = Dio();

    try {
      // Get the application's directory path
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = "${appDocDir.path}/$fileName";  // Ensure this is a valid string

      await dio.download(
        url,
        savePath,
        cancelToken: cancelToken, // Use the CancelToken here
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != -1) {
            setState(() {
              // Calculate progress percentage
              progress = receivedBytes / totalBytes;

              // Convert bytes to megabytes (MB) for display
              double receivedMB = receivedBytes / (1024 * 1024);
              double totalMB = totalBytes / (1024 * 1024);

              // Update the progress text with file size information
              progressText = "${receivedMB.toStringAsFixed(2)} MB / ${totalMB.toStringAsFixed(2)} MB";
            });
          }
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download completed! File saved at $savePath")));

    } catch (e) {
      if (e is DioError && e.type == DioErrorType.cancel) {
        // Check if the error is due to cancellation
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download canceled!")));
      } else {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download failed: $e"))); // Improved error message
        print('Error occurred: $e');
      }
    }
  }

  // Function to cancel the download
  void cancelDownload() {
    cancelToken.cancel("Download canceled by user.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File Download with Cancel Option')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 20),

            // Progress percentage and file size text
            Text(
              "${(progress * 100).toStringAsFixed(0)}% - $progressText",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 40),

            // Row with download and cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Trigger the file download with URL and file name
                    downloadFile(
                      'https://fetena.net/books_asset/books_29/collection/grade%2012-biology_fetena_net_987f.pdf', // Replace with your file URL
                      'boos12.pdf', // Desired file name
                    );
                  },
                  child: Text("Download File"),
                ),
                ElevatedButton(
                  onPressed: cancelDownload,
                  child: Text("Cancel Download"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
