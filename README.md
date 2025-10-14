## Features

1. Stylish Grid for images
2. Interactive image viewer with in this package


## Example Snippet

```dart
import 'package:flutter/material.dart';
import 'package:image_grids/image_grids.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ImageGrid(
          imageLinks: ["https://avatars.githubusercontent.com/u/93590694"],
        ),
      ),
    );
  }
}

```
