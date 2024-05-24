import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/template/top_bar.dart';
import 'package:remixicon/remixicon.dart';

class DinnerMenu extends StatefulWidget {
  const DinnerMenu({super.key});

  @override
  State<DinnerMenu> createState() => _DinnerMenuState();
}

class _DinnerMenuState extends State<DinnerMenu> {
  final _formKey = GlobalKey<FormState>();

  List<dynamic> menu = [];
  List<dynamic> _checkMenuBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var _,
          "success": bool success,
          "code": int code,
          "data": {
            "dinner_menus": List<dynamic> menuResponse,
          }
        }) {
      return menuResponse;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> _loadMenu() async {
    final url =
        Uri.parse('https://app.premscollectionskolkata.com/api/dinner-menus');
    try {
      final result = await getGetResponseWithHeader(url, headersWithToken);

      menu.addAll(_checkMenuBody(result));
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return [];
      }
      showSnackBarMessage(context,
          message: 'Something went wrong while fetching menu.');
    }

    return menu;
  }

  void _asyncMethod() async {
    menu = await _loadMenu();
    setState(() {
      menuItems = List.generate(
        menu.length,
        (index) => menu[index]["name"],
      );
      menuImages = List.generate(
        menu.length,
        (index) => menu[index]["image"],
      );
    });
  }

  @override
  void initState() {
    menuItems = [];
    menuImages = [];

    _asyncMethod();
    super.initState();
  }

  List<String> menuItems = [];
  List<String> menuImages = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "lib/assets/bg-2.png",
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      TopBar(
                          onPressed: () => Navigator.pop(context),
                          title: "Dinner\nMenu",
                          height: 0),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(30, 30, 30, 1),
                            border: Border.all(
                              color: const Color.fromRGBO(50, 50, 50, 1),
                            ),
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              for (int i = 0; i < menuItems.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Remix.restaurant_2_fill,
                                            color:
                                                Color.fromRGBO(224, 171, 67, 1),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Switzer',
                                              color: Color.fromRGBO(
                                                  226, 226, 226, 1),
                                            ),
                                            menuItems[i],
                                          ),
                                        ],
                                      ),
                                      (i < menuItems.length - 1)
                                          ? const Divider()
                                          : const SizedBox()
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromRGBO(224, 171, 67, 1),
                      ),
                      minimumSize: MaterialStatePropertyAll(
                        Size.fromHeight(55),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      "BACK",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
