import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temari/core/model.dart';
import 'package:http/http.dart' as http;

class NetworkPdfViewer extends StatefulWidget {
  final Book book;

  NetworkPdfViewer({required this.book});

  @override
  _NetworkPdfViewerState createState() => _NetworkPdfViewerState();
}

class _NetworkPdfViewerState extends State<NetworkPdfViewer> {
  int? _totalPages = 0;
  int? _currentPage = 0;
  bool _isReady = false;
  String _filePath = "";
  late PDFViewController _pdfViewController;

  @override
  void initState() {
    super.initState();
    _loadPdf();
    _loadLastPage();
  }

  Future<void> _loadPdf() async {
    // Check if the file is already saved locally
    Directory documentsDir = await getApplicationDocumentsDirectory();
    File localFile = File('${documentsDir.path}/${widget.book.title}.pdf');

    if (await localFile.exists()) {
      // File exists, load from local storage
      setState(() {
        _filePath = localFile.path;
      });
      print("Loaded PDF from local storage: ${localFile.path}");
    } else {
      // File does not exist, download from the network
      try {
        var response = await http.get(Uri.parse(widget.book.pdfUrl));
        var bytes = response.bodyBytes;

        // Save file to local storage
        await localFile.writeAsBytes(bytes, flush: true);
        setState(() {
          _filePath = localFile.path;
        });
        print("Downloaded and saved PDF to local storage: ${localFile.path}");
      } catch (e) {
        print('Error loading PDF: $e');
      }
    }
  }

  Future<void> _loadLastPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedPage = prefs.getInt('lastPage_${widget.book.title}');
    setState(() {
      _currentPage = savedPage ?? 0;
    });
  }

  Future<void> _saveLastPage(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastPage_${widget.book.title}', page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: _filePath.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: _filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        defaultPage: _currentPage!,
        onRender: (_pages) {
          setState(() {
            _totalPages = _pages;
            _isReady = true;
          });
        },
        onViewCreated: (PDFViewController pdfViewController) {
          _pdfViewController = pdfViewController;
        },
        onPageChanged: (page, total) {
          setState(() {
            _currentPage = page;
          });
          _saveLastPage(page!); // Save current page for this book
        },
      ),
    );
  }
}