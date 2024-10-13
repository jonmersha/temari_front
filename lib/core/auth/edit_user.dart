import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temari/core/utils/country_list.dart';

import 'data/UserModel.dart';

class UpdateUserForm extends StatefulWidget {
  final UserModel userData;
  final User google;

  const UpdateUserForm({Key? key, required this.userData, required this.google})
      : super(key: key);

  @override
  _UpdateUserFormState createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUserForm> {
  bool isEditable=false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _selectedStateController;

  //String? _selectedState;
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userData.username);
    //_emailController = TextEditingController(text: widget.userData.email);
    _firstNameController =
        TextEditingController(text: widget.userData.firstName);
    _lastNameController = TextEditingController(text: widget.userData.lastName);
    _phoneController = TextEditingController(text: widget.userData.phone);
    _addressController = TextEditingController(text: widget.userData.address);
    _cityController = TextEditingController(text: widget.userData.city);
    _postalCodeController =
        TextEditingController(text: widget.userData.postalCode);
    _selectedStateController =
        TextEditingController(text: widget.userData.state);
    //_selectedState = widget.userData.state;
    _selectedCountry = widget.userData.country;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    // _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _updateUser() {
    if (_formKey.currentState!.validate()) {
      // Perform PUT request to update user information
      Map<String, dynamic> updatedUserData = {
        "criteria": {"user_id": widget.userData.userId},
        "fields": {
          "username": _usernameController.text,
          "first_name": _firstNameController.text,
          "last_name": _lastNameController.text,
          "phone": _phoneController.text,
          "address": _addressController.text,
          "city": _cityController.text,
          "state": _selectedStateController.text,
          "country": _selectedCountry,
          "postal_code": _postalCodeController.text,
        }
      };
      //updateTable('19', updatedUserData);
      setState(() {
        //check the status
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child:
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                         // color: Colors.red,
                          image: DecorationImage(
                            image: NetworkImage('${widget.google.photoURL}'),
                            fit: BoxFit.fitHeight
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.userData.email}',
                        style: TextStyle(fontSize: 20,),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            isEditable=!isEditable;

                          });
                        },

                          child: !isEditable?
                          Icon(Icons.mode_edit_outline,color: Colors.red,size: 30,):
                          Icon(Icons.edit_off_outlined,color: Colors.green,size: 30,)

                        ,)
                    ],
                  ),
                //
                  SizedBox(
                    height: 20,
                  ),
                  if(isEditable)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        onPressed: _updateUser, child: Text('Save change',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.white,fontSize: 18),))
                  ],),
                  TextFormField(
                    controller: _usernameController,
                    enabled: isEditable,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    enabled: isEditable,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first Name';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          enabled: isEditable,
                          decoration: const InputDecoration(labelText: 'Last Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          enabled: isEditable,
                          decoration: const InputDecoration(labelText: 'Phone'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _addressController,
                    enabled: isEditable,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          enabled: isEditable,
                          decoration: const InputDecoration(labelText: 'City'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _selectedStateController,
                          enabled: isEditable,
                          decoration: const InputDecoration(labelText: 'State'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your State';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  isEditable?DropdownButtonFormField<String>(
                    value: _selectedCountry,

                    decoration: const InputDecoration(labelText: 'Country'),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCountry = newValue;
                      });
                    },
                    items: countries.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a country';
                      }
                      return null;
                    },
                  ):Text('Country:  ${widget.userData.country}'),
                  TextFormField(
                    controller: _postalCodeController,
                    enabled: isEditable,
                    decoration: const InputDecoration(labelText: 'Postal Code'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your postal code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  if(isEditable)
                  ElevatedButton(
                    onPressed: _updateUser,
                    child: const Text('Update'),
                  ),
                 // Text('Yo),
                  // MerchantProfile(userData: widget.userData)

                 ],
              ),
            ),
           //MerchantProfile(userData: widget.userData),
           // Text('Our Work')
          ],
        ),
      ),
    );
  }
}
