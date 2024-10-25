import 'package:flutter/material.dart';
import 'package:temari/features/service_provider/exam_draft/builder_widget.dart';
import 'package:temari/features/service_provider/exam_draft/exam_model.dart';

class ExamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exam')),
      body: FutureBuilderWidget<List<Question>>(
        future: fetchQuestions(),
        builder: (context, questions) {
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return _buildQuestionCard(questions[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Column(
              children: question.choices.map((choice) {
                return ListTile(
                  title: Text(choice),
                  onTap: () {
                    // Handle answer selection
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
