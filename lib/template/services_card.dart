// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard(
      {required this.goto, required this.img, this.bg, super.key});
  final Widget goto;
  final String img;
  final Color? bg;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => goto,
            ));
      },
      child: Card(
        color: (bg == null) ? Colors.transparent : bg,
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              color: Color.fromRGBO(224, 171, 67, 1),
            ),
            /*image: DecorationImage(
              fit: BoxFit.scaleDown,
              image: AssetImage(img),
            ),*/
          ),
          height: 100,
          width: 100,
          child: Image.asset(
            img,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
