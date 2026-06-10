/// Flutter Image Grids — stylish multi-image grid with smart layouts.
///
/// Import this library to access:
/// - [FlutterImageGrids] — the main grid widget.
/// - [ImageSource] — wraps network, asset, file, or memory images.
/// - [ImageViewer] — built-in full-screen swipeable image viewer.
///
/// ### Quick start
/// ```dart
/// import 'package:flutter_image_grids/flutter_image_grids.dart';
///
/// FlutterImageGrids(
///   images: [
///     ImageSource.network('https://picsum.photos/800/600'),
///     ImageSource.asset('assets/photo.jpg'),
///   ],
/// )
/// ```
library;

export 'src/flutter_image_grids_widget.dart';
export 'src/image_source.dart';
export 'src/image_viewer.dart';
