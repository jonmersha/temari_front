import 'package:flutter/material.dart';
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
    groupedBooksFuture = fetchAndGroupBooks('3');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      actions: [IconButton(onPressed: (){
        setState(() {
          groupedBooksFuture = fetchAndGroupBooks('3');

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

