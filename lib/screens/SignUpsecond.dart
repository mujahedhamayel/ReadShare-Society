import 'package:facebook/models/user_model.dart';
import 'package:facebook/providers/user_provider.dart';
import 'package:facebook/screens/map_screen.dart';
import 'package:facebook/services/notification_service.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _gender;
  LatLng? _selectedLocation;
  final _notificationService = NotificationService();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectLocation(BuildContext context) async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
            initialLocation: LatLng(32.220086172828864, 35.25749994011423)),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = selectedLocation;
        _locationController.text =
            '${selectedLocation.latitude}, ${selectedLocation.longitude}';
      });
    }
  }

  void _signUp(BuildContext context) async {
    final url = Uri.parse('http://$ip:$port/api/users/signup');
    final Map<String, dynamic> body = {
      'name': widget.userName,
      'email': widget.email,
      'password': widget.password,
      'mobileNumber': _mobileNumberController.text,
      'gender': _gender,
      'birthday': formatDate(_dobController.text),
    };

    // Add location if it has been set
    if (_selectedLocation != null) {
      body['location'] = {
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      };
    }

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final backendToken = body['token'];
      AuthToken().setToken(backendToken);

      var url = Uri.parse('http://$ip:$port/api/users/profile');
      response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $backendToken',
        },
      );

      var data = jsonDecode(response.body);
      User user = User.fromJson(data['user']);

      _notificationService.saveTokenToServer();
      
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: ${response.body}')),
      );
    }
  }

  String formatDate(String date) {
    List<String> parts = date.split('/');
    return "${parts[2]}-${parts[1]}-${parts[0]}";
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
                              dobController: _dobController,
                              locationController: _locationController,
                              gender: _gender,
                              onGenderChanged: (String? newValue) {
                                setState(() {
                                  _gender = newValue;
                                });
                              },
                              onSelectDate: () => _selectDate(context),
                              onSelectLocation: () => _selectLocation(context),
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
                                    dobController: _dobController,
                                    locationController: _locationController,
                                    gender: _gender,
                                    onGenderChanged: (String? newValue) {
                                      setState(() {
                                        _gender = newValue;
                                      });
                                    },
                                    onSelectDate: () => _selectDate(context),
                                    onSelectLocation: () =>
                                        _selectLocation(context),
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
}

class _AdditionalFormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController mobileNumberController;
  final TextEditingController dobController;
  final TextEditingController locationController;
  final String? gender;
  final Function(String?) onGenderChanged;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectLocation;

  const _AdditionalFormContent({
    required this.formKey,
    required this.mobileNumberController,
    required this.dobController,
    required this.locationController,
    required this.gender,
    required this.onGenderChanged,
    required this.onSelectDate,
    required this.onSelectLocation,
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
                GestureDetector(
                  onTap: onSelectLocation,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        hintText: 'Select your location',
                        prefixIcon:
                            Icon(Icons.location_on, color: Colors.black),
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black),
                      ),
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
