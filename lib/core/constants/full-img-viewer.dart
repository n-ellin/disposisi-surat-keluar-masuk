import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

/// Reusable full-screen image viewer with pinch-to-zoom, pan, and close overlay.
/// Supports local asset via [imageAssetPath] or network URL via [imageUrl].
/// Asset path takes priority if both are set.
class FullScreenImageViewer extends StatelessWidget {
  const FullScreenImageViewer({
    super.key,
    this.imageAssetPath,
    this.imageUrl,
    this.imageUrls,
    this.initialIndex = 0,
  });

  /// Local asset path (e.g. 'assets/images/logo.png'). Must be listed in pubspec.yaml.
  final String? imageAssetPath;

  /// Network image URL.
  final String? imageUrl;

  /// List of multiple images for carousel (optional)
  final List<String>? imageUrls;

  /// Initial index if using multiple images
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (imageUrls != null && imageUrls!.isNotEmpty)
            PageView.builder(
              controller: PageController(initialPage: initialIndex),
              itemCount: imageUrls!.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: Image.asset(
                      imageUrls![index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          _placeholder(context),
                    ),
                  ),
                );
              },
            )
          else
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(child: _buildImage(context)),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (imageAssetPath != null && imageAssetPath!.isNotEmpty) {
      return Image.asset(
        imageAssetPath!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _placeholder(context),
      );
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: AppColors.bluePrimary,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _placeholder(context),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.insert_drive_file, size: 80, color: Colors.grey.shade600),
        const SizedBox(height: 16),
        Text(
          "Tidak ada lampiran",
          style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
        ),
      ],
    );
  }
}