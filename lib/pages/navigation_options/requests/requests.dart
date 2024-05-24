import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/navigation_options/requests/request_details.dart';

import 'package:remixicon/remixicon.dart';
import 'package:ppc/pages/services.dart';
import 'package:ppc/template/top_bar.dart';

class Requests extends StatefulWidget {
  const Requests({required this.backHome, super.key});
  final void Function() backHome;

  @override
  State<Requests> createState() => _RequestsState();
}

Map<int, Map> requestsDetailedData = {};

class _RequestsState extends State<Requests> {
  List<dynamic> services = [];
  List<List<dynamic>> requests = [];
  final _formKey = GlobalKey<FormState>();

  List<dynamic> _checkRequestsBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var _,
          "success": bool success,
          "code": int code,
          "data": {"services": List<dynamic> servicesResponse}
        }) {
      return servicesResponse;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> _loadRequests() async {
    final url = Uri.parse(
        'https://app.premscollectionskolkata.com/api/my-booked-services');
    try {
      final result = await getGetResponseWithHeader(url, headersWithToken);

      return _checkRequestsBody(result);
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return [];
      }

      showSnackBarMessage(context,
          message: 'Something went wrong while fetching requests.');
    }
    return [];
  }

  void _asyncFunc() async {
    services = await _loadRequests();
    if (mounted) {
      setState(() {
        for (var i = 0; i < services.length; i++) {
          if (services[i]
              case {
                "booked_on": var bookedOnResponse,
                "status": var statusResponse,
                "extra_data": Map? extraData,
                "service": Map? serviceDetailsResponse,
                "service_type": var serviceTypeResponse
              }) {
            // bookingDate = bookingDateResponse.toString();
            // numberOfPeople = numberOfPeopleResponse.toString();

            requests.add([
              i,
              serviceTypeResponse,
              bookedOnResponse.substring(0, 10),
            ]);
            requestsDetailedData[i] = {
              "booked_on": bookedOnResponse,
              "status": statusResponse,
              "extra_data": extraData,
              "service_details": serviceDetailsResponse,
              "service_type": serviceTypeResponse,
            };
          }
        }
      });
    }
  }

  @override
  void initState() {
    _asyncFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TopBar(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Services(),
                    ),
                  ),
              title: 'All\nRequests',
              height: 50),
          Form(
            key: _formKey,
            child: Column(
              children: [
                (requests.isEmpty)
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 250,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(50, 50, 50, 1),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Icon(
                                size: 30,
                                color: Color.fromRGBO(224, 171, 67, 1),
                                Remix.send_plane_line,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(159, 159, 159, 1),
                              ),
                              "No Upcoming Requests to Show"),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: Text(
                                style: Theme.of(context).textTheme.bodyLarge,
                                'Upcoming Requests'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          for (List<dynamic> i in requests)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 7,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RequestDetails(
                                        requestsDetailedData:
                                            requestsDetailedData[i[0]]!,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 30, 30, 30),
                                    border: Border.all(
                                      color:
                                          const Color.fromRGBO(50, 50, 50, 1),
                                    ),
                                  ),
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                            top: 16,
                                            bottom: 13,
                                            right: 13,
                                            left: 11,
                                          ),
                                          child: Icon(
                                            Remix.send_plane_line,
                                            size: 24,
                                            color:
                                                Color.fromRGBO(224, 171, 67, 1),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color:
                                                          const Color.fromRGBO(
                                                              232, 232, 232, 1),
                                                      fontSize: 20),
                                              i[1].toString()),
                                          Text(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(fontSize: 16),
                                              i[2].toString()),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
