import 'package:flutter/material.dart';
import 'package:read_share/content/HomeContent.dart';
import 'package:read_share/content/ProfilePage.dart';
import 'package:read_share/content/BooksContent.dart';
import 'package:read_share/content/WishlistContent.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.menu_book_sharp),
    activeIcon: Icon(Icons.menu_book_sharp),
    label: 'Books',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.favorite_border),
    activeIcon: Icon(Icons.favorite_rounded),
    label: 'Wishlist',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Profile',
  ),
];

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;

    return Scaffold(
      bottomNavigationBar: isSmallScreen
          ? BottomNavigationBar(
              items: _navBarItems,
              currentIndex: _selectedIndex,
              selectedItemColor: const Color.fromRGBO(226, 124, 126, 0.978),
              unselectedItemColor: const Color(0xff757575),
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            )
          : null,
      body: Row(
        children: <Widget>[
          if (!isSmallScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              extended: isLargeScreen,
              selectedIconTheme: IconThemeData(
                  color: const Color.fromRGBO(226, 124, 126, 0.978)),
              unselectedIconTheme:
                  IconThemeData(color: const Color(0xff757575)),
              destinations: _navBarItems
                  .map((item) => NavigationRailDestination(
                        icon: item.icon,
                        selectedIcon: item.activeIcon,
                        label: Text(
                          item.label!,
                        ),
                      ))
                  .toList(),
            ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: Center(
              child: _buildPage(_selectedIndex),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomeContent();
      case 1:
        return BooksContent();
      case 2:
        return WishlistContent();
      case 3:
        return ProfilePage();
      default:
        return Container();
    }
  }
}
