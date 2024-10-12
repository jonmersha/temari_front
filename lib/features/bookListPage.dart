import 'package:flutter/material.dart';
import 'package:temari/book_model.dart';
import 'package:temari/core/constants.dart';
import 'package:temari/core/model.dart';
import 'package:temari/features/pdf_viewer.dart';
import 'package:temari/grade_grouped.dart';

class BookListPage extends StatelessWidget {
  final String regionName;
  final List<Map<String, dynamic>> books;

  BookListPage({required this.regionName, required this.books});

  // Group books by grade
  Map<String, List<Map<String, dynamic>>> groupBooksByGrade(List<Map<String, dynamic>> books) {
    Map<String, List<Map<String, dynamic>>> groupedBooks = {};

    for (var book in books) {
      String gradeName = book['grade_name'];
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
    Map<String, List<Map<String, dynamic>>> groupedByGrade = groupBooksByGrade(books);

    return Scaffold(
      appBar: AppBar(
        title: Text('Books in $regionName'),
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
                title: Text(book['title']),
                subtitle: Text('PDF: ${book['pdf_url']}'),
                onTap: () {
                  // Handle book tap (e.g., open PDF)

print('$base/${book['pdf_url']}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NetworkPdfViewer(
                          book:Book(
                              title: '${book['title']}',
                              pdfUrl: '$base/${book['pdf_url']}', grade:'$base/${book['name_am']}' ,)),
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