import 'package:flutter/material.dart';
import 'package:untitled/SignInPage.dart';

void main() {
  runApp(
    MaterialApp(home: WelcomePage()), // use MaterialApp
  );
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Logo(),
                _text(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'img/back.jpg', // Adjust the path to match your logo image
          width: isSmallScreen ? 600 : 700,
          height: isSmallScreen ? 600 : 700,
        ),
      ],
    );
  }
}

class _text extends StatelessWidget {
  const _text({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            );
          },
          icon: Icon(Icons.arrow_forward, color: Colors.white), // Icon widget
          label: Text(''), // Empty text to make space for icon
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(226, 124, 126, 0.978)), // Button color
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                    vertical: 15, horizontal: 25)), // Padding around icon
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))), // Button shape
          ),
        ),
      ],
    );
  }
}
