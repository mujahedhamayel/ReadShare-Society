import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../config/palette.dart';

class CustomFollowNotifcation extends StatefulWidget {
  const CustomFollowNotifcation({super.key});

  @override
  State<CustomFollowNotifcation> createState() =>
      _CustomFollowNotifcationState();
}

class _CustomFollowNotifcationState extends State<CustomFollowNotifcation> {
  bool follow = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
            radius: 25,
            backgroundImage: CachedNetworkImageProvider(
              'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
            )),
        const SizedBox(
          width: 15,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Dean Winchester",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: const Color(0xFF2E3E5C)),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "New following you  .  1h",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: const Color(0xFF9FA5C0)),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: follow == false ? 50 : 30),
            child: CustomButton(
              height: 40,
              color:
                  follow == false ? Palette.REDcolor : const Color(0xFFF4F5F7),
              textColor:
                  follow == false ? Colors.white : const Color(0xFF2E3E5C),
              onTap: () {
                setState(() {
                  follow = !follow;
                });
              },
              text: "Follow",
            ),
          ),
        ),
      ],
    );
  }
}
