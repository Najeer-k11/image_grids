/// Layout constants for [FlutterImageGrids].
///
/// Centralising these values avoids scattered magic numbers and makes it
/// trivial to tweak the visual rhythm of the grid in one place.
class ImageGridConstants {
  ImageGridConstants._();

  /// Height ratio of the thumbnail strip relative to the container width.
  static const double thumbnailHeightRatio = 0.32;

  /// Thickness (logical pixels) of dividers between cells.
  static const double dividerThickness = 4.0;

  /// Maximum number of thumbnails shown in the bottom strip.
  static const int maxThumbnails = 3;
}
