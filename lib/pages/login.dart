import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/otp.dart';
import 'package:ppc/template/text_fields.dart';
import 'package:remixicon/remixicon.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  void _checkBody(dynamic body) {
    if (body
        case {
          "msg": var message,
          "error": var error,
          "success": bool success,
          "code": var code,
          "data": {
            "otp": var otp,
          }
        }) {
      if (success) {
        showSnackBarMessage(context, message: message);
        print(otp);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => OTP(
                email: email,
              ),
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
      showSnackBarMessage(context, message: message);
    }
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final url = Uri.parse(
          'https://app.premscollectionskolkata.com/api/send-login-otp');
      try {
        final result = await getPostResponse(
            url: url,
            body: {
              'email': email,
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

  final TextEditingController _emailController = TextEditingController();
  String email = '';
  @override
  void initState() {
    _emailController.addListener(
      () {
        email = _emailController.text;
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: ListView(
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
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: const Color.fromRGBO(224, 171, 67, 1),
                              ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Text(
                          "Enter your email address to continue",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontSize: 16,
                                color: const Color.fromRGBO(255, 255, 255, 1),
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 13,
                            left: 20,
                            right: 20,
                            bottom: 20,
                          ),
                          child: TextFields(
                            textController: _emailController,
                            hintText: 'Email',
                            fieldIcon: const Icon(
                              Remix.mail_line,
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
                            onPressed: _signIn,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                const Text(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  'SEND OTP',
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
