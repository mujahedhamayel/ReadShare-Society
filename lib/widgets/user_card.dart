import 'package:facebook/screens/ProfilePage.dart';
import 'package:facebook/screens/chatscreen.dart';
import 'package:flutter/material.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(
            user: user,
            isActive: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          ),
          const SizedBox(width: 6.0),
          Flexible(
            child: Text(
              user.name,
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class UserCardChat extends StatelessWidget {
  final User user;

  const UserCardChat({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chatscreen(user: user),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(
            user: user,
            isActive: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          ),
          const SizedBox(
              width: 12.0), // Adjusted padding between avatar and name
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10.0), // Padding around the user's name
              child: Text(
                user.name,
                style: const TextStyle(fontSize: 16.0),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
