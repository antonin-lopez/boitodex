import 'dart:io';

import 'package:boitodex/core/utils/system_ui.dart';
import 'package:flutter/material.dart';

import 'package:boitodex/core/theme/app_sizes.dart';
import 'package:boitodex/core/theme/app_spacing.dart';

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
  var _overlayVisible = true;

  @override
  void dispose() {
    _pageController.dispose();
    SystemUi.enableEdgeToEdge();
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() => _overlayVisible = !_overlayVisible);
    _overlayVisible ? SystemUi.enableEdgeToEdge() : SystemUi.enableImmersive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePaths.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: _toggleOverlay,
              child: InteractiveViewer(
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
          ),
          AnimatedOpacity(
            opacity: _overlayVisible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_overlayVisible,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
