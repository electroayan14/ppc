import 'package:flutter/material.dart';
import 'package:ppc/template/hotels.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({required this.hotelDetails, required this.onTap, super.key});
  final Hotels hotelDetails;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(
              hotelDetails.imgPath,
            ),
          ),
        ),
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.sizeOf(context).height*0.25,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Color.fromARGB(255, 0, 0, 0),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                          softWrap: true,
                          style: Theme.of(context).textTheme.headlineMedium,
                          hotelDetails.name),
                    ),
                    Text(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(175, 175, 175, 1),
                        ),
                        hotelDetails.price),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
