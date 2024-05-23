import 'package:flutter/material.dart';

class GalleryCard extends StatelessWidget {
  const GalleryCard(
      {required this.imgLoc,
      required this.label,
      required this.onPressed,
      required this.viewMode,
      super.key});

  final String imgLoc, label;
  final void Function() onPressed;
  final int viewMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          SizedBox(
            child: Card(
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.45,
                width: MediaQuery.of(context).size.width * 0.45,
                child: viewMode == 1
                    ? Image.network(
                        imgLoc,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // Return the original image if it's fully loaded
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ); // Show a loading indicator while the image is loading
                          }
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          // This function is called when the image fails to load.
                          return Image.asset(
                            'assets/error_image.png', // Placeholder for error
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          );
                        },
                      )
                    : Image.asset(
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        imgLoc,
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            style: Theme.of(context).textTheme.bodyLarge,
            label,
          ),
        ],
      ),
    );
  }
}
