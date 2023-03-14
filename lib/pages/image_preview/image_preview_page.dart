import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../global/enum_gen.dart';

class ImagePreviewPage extends StatefulWidget {
  final ImageProviderCategory imageProviderCategory;
  final String imagePath;

  const ImagePreviewPage({
    super.key,
    required this.imageProviderCategory,
    required this.imagePath,
  });

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PhotoView(
          imageProvider: getParticularImage(),
          enableRotation: true,
          initialScale: null,
          loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator()),
          errorBuilder: (context, obj, stackTrace) => const Center(
            child: Text(
              'Image not found!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  getParticularImage() {
    switch (widget.imageProviderCategory) {
      case ImageProviderCategory.fileImage:
        return FileImage(File(widget.imagePath));
      case ImageProviderCategory.exactAssetImage:
        return ExactAssetImage(widget.imagePath);
      case ImageProviderCategory.networkImage:
        return NetworkImage(widget.imagePath);
    }
  }
}
