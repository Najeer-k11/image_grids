import 'package:flutter/material.dart';
/// This is the main widget to call in your app.
class FlutterImageGrids extends StatelessWidget {
  /// Constructor which has some default values. Incase you don't want to modify.
  const FlutterImageGrids({
    super.key,
    required this.imageLinks,
    this.padding = 12,
    this.borderRadius = 24,
    this.emptyWidget,
    this.backgroundColor = Colors.white,
    this.dividerColor = Colors.white,
    this.height,
  });
  /// This argument takes the image links array - At present we support only network images
  final List<dynamic> imageLinks;
  /// [padding] is used for gaps between the [FlutterImageGrids] widget and outer widget
  final double padding;
  /// [borderRadius] is used to define the roundness of the [FlutterImageGrids].
  final double borderRadius;
  /// [emptyWidget] is a widget to display on the [FlutterImageGrids]. when images Links are empty.
  final Widget? emptyWidget;
  /// background color for [FlutterImageGrids] 
  final Color backgroundColor;
  /// divider color for 2 images separation
  final Color dividerColor;
  /// we can height of the [FlutterImageGrids]
  final double? height;

  /// Full screen Image viewer in this package only.
  void sendToImageViewer(BuildContext context, {required int index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewer(images: imageLinks, index: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.sizeOf(context).width;
    return Container(
      margin: EdgeInsets.all(padding),
      clipBehavior: Clip.antiAlias,
      width: sw - (2 * padding),
      height: (height ?? sw) - (2 * padding),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Column(
        children: [
          // if (true) ...[
          //   Expanded(
          //     child: Image.network(
          //       images.first,
          //       fit: BoxFit.cover,
          //       width: sw,
          //       height: sw,
          //     ),
          //   ),
          // ],
          if (imageLinks.isEmpty && emptyWidget != null) ...[
            Expanded(child: emptyWidget!),
          ],

          if (imageLinks.length <= 2) ...[
            ...imageLinks.asMap().entries.map(
              (entry) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    sendToImageViewer(context, index: entry.key);
                  },
                  child: Image.network(
                    entry.value,
                    width: sw - (2 * padding),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],

          if (imageLinks.length >= 3) ...[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  sendToImageViewer(context, index: 0);
                },
                child: Image.network(
                  imageLinks.first,
                  width: sw,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Divider(height: 4, color: dividerColor),
            SizedBox(
              height: (sw - (2 * padding)) * 0.32,
              width: sw - (2 * padding),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(width: 4);
                },
                scrollDirection: Axis.horizontal,
                itemCount: (imageLinks.length - 1) > 3 ? 3 : (imageLinks.length - 1),
                itemBuilder: (context, index) {
                  int numRemaining = imageLinks.length - 1; // After hero
                  int numShown = (numRemaining > 3) ? 3 : numRemaining;
                  int remImages = (numRemaining > 3) ? numRemaining - 3 : 0;

                  bool isLast = index == (numShown - 1);

                  return GestureDetector(
                    onTap: () {
                      sendToImageViewer(context, index: index + 1);
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          width: (sw - (2 * padding)) / 3,
                          height: (sw - (2 * padding)) / 3,
                          child: Image.network(
                            imageLinks[index + 1],
                            fit: BoxFit.cover,
                          ),
                        ),

                        if (isLast && remImages > 0) ...[
                          Container(
                            width: (sw - (2 * padding)) / 3,
                            height: (sw - (2 * padding)) / 3,
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(
                                102,
                              ), // Slightly more opaque
                            ),
                            child: Center(
                              child: Text(
                                '+$remImages more', // Cleaner text
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}


/// [ImageViewer] is defined for viewing all the images in a horizontal scrolling.
class ImageViewer extends StatefulWidget {
  /// index is used to show the that image when navigating to this page.
  final int index;
  /// images is an array of network image links.
  final List<dynamic> images;
  /// public constructor
  const ImageViewer({super.key, required this.images, this.index = 0});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  PageController pc = PageController();

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: PageView.builder(
        controller: pc,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          String img = widget.images[index];
          return InteractiveViewer(
            maxScale: 2.5,
            child: Image.network(img.toString()),
          );
        },
      ),
    );
  }
}
