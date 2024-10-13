import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfViewerImp extends StatefulWidget {
  final fileName;
  const PdfViewerImp({super.key,required this.fileName});

  @override
  State<PdfViewerImp> createState() => _PdfViewerImpState();
}

class _PdfViewerImpState extends State<PdfViewerImp> {
  int? _totalPages = 0;
  int? _currentPage = 0;
  bool _isReady = false;
  String _filePath = "";
  late PDFViewController _pdfViewController;


  Future<void> _loadPdf() async {
    // Check if the file is already saved locally
    Directory documentsDir = await getApplicationDocumentsDirectory();
    File localFile = File('${documentsDir.path}/${widget.fileName}');

    if (await localFile.exists()) {
      // File exists, load from local storage
      setState(() {
        _filePath = localFile.path;
      });
      print("Loaded PDF from local storage: ${localFile.path}");
    }
    //else
    // {
    //   // File does not exist, download from the network
    //   try {
    //     //var response = await http.get(Uri.parse(widget.book.pdfUrl));
    //     //var bytes = response.bodyBytes;
    //
    //     // Save file to local storage
    //     await localFile.writeAsBytes(bytes, flush: true);
    //     setState(() {
    //       _filePath = localFile.path;
    //     });
    //     print("Downloaded and saved PDF to local storage: ${localFile.path}");
    //   } catch (e) {
    //     print('Error loading PDF: $e');
    //   }
    // }
  }

  Future<void> _loadLastPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedPage = prefs.getInt('lastPage_${widget.fileName}');
    setState(() {
      _currentPage = savedPage ?? 0;
    });
  }

  Future<void> _saveLastPage(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastPage_${widget.fileName}', page);
  }


  @override
  void initState() {// TODO: implement initState
    super.initState();
    _loadPdf();
    _loadLastPage();
  }
  // @override
  // Widget build(BuildContext context) {
  //   return const Placeholder();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.fileName),
      // ),
      body: _filePath.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: _filePath,
        enableSwipe: true,
        swipeHorizontal: false,
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
