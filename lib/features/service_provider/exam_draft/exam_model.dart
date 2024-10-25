import 'dart:convert';
import 'package:http/http.dart' as http;

class Question {
  final String questionText;
  final List<String> choices;

  Question({
    required this.questionText,
    required this.choices,
  });

  // A factory method to create a Question from JSON data
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['questionText'],
      choices: List<String>.from(json['choices']),
    );
  }
}


Future<List<Question>> fetchQuestions() async {
  final response = await http.get(Uri.parse('https://temari.besheger.com/get/data/15'));

  if (response.statusCode == 200) {
    // Parse the JSON
    List<dynamic> data = jsonDecode(response.body);

    // Convert the JSON data into a list of Question objects
    return data.map((json) => Question.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load questions');
  }
}