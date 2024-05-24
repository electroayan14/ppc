import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/navigation_options/home.dart';
import 'package:ppc/pages/navigation_options/requests/astrologer/astrologer.dart';
import 'package:ppc/pages/navigation_options/requests/astrologer/astrologer_card.dart';

import 'package:ppc/template/booking_confirmation.dart';
import 'package:ppc/template/bottom_button.dart';
import 'package:ppc/template/date_picker_fields.dart';

import 'package:ppc/template/top_bar.dart';
import 'package:remixicon/remixicon.dart';

class AstrologerRequestForm extends StatefulWidget {
  const AstrologerRequestForm({required this.selectedAstrologer, super.key});
  final Astrologer selectedAstrologer;
  @override
  State<StatefulWidget> createState() {
    return _AstrologerRequestFormState();
  }
}

class _AstrologerRequestFormState extends State<AstrologerRequestForm> {
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
      final url = Uri.parse(
          'https://app.premscollectionskolkata.com/api/Astrologer/book');
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
              'custom_id': widget.selectedAstrologer.id.toString(),
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
                  TopBar(
                    onPressed: () => Navigator.pop(context),
                    title: "Booking\nRequest",
                    height: 0,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AstrologerCard(
                    astrologerInfo: widget.selectedAstrologer,
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
                      child: const Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Color.fromRGBO(159, 159, 159, 1),
                          ),
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
                        DatePickerTextFields(
                          hintText: "Select Date",
                          fieldIcon: const Icon(
                            Remix.calendar_event_line,
                            size: 16,
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
                    height: 100,
                  ),
                  const Center(
                    child: Text(
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(100, 100, 100, 1),
                        ),
                        "Booking details will be shared by our team"),
                  ),
                  const SizedBox(
                    height: 300,
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
