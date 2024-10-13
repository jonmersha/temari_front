import 'package:flutter/material.dart';
import 'package:temari/core/constants.dart';
import 'package:temari/core/model.dart';
import 'package:temari/features/downloader/save_pdf.dart';
import 'package:temari/features/pdf_viewer.dart';

class BookListPage extends StatelessWidget {
  final String regionName;
  final List<Map<String, dynamic>> books;

  BookListPage({required this.regionName, required this.books});

  // Group books by grade
  Map<String, List<Map<String, dynamic>>> groupBooksByGrade(
      List<Map<String, dynamic>> books) {
    Map<String, List<Map<String, dynamic>>> groupedBooks = {};

    for (var book in books) {
      String gradeName = book['textbook_description'];
      if (groupedBooks.containsKey(gradeName)) {
        groupedBooks[gradeName]!.add(book);
      } else {
        groupedBooks[gradeName] = [book];
      }
    }

    return groupedBooks;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> groupedByGrade =
        groupBooksByGrade(books);

    return Scaffold(
      appBar: AppBar(
        title: Text('$regionName'),
      ),
      body: ListView.builder(
        itemCount: groupedByGrade.keys.length,
        itemBuilder: (context, index) {
          String gradeName = groupedByGrade.keys.elementAt(index);
          List<Map<String, dynamic>> booksForGrade = groupedByGrade[gradeName]!;

          return ExpansionTile(
            title: Text(gradeName),
            children: booksForGrade.map((book) {
              return ListTile(
                title: Text(book['textbook_title']),
                subtitle: Text('PDF: ${book['textbook_subject']}'),
                onTap: () {
                  //print('$base/${book['textbook_url']}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaveFile(book: book),

                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
