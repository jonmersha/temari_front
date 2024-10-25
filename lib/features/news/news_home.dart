import 'package:flutter/material.dart';
import 'package:temari/core/utils/network_access.dart';

class NewsHome extends StatefulWidget {
  const NewsHome({super.key});

  @override
  State<NewsHome> createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  late Future<List<dynamic>> data;

  @override
  void initState() {
    super.initState();
    setState(() {
      data = fetchData('9');
      //print(data);
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
            return Center();
          }
          List<dynamic> newsData = snapshot.data!;
          return (newsData.length == 0)
              ? Container()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('News',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
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
