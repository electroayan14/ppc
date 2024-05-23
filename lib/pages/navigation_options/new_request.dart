import 'package:flutter/material.dart';
import 'package:ppc/pages/navigation_options/requests/astrologer/astrologers.dart';
import 'package:ppc/pages/navigation_options/requests/cars/car_request_form.dart';
import 'package:ppc/pages/navigation_options/requests/dinner/dinner_request_form.dart';
import 'package:ppc/pages/navigation_options/requests/doctor/doctor_choices.dart';
import 'package:ppc/pages/navigation_options/requests/hotels/hotel_choices.dart';
import 'package:ppc/pages/services.dart';
import 'package:ppc/template/gallery_card.dart';
import 'package:ppc/template/top_bar.dart';

class NewRequest extends StatelessWidget {
  const NewRequest({required this.backHome, super.key});
  final void Function() backHome;
  @override
  Widget build(BuildContext context) {
    List<String> requests = [
      "Hotel",
      "Car",
      "Dinner",
      "Doctor",
      "Astrologer",
    ];
    List<String> imgs = [
      "lib/assets/hotel_services.png",
      "lib/assets/car_services.png",
      "lib/assets/dinner_services.png",
      "lib/assets/doctor.png",
      "lib/assets/astro.png",
    ];
    List<Widget> requestsWidgets = [
      const HotelChoices(),
      const CarRequestForm(),
      const DinnerRequestForm(),
      const DoctorChoices(),
      const Astrologers(),
    ];
    return Column(
      children: [
        TopBar(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Services(),
              )),
          title: "Make\nA Request",
          height: 22,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  color: Color.fromRGBO(224, 171, 67, 1),
                ),
                "What service would you like to request for?",
              ),
              SizedBox()
            ],
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemCount: requests.length,
            itemBuilder: (context, index) => GalleryCard(
                imgLoc: imgs[index],
                label: requests[index],
                viewMode: 0,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => requestsWidgets[index],
                      ));
                }),
          ),
        )
      ],
    );
  }
}
