import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    required this.onPressed,
    required this.title,
    required this.height,
    super.key,
  });
  final void Function() onPressed;
  final String title;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Remix.arrow_left_line,
                color: Color.fromRGBO(224, 171, 67, 1),
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            )
          ],
        ),
        SizedBox(
          height: height,
        )
      ],
    );
  }
}
