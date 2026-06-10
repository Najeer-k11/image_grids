import 'package:flutter/material.dart';

import 'image_source.dart';

/// Full-screen, swipeable image viewer.
///
/// Opened automatically when a user taps an image in [FlutterImageGrids]
/// (unless [FlutterImageGrids.enableFullScreenView] is `false` or
/// [FlutterImageGrids.onImageTap] is provided).
///
/// Supports pinch-to-zoom up to 4× via [InteractiveViewer] and smooth
/// [Hero] transitions from the grid thumbnails.
class ImageViewer extends StatefulWidget {
  /// The image to show initially (0-based).
  final int index;

  /// All images available for swiping.
  final List<ImageSource> images;

  /// Creates an [ImageViewer].
  const ImageViewer({
    super.key,
    required this.images,
    this.index = 0,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late final PageController _pc;

  @override
  void initState() {
    super.initState();
    _pc = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        controller: _pc,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final src = widget.images[index];
          return Hero(
            tag: src.heroTag,
            child: InteractiveViewer(
              maxScale: 4.0,
              child: Center(
                child: src.toWidget(fit: BoxFit.contain),
              ),
            ),
          );
        },
      ),
    );
  }
}
