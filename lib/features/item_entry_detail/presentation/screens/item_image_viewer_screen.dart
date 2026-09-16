import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:boitodex/core/theme/app_spacing.dart';

class ItemImageViewerScreen extends StatefulWidget {
  const ItemImageViewerScreen({
    required this.imagePaths,
    required this.initialIndex,
    super.key,
  });

  final List<String> imagePaths;
  final int initialIndex;

  @override
  State<ItemImageViewerScreen> createState() => _ItemImageViewerScreenState();
}

class _ItemImageViewerScreenState extends State<ItemImageViewerScreen> {
  // --- Colocated UI Constants ---
  static const double _minScale = 1.0;
  static const double _maxScale = 4.0;
  static const Duration _fadeDuration = Duration(milliseconds: 200);

  late final _pageController = PageController(initialPage: widget.initialIndex);
  var _overlayVisible = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() => _overlayVisible = !_overlayVisible);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Force white status bar icons against the black background.
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.imagePaths.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: _toggleOverlay,
                child: InteractiveViewer(
                  minScale: _minScale,
                  maxScale: _maxScale,
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
              duration: _fadeDuration,
              child: IgnorePointer(
                ignoring: !_overlayVisible,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      tooltip: 'Retour',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
