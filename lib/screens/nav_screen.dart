import 'package:flutter/material.dart';
import '/data/data.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    const BooksContent(), // Replace Scaffold with BooksContent
    const Scaffold(), // Placeholder for other screens
    const Scaffold(), // Placeholder for other screens
    const Scaffold(), // Placeholder for other screens
    const Scaffold(), // Placeholder for other screens
  ];
  final List<IconData> _icons = const [
    Icons.home,
    Icons.menu_book_sharp,
    Icons.favorite,
    Icons.message_sharp,
    Icons.menu,
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: _icons.length,
      child: Scaffold(
        appBar: Responsive.isDesktop(context)
            ? PreferredSize(
                preferredSize: Size(screenSize.width, 100.0),
                child: CustomAppBar(
                  currentUser: currentUser,
                  icons: _icons,
                  selectedIndex: _selectedIndex,
                  onTap: (index) => setState(() => _selectedIndex = index),
                ),
              )
            : null,
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: !Responsive.isDesktop(context)
            ? Container(
                padding: const EdgeInsets.only(bottom: 0.0),
                color: Colors.white,
                child: CustomTabBar(
                  icons: _icons,
                  selectedIndex: _selectedIndex,
                  onTap: (index) => setState(() => _selectedIndex = index),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
