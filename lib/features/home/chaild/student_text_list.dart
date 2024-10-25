import 'package:flutter/material.dart';
import 'package:temari/core/constants.dart';
import 'package:temari/features/home/bookListPage.dart';

Widget studentTextGridView(
    Map<String, List<Map<String, dynamic>>> groupedBooks, double screenWidth) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('የተማሪዎች መጽሐፍት/Students Text Books',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (screenWidth>800)?6:(screenWidth<500)?2:4, // Two items per row
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: (screenWidth<500)?2:1.6, // Adjust as needed
        ),
        itemCount: groupedBooks.length,
        // Example item count
        itemBuilder: (context, index) {
          String regionName = groupedBooks.keys.elementAt(index);
          List<Map<String, dynamic>> books = groupedBooks[regionName]!;

          return Card(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookListPage(regionName: regionName, books: books),
                    ),
                  );
                },
                child: Row(
                  children: [
                Container(width: 50,
                height: 50,
                decoration: BoxDecoration(
                image: DecorationImage(
                image: NetworkImage('$base/${books.first['textbook_image_url']}'),
                  fit: BoxFit.fitHeight
                            ),
                            borderRadius:  BorderRadius.circular(25),
                          ),
                          ),
                    SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$regionName',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        Text('${books.length} Text Books',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500)),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ],
  );
}
