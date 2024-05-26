import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomLikedNotifcation extends StatelessWidget {
  const CustomLikedNotifcation({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 80,
          width: 80,
          child: Stack(children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: CachedNetworkImageProvider(
                  'https://images.unsplash.com/photo-1528892952291-009c663ce843?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=592&q=80',
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: CircleAvatar(
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider(
                    'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                  )),
            ),
          ]),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                maxLines: 2,
                text: TextSpan(
                    text: "John Steve",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: const Color(0xFF2E3E5C)),
                    children: [
                      TextSpan(
                        text: " and \n",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: const Color(0xFF9FA5C0)),
                      ),
                      const TextSpan(text: "Sam Wincherter")
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("Liked your recipe  .  h1",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: const Color(0xFF9FA5C0)))
            ],
          ),
        ),
        Image.asset(
          "assets/images/book1.png",
          height: 64,
          width: 64,
        ),
      ],
    );
  }
}
