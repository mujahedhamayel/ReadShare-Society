import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode
import 'package:uuid/uuid.dart'; // For uuid generation if needed
import 'package:facebook/constants.dart';
import '/screens/screens.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
                        child: const Column(
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
            "Create your account",
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _userNameController,
                  decoration: const InputDecoration(
                    labelText: 'UserName',
                    hintText: 'Enter your UserName',
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: Colors.black),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: Colors.black),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black),
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
                const SizedBox(height: 16),
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
                const Center(child: Text("Or")),
                const SizedBox(height: 16),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color.fromRGBO(226, 124, 126, 0.978),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/google.jpg'),
                                fit: BoxFit.cover),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 18),
                        const Text(
                          "Sign In with Google",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(226, 124, 126, 0.978)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              
                                builder: (context) => const SignInPage()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Color.fromRGBO(226, 124, 126, 0.978)),
                        ))
                  ],
                )
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
