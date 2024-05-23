import 'package:flutter/material.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

void showImageGallery(context, init, images) async {
  List<Widget> galleryImages = List.generate(
      images.length,
      (index) => Image(
            image: NetworkImage(
              images[index],
            ),
          ));
  await SwipeImageGallery(
    hideStatusBar: false,
    backgroundOpacity: 0.4,
    backgroundColor: Colors.transparent,
    context: context,
    initialIndex: init,
    children: galleryImages,
  ).show();
}
