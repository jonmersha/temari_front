import 'package:flutter/material.dart';
import 'package:temari/core/network_access.dart';

class ReadHistoryHome extends StatefulWidget {
  const ReadHistoryHome({super.key});

  @override
  State<ReadHistoryHome> createState() => _ReadHistoryHomeState();
}

class _ReadHistoryHomeState extends State<ReadHistoryHome> {
  late Future<List<dynamic>> data;

  @override
  void initState() {
    super.initState();
    setState(() {
      data = fetchData('5');
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Reading Histry found'));
          }
          List<dynamic> newsData = snapshot.data!;
          return (newsData.length == 0)
              ? Container(child: Text('No Recent News'))
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('ከዚህ ቀደም ያነበቡት/What you have read before',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    //NewsCardDemo(),
                    Container(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: newsData.length, // Example item count
                        itemBuilder: (context, index) {
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text('${newsData[index]['title']}'),
                                Divider(),
                                Text('${newsData[index]['content']}'),


                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
        });
  }
}
