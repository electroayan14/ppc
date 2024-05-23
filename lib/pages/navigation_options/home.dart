import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/main.dart';
import 'package:ppc/pages/home_page.dart';
import 'package:ppc/pages/navigation_options/requests/astrologer/astrologers.dart';
import 'package:ppc/pages/navigation_options/requests/cars/car_request_form.dart';

import 'package:ppc/pages/navigation_options/requests/dinner/dinner_request_form.dart';
import 'package:ppc/pages/navigation_options/requests/doctor/doctor_choices.dart';
import 'package:ppc/pages/navigation_options/requests/hotels/hotel_choices.dart';
import 'package:ppc/api_helpers/profile_data.dart';
import 'package:ppc/template/services_card.dart';
import 'package:remixicon/remixicon.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() {
    return _HomeState();
  }
}

Map<String, dynamic> storeDetails = {};

const Map<String, dynamic> userDetails = {};

class _HomeState extends State<Home> {
  List<dynamic> bannerMap = [];
  Map<int, String> imagesPrioMap = {};
  List<String> images = [];
  late PageController _pageController = PageController();
  int activePage = 1;

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index
                ? const Color.fromRGBO(224, 171, 67, 1)
                : const Color.fromARGB(127, 211, 211, 211),
            shape: BoxShape.circle),
      );
    });
  }

  List<dynamic> _checkBannerBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var _,
          "success": bool success,
          "code": int code,
          "data": {"banners": List<dynamic> bannerMapResponse}
        }) {
      return bannerMapResponse;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> _loadBannerImages() async {
    final url =
        Uri.parse('https://app.premscollectionskolkata.com/api/banners');
    try {
      final result = await getGetResponseWithHeader(url, headersWithToken);
      return _checkBannerBody(result);
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return [];
      }
      showSnackBarMessage(context,
          message: 'Something went wrong while fetching banners.');
    }
    return [];
  }

  Map _checkProfileBody(dynamic body) {
    if (body
        case {
          "msg": var message,
          "error": var _,
          "success": var _,
          "code": var code,
          "data": {"data": Map<dynamic, dynamic> userDataResponse},
        }) {
      print("Loading profile complete");
      return userDataResponse;
    } else {
      return {};
    }
  }

  Future<Map> loadProfile() async {
    final url =
        Uri.parse('https://app.premscollectionskolkata.com/api/fetch-profile');
    try {
      final result = await getGetResponseWithHeader(url, onlyToken);

      return _checkProfileBody(result);
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return {};
      }
      showSnackBarMessage(context, message: e.toString());
    }
    return {};
  }

  Map<dynamic, dynamic> userData = {};

  void _asyncFunc() async {
    bannerMap = await _loadBannerImages();

    userData = await loadProfile();

    if (mounted) {
      setState(() {
        userName = (userData["name"] != null) ? userData["name"] : "";
        userEmail = (userData["email"] != null) ? userData["email"] : "";
        customerId = userData["user_details"]["id"].toString();

        phone = (userData["user_details"]["phone"] != null)
            ? userData["user_details"]["phone"]
            : "";

        whatsapp = (userData["user_details"]["whatsapp"] != null)
            ? userData["user_details"]["whatsapp"]
            : "";

        dob = (userData["user_details"]["dob"] != null)
            ? userData["user_details"]["dob"]
            : "";

        address = (userData["user_details"]["address"] != null)
            ? userData["user_details"]["address"]
            : "";

        bio = (userData["user_details"]["bio"] != null)
            ? userData["user_details"]["bio"]
            : "";

        cardNumber = (userData["user_details"]["card_number"] != null)
            ? userData["user_details"]["card_number"]
            : "";

        clubName = (userData["user_details"]["club_name"] != null)
            ? userData["user_details"]["club_name"]
            : "";

        storeId = (userData["user_details"]["store_id"].toString() != null)
            ? userData["user_details"]["store_id"].toString()
            : "";

        storeDetails = (userData["user_details"]["store"] != null)
            ? userData["user_details"]["store"]
            : {};
        for (Map i in bannerMap) {
          imagesPrioMap[i["priority"]] = i["image"];
        }
      });
    }
  }

  void _checkLogoutBody(body) {
    if (body
        case {
          "msg": String message,
          "error": var _,
          "success": bool success,
          "code": int code,
          "data": var _
        }) {
      if (code == 200) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false);
        prefs.clear();
        showSnackBarMessage(context, message: message);
      }
    }
  }

  void _logout() async {
    final url = Uri.parse('https://app.premscollectionskolkata.com/api/logout');
    try {
      final result = await getGetResponseWithHeader(url, headersWithToken);
      _checkLogoutBody(result);
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      showSnackBarMessage(context,
          message: 'Something went wrong while trying to log out.');
    }
  }

  @override
  void initState() {
    _asyncFunc();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < imagesPrioMap.length; i++) {
      images.add(imagesPrioMap[i + 1]!);
    }
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 19,
              ),
              child: Image.asset(
                "lib/assets/placeholder.png",
                // height: 50,
                // width: 80,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Padding(
                    padding: EdgeInsets.only(top: 22, bottom: 20),
                    child: Icon(
                      Remix.notification_3_line,
                      size: 28,
                      color: Color.fromRGBO(224, 171, 67, 1),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Material(
                        type: MaterialType.transparency,
                        child: Center(
                          // Aligns the container to center
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 5,
                                  bottom: 30,
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                    ),
                                    child: ListView(
                                      children: [
                                        Center(
                                          child: Text(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge,
                                              "Menu"),
                                        ),
                                        ListTile(
                                          onTap: _logout,
                                          title: Padding(
                                            padding: const EdgeInsets.only(),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Divider(
                                                  color: Color.fromRGBO(
                                                      224, 171, 67, 1),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          22),
                                                          "Logout"),
                                                      const Icon(
                                                        Remix.logout_box_line,
                                                        color: Color.fromRGBO(
                                                            224, 171, 67, 1),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 28,
                        minWidth: 28,
                      ),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage(
                            "lib/assets/profile.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.2,
              width: double.infinity,
              child: PageView.builder(
                itemCount: images.length,
                pageSnapping: true,
                controller: _pageController,
                onPageChanged: (page) {
                  setState(
                    () {
                      activePage = page;
                    },
                  );
                },
                itemBuilder: (context, position) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        scale: 1,
                        fit: BoxFit.fitWidth,
                        images[position],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: indicators(
                images.length,
                activePage,
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.02,
        ),
        Center(
          child: Text(
            "Our Services",
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: const Color.fromRGBO(224, 171, 67, 1),
                  fontSize: 25,
                ),
          ),
        ),
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
        Padding(
          padding: const EdgeInsets.only(left: 15.0,right:15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center ,
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _optionView(const HotelChoices(), "lib/assets/hotel_services.png",
                    'Hotel'),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.02,
                ),
                _optionView(
                    const CarRequestForm(), "lib/assets/car_services.png", 'Car'),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.02,
                ),
                _optionView(const DinnerRequestForm(),
                    "lib/assets/dinner_services.png", "Dinner"),
              ],
            ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _optionView(
                    const DoctorChoices(), "lib/assets/doctor.png", 'Doctor'),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.02,
                ),
                _optionView(
                    const Astrologers(), "lib/assets/astro.png", 'Astrologer'),
              ],
            )
          ]),
        )
      ],
    );
  }

  //menu section option widget
  Widget _optionView(Widget gotoView, image, textValue) {
    return Column(
      children: [
        ServicesCard(
          goto: gotoView,
          img: image,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: 18,
                  color: const Color.fromRGBO(224, 171, 67, 1),
                ),
            textValue.toString()),
      ],
    );
  }
}
