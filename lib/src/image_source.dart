import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Describes the origin of an image used in [FlutterImageGrids].
enum ImageSourceType {
  /// Image fetched from a URL via HTTP/HTTPS. Cached automatically.
  network,

  /// Image bundled as a Flutter asset.
  asset,

  /// Image read from a local [File] on disk.
  file,

  /// Image decoded from raw bytes (e.g. base64-decoded data from a draft).
  memory,
}

/// Wraps the origin of a single image so [FlutterImageGrids] can render
/// network, asset, file, and in-memory images uniformly.
///
/// ### Usage
/// ```dart
/// ImageSource.network('https://example.com/photo.jpg')
/// ImageSource.asset('assets/placeholder.png')
/// ImageSource.file(File('/sdcard/DCIM/img.jpg'))
/// ImageSource.memory(bytes)
/// ```
class ImageSource {
  /// The source type.
  final ImageSourceType type;

  /// Network URL — set when [type] is [ImageSourceType.network].
  final String? url;

  /// Asset path — set when [type] is [ImageSourceType.asset].
  final String? assetPath;

  /// Local file — set when [type] is [ImageSourceType.file].
  final File? file;

  /// Raw bytes — set when [type] is [ImageSourceType.memory].
  final Uint8List? bytes;

  /// Creates a network image source. The URL is cached on first load.
  const ImageSource.network(this.url)
      : type = ImageSourceType.network,
        assetPath = null,
        file = null,
        bytes = null;

  /// Creates an asset image source.
  const ImageSource.asset(this.assetPath)
      : type = ImageSourceType.asset,
        url = null,
        file = null,
        bytes = null;

  /// Creates a file image source.
  ImageSource.file(this.file)
      : type = ImageSourceType.file,
        url = null,
        assetPath = null,
        bytes = null;

  /// Creates a memory (bytes) image source.
  ImageSource.memory(this.bytes)
      : type = ImageSourceType.memory,
        url = null,
        assetPath = null,
        file = null;

  /// A tag unique to this source, used for [Hero] animations.
  String get heroTag {
    switch (type) {
      case ImageSourceType.network:
        return 'flutter_image_grid_net_$url';
      case ImageSourceType.asset:
        return 'flutter_image_grid_asset_$assetPath';
      case ImageSourceType.file:
        return 'flutter_image_grid_file_${file?.path}';
      case ImageSourceType.memory:
        return 'flutter_image_grid_mem_${identityHashCode(bytes)}';
    }
  }

  /// Renders this image source as a Flutter [Widget].
  ///
  /// Falls back to [loadingWidget] while loading and [errorWidget] on failure.
  Widget toWidget({
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    Widget? loadingWidget,
    Widget? errorWidget,
  }) {
    final Widget defaultLoading = loadingWidget ??
        Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );

    final Widget defaultError = errorWidget ??
        Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: Icon(Icons.broken_image_outlined, color: Colors.grey),
          ),
        );

    switch (type) {
      case ImageSourceType.network:
        return CachedNetworkImage(
          imageUrl: url!,
          fit: fit,
          width: width,
          height: height,
          placeholder: (_, __) => defaultLoading,
          errorWidget: (_, __, ___) => defaultError,
        );
      case ImageSourceType.asset:
        return Image.asset(
          assetPath!,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => defaultError,
        );
      case ImageSourceType.file:
        return Image.file(
          file!,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => defaultError,
        );
      case ImageSourceType.memory:
        return Image.memory(
          bytes!,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => defaultError,
        );
    }
  }
}
