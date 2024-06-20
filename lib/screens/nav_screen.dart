import 'package:facebook/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data/data.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';
import '/screens/menu_page.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const BooksContent(),
    const FavoritePage(),
    const UserListPage(),
    const Scaffold(), // Placeholder for other screens
  ];
  final List<IconData> _icons = const [
    Icons.home,
    Icons.menu_book_sharp,
    Icons.bookmark,
    Icons.message_sharp,
    Icons.menu,
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final providerUser = Provider.of<UserProvider>(context).user;
    return DefaultTabController(
      length: _icons.length,
      child: Scaffold(
        appBar: Responsive.isDesktop(context)
            ? PreferredSize(
                preferredSize: Size(screenSize.width, 100.0),
                child: CustomAppBarDesktop(
                  currentUser: providerUser!,
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
            ? Builder(
                builder: (context) => BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    if (index == _icons.length - 1) {
                      Scaffold.of(context).openEndDrawer();
                    } else {
                      setState(() {
                        _selectedIndex = index;
                      });
                    }
                  },
                  backgroundColor: Colors.grey[800], // Set background color
                  selectedItemColor: const Color.fromARGB(
                      255, 176, 101, 101), // Set selected item color
                  unselectedItemColor:
                      Colors.grey[400], // Set unselected item color
                  items: _icons.map((icon) {
                    return BottomNavigationBarItem(
                      icon: Icon(icon),
                      label: '',
                    );
                  }).toList(),
                ),
              )
            : const SizedBox.shrink(),
        endDrawer: const MenuPage(),
      ),
    );
  }
}
