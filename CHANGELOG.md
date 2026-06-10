## 2.0.0

### ⚠️ Breaking Changes
- `imageLinks: List<dynamic>` → `images: List<ImageSource>`.  
  Migrate: `ImageSource.network(url)` replaces bare URL strings.

### ✨ New Features
- **`ImageSource` wrapper** — supports `network`, `asset`, `file`, and `memory` images.
- **`cached_network_image`** — network images are now cached for performance and offline resilience.
- **2 × 2 grid for exactly 4 images** — replaces the awkward hero + 3-strip layout.
- **Side-by-side layout for 2 images** — was incorrectly stacked vertically.
- **Hero animations** — smooth open/close transitions between grid and full-screen viewer.
- **`onImageTap(int index)`** — custom tap handler replacing built-in viewer navigation.
- **`onLongPress(int index)`** — callback for long-press on any image cell.
- **`enableFullScreenView`** — disable built-in viewer to handle navigation yourself.
- **`loadingWidget`** — custom widget shown while an image is loading.
- **`errorWidget`** — custom widget shown when an image fails to load.
- **`aspectRatio`** — control the grid's aspect ratio (`16/9`, `4/3`, `1.0`, …).

### 🐛 Bug Fixes
- `withAlpha(102)` replaced with `withOpacity(0.4)` for overlay readability.
- `PageController` in `ImageViewer` is now correctly disposed.
- `ImageViewer` background is now black (was transparent).

### 🧹 Code Quality
- Extracted layout constants into `ImageGridConstants`.
- Split into `src/` subdirectory: `flutter_image_grids_widget.dart`, `image_source.dart`, `image_viewer.dart`, `constants.dart`.
- `lib/flutter_image_grids.dart` is now a clean barrel export.

## 1.0.4


- Added Documentation
- Preview Images

## 1.0.2

- updating file names and code snippet

## 1.0.1
 - initial publish
