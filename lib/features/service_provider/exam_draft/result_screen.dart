import 'package:flutter/material.dart';
import 'package:temari/features/service_provider/exam_draft/builder_widget.dart';
import 'package:temari/features/service_provider/exam_draft/result_model.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      body: FutureBuilderWidget<List<Result>>(
        future: fetchResults(), // Fetch data for results
        builder: (context, results) {
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(results[index].resultText),
                subtitle: Text('Score: ${results[index].score}'),
              );
            },
          );
        },
      ),
    );
  }
}
