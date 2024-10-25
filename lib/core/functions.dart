// Group books by grade
Map<String, List<Map<String, dynamic>>> groupBooksByGrade(
    List<Map<String, dynamic>> books) {
  Map<String, List<Map<String, dynamic>>> groupedBooks = {};

  for (var book in books) {
    String gradeName = book['textbook_grade'].toString();
    if (groupedBooks.containsKey(gradeName)) {
      groupedBooks[gradeName]!.add(book);
    } else {
      groupedBooks[gradeName] = [book];
    }
  }

  return groupedBooks;
}
