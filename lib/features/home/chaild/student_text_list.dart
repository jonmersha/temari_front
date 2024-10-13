import 'package:flutter/material.dart';
import 'package:temari/features/bookListPage.dart';

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
          crossAxisCount: (screenWidth<500)?3:6, // Two items per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: (screenWidth<500)?0.8:0.9, // Adjust as needed
        ),
        itemCount: groupedBooks.length,
        // Example item count
        itemBuilder: (context, index) {
          String regionName = groupedBooks.keys.elementAt(index);
          List<Map<String, dynamic>> books = groupedBooks[regionName]!;

          return Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
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
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('${books.first['textbook_image_url']}'),
                          fit: BoxFit.cover
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  //const SizedBox(height: 20,),
                  Text('$regionName',style: TextStyle(color:Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                  Divider(),
                  Text('${books.length} Text Books',style: TextStyle(color:Colors.white,fontSize: 14,fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5,),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );
}
