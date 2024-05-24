import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppc/api_helpers/get_response.dart';
import 'package:ppc/api_helpers/headers.dart';
import 'package:ppc/api_helpers/show_error_message.dart';
import 'package:ppc/template/store_card.dart';
import 'package:ppc/template/swipeable_gallery.dart';
import 'package:ppc/template/top_bar.dart';

class KolkataStore extends StatefulWidget {
  const KolkataStore({required this.id, super.key});
  final String id;
  @override
  State<KolkataStore> createState() => _KolkataStoreState();
}

class _KolkataStoreState extends State<KolkataStore> {
  final List<String> albumImages = [];

  void _checkAlbumImagesBody(dynamic body) {
    if (body
        case {
          "msg": String message,
          "error": var error,
          "success": bool success,
          "code": int code,
          "data": {
            "album": {
              "id": var _,
              "name": String nameResponse,
              "image": String imgResponse,
              "active": var active,
              "publish_at": var _,
              "deleted_at": var _,
              "created_at": var _,
              "updated_at": var _,
            },
            "images": List<dynamic> bannerImagesResponse,
          }
        }) {
      print("Albums case check passed");
      for (var i in bannerImagesResponse) {
        albumImages.add(i["image"]);
      }
    }
  }

  Future<void> _loadAlbumImages() async {
    print("Loading albums ${widget.id}");
    final url = Uri.parse(
        'https://app.premscollectionskolkata.com/api/album/${widget.id.substring(6)}/images');
    try {
      final result = await getGetResponseWithHeader(url, headersWithToken);

      _checkAlbumImagesBody(result);
    } on HttpException catch (e) {
      if (mounted) {
        showSnackBarMessage(context, message: e.message);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      showSnackBarMessage(context,
          message: 'Something went wrong while fetching album images.');
    }
  }

  void _asyncFunc() async {
    print("Enter async");
    await _loadAlbumImages();

    setState(() {});
  }

  @override
  void initState() {
    _asyncFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                TopBar(
                  onPressed: () => Navigator.pop(
                    context,
                  ),
                  title: "Kolkata\nStore",
                  height: 38,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                    ),
                    itemCount: albumImages.length,
                    itemBuilder: (context, index) => StoreCard(
                      onTap: () =>
                          showImageGallery(context, index, albumImages),
                      imgLoc: albumImages[index],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
