import 'dart:convert';

import 'package:facebook/services/notification_service.dart';
import 'package:facebook/utils/auth_token.dart';
import 'package:facebook/models/models.dart';
import 'package:facebook/providers/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:facebook/constants.dart';
import 'package:facebook/screens/SignUpScreen.dart';
import 'package:facebook/screens/screens.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Logo(),
                  SizedBox(height: 20),
                  _FormContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.jpg', // Adjust the path to match your logo image
          width: isSmallScreen ? 200 : 300,
          height: isSmallScreen ? 200 : 300,
        ),
        const Text(
          "Login",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  __FormContentState createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final TextEditingController _emailController =
      TextEditingController(text: "test111@test.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "123456");
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _notificationService = NotificationService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      var url = Uri.parse('http://$ip:$port/api/users/login');
      var response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        print("response ${response.body}");
        final body = jsonDecode(response.body);
        final backendToken = body['token'];
        AuthToken().setToken(backendToken);

        url = Uri.parse('http://$ip:$port/api/users/profile');

        response = await http.get(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $backendToken',
          },
        );

        var data = jsonDecode(response.body);
        User user = User.fromJson(
            data['user']); // Assuming your API returns a user object
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        // Get the device token
       
       
      _notificationService.saveTokenToServer();
        // Save the token to your backend server
       
        Navigator.pushReplacementNamed(context, '/nav_screen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid email';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined, color: Colors.black),
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon:
                    const Icon(Icons.lock_outline_rounded, color: Colors.black),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                labelStyle: const TextStyle(color: Colors.black),
                hintStyle: const TextStyle(color: Colors.black),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            _gap(),
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _rememberMe = value;
                  });
                }
              },
              title: const Text('Remember me',
                  style: TextStyle(color: Colors.black)),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              activeColor: Colors.black,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(226, 124, 126, 0.978),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: _signIn,
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            _gap(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ResetPassPage()),
                );
              },
              child: const Text(
                "Forgot password?",
                style: TextStyle(color: Color.fromRGBO(226, 124, 126, 0.978)),
              ),
            ),
            _gap(),
            _gap(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpBasicPage()),
                      );
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(
                          color: Color.fromRGBO(226, 124, 126, 0.978)),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
