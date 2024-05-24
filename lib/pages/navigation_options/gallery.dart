import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/pages/navigation_options/home.dart';
import 'package:ppc/pages/services.dart';
import 'package:ppc/pages/stores/kolkata_store.dart';
import 'package:ppc/template/gallery_card.dart';
import 'package:ppc/template/gallery_entity.dart';
import 'package:ppc/template/top_bar.dart';

class Gallery extends StatefulWidget {
  const Gallery({required this.backHome, super.key});
  final void Function() backHome;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  var _isLoading = false;
  Map storesToDisplay = {};
  Map albumsToDisplay = {};
  List<GalleryEntity> entitiesToDisplay = [];
  // void _checkStoresBody(dynamic body) {
  //   if (body
  //       case {
  //         "msg": String message,
  //         "error": var error,
  //         "success": bool success,
  //         "code": int code,
  //         "data": {
  //           "stores": Map storesMapResponse,
  //         }
  //       }) {
  //     print("Stores case check passed");
  //     String image = "";
  //     for (var i in storesMapResponse.keys) {
  //       for (var e in bannerMap) {
  //         if (e["id"] == int.parse(i)) {
  //           image = e["image"];
  //         }
  //       }
  //       entitiesToDisplay.add(
  //         GalleryEntity(
  //           id: "store-$i",
  //           imgUrl: image,
  //           name: storesMapResponse[i],
  //         ),
  //       );
  //     }
  //   }
  // }

  // Future<void> _loadStores() async {
  //   print("Loading stores");
  //   final url =
  //       Uri.parse('https://app.premscollectionskolkata.com/api/store-list');
  //   try {
  //     final result = await getGetResponseWithHeader(url, headersWithToken);

  //     _checkStoresBody(result);
  //   } on HttpException catch (e) {
  //     if (mounted) {
  //       showSnackBarMessage(context, message: e.message);
  //     }
  //   } catch (e) {
  //     if (!mounted) {
  //       return;
  //     }
  //     showSnackBarMessage(context,
  //         message: 'Something went wrong while fetching stores.');
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  void _checkAlbumsBody(dynamic body) {
    if (body
        case {
          "msg": var message,
          "error": var error,
          "success": var success,
          "code": var code,
          "data": {
            "albums": List<dynamic> albumsMapResponse,
          }
        }) {
      print("Albums case check passed");
      for (var i in albumsMapResponse) {
        entitiesToDisplay.add(
          GalleryEntity(
            id: "album-${i["id"]}",
            imgUrl: i["image"],
            name: i["name"],
          ),
        );
      }
    }
  }

  Future<void> _loadAlbums() async {
    print("Loading almbums");
    final url = Uri.parse('https://app.premscollectionskolkata.com/api/albums');
    try {
      final result = await getGetResponseWithHeader(url, headersWithToken);

      _checkAlbumsBody(result);
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      showSnackBarMessage(context,
          message: 'Something went wrong while fetching albums.');
    }
  }

  void _asyncFunc() async {
    print("Enter async");
    await _loadAlbums();

    setState(() {});
  }

  @override
  void initState() {
    _asyncFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> stores = [
      "Wedding Collection",
      "Bangladesh Store",
      "Kolkata Store",
      "Latest Collection",
      "Bridal Store",
      "Wedding Collection",
    ];
    List<String> storeImages = [
      "lib/assets/gallery_placeholder.png",
      "lib/assets/gallery_placeholder.png",
      "lib/assets/kolkata_store.jpg",
      "lib/assets/gallery_placeholder.png",
      "lib/assets/gallery_placeholder.png",
      "lib/assets/gallery_placeholder.png",
    ];

    return Column(
      children: [
        TopBar(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Services(),
              )),
          title: "Our\nGallery",
          height: 22,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: entitiesToDisplay.length,
              itemBuilder: (context, index) => GalleryCard(
                imgLoc: entitiesToDisplay[index].imgUrl,
                label: entitiesToDisplay[index].name,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          KolkataStore(id: entitiesToDisplay[index].id),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
