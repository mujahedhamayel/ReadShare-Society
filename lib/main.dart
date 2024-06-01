import 'package:facebook/providers/user_provider.dart';
import 'package:facebook/services/notification_service.dart';

import '/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:facebook/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationService = NotificationService();
  notificationService.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        home: WelcomePage(),
        routes: {
          '/home': (context) => NavScreen(),
          '/signin': (context) => SignInPage(),
          '/nav_screen': (context) => NavScreen(),
        },
      ),
    ),
  );
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromRGBO(226, 124, 126, 0.978),
            ), // Button color
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ), // Padding around icon
            shape: WidgetStateProperty.all<OutlinedBorder>(
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
