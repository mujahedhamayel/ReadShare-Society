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
    Key? key,
    required this.user,
    this.isActive = false,
    this.hasBorder = false,
    required this.onTap,
  }) : super(key: key);

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
              backgroundImage: CachedNetworkImageProvider(user.imageUrl),
            ),
          ),
          isActive
              ? Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 15.0,
                    width: 15.0,
                    decoration: BoxDecoration(
                      color: Palette.online,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
