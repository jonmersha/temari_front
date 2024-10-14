import 'package:flutter/material.dart';
import 'package:temari/core/network_access.dart';
import 'package:temari/features/history/read_history_home.dart';
import 'package:temari/features/home/chaild/student_text_list.dart';
import 'package:temari/features/home/chaild/usage_history.dart';
import 'package:temari/features/news/news_home.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: Text('Books'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  groupedBooksFuture = fetchAndGroupBooks('3');
                });
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ))
        ],
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: groupedBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books found'));
          }

          Map<String, List<Map<String, dynamic>>> groupedBooks = snapshot.data!;

          final screenWidth = MediaQuery.of(context).size.width;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewsHome(),
                studentTextGridView(groupedBooks,screenWidth),
                ReadHistoryHome()
              ],
            ),
          );


        },
      ),
    );
  }
}
