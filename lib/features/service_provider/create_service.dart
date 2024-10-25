
import 'package:flutter/material.dart';
import 'package:temari/core/auth/data/network_access.dart';
import 'package:temari/core/auth/result.dart';
import 'package:temari/core/utils/navigation.dart';
class CreateServiceProfile extends StatefulWidget {
  final dynamic userModel;

  const CreateServiceProfile({super.key,required this.userModel});
  @override
  _CreateServiceProfileState createState() => _CreateServiceProfileState();
}

class _CreateServiceProfileState extends State<CreateServiceProfile> {
  // Create controllers for each input field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose of the controllers when no longer needed to free up resources
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> serviceProviderData = {
         "user_id":widget.userModel[0]['user_id'],
        "username": widget.userModel[0]['username'],
        "email": widget.userModel[0]['email'],
        "phone_number": _phoneNumberController.text,
        "bio": _bioController.text,
         // Example of adding a timestamp
      };
      performUpdate(10, serviceProviderData);
    }

  }
  bool isLoading=false;
  Future<void> performUpdate(int i, Map<String, dynamic> serviceProviderData)async {
    isLoading=true;
  List<dynamic> response= await register(i, serviceProviderData);

    setState(() {
      isLoading=false;
     //Navigator.pop(context);
      navigateReplace(context: context, page: UpdateResult(response: response[0],));
    });

  }

  @override
  Widget build(BuildContext context) {
    if(widget.userModel[0]['phone']!=null) {
      _phoneNumberController.text=widget.userModel[0]['phone'].toString();
    }
    // _bioController.dispose();
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Provider Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(labelText: 'Description of your service'),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneNumberController,
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
