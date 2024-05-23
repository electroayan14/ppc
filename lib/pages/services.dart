// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:ppc/pages/navigation_options/gallery.dart';
import 'package:ppc/pages/navigation_options/home.dart';
import 'package:ppc/pages/navigation_options/new_request.dart';
import 'package:ppc/pages/navigation_options/profile.dart';
import 'package:ppc/pages/navigation_options/requests/requests.dart';
import 'package:remixicon/remixicon.dart';

class Services extends StatefulWidget {
  const Services({super.key});
  @override
  State<Services> createState() {
    return _ServicesState();
  }
}

class _ServicesState extends State<Services> {
  int activeNavigationPage = 0;
  void backHome() {
    setState(() {
      activeNavigationPage = 0;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _loadProfile();
  //   print(customerId);
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> navigationOptions = [
      const Home(),
      Gallery(backHome: backHome),
      NewRequest(backHome: backHome),
      Requests(backHome: backHome),
      Profile(backHome: backHome),
    ];
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("lib/assets/bg-2.png"),
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only( 
            left: 18,
            right: 18,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BottomNavigationBar(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                items: [
                  const BottomNavigationBarItem(
                    label: "",
                    icon: Icon(
                      Remix.home_4_line,
                    ),
                  ),
                  const BottomNavigationBarItem(
                    label: "",
                    icon: Padding(
                      padding: EdgeInsets.only(
                        right: 10,
                      ),
                      child: Icon(
                        Remix.store_2_line,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(224, 171, 67, 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          size: 24,
                          color: Colors.black,
                          Remix.add_fill,
                        ),
                      ),
                    ),
                    label: "",
                  ),
                  const BottomNavigationBarItem(
                      label: "",
                      icon: Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                        ),
                        child: Icon(
                          Remix.send_plane_line,
                        ),
                      )),
                  const BottomNavigationBarItem(
                    label: "",
                    icon: Icon(
                      Remix.user_3_line,
                    ),
                  )
                ],
                currentIndex: activeNavigationPage,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: const Color.fromRGBO(224, 171, 67, 1),
                selectedFontSize: 0,
                unselectedFontSize: 0,
                iconSize: 22,
                onTap: (int value) {
                  setState(() {
                    activeNavigationPage = value;
                  });
                },
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: navigationOptions.elementAt(activeNavigationPage),
        ),
      ),
    );
  }
}
