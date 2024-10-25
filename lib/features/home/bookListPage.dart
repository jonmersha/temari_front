import 'package:flutter/material.dart';
import 'package:temari/core/functions.dart';
import 'package:temari/features/downloader/save_pdf.dart';

class BookListPage extends StatelessWidget {
  final String regionName;
  final List<Map<String, dynamic>> books;
  BookListPage({required this.regionName, required this.books});
  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> groupedByGrade =
        groupBooksByGrade(books);

    return Scaffold(
      //backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
       // backgroundColor: Colors.grey.shade900,
        title: Text('$regionName'),
      ),
      body: ListView.builder(
        itemCount: groupedByGrade.keys.length,
        itemBuilder: (context, index) {
          String gradeName = groupedByGrade.keys.elementAt(index);
          List<Map<String, dynamic>> booksForGrade = groupedByGrade[gradeName]!;
          return buildCardTile(gradeName, booksForGrade, context);
        },
      ),
    );
  }

}
Widget buildCardTile(String gradeName, List<Map<String, dynamic>> booksForGrade, BuildContext context) {
  return Container(
    child: Card(
      color: Colors.white,
      elevation: 4,
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: 50,
                height: 70,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/leading.png'),fit: BoxFit.fitWidth),
                  borderRadius: BorderRadius.circular(10),
                )

            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gradeName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),

                Row(
                  children: [
                    Text('${booksForGrade.length}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                    Text(' Books',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                  ],
                ),

              ],
            ),
          ],
        ),
        children: booksForGrade.map((book) {
          return  subjectList(book, context);


        }).toList(),
      ),
    ),
  );
}

Column subjectList(Map<String, dynamic> book, BuildContext context) {
  return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
             color: Colors.white30,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu_book,size: 30,color: Colors.purple,),
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(' ${book['textbook_title']}',style: TextStyle(fontWeight: FontWeight.bold),),
                     // Divider(),
                      Text('${book['textbook_description']}'),
                    ],
                  ),
                ),
                IconButton(onPressed: (){

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaveFile(book: book),

                    ),
                  );
                }, icon: Icon(Icons.open_in_new, size: 30,color: Colors.green,))
              ],
            ),),
          Divider()
        ],
      );
}

