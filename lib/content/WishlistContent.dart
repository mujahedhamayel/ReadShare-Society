import 'package:flutter/material.dart';

class WishlistContent extends StatefulWidget {
  const WishlistContent({Key? key}) : super(key: key);

  @override
  _WishlistContentState createState() => _WishlistContentState();
}

class _WishlistContentState extends State<WishlistContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isActive = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;
    return Center(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          leading: isLargeScreen
              ? null
              : IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
          actions: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: 400), // Set a maximum width for the Row
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        child: _isActive
                            ? Container(
                                height: 40, // Adjust the height as needed
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: 'Search for something',
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isActive = false;
                                            });
                                          },
                                          icon: const Icon(Icons.close))),
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isActive = true;
                                  });
                                },
                                icon: const Icon(Icons.search)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: isLargeScreen ? null : _drawer(),
        body: const Center(
          child: Text(
            "Body",
          ),
        ),
      ),
    );
  }

  Widget _drawer() => Drawer(
        child: ListView(
          children: _menuItems
              .map((item) => ListTile(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    title: Text(item),
                  ))
              .toList(),
        ),
      );

  Widget _navBarItems() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _menuItems
            .map(
              (item) => InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16),
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            )
            .toList(),
      );
}

final List<String> _menuItems = <String>[
  'About',
  'Contact',
  'Settings',
  'Sign Out',
];