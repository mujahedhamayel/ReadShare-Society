import 'package:flutter/material.dart';
import '/config/palette.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/models/models.dart';

class ProfileAvatar extends StatelessWidget {
  final User user;
  final bool isActive;
  final bool hasBorder;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.user,
    this.isActive = false,
    this.hasBorder = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: Palette.REDcolor,
            child: CircleAvatar(
              radius: hasBorder ? 17.0 : 20.0,
              backgroundColor: Colors.grey[200],
              backgroundImage: CachedNetworkImageProvider(user.imageUrl ?? 'https://defaultimageurl.com/default.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}
