import 'package:flutter/material.dart';

class ImageWithLoader extends StatelessWidget {
  const ImageWithLoader(this.imageUri, {Key? key}) : super(key: key);
  final String imageUri;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUri,
      fit: BoxFit.fill,
      height: 100,
      width: 180,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}
