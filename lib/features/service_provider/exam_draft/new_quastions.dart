
import 'package:flutter/material.dart';
import 'package:temari/core/auth/data/network_access.dart';
import 'package:temari/core/auth/result.dart';
import 'package:temari/core/utils/navigation.dart';
class QuestionRegistrationForm extends StatefulWidget {
  final dynamic examModel;

  const QuestionRegistrationForm({super.key,required this.examModel});
  @override
  _QuestionRegistrationFormState createState() => _QuestionRegistrationFormState();
}

class _QuestionRegistrationFormState extends State<QuestionRegistrationForm> {
  // Create controllers for each input field
  final TextEditingController _pointController = TextEditingController();
  final TextEditingController _examQuestionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose of the controllers when no longer needed to free up resources
    _pointController.dispose();
    _examQuestionController.dispose();
    super.dispose();
  }


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> serviceProviderData = {
        "exam_id":widget.examModel['exam_id'],
        "question_text": _examQuestionController.text,
        "points": _pointController.text,
      };
      performUpdate(19, serviceProviderData);
    }

  }
  bool isLoading=false;
  Future<void> performUpdate(int i, Map<String, dynamic> serviceProviderData)async {
    isLoading=true;
    List<dynamic> response= await register(i, serviceProviderData);

    setState(() {
      isLoading=false;

      navigateReplace(context: context, page: UpdateResult(response: response[0],));
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Exam question Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _examQuestionController,
                decoration: InputDecoration(labelText: 'Please inter your Question'),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _pointController,
                decoration: InputDecoration(labelText: 'Please inter phone number'),
                keyboardType: TextInputType.phone,
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
