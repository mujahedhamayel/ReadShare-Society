import 'package:facebook/utils/auth_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode
import 'package:uuid/uuid.dart'; // For uuid generation if needed
import 'package:facebook/constants.dart';
import '/screens/screens.dart';

class SignUpPage2 extends StatelessWidget {
  const SignUpPage2({super.key});

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
                    ? const SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _FormContent(),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(32.0),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Center(child: _FormContent()),
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

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _gender;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
            "Contiune Create your account",
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _mobileNumberController,
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
                  controller: _addressController,
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
                  value: _gender,
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
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                InputDatePickerFormField(
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  initialDate: DateTime(2000),
                  fieldLabelText: 'Date of Birth',
                  onDateSubmitted: (DateTime date) {
                    setState(() {});
                  },
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
                      if (_formKey.currentState!.validate()) {
                        _signUp(context);
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

  void _signUp(BuildContext context) async {
    final url = Uri.parse('http://$ip:$port/api/users/signup');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _userNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Successful signup, navigate to Home screen
      final body = jsonDecode(response.body);
      final backendToken = body['token'];
      AuthToken().setToken(backendToken);
      Navigator.pushReplacementNamed(context, '/nav_screen');
    } else {
      // If the server returns an error response, show a Snackbar with the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: ${response.body}')),
      );
    }
  }
}

// class SignInPage extends StatelessWidget {
//   const SignInPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign In')),
//       body: Center(child: const Text('Sign In Page')),
//     );
//   }
// }

// class NavScreen extends StatelessWidget {
//   const NavScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Home')),
//       body: Center(child: const Text('Home Page')),
//     );
//   }
// }
