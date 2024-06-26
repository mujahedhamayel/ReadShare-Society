import 'package:flutter/material.dart';
import '/config/palette.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';

class CustomAppBar extends StatelessWidget {
  final User currentUser;
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;

  const CustomAppBar({
    super.key,
    required this.currentUser,
    required this.icons,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 65.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '',
            style: TextStyle(
              color: Palette.REDcolor,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.2,
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: double.infinity,
                width: 600.0,
                child: CustomTabBar(
                  icons: icons,
                  selectedIndex: selectedIndex,
                  onTap: onTap,
                  isBottomIndicator: true,
                ),
              ),
            ),
          ),
          Row(
            children: [
              UserCard(user: currentUser),
              const SizedBox(width: 12.0),
              CircleButton(
                icon: Icons.search,
                iconSize: 30.0,
                onPressed: () => print('Search'),
              ),
              CircleButton(
                icon: Icons.notifications,
                iconSize: 30.0,
                onPressed: () => print('notifications'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomAppBarDesktop extends StatefulWidget {
  final User currentUser;
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;

  const CustomAppBarDesktop({
    super.key,
    required this.currentUser,
    required this.icons,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  _CustomAppBarDesktopState createState() => _CustomAppBarDesktopState();
}

class _CustomAppBarDesktopState extends State<CustomAppBarDesktop> {
  final TextEditingController _searchController = TextEditingController();
  late FocusNode _focusNode;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 65.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '',
            style: TextStyle(
              color: Palette.REDcolor,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(
            width: 100,
          ),
          Row(
            children: [
              SizedBox(
                height: double.infinity,
                width: 600.0,
                child: CustomTabBar(
                  icons: widget.icons,
                  selectedIndex: widget.selectedIndex,
                  onTap: widget.onTap,
                  isBottomIndicator: true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(_isSearching ? Icons.close : Icons.search),
                      onPressed: () {
                        if (_isSearching) {
                          _searchController.clear();
                        } else {
                          // Perform search action
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              CircleButton(
                icon: Icons.notifications,
                iconSize: 30.0,
                onPressed: () => print('notifications'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
