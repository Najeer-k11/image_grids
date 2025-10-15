## Features

1. Stylish Grid for images
2. Interactive image viewer with in this package

## Example Snippet

```dart
import 'package:flutter/material.dart';
import 'package:flutter_image_grids/flutter_image_grids.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FlutterImageGrids(
          imageLinks: ["https://avatars.githubusercontent.com/u/93590694"],
        ),
      ),
    );
  }
}

```

![Alt text](https://raw.githubusercontent.com/Najeer-k11/flutter_image_grids/main/preview_images/flutter_image_grids_demo.png)
