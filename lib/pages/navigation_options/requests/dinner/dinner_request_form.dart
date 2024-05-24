import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/navigation_options/requests/dinner/dinner_menu.dart';
import 'package:ppc/pages/navigation_options/home.dart';
import 'package:ppc/template/booking_confirmation.dart';
import 'package:ppc/template/bottom_button.dart';
import 'package:ppc/template/date_picker_fields.dart';
import 'package:ppc/template/text_fields.dart';
import 'package:ppc/template/top_bar.dart';
import 'package:remixicon/remixicon.dart';

class DinnerRequestForm extends StatefulWidget {
  const DinnerRequestForm({super.key});
  @override
  State<StatefulWidget> createState() {
    return _DinnerRequestFormState();
  }
}

class _DinnerRequestFormState extends State<DinnerRequestForm> {
  final TextEditingController noOfPersonsController = TextEditingController();
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
          'https://app.premscollectionskolkata.com/api/DinnerMenu/book');
      try {
        int? guests = int.tryParse(noOfPersonsController.text);
        if (_selectedDate == null || guests == null) {
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
              'number_of_person': guests.toString(),
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
                          title: "Booking\nRequest",
                          height: 0),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child:
                            Image.asset(height: 120, "lib/assets/dinner.png"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                          side: MaterialStatePropertyAll(
                            BorderSide(
                              color: Color.fromRGBO(224, 171, 67, 1),
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(8, 8, 8, 1),
                          ),
                          fixedSize: MaterialStatePropertyAll(
                            Size(
                              156,
                              40,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DinnerMenu(),
                            ),
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              const Icon(
                                size: 17,
                                Remix.restaurant_fill,
                                color: Color.fromRGBO(224, 171, 67, 1),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  "See Menu"),
                              const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Container(
                          constraints: BoxConstraints(
                              maxHeight: 80,
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.8),
                          child: Text(
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                              softWrap: true,
                              "Enter your details to request booking"),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          children: [
                            DatePickerTextFields(
                              hintText: "Date",
                              fieldIcon: const Icon(
                                Remix.calendar_event_line,
                                size: 16,
                              ),
                              onChanged: (value) {
                                _selectedDate = value;
                              },
                              mode: DateTimeFieldPickerMode.date,
                              selectedDateTime: _selectedDate,
                            ),
                            const SizedBox(
                              height: 15,
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
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                          "We will confirm your booking.",
                        ),
                      ),
                    ],
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
