import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/navigation_options/requests/doctor/cardiologist.dart';
import 'package:ppc/pages/navigation_options/requests/doctor/cardiologist_card.dart';
import 'package:ppc/pages/navigation_options/requests/doctor/doctor_request_form.dart';
import 'package:ppc/template/top_bar.dart';

class Cardiologists extends StatefulWidget {
  const Cardiologists(
      {required this.selectedID, required this.doctorCategMap, super.key});
  final Map<int, String> doctorCategMap;
  final int selectedID;
  @override
  State<Cardiologists> createState() => _CardiologistsState();
}

class _CardiologistsState extends State<Cardiologists> {
  final _formKey = GlobalKey<FormState>();

  String name = "", education = "", specialization = "", imgPath = "";
  int experience = 0, docID = 0, categID = 1;
  List<dynamic> doctorsToDisplay = [];
  List<dynamic> _checkDocBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var _,
          "success": bool success,
          "code": int code,
          "data": {"doctors": List<dynamic> doctorResponse}
        }) {
      return doctorResponse;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> _loadDoctors() async {
    final url = Uri.parse(
        'https://app.premscollectionskolkata.com/api/doctors?category_id=${widget.selectedID}');

    try {
      final result = await getGetResponseWithHeader(url, onlyToken);

      return _checkDocBody(result);
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return [];
      }
      showSnackBarMessage(context,
          message: 'Something went wrong while fetching doctors');
    }
    return [];
  }

  List<Cardiologist> doctorsList = [];
  void _asyncFunc() async {
    doctorsToDisplay = await _loadDoctors();

    setState(() {
      for (var i = 0; i < doctorsToDisplay.length; i++) {
        if (doctorsToDisplay[i]
            case {
              "id": int idResponse,
              "name": String nameResponse,
              "degree": String degreeResponse,
              "image": String imgUrlResponse,
              "experience": String experienceResponse,
              "category_name": [
                {
                  "name": String categName,
                  "pivot": {
                    "doctor_id": var _,
                    "category_id": int categIDResponse
                  }
                }
              ],
            }) {
          doctorsList.add(
            Cardiologist(
                imgPath: imgUrlResponse,
                name: nameResponse,
                education: degreeResponse,
                specialization: categName,
                experience: int.parse(experienceResponse.substring(0, 2)),
                categID: categIDResponse,
                docID: idResponse),
          );
        }
      }
    });
  }

  @override
  void initState() {
    _asyncFunc();
    super.initState();
  }

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
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TopBar(
                      onPressed: () => Navigator.pop(context),
                      title: "${widget.doctorCategMap[widget.selectedID]}s",
                      height: 0),
                  const SizedBox(
                    height: 40,
                  ),
                  if (doctorsList.isNotEmpty)
                    for (Cardiologist i in doctorsList)
                      CardiologistCard(
                        cardiologistInfo: i,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DoctorRequestForm(selectedCardiologist: i),
                            ),
                          );
                        },
                      )
                  else
                    Text(
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontSize: 18),
                      'None available at the moment. Sorry!',
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
