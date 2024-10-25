import 'package:flutter/material.dart';
import 'package:temari/core/auth/data/network_access.dart';
import 'package:temari/core/auth/result.dart';
import 'package:temari/core/utils/navigation.dart';

class ServiceRegistrationPage extends StatefulWidget {
  final String usrId;

  const ServiceRegistrationPage({super.key, required this.usrId});
  @override
  _ServiceRegistrationPageState createState() => _ServiceRegistrationPageState();
}

class _ServiceRegistrationPageState extends State<ServiceRegistrationPage> {
  bool isLoading=false;
  // Create controllers for each input field
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();

  String? _selectedServiceType;
  final List<String> _serviceTypes = [
    'Tutoring', 'Group Study', 'Homework Help', 'Exam and Test', 'Private Teaching', 'Other'
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose of controllers when no longer needed
    _serviceNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Collect the form data into variables
      String serviceName = _serviceNameController.text;
      String description = _descriptionController.text;
      String serviceType = _selectedServiceType!; // Dropdown selected value

      // Build the JSON structure
      Map<String, dynamic> serviceData = {

        "service_name": serviceName,
        "service_type": serviceType,
        "description": description,
        "user_id": widget.usrId, // Assume user ID comes from the logged-in user

      };
      //print('Service Data: $serviceData');
      setState(() async {
        isLoading=true;
        List<dynamic> registerService=await  register('11', serviceData);
        isLoading=false;
        navigateReplace(context: context, page: UpdateResult(response:registerService[0]));
      });



    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _serviceNameController,
                decoration: InputDecoration(labelText: 'Service Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a service name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedServiceType,
                decoration: InputDecoration(labelText: 'Service Type'),
                items: _serviceTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedServiceType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a service type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              !isLoading?
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Register Your Service'),
              ):Column(
                children: [
                  Text('Registering Your service'),
                  CircularProgressIndicator(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
