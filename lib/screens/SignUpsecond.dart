import 'package:facebook/utils/auth_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode
import 'package:uuid/uuid.dart'; // For uuid generation if needed
import 'package:facebook/constants.dart';

class SignUpAdditionalPage extends StatefulWidget {
  final String userName;
  final String email;
  final String password;

  const SignUpAdditionalPage({
    super.key,
    required this.userName,
    required this.email,
    required this.password,
  });

  @override
  State<SignUpAdditionalPage> createState() => _SignUpAdditionalPageState();
}

class _SignUpAdditionalPageState extends State<SignUpAdditionalPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _gender;

  // Function to show the date picker and update the date of birth field
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Initial date of the date picker
      firstDate: DateTime(1900), // The earliest date the picker can select
      lastDate: DateTime(2100), // The latest date the picker can select
    );

    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              return Center(
                child: isSmallScreen
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _AdditionalFormContent(
                              formKey: _formKey,
                              mobileNumberController: _mobileNumberController,
                              addressController: _addressController,
                              dobController: _dobController,
                              gender: _gender,
                              onGenderChanged: (String? newValue) {
                                setState(() {
                                  _gender = newValue;
                                });
                              },
                              onSelectDate: () => _selectDate(context),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(32.0),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: _AdditionalFormContent(
                                    formKey: _formKey,
                                    mobileNumberController:
                                        _mobileNumberController,
                                    addressController: _addressController,
                                    dobController: _dobController,
                                    gender: _gender,
                                    onGenderChanged: (String? newValue) {
                                      setState(() {
                                        _gender = newValue;
                                      });
                                    },
                                    onSelectDate: () => _selectDate(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _signUp(BuildContext context) async {
    final url = Uri.parse('http://$ip:$port/api/users/signup');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': widget.userName,
        'email': widget.email,
        'password': widget.password,
        'mobileNumber': _mobileNumberController.text,
        'address': _addressController.text,
        'gender': _gender,
        'birthday': formatDate(_dobController.text),
      }),
    );

    if (response.statusCode == 200) {
      // Successful signup, navigate to Home screen
      final body = jsonDecode(response.body);
      final backendToken = body['token'];
      AuthToken().setToken(backendToken);
      Navigator.pushReplacementNamed(context, '/signin');
    } else {
      // If the server returns an error response, show a Snackbar with the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: ${response.body}')),
      );
    }
  }

  // Helper function to format date to YYYY-MM-DD
  String formatDate(String date) {
    List<String> parts = date.split('/');
    return "${parts[2]}-${parts[1]}-${parts[0]}";
  }
}

class _AdditionalFormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController mobileNumberController;
  final TextEditingController addressController;
  final TextEditingController dobController;
  final String? gender;
  final Function(String?) onGenderChanged;
  final VoidCallback onSelectDate;

  const _AdditionalFormContent({
    required this.formKey,
    required this.mobileNumberController,
    required this.addressController,
    required this.dobController,
    required this.gender,
    required this.onGenderChanged,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 60.0),
          const Text(
            "Sign up",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Continue to create your account",
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: mobileNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: 'Enter your mobile number',
                    prefixIcon: Icon(Icons.phone, color: Colors.black),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter your address',
                    prefixIcon: Icon(Icons.home, color: Colors.black),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  items: <String>['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: onGenderChanged,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onSelectDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dobController,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'Enter your date of birth',
                        prefixIcon:
                            Icon(Icons.calendar_today, color: Colors.black),
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                          226, 124, 126, 0.978), // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        (context as Element)
                            .findAncestorStateOfType<
                                _SignUpAdditionalPageState>()
                            ?._signUp(context);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
