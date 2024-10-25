import 'dart:convert';
import 'package:http/http.dart' as http;

class Result {
  final String resultText;
  final int score;
  final String examDate;

  Result({
    required this.resultText,
    required this.score,
    required this.examDate,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      resultText: json['resultText'],
      score: json['score'],
      examDate: json['examDate'],
    );
  }
}


Future<List<Result>> fetchResults() async {
  final response = await http.get(Uri.parse('https://temari.besheger.com/get/data/results'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);

    // Convert the JSON data into a list of Result objects
    return data.map((json) => Result.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load results');
  }
}
