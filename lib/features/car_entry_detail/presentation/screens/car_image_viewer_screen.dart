import 'dart:io';

import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_sizes.dart';

class CarImageViewerScreen extends StatefulWidget {
  const CarImageViewerScreen({
    required this.imagePaths,
    required this.initialIndex,
    super.key,
  });

  final List<String> imagePaths;
  final int initialIndex;

  @override
  State<CarImageViewerScreen> createState() => _CarImageViewerScreenState();
}

class _CarImageViewerScreenState extends State<CarImageViewerScreen> {
  late final _pageController = PageController(initialPage: widget.initialIndex);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) => InteractiveViewer(
          minScale: AppSizes.galleryZoomMinScale,
          maxScale: AppSizes.galleryZoomMaxScale,
          child: Center(
            child: Image.file(
              File(widget.imagePaths[index]),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
