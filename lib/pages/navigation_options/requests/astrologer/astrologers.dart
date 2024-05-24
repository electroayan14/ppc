import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/navigation_options/requests/astrologer/astrologer.dart';
import 'package:ppc/pages/navigation_options/requests/astrologer/astrologer_card.dart';
import 'package:ppc/pages/navigation_options/requests/astrologer/astrologer_request_form.dart';
import 'package:ppc/template/top_bar.dart';

class Astrologers extends StatefulWidget {
  const Astrologers({super.key});

  @override
  State<Astrologers> createState() => _AstrologersState();
}

class _AstrologersState extends State<Astrologers> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> astrologers = [];
  List<dynamic> _checkAstroBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var _,
          "success": var success,
          "code": int code,
          "data": {
            "astrologers": List<dynamic> astroResponse,
          }
        }) {
      showSnackBarMessage(context, message: message);
      print("BBBBB $astroResponse");
      return astroResponse;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> _loadAstros() async {
    final url =
        Uri.parse('https://app.premscollectionskolkata.com/api/astrologers');
    try {
      final result = await getGetResponseWithHeader(url, headersWithToken);

      astrologers.addAll(_checkAstroBody(result));
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return [];
      }
      showSnackBarMessage(context,
          message: 'Something went wrong while fetching astrologer choices.');
    }

    return astrologers;
  }

  void _asyncMethod() async {
    astrologers = await _loadAstros();

    setState(() {
      astrologerList = List.generate(
        astrologers.length,
        (index) => Astrologer(
          imgPath: astrologers[index]["image"],
          name: astrologers[index]["name"],
          id: astrologers[index]["id"],
          experience: int.parse(astrologers[index]["experience"]),
        ),
      );
    });
  }

  List<Astrologer> astrologerList = [];
  @override
  void initState() {
    astrologerList = [];

    _asyncMethod();
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
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
              children: [
                TopBar(
                  onPressed: () => Navigator.pop(context),
                  title: "Astrologers",
                  height: 0,
                ),
                const SizedBox(
                  height: 40,
                ),
                if (astrologerList != [])
                  for (Astrologer i in astrologerList)
                    AstrologerCard(
                      astrologerInfo: i,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AstrologerRequestForm(selectedAstrologer: i),
                          ),
                        );
                      },
                    )
                else
                  Center(
                    child: Text(
                        style: Theme.of(context).textTheme.bodyMedium,
                        'Loading, please wait...'),
                  ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
