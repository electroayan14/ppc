import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/navigation_options/home.dart';
import 'package:ppc/template/booking_confirmation.dart';
import 'package:ppc/template/bottom_button.dart';
import 'package:ppc/template/date_picker_fields.dart';
import 'package:ppc/template/text_fields.dart';
import 'package:ppc/template/top_bar.dart';
import 'package:remixicon/remixicon.dart';

class CarRequestForm extends StatefulWidget {
  const CarRequestForm({super.key});
  @override
  State<StatefulWidget> createState() {
    return _CarRequestFormState();
  }
}

class _CarRequestFormState extends State<CarRequestForm> {
  final TextEditingController noOfPersonsController = TextEditingController(),
      dropLocationController = TextEditingController();
  DateTime? _selectedDOA, _selectedTOA;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String carImg = '';
  String _checkCarBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var _,
          "success": var _,
          "code": var _,
          "data": {
            "cars": [
              {
                "id": 1,
                "name": "Tata Innova",
                "image": String carImgResponse,
              }
            ]
          }
        }) {
      return carImgResponse;
    } else {
      return '';
    }
  }

  Future<String> _loadCar() async {
    final url =
        Uri.parse('https://app.premscollectionskolkata.com/api/dinner-menus');
    try {
      final result = await getGetResponseWithHeader(url, headersWithToken);

      return _checkCarBody(result);
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return '';
      }
      showSnackBarMessage(context,
          message: 'Something went wrong while fetching menu.');
    }

    return '';
  }

  void _asyncMethod() async {
    carImg = await _loadCar();
    setState(() {});
  }

  void _checkBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var error,
          "success": bool success,
          "code": int code,
          "data": var _,
        }) {
      if (success) {
        showSnackBarMessage(context, message: message);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BookingConfirmation(),
          ),
        );
      } else {
        showSnackBarMessage(context, message: 'Error Code: $code\n${message}');
      }
    } else if (body
        case {
          "msg": var message,
          "error": var error,
          "success": var _,
          "code": var _,
          "data": var _
        }) {
      showSnackBarMessage(context, message: message);
    }
  }

  void _sendBookingDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final url =
          Uri.parse('https://app.premscollectionskolkata.com/api/Car/book');
      try {
        int? guests = int.tryParse(noOfPersonsController.text);
        if (guests == null ||
            _selectedDOA == null ||
            _selectedTOA == null ||
            dropLocationController.text == null) {
          showSnackBarMessage(context, message: 'Please fill all fields.');
          setState(() {
            _isLoading = false;
          });
          return;
        }
        final result = await getPostResponse(
            url: url,
            body: {
              'arrival_date': _selectedDOA.toString(),
              'arrival_time': _selectedTOA.toString(),
              'number_of_guest': guests.toString(),
              'drop_location': dropLocationController.text.toString(),
            },
            headers: headersWithToken);
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
  void initState() {
    _asyncMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(carImg);
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
              children: [
                TopBar(
                  onPressed: () => Navigator.pop(
                    context,
                  ),
                  title: "Booking\nRequest",
                  height: 0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Image.asset(height: 100, "lib/assets/car.png"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                          softWrap: true,
                          "Enter your details to request booking",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Column(
                            children: [
                              DatePickerTextFields(
                                hintText: "Date of Arrival",
                                fieldIcon: const Icon(
                                  Remix.calendar_event_line,
                                  size: 16,
                                ),
                                mode: DateTimeFieldPickerMode.date,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDOA = value;
                                  });
                                },
                                selectedDateTime: _selectedDOA,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              DatePickerTextFields(
                                hintText: "Time of Arrival",
                                fieldIcon: const Icon(
                                  Remix.time_line,
                                  size: 16,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTOA = value;
                                  });
                                },
                                mode: DateTimeFieldPickerMode.time,
                                selectedDateTime: _selectedTOA,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFields(
                                hintText: "No. of Person/s",
                                fieldIcon: const Icon(
                                  Remix.user_3_line,
                                  size: 16,
                                ),
                                keyboardType: TextInputType.number,
                                textController: noOfPersonsController,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFields(
                                hintText: "Drop Location",
                                fieldIcon: const Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                ),
                                textController: dropLocationController,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: Text(
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  "Car's & Driver's details will be shared after confirmation.",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 170,
                        ),
                      ],
                    ),
                  ),
                ),
                BottomButton(
                  label: "SEND REQUEST",
                  onPressed: _sendBookingDetails,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
