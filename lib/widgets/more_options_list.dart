import 'package:flutter/material.dart';
import '/config/palette.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';

class MoreOptionsList extends StatelessWidget {
  final List<List> _moreOptionsList = const [
    [Icons.flag, Colors.orange, 'Pages'],
    [Icons.storefront, Palette.REDcolor, 'Marketplace'],
    [Icons.ondemand_video, Palette.REDcolor, 'Watch'],
  ];

  final User currentUser;

  const MoreOptionsList({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280.0),
      child: ListView.builder(
        itemCount: 1 + _moreOptionsList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: UserCard(user: currentUser),
            );
          }
          final List option = _moreOptionsList[index - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _Option(
              icon: option[0],
              color: option[1],
              label: option[2],
            ),
          );
        },
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _Option({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print(label),
      child: Row(
        children: [
          Icon(icon, size: 38.0, color: color),
          const SizedBox(width: 6.0),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
