import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class NetworkPdfViewer extends StatefulWidget {
  final String pdfUrl;

  NetworkPdfViewer({required this.pdfUrl});

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
    try {
      var response = await http.get(Uri.parse(widget.pdfUrl));
      var bytes = response.bodyBytes;
      Directory tempDir = await getTemporaryDirectory();
      File tempFile = File('${tempDir.path}/temp_pdf.pdf');
      await tempFile.writeAsBytes(bytes, flush: true);
      setState(() {
        _filePath = tempFile.path;
      });
    } catch (e) {
      print('Error loading PDF: $e');
    }
  }

  Future<void> _loadLastPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedPage = prefs.getInt('lastPage');
    setState(() {
      _currentPage = savedPage ?? 0;
    });
  }

  Future<void> _saveLastPage(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastPage', page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
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
          _saveLastPage(page!); // Save current page
        },
      ),
    );
  }
}
