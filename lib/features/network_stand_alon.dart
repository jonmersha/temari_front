import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

// Book model with a grade field
class Book {
  final String title;
  final String pdfUrl;
  final String grade;

  Book({required this.title, required this.pdfUrl, required this.grade});
}

class PdfViewerApp extends StatefulWidget {
  @override
  _PdfViewerAppState createState() => _PdfViewerAppState();
}

class _PdfViewerAppState extends State<PdfViewerApp> {
  // Sample list of books with different grades
  List<Book> books = [
    Book(title: 'Math Book 1', pdfUrl: 'https://example.com/math1.pdf', grade: 'Grade 1'),
    Book(title: 'Science Book 1', pdfUrl: 'https://example.com/science1.pdf', grade: 'Grade 1'),
    Book(title: 'Math Book 2', pdfUrl: 'https://example.com/math2.pdf', grade: 'Grade 2'),
    Book(title: 'Science Book 2', pdfUrl: 'https://example.com/science2.pdf', grade: 'Grade 2'),
    Book(title: 'Math Book 3', pdfUrl: 'https://example.com/math3.pdf', grade: 'Grade 3'),
    Book(title: 'Science Book 3', pdfUrl: 'https://example.com/science3.pdf', grade: 'Grade 3'),
  ];

  // Group the books by grade
  Map<String, List<Book>> _groupBooksByGrade() {
    Map<String, List<Book>> groupedBooks = {};
    for (var book in books) {
      if (!groupedBooks.containsKey(book.grade)) {
        groupedBooks[book.grade] = [];
      }
      groupedBooks[book.grade]!.add(book);
    }
    return groupedBooks;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Book>> groupedBooks = _groupBooksByGrade();

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Book by Grade'),
      ),
      body: ListView(
        children: groupedBooks.keys.map((grade) {
          return ExpansionTile(
            title: Text(grade),  // Section title is the grade
            children: groupedBooks[grade]!.map((book) {
              return ListTile(
                title: Text(book.title),
                onTap: () {
                  // Navigate to PDF viewer and pass selected book
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NetworkPdfViewer(book: book),
                    ),
                  );
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

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
