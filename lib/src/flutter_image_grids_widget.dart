import 'package:flutter/material.dart';

import 'constants.dart';
import 'image_source.dart';
import 'image_viewer.dart';

/// A beautiful multi-image grid widget with smart per-count layouts.
///
/// | Image count | Layout |
/// |---|---|
/// | 0 | [emptyWidget] (if provided) |
/// | 1 | Full-size single image |
/// | 2 | Side-by-side row |
/// | 3 | Large hero + 2 equal thumbnails |
/// | 4 | True 2 × 2 grid |
/// | 5+ | Large hero + up to 3 thumbnails with `+N more` overlay |
///
/// ### Basic usage
/// ```dart
/// FlutterImageGrids(
///   images: [
///     ImageSource.network('https://example.com/a.jpg'),
///     ImageSource.asset('assets/b.png'),
///   ],
/// )
/// ```
///
/// ### Custom tap handling
/// ```dart
/// FlutterImageGrids(
///   images: sources,
///   enableFullScreenView: false,
///   onImageTap: (i) => myGallery.open(i),
///   onLongPress: (i) => showSaveSheet(i),
/// )
/// ```
class FlutterImageGrids extends StatelessWidget {
  /// Creates a [FlutterImageGrids] widget.
  ///
  /// [aspectRatio] and [height] are mutually exclusive.
  const FlutterImageGrids({
    super.key,
    required this.images,
    this.padding = 12,
    this.borderRadius = 24,
    this.emptyWidget,
    this.backgroundColor = Colors.white,
    this.dividerColor = Colors.white,
    this.height,
    this.aspectRatio,
    this.onImageTap,
    this.onLongPress,
    this.enableFullScreenView = true,
    this.loadingWidget,
    this.errorWidget,
  }) : assert(
          aspectRatio == null || height == null,
          'Specify either aspectRatio or height, not both.',
        );

  // ─── Required ─────────────────────────────────────────────────────────────

  /// Images to display.
  ///
  /// Use [ImageSource.network], [ImageSource.asset], [ImageSource.file],
  /// or [ImageSource.memory] to create entries.
  final List<ImageSource> images;

  // ─── Layout ───────────────────────────────────────────────────────────────

  /// Outer margin around the widget. Defaults to `12`.
  final double padding;

  /// Corner radius of the container. Defaults to `24`.
  final double borderRadius;

  /// Widget to show when [images] is empty.
  final Widget? emptyWidget;

  /// Background color of the container. Defaults to [Colors.white].
  final Color backgroundColor;

  /// Color of the thin dividers between grid cells. Defaults to [Colors.white].
  final Color dividerColor;

  /// Explicit container height. Cannot be combined with [aspectRatio].
  final double? height;

  /// Aspect ratio (width ÷ height) of the container.
  ///
  /// Overrides [height] when provided. Examples: `1.0` (square), `16/9`.
  /// Cannot be combined with [height].
  final double? aspectRatio;

  // ─── Interaction ──────────────────────────────────────────────────────────

  /// Called with the tapped image's index whenever a cell is tapped.
  ///
  /// When provided, **replaces** the built-in [ImageViewer] navigation.
  /// Use together with [enableFullScreenView] `= false` to take full control.
  final void Function(int index)? onImageTap;

  /// Called with the image index on long-press.
  final void Function(int index)? onLongPress;

  /// Whether tapping opens the built-in full-screen [ImageViewer].
  ///
  /// Defaults to `true`. Ignored when [onImageTap] is provided.
  final bool enableFullScreenView;

  // ─── Image rendering ──────────────────────────────────────────────────────

  /// Widget shown while an image is loading.
  ///
  /// Defaults to a centered [CircularProgressIndicator].
  final Widget? loadingWidget;

  /// Widget shown when an image fails to load.
  ///
  /// Defaults to a centered broken-image icon.
  final Widget? errorWidget;

  // ─── Private helpers ──────────────────────────────────────────────────────

  /// How many thumbnails are currently shown in the strip.
  int get _shownThumbnailCount =>
      (images.length - 1).clamp(0, ImageGridConstants.maxThumbnails);

  void _handleTap(BuildContext context, int index) {
    if (onImageTap != null) {
      onImageTap!(index);
      return;
    }
    if (enableFullScreenView) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImageViewer(images: images, index: index),
        ),
      );
    }
  }

  /// Renders the image at [src] with optional [Hero] wrapping.
  Widget _img(
    ImageSource src, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    bool withHero = true,
  }) {
    final img = src.toWidget(
      fit: fit,
      width: width,
      height: height,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
    );
    return withHero ? Hero(tag: src.heroTag, child: img) : img;
  }

  /// Wraps [child] in a [GestureDetector] wired to tap/long-press callbacks.
  Widget _tappable(BuildContext context, int index, Widget child) {
    return GestureDetector(
      onTap: () => _handleTap(context, index),
      onLongPress: onLongPress != null ? () => onLongPress!(index) : null,
      child: child,
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.sizeOf(context).width;
    final double w = sw - 2 * padding;
    final double h = aspectRatio != null
        ? w / aspectRatio!
        : (height ?? sw) - 2 * padding;

    return Container(
      margin: EdgeInsets.all(padding),
      clipBehavior: Clip.antiAlias,
      width: w,
      height: h,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: _layout(context, w, h),
    );
  }

  Widget _layout(BuildContext context, double w, double h) {
    if (images.isEmpty) {
      return emptyWidget != null
          ? SizedBox.expand(child: emptyWidget!)
          : const SizedBox.shrink();
    }

    switch (images.length) {
      case 1:
        return _singleImage(context, w, h);
      case 2:
        return _twoImages(context);
      case 4:
        return _twoByTwoGrid(context);
      default:
        // 3 images → hero + 2 thumbnails
        // 5+ images → hero + 3 thumbnails with +N overlay
        return _heroWithStrip(context, w);
    }
  }

  // ─── Layout: 1 image ─────────────────────────────────────────────────────

  Widget _singleImage(BuildContext context, double w, double h) {
    return _tappable(
      context,
      0,
      SizedBox.expand(child: _img(images[0], width: w, height: h)),
    );
  }

  // ─── Layout: 2 images (side-by-side) ─────────────────────────────────────

  Widget _twoImages(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _tappable(
            context,
            0,
            SizedBox.expand(child: _img(images[0])),
          ),
        ),
        Container(
          width: ImageGridConstants.dividerThickness,
          color: dividerColor,
        ),
        Expanded(
          child: _tappable(
            context,
            1,
            SizedBox.expand(child: _img(images[1])),
          ),
        ),
      ],
    );
  }

  // ─── Layout: 4 images (2 × 2 grid) ──────────────────────────────────────

  Widget _twoByTwoGrid(BuildContext context) {
    const double sep = ImageGridConstants.dividerThickness;

    Widget cell(int i) => Expanded(
          child: _tappable(
            context,
            i,
            SizedBox.expand(child: _img(images[i])),
          ),
        );

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              cell(0),
              Container(width: sep, color: dividerColor),
              cell(1),
            ],
          ),
        ),
        Container(height: sep, color: dividerColor),
        Expanded(
          child: Row(
            children: [
              cell(2),
              Container(width: sep, color: dividerColor),
              cell(3),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Layout: hero + thumbnail strip (3 or 5+) ────────────────────────────

  Widget _heroWithStrip(BuildContext context, double w) {
    const double sep = ImageGridConstants.dividerThickness;
    final int numShown = _shownThumbnailCount;
    final int numRemaining = images.length - 1;
    final int remImages =
        numRemaining > ImageGridConstants.maxThumbnails
            ? numRemaining - ImageGridConstants.maxThumbnails
            : 0;
    final double thumbH = w * ImageGridConstants.thumbnailHeightRatio;

    return Column(
      children: [
        // ── Hero (first image) ────────────────────────────────────────────
        Expanded(
          child: _tappable(
            context,
            0,
            SizedBox.expand(child: _img(images[0])),
          ),
        ),

        Container(height: sep, color: dividerColor),

        // ── Thumbnail strip ───────────────────────────────────────────────
        SizedBox(
          height: thumbH,
          child: Row(
            children: [
              for (int i = 0; i < numShown; i++) ...[
                if (i > 0) Container(width: sep, color: dividerColor),
                Expanded(
                  child: _thumbCell(
                    context,
                    imgIndex: i + 1,
                    stripIndex: i,
                    numShown: numShown,
                    remImages: remImages,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a single cell in the thumbnail strip.
  ///
  /// The last cell gets an overlay with the `+N more` count when there are
  /// images beyond the visible strip.
  Widget _thumbCell(
    BuildContext context, {
    required int imgIndex,
    required int stripIndex,
    required int numShown,
    required int remImages,
  }) {
    final bool isLast = stripIndex == numShown - 1;
    final bool showOverlay = isLast && remImages > 0;

    return _tappable(
      context,
      imgIndex,
      Stack(
        fit: StackFit.expand,
        children: [
          // Skip Hero on the overlaid cell — no smooth transition from a
          // half-obscured thumbnail.
          _img(images[imgIndex], withHero: !showOverlay),

          if (showOverlay)
            Container(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.4),
              alignment: Alignment.center,
              child: Text(
                '+$remImages more',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
