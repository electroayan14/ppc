import 'package:flutter/material.dart';

class GalleryCard extends StatelessWidget {
  const GalleryCard(
      {required this.imgLoc,
      required this.label,
      required this.onPressed,
      super.key});
  final String imgLoc, label;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          SizedBox(
            child: Card(
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.45,
                width: MediaQuery.of(context).size.width * 0.45,
                child: Image.network(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  imgLoc,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            style: Theme.of(context).textTheme.bodyLarge,
            label,
          ),
        ],
      ),
    );
  }
}
