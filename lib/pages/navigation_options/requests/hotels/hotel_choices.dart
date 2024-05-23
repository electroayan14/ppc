import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/navigation_options/requests/hotels/hotel_request_form.dart';
import 'package:ppc/template/hotel_card.dart';
import 'package:ppc/template/hotels.dart';
import 'package:ppc/template/top_bar.dart';

class HotelChoices extends StatefulWidget {
  const HotelChoices({super.key});

  @override
  State<HotelChoices> createState() => _HotelChoicesState();
}

class _HotelChoicesState extends State<HotelChoices> {
  final _formKey = GlobalKey<FormState>();

  List<dynamic> hotelChoiceList = [];
  List<dynamic> _checkHotelBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var _,
          "success": bool success,
          "code": int code,
          "data": {
            "hotels": List<dynamic> hotelChoicesResponse,
          }
        }) {
      showSnackBarMessage(context, message: message);

      return hotelChoicesResponse;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> _loadHotels() async {
    final url = Uri.parse('https://app.premscollectionskolkata.com/api/hotels');
    try {
      final result = await getGetResponseWithHeader(url, headersWithToken);

      hotelChoiceList.addAll(_checkHotelBody(result));
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return [];
      }
      showSnackBarMessage(context,
          message: 'Something went wrong while fetching hotel choices.');
    }
    return hotelChoiceList;
  }

  void _asyncMethod() async {
    hotelChoiceList = await _loadHotels();
    setState(() {
      hotelList = List.generate(
          hotelChoiceList.length,
          (index) => Hotels(
              name: hotelChoiceList[index]["name"],
              id: hotelChoiceList[index]["id"],
              price: hotelChoiceList[index]["price_text"],
              imgPath: hotelChoiceList[index]["image"]));
    });
  }

  List<Hotels> hotelList = [];
  @override
  void initState() {
    _asyncMethod();
    super.initState();
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
            child: Column(
              children: [
                TopBar(
                    onPressed: () => Navigator.pop(context),
                    title: "Hotel\nBooking",
                    height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < hotelList.length; i++)
                          HotelCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HotelRequestForm(
                                    hotelDetails: hotelList[i],
                                  ),
                                ),
                              );
                            },
                            hotelDetails: hotelList[i],
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
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
