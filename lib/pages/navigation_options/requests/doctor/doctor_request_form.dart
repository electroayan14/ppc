import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/navigation_options/requests/doctor/cardiologist.dart';
import 'package:ppc/pages/navigation_options/requests/doctor/cardiologist_card.dart';
import 'package:ppc/api_helpers/profile_data.dart';
import 'package:ppc/template/booking_confirmation.dart';
import 'package:ppc/template/bottom_button.dart';
import 'package:ppc/template/date_picker_fields.dart';
import 'package:ppc/template/text_fields.dart';
import 'package:remixicon/remixicon.dart';

class DoctorRequestForm extends StatefulWidget {
  const DoctorRequestForm({required this.selectedCardiologist, super.key});
  final Cardiologist selectedCardiologist;
  @override
  State<StatefulWidget> createState() {
    return _DoctorRequestFormState();
  }
}

class _DoctorRequestFormState extends State<DoctorRequestForm> {
  TextEditingController nameController = TextEditingController();
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  void _checkBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var _,
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
        showSnackBarMessage(context, message: 'Error Code: $code\n$message');
      }
    } else if (body
        case {
          "msg": var message,
          "error": var _,
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
          Uri.parse('https://app.premscollectionskolkata.com/api/Doctor/book');
      try {
        if (_selectedDate == null) {
          showSnackBarMessage(context, message: 'Please fill all fields.');
          setState(() {
            _isLoading = false;
          });
          return;
        }
        final result = await getPostResponse(
            url: url,
            body: {
              'booking_date': _selectedDate.toString(),
              'custom_id': widget.selectedCardiologist.docID.toString(),
              'patient_name': nameController.text,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color.fromRGBO(224, 171, 67, 1),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        style: Theme.of(context).textTheme.headlineLarge,
                        "Booking\nRequest",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CardiologistCard(
                    cardiologistInfo: widget.selectedCardiologist,
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      constraints: BoxConstraints(
                          maxHeight: 80,
                          maxWidth: MediaQuery.of(context).size.width * 0.8),
                      child: Text(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                          softWrap: true,
                          "Enter your details to request booking"),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      children: [
                        TextFields(
                          hintText: "Name of patient",
                          fieldIcon: const Icon(
                            size: 16,
                            Remix.user_3_line,
                            color: Color.fromRGBO(224, 171, 67, 1),
                          ),
                          textController: nameController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DatePickerTextFields(
                          hintText: "Select Date",
                          fieldIcon: const Icon(
                            size: 16,
                            Remix.calendar_event_line,
                            color: Color.fromRGBO(224, 171, 67, 1),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedDate = value;
                            });
                          },
                          mode: DateTimeFieldPickerMode.date,
                          selectedDateTime: _selectedDate,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 330,
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
      ),
    );
  }
}
