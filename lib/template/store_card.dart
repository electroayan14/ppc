import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({required this.onTap, required this.imgLoc, super.key});
  final void Function() onTap;
  final String imgLoc;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(
                imgLoc,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
