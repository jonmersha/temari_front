import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:temari/core/constants.dart';

Future<Map<String, List<Map<String, dynamic>>>> fetchAndGroupBooks(apiEnd) async {
  print('$getData/$apiEnd');
  final url = Uri.parse('$getData/$apiEnd');
  try {
    final response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<dynamic> books = data['Data'];
      Map<String, List<Map<String, dynamic>>> groupedData = {};

      for (var book in books) {
        String regionName = book['region_name'];
        if (groupedData.containsKey(regionName)) {
          groupedData[regionName]!.add(book);
        } else {
          groupedData[regionName] = [book];
        }
      }

      return groupedData;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
