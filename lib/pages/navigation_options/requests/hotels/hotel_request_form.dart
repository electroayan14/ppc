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
import 'package:ppc/template/hotels.dart';
import 'package:ppc/template/text_fields.dart';
import 'package:ppc/template/top_bar.dart';
import 'package:remixicon/remixicon.dart';

class HotelRequestForm extends StatefulWidget {
  const HotelRequestForm({required this.hotelDetails, super.key});
  final Hotels hotelDetails;

  @override
  State<StatefulWidget> createState() {
    return _HotelRequestFormState();
  }
}

class _HotelRequestFormState extends State<HotelRequestForm> {
  TextEditingController checkInController = TextEditingController(),
      checkOutController = TextEditingController(),
      noOfGuestsController = TextEditingController(),
      noOfRoomsController = TextEditingController();
  DateTime? _selectedCIDate;
  DateTime? _selectedCODate;
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
          Uri.parse('https://app.premscollectionskolkata.com/api/Hotel/book');
      try {
        int? rooms = int.tryParse(noOfRoomsController.text);
        int? guests = int.tryParse(noOfGuestsController.text);
        if (rooms == null ||
            guests == null ||
            _selectedCIDate == null ||
            _selectedCODate == null) {
          showSnackBarMessage(context, message: 'Please fill all fields.');
          setState(() {
            _isLoading = false;
          });
          return;
        }
        final result = await getPostResponse(
            url: url,
            body: {
              'check_in_date': _selectedCIDate.toString(),
              'custom_id': widget.hotelDetails.id.toString(),
              'check_out_date': _selectedCODate.toString(),
              'number_of_room': rooms.toString(),
              'number_of_guest': guests.toString(),
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
              children: [
                TopBar(
                    onPressed: () => Navigator.pop(context),
                    title: "Booking\nRequest",
                    height: 0),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const ShapeDecoration(
                              color: Color.fromRGBO(13, 13, 13, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            constraints: const BoxConstraints(
                              minHeight: 120,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          widget.hotelDetails.imgPath),
                                    ),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                  constraints: const BoxConstraints(
                                    minHeight: 110,
                                    minWidth: 110,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    const SizedBox(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 35,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 5,
                                          ),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                                softWrap: true,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: const Color
                                                            .fromRGBO(
                                                            232, 232, 232, 1),
                                                        fontSize: 21),
                                                widget.hotelDetails.name),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                widget.hotelDetails.price),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Container(
                            constraints: BoxConstraints(
                                maxHeight: 80,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Text(
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                                softWrap: true,
                                "Enter your details to request booking for this hotel"),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Column(
                    children: [
                      DatePickerTextFields(
                        hintText: 'Check-in',
                        fieldIcon: const Icon(
                          size: 16,
                          Remix.calendar_event_line,
                          color: Color.fromRGBO(224, 171, 67, 1),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedCIDate = value;
                          });
                        },
                        mode: DateTimeFieldPickerMode.date,
                        selectedDateTime: _selectedCIDate,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DatePickerTextFields(
                          hintText: 'Check-Out',
                          fieldIcon: const Icon(
                            size: 16,
                            Remix.calendar_event_line,
                            color: Color.fromRGBO(224, 171, 67, 1),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedCODate = value;
                            });
                          },
                          mode: DateTimeFieldPickerMode.date,
                          selectedDateTime: _selectedCODate),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFields(
                        hintText: "No. of Guest/s",
                        fieldIcon: const Icon(
                          size: 16,
                          Remix.user_3_line,
                          color: Color.fromRGBO(224, 171, 67, 1),
                        ),
                        keyboardType: TextInputType.number,
                        textController: noOfGuestsController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFields(
                        hintText: "No. of Room/s",
                        fieldIcon: const Icon(
                          size: 16,
                          Remix.hotel_bed_line,
                          color: Color.fromRGBO(224, 171, 67, 1),
                        ),
                        keyboardType: TextInputType.number,
                        textController: noOfRoomsController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                          "Rooms & other details will be shared by our team based on availability.",
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 130,
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
