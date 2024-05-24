import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ppc/pages/navigation_options/requests/requests.dart';
import 'package:ppc/template/hotel_card.dart';
import 'package:ppc/template/hotels.dart';
import 'package:ppc/template/top_bar.dart';
import 'package:remixicon/remixicon.dart';

class RequestDetails extends StatefulWidget {
  const RequestDetails({required this.requestsDetailedData, super.key});

  final Map requestsDetailedData;

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  @override
  Widget build(BuildContext context) {
    String serviceTypeText =
        (widget.requestsDetailedData["service_type"] != "DinnerMenu")
            ? ("${widget.requestsDetailedData["service_type"]} Booking Service")
            : ("Dinner Menu Booking Service");
    String dispName = (widget.requestsDetailedData["service_details"] != null)
        ? widget.requestsDetailedData["service_details"]["name"]
        : '';
    String dispImg = (widget.requestsDetailedData["service_details"] != null)
        ? widget.requestsDetailedData["service_details"]["image"]
        : '';
    String statusText = (widget.requestsDetailedData["status"] ==
            "under-process")
        ? 'Your request has been received and someone from our team will call you.'
        : 'Your request has been confirmed.';
    print(requestsDetailedData);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("lib/assets/bg-2.png"),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(
                onPressed: () {
                  Navigator.pop(context);
                },
                title: "",
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (widget.requestsDetailedData["status"] == "under-process")
                        ? Text(
                            style: Theme.of(context).textTheme.headlineMedium,
                            'Request under process',
                          )
                        : Text(
                            style: Theme.of(context).textTheme.headlineMedium,
                            'Request confirmed',
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color.fromRGBO(217, 217, 217, 1),
                          fontSize: 18),
                      'You requested:',
                    ),
                    Text(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                          ),
                      serviceTypeText,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
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
                                image: NetworkImage(dispImg),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  Text(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: const Color.fromRGBO(
                                                  217, 217, 217, 1),
                                              fontSize: 21),
                                      dispName),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color.fromRGBO(217, 217, 217, 1),
                          fontSize: 18),
                      statusText,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            color: Color.fromRGBO(79, 79, 79, 1),
                          ),
                      'Updated: ${widget.requestsDetailedData["booked_on"].toString().substring(0, 10)}',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color.fromRGBO(217, 217, 217, 1),
                          fontSize: 18),
                      'Speak with our team:',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          constraints: BoxConstraints(maxWidth: 170),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color.fromRGBO(224, 171, 67, 1),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: 20,
                              right: 20,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Remix.phone_fill,
                                  color: Color.fromRGBO(224, 171, 67, 1),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontSize: 16,
                                      ),
                                  'Make a call',
                                )
                              ],
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
