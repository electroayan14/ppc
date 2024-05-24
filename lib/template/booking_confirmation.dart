import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppc/pages/services.dart';
import 'package:ppc/template/bottom_button.dart';

class BookingConfirmation extends StatelessWidget {
  const BookingConfirmation({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("lib/assets/bg-2.png"),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Column(
                    children: [
                      Container(
                        height: 105,
                        width: 109,
                        child: Image.asset(
                          "lib/assets/confirmation.png",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        style: Theme.of(context).textTheme.headlineLarge,
                        "Thank You",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        style: Theme.of(context).textTheme.bodyLarge,
                        "Your request has been received.",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontFamily: 'Switzer',
                              fontSize: 16,
                              color: Color.fromRGBO(217, 217, 217, 1),
                            ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        "Someone from our team will get back\nto you as soon as possible.",
                      ),
                    ],
                  ),
                  const SizedBox(),
                ],
              ),
              BottomButton(
                label: "BACK TO HOME",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Services(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
