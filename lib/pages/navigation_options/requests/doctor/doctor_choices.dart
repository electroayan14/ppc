import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/navigation_options/requests/doctor/cardiologists.dart';
import 'package:ppc/template/top_bar.dart';
import 'package:remixicon/remixicon.dart';

class DoctorChoices extends StatefulWidget {
  const DoctorChoices({super.key});

  @override
  State<DoctorChoices> createState() => _DoctorChoicesState();
}

class _DoctorChoicesState extends State<DoctorChoices> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> doctorChoiceList = [];

  List<dynamic> _checkDocCategBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var _,
          "success": bool success,
          "code": int code,
          "data": {
            "categories": List<dynamic> doctorChoicesResponse,
          }
        }) {
      showSnackBarMessage(context, message: message);
      return doctorChoicesResponse;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> _loadDoctorCategs() async {
    final url = Uri.parse(
        'https://app.premscollectionskolkata.com/api/doctor-categories');
    try {
      final result = await getGetResponseWithHeader(url, headersWithToken);

      return (_checkDocCategBody(result));
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return [];
      }
      showSnackBarMessage(context,
          message: 'Something went wrong while fetching doctor choices.');
    }
    return [];
  }

  void _asyncMethod() async {
    doctorChoiceList = await _loadDoctorCategs();
    setState(() {
      doctorChoices = List.generate(
        doctorChoiceList.length,
        (index) => [
          doctorChoiceList[index]["id"],
          doctorChoiceList[index]["name"],
        ],
      );
    });
  }

  @override
  void initState() {
    _asyncMethod();
    super.initState();
  }

  List<List<dynamic>> doctorChoices = [];
  @override
  Widget build(BuildContext context) {
    Map<int, String> doctorMap = {for (var e in doctorChoices) e[0]: e[1]};

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TopBar(
                      onPressed: () => Navigator.pop(context),
                      title: "Doctor\nBooking",
                      height: 0),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          for (var i in doctorChoices)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Cardiologists(
                                        doctorCategMap: doctorMap,
                                        selectedID: i[0],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          const Color.fromRGBO(50, 50, 50, 1),
                                    ),
                                    color: const Color.fromRGBO(30, 30, 30, 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  size: 18,
                                                  Remix.user_add_line,
                                                  color: Color.fromRGBO(
                                                      224, 171, 67, 1),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: const Color.fromRGBO(
                                                        232, 232, 232, 1),
                                                  ),
                                              i[1].toString(),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          size: 13,
                                          Icons.arrow_forward_ios_outlined,
                                          color:
                                              Color.fromRGBO(224, 171, 67, 1),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
