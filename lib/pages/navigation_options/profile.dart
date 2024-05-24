import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/navigation_options/home.dart';
import 'package:ppc/api_helpers/profile_data.dart';
import 'package:ppc/pages/services.dart';
import 'package:ppc/template/date_picker_fields.dart';
import 'package:ppc/template/text_fields.dart';
import 'package:ppc/template/top_bar.dart';
import 'package:remixicon/remixicon.dart';

class Profile extends StatefulWidget {
  const Profile({required this.backHome, super.key});
  final void Function() backHome;

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  bool editMode = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController mobileController = TextEditingController(),
      whatsappController = TextEditingController(),
      emailController = TextEditingController(),
      nameController = TextEditingController();
  void _checkProfileBody(dynamic body) {
    if (body
        case {
          "msg": var message,
          "error": var _,
          "success": var _,
          "code": var code,
          "data": {
            "data": {
              "id": var id,
              "name": String localUserName,
              "email": String localUserEmail,
              "email_verified_at": var _,
              "phone_verified_at": var _,
              "role": var _,
              "active": var _,
              "otp": var _,
              "deleted_at": var _,
              "created_at": var _,
              "updated_at": var _,
              "user_details": Map<String, dynamic> userDetails,
            }
          }
        }) {
      print('Save func check passed');
      userName = localUserName;
      userEmail = localUserEmail;
      if (userDetails.isNotEmpty) {
        if (userDetails.containsKey("phone")) {
          phone = userDetails["phone"].toString();
        }
        if (userDetails.containsKey("whatsapp")) {
          whatsapp = userDetails["whatsapp"].toString();
        }
        if (userDetails.containsKey("dob")) {
          dob = userDetails["dob"];
        }
        if (userDetails.containsKey("address") &&
            userDetails["address"] != null) {
          address = userDetails["address"];
        }
        if (userDetails.containsKey("bio") && userDetails["bio"] != null) {
          bio = userDetails["bio"];
        }
        if (userDetails.containsKey("card_number") &&
            userDetails["card_number"] != null) {
          cardNumber = userDetails["card_number"];
        }
        if (userDetails.containsKey("club_name") &&
            userDetails["club_name"] != null) {
          clubName = userDetails["club_name"];
        }
        if (userDetails.containsKey("store_id") &&
            userDetails["store_id"] != null) {
          storeId = userDetails["store_id"];
        }
        if (userDetails.containsKey("store") && userDetails["store"] != null) {
          storeDetails = userDetails["store"];
        }
      }
    }
  }

  String profileImg =
      "https://app.premscollectionskolkata.com/doctor-images/1714112757.jpg";
  Future<void> _saveProfile() async {
    print("$phone P$whatsapp P$dob P$address P$bio P$clubName");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final url =
          Uri.parse('https://app.premscollectionskolkata.com/api/save-profile');
      try {
        final result = await getPostResponse(
            url: url,
            body: {
              'phone': phone,
              'whatsapp': whatsapp,
              'dob': dob,
              'image': "",
              'address': address,
              'bio': bio,
              'club_name': clubName,
            },
            headers: headersWithToken);
        _checkProfileBody(result);
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
    nameController.addListener(_editingListener);

    mobileController.addListener(_editingListener);
    whatsappController.addListener(_editingListener);
    emailController.addListener(_editingListener);
    super.initState();
  }

  @override
  void dispose() {
    mobileController.dispose();
    whatsappController.dispose();
    emailController.dispose();

    nameController.dispose();
    super.dispose();
  }

  String tempMobile = "",
      tempWhatsapp = "",
      tempEmail = "",
      tempName = "",
      tempDOB = dob;
  void _editingListener() {
    tempMobile = mobileController.text;
    tempWhatsapp = whatsappController.text;
    tempEmail = emailController.text;
    tempName = nameController.text;
  }

  @override
  Widget build(BuildContext context) {
    print("AAAAAAAAAA $cardNumber BBBBBBBBBB $dob");
    setState(() {});
    return Form(
      key: _formKey,
      child: (_isLoading == false)
          ? SingleChildScrollView(
              child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopBar(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Services(),
                            )),
                        title: "My\nProfile",
                        height: 0),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              editMode = !editMode;
                            });
                          },
                          icon: const Icon(
                            Remix.pencil_fill,
                            color: Color.fromRGBO(224, 171, 67, 1),
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight:
                          172 / 300 * (MediaQuery.of(context).size.width * 0.9),
                      minWidth: MediaQuery.of(context).size.width * 0.9,
                    ),
                    decoration: const BoxDecoration(
                      /*border: Border.all(
                    color: const Color.fromRGBO(224, 171, 67, 1),
                  ),*/
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          "lib/assets/mem_card.png",
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                        bottom: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            style: const TextStyle(
                                fontFamily: 'Switzer',
                                fontSize: 19,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w300),
                            userName.toUpperCase(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              style: GoogleFonts.sunflower().copyWith(
                                fontSize: 23,
                                color: const Color.fromRGBO(224, 171, 67, 1),
                                fontWeight: FontWeight.w900,
                              ),
                              cardNumber.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 8,
                        child: Text(
                            style: TextStyle(
                              fontSize: 17,
                            ),
                            "Name:"),
                      ),
                      Expanded(
                          flex: 13,
                          child: (editMode)
                              ? TextFields(
                                  hintText: userName,
                                  fieldIcon: const Icon(
                                    Icons.brightness_1_outlined,
                                    color: Colors.black,
                                    size: 0,
                                  ),
                                  textController: nameController)
                              : Text(
                                  softWrap: true,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(224, 171, 67, 1),
                                    fontSize: 17,
                                  ),
                                  userName))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 8,
                        child: Text(
                            style: TextStyle(
                              fontSize: 17,
                            ),
                            "Date of Birth:"),
                      ),
                      Expanded(
                        flex: 13,
                        child: (editMode)
                            ? DatePickerTextFields(
                                onChanged: (value) {
                                  setState(() {
                                    tempDOB = value.toString();
                                  });
                                },
                                hintText: dob,
                                fieldIcon: const Icon(
                                  Icons.brightness_1_outlined,
                                  color: Colors.black,
                                  size: 0,
                                ),
                                mode: DateTimeFieldPickerMode.date,
                                selectedDateTime:
                                    DateFormat('yyyy-MM-dd').parse(tempDOB),
                                firstDate: DateTime(1900, 1, 1),
                              )
                            : Text(
                                style: const TextStyle(
                                  color: Color.fromRGBO(224, 171, 67, 1),
                                  fontSize: 17,
                                ),
                                dob),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 8,
                        child: Text(
                            style: TextStyle(
                              fontSize: 17,
                            ),
                            "Mobile no.:"),
                      ),
                      Expanded(
                        flex: 13,
                        child: editMode == false
                            ? Text(
                                style: const TextStyle(
                                  color: Color.fromRGBO(224, 171, 67, 1),
                                  fontSize: 17,
                                ),
                                phone)
                            : TextFields(
                                hintText: phone,
                                fieldIcon: const Icon(
                                  Icons.brightness_1_outlined,
                                  color: Colors.black,
                                  size: 0,
                                ),
                                textController: mobileController),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 8,
                        child: Text(
                            style: TextStyle(
                              fontSize: 17,
                            ),
                            "Whatsapp no.:"),
                      ),
                      Expanded(
                        flex: 13,
                        child: editMode == false
                            ? Text(
                                style: const TextStyle(
                                  color: Color.fromRGBO(224, 171, 67, 1),
                                  fontSize: 17,
                                ),
                                whatsapp)
                            : TextFields(
                                hintText: whatsapp,
                                fieldIcon: const Icon(
                                  Icons.brightness_1_outlined,
                                  color: Colors.black,
                                  size: 0,
                                ),
                                textController: whatsappController),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 8,
                        child: Text(
                            style: TextStyle(
                              fontSize: 17,
                            ),
                            "Email address:"),
                      ),
                      Expanded(
                          flex: 13,
                          child: editMode == false
                              ? Text(
                                  softWrap: true,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(224, 171, 67, 1),
                                    fontSize: 17,
                                  ),
                                  userEmail)
                              : TextFields(
                                  hintText: userEmail,
                                  fieldIcon: const Icon(
                                    Icons.brightness_1_outlined,
                                    color: Colors.black,
                                    size: 0,
                                  ),
                                  textController: emailController)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                if (editMode == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(right: 35),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (tempMobile != "" && tempMobile != phone) {
                                phone = tempMobile;
                              }
                              if (tempWhatsapp != "" &&
                                  tempWhatsapp != whatsapp) {
                                whatsapp = tempWhatsapp;
                              }
                              if (tempEmail != "" && tempEmail != userEmail) {
                                userEmail = tempEmail;
                              }

                              if (tempName != "" && tempName != userName) {
                                userName = tempName;
                              }
                              if (tempDOB != "" && tempDOB != dob) {
                                dob = tempDOB;
                              }
                              _saveProfile();
                              editMode = false;
                            });
                          },
                          child: const Text("Save"),
                        ),
                      ),
                    ],
                  )
              ],
            ))
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
    );
  }
}
