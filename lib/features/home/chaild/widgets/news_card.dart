import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String date;

  NewsCard({required this.title, required this.description, required this.imageUrl, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 100,
      width: 300,
      child: Card(

        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // News title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),

                  // News description
                  Text(
                    description,
                    maxLines: 2,  // Show just two lines of description
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),

                  // News date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.blueAccent)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NewsCardDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          NewsCard(
            title: 'Breaking News',
            description: 'This is the latest news happening right now...',
            imageUrl: 'https://via.placeholder.com/400x200', // Sample image URL
            date: 'Oct 13, 2024',
          ),
          NewsCard(
            title: 'Flutter Update',
            description: 'Flutter has released a new version with exciting features...',
            imageUrl: 'https://via.placeholder.com/400x200', // Sample image URL
            date: 'Oct 12, 2024',
          ),
        ],
      ),
    );
  }
}

