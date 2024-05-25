import 'package:flutter/material.dart';
import '/screens/screens.dart';

void main() {
  runApp(
    MaterialApp(
      home: WelcomePage(),
      routes: {
        '/home': (context) => NavScreen(),
        '/signin': (context) => SignInPage(),
        '/nav_screen': (context) => NavScreen(),
      },
    ),
  );
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _Logo(),
              SizedBox(height: 20), // Adding some spacing
              _Text(), // Class names should be capitalized
            ],
          ),
        ),
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
      crossAxisAlignment: CrossAxisAlignment.center, // Center the logo
      children: [
        Image.asset(
          'assets/images/back.jpg', // Adjust the path to match your logo image
          width: isSmallScreen
              ? 550
              : 600, // Adjust the width and height to better fit smaller screens
          height: isSmallScreen ? 550 : 600,
        ),
      ],
    );
  }
}

class _Text extends StatelessWidget {
  const _Text();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center, // Center the button
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()),
            );
          },
          icon: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ), // Icon widget
          label: const Text(""), // Empty text to make space for icon
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromRGBO(226, 124, 126, 0.978),
            ), // Button color
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ), // Padding around icon
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ), // Button shape
          ),
        ),
      ],
    );
  }
}
