import 'dart:io';

import 'package:flutter/material.dart';

import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/main.dart';
import 'package:ppc/pages/services.dart';

class OTP extends StatefulWidget {
  const OTP({required this.email, super.key});
  final String email;
  @override
  State<OTP> createState() {
    return _OTPState();
  }
}

class _OTPState extends State<OTP> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  void _checkBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var error,
          "success": var success,
          "code": var code,
          "data": {
            "token": String tkn,
          }
        }) {
      prefs.setString('token', tkn);

      if (success = true) {
        showSnackBarMessage(context, message: message);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Services(),
            ),
            (route) => false);
      } else {
        showSnackBarMessage(context, message: message);
      }
    } else if (body
        case {
          "msg": var message,
          "error": var error,
          "success": bool success,
          "code": var code,
          "data": var _
        }) {
      showSnackBarMessage(context, message: message);
    }
  }

  void _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final url = Uri.parse(
          'https://app.premscollectionskolkata.com/api/verify-login-otp');
      try {
        final result = await getPostResponse(
            url: url,
            body: {
              'email': widget.email,
              'otp': enteredPin,
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
        showSnackBarMessage(context, message: 'Could not validate OTP');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  String enteredPin = '';

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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        Container(
                            height: 105,
                            width: 161,
                            child: Image.asset("lib/assets/logo.png")),
                        const SizedBox(
                          height: 35,
                        ),
                        Text(
                          "Member Login",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Text(
                          "Enter OTP sent to your email address",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontSize: 16,
                                color: const Color.fromRGBO(255, 255, 255, 1),
                              ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 60,
                            right: 60,
                            bottom: 200,
                          ),
                          child: OTPTextField(
                            length: 4,
                            onChanged: (value) {
                              enteredPin = value;
                            },
                            onCompleted: (value) {
                              enteredPin = value;
                            },
                            fieldStyle: FieldStyle.box,
                            fieldWidth: 50,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            width: MediaQuery.of(context).size.width,
                            otpFieldStyle: OtpFieldStyle(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 0, 0),
                              borderColor:
                                  const Color.fromARGB(255, 104, 104, 104),
                              focusBorderColor:
                                  const Color.fromRGBO(224, 171, 67, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: (_isLoading == false)
                                  ? const MaterialStatePropertyAll(
                                      Color.fromRGBO(224, 171, 67, 1),
                                    )
                                  : const MaterialStatePropertyAll(
                                      Color.fromRGBO(116, 104, 82, 1),
                                    ),
                              minimumSize: const MaterialStatePropertyAll(
                                Size.fromHeight(55),
                              ),
                            ),
                            onPressed: _verifyOtp,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                const Text(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  'LOGIN',
                                ),
                                if (_isLoading == true)
                                  const CircularProgressIndicator()
                                else
                                  const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
