import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageWithLoader extends StatefulWidget {
  final String imageUrl;

  ImageWithLoader({super.key, required this.imageUrl});

  @override
  _ImageWithLoaderState createState() =>
      _ImageWithLoaderState();
}

class _ImageWithLoaderState
    extends State<ImageWithLoader> {
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    // Check if the image is loaded successfully
    Image.network(widget.imageUrl).image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }, onError: (_, __) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isError = true;
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return _isError
        ? Container(
      color: Colors.grey,
      child: Icon(Icons.error),
    )
        : _isLoading
        ? Container(
      color: Colors.grey,
      child: const Center(child: CircularProgressIndicator()),
    )
        : FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: widget.imageUrl,
      fit: BoxFit.cover,
    );
  }
}
