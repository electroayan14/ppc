import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/login.dart';
import 'package:ppc/template/bottom_button.dart';
import 'package:ppc/template/text_fields.dart';
import 'package:remixicon/remixicon.dart';

class Apply extends StatefulWidget {
  const Apply({super.key});
  @override
  State<Apply> createState() {
    return _ApplyState();
  }
}

class _ApplyState extends State<Apply> {
  TextEditingController nameController = TextEditingController(),
      mobileController = TextEditingController(),
      emailController = TextEditingController(),
      clubNameController = TextEditingController();
  DateTime? dob;
  int hasVisited = 0;
  String? selectedDropdownOption = 'Not Visited';
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  void _checkBody(dynamic body) {
    if (body
        case {
          "msg": var message,
          "error": var _,
          "success": bool success,
          "code": var code,
          "data": {
            "otp": var otp,
          }
        }) {
      if (success) {
        showSnackBarMessage(context, message: message);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
            (route) => false);
      } else {
        showSnackBarMessage(context, message: 'Error Code: $code\n$message');
      }
    } else if (body
        case {
          "msg": var message,
          "error": var error,
          "success": bool success,
          "code": var code,
          "data": var _
        }) {
      showSnackBarMessage(context,
          message: "$message ${error.toString()} $success $code");
    }
  }

  void _sendRegistrationData() async {
    String clubName = '';
    if (clubNameController.text.isNotEmpty) {
      clubName = clubNameController.text;
    }
    hasVisited = (selectedDropdownOption == 'Not Visited') ? 0 : 1;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final url = Uri.parse(
          'https://app.premscollectionskolkata.com/api/apply-membership');
      try {
        final result = await getPostResponse(
            url: url,
            body: {
              'name': nameController.text,
              'email': emailController.text,
              'phone': mobileController.text,
              'dob': dob.toString(),
              if (clubName != '') 'club_name': clubName,
              'visit_before': hasVisited.toString(),
            },
            headers: headers);
        _checkBody(result);
      } on HttpException catch (e) {
        if (mounted) {
          showSnackBarMessage(context, message: e.message);
        }
      } catch (e) {
        if (!mounted) {
          return;
        }
        showSnackBarMessage(context, message: e.toString());
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("lib/assets/bg-2.png"),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      left: 25,
                      right: 25,
                      bottom: 10,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Apply for Membership",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFields(
                            textController: nameController,
                            hintText: "Full Name",
                            fieldIcon: const Icon(
                              size: 16,
                              Remix.user_3_line,
                              color: Color.fromRGBO(224, 171, 67, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DateTimeField(
                            onChanged: (value) {
                              setState(() {
                                dob = value;
                              });
                            },
                            mode: DateTimeFieldPickerMode.date,
                            dateFormat: DateFormat('yyyy-MM-dd'),
                            value: dob,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              constraints: BoxConstraints.tight(
                                const Size.fromHeight(50),
                              ),
                              suffixIcon: const Icon(
                                size: 16,
                                Remix.calendar_event_line,
                                color: Color.fromRGBO(224, 171, 67, 1),
                              ),
                              suffixIconColor:
                                  const Color.fromRGBO(224, 171, 67, 1),
                              labelText: "Date of birth",
                              contentPadding: const EdgeInsets.only(
                                top: 0.1,
                                bottom: 0.1,
                                left: 15,
                              ),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        const Color.fromRGBO(102, 102, 102, 1),
                                  ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(39, 39, 39, 1),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(224, 171, 67, 1),
                                ),
                              ),
                            ),
                            firstDate: DateTime(DateTime.now().year - 100),
                            lastDate: DateTime(
                              DateTime.now().year,
                            ),
                            hideDefaultSuffixIcon: true,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFields(
                            textController: emailController,
                            hintText: "Email",
                            fieldIcon: const Icon(
                              size: 16,
                              Remix.mail_line,
                              color: Color.fromRGBO(224, 171, 67, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFields(
                            textController: mobileController,
                            hintText: "Phone",
                            fieldIcon: const Icon(
                              size: 16,
                              Remix.phone_line,
                              color: Color.fromRGBO(224, 171, 67, 1),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 30,
                              bottom: 20,
                            ),
                            child: Divider(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                style: Theme.of(context).textTheme.bodyLarge,
                                "Have you visited Prem's Collections before?",
                              ),
                              const SizedBox(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(
                                  color: Color.fromRGBO(39, 39, 39, 1),
                                ),
                              ),
                              constraints: BoxConstraints(
                                minHeight: 50,
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.9,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                ),
                                child: DropdownButton<String>(
                                  underline: const SizedBox(),
                                  items: <String>[
                                    'Not Visited',
                                    'Visited',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Color.fromRGBO(216, 215, 215, 1),
                                      ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDropdownOption = value;
                                    });
                                  },
                                  value: selectedDropdownOption,
                                  icon: Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.53,
                                    ),
                                    child: const Icon(
                                      size: 26,
                                      color: Color.fromRGBO(224, 171, 67, 1),
                                      Remix.arrow_down_s_line,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            softWrap: true,
                            style: Theme.of(context).textTheme.bodyLarge,
                            "Are you a member of any other club? If yes, enter the name.",
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFields(
                            textController: clubNameController,
                            hintText: "Club name (Optional)",
                            fieldIcon: const Icon(
                              size: 16,
                              Remix.building_line,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: BottomButton(
                      isLoading: _isLoading,
                      label: "APPLY NOW",
                      onPressed: _sendRegistrationData,
                    ),
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
