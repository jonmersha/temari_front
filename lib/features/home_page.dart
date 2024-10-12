import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:temari/core/network_access.dart';
import 'package:temari/features/bookListPage.dart';




class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  Future<Map<String, List<Map<String, dynamic>>>>? groupedBooksFuture;

  @override
  void initState() {
    super.initState();
    groupedBooksFuture = fetchAndGroupBooks('4');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      actions: [IconButton(onPressed: (){
        setState(() {
          groupedBooksFuture = fetchAndGroupBooks('4');

        });
      }, icon: Icon(Icons.refresh))],
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: groupedBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books found'));
          }

          Map<String, List<Map<String, dynamic>>> groupedBooks = snapshot.data!;
          return ListView.builder(
            itemCount: groupedBooks.keys.length,
            itemBuilder: (context, index) {
              String regionName = groupedBooks.keys.elementAt(index);
              List<Map<String, dynamic>> books = groupedBooks[regionName]!;

              return ListTile(
                title: Text(regionName),
                subtitle: Text('${books.length} books'),
                onTap: () {
                  // Navigate to a new page that shows the books for this region
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookListPage(regionName: regionName, books: books),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// class BookListPage extends StatelessWidget {
//   final String regionName;
//   final List<Map<String, dynamic>> books;
//
//   BookListPage({required this.regionName, required this.books});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Books in $regionName'),
//       ),
//       body: ListView.builder(
//         itemCount: books.length,
//         itemBuilder: (context, index) {
//           var book = books[index];
//           return ListTile(
//             title: Text(book['title']),
//             subtitle: Text(book['name_am']),
//             onTap: () {
//               // You can handle book tap here (e.g., opening PDF)
//               print(book['']);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
