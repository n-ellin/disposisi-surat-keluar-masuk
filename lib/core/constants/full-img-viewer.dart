import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

class FullScreenImageViewer extends StatefulWidget {
  const FullScreenImageViewer({
    super.key,
    this.imageAssetPath,
    this.imageUrl,
    this.imageUrls,
    this.initialIndex = 0,
  });

  final String? imageAssetPath;
  final String? imageUrl;
  final List<String>? imageUrls;
  final int initialIndex;

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final multipleImages = widget.imageUrls ?? const <String>[];
    final total = multipleImages.isNotEmpty ? multipleImages.length : 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          // ── KONTEN GAMBAR ──
          if (multipleImages.isNotEmpty)
            PageView.builder(
              controller: _pageController,
              itemCount: multipleImages.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: Image.asset(
                      multipleImages[index],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    ),
                  ),
                );
              },
            )
          else
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(child: _buildImage()),
            ),

          // ── TOMBOL CLOSE ──
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

          // ✅ INDICATOR HALAMAN "1/3"
          if (total > 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${_currentIndex + 1} / $total",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

          // ✅ ARROW KIRI — kalau bukan halaman pertama
          if (total > 1 && _currentIndex > 0)
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.black38,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ✅ ARROW KANAN — kalau bukan halaman terakhir
          if (total > 1 && _currentIndex < total - 1)
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.black38,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ✅ DOT INDICATOR DI BAWAH
          if (total > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(total, (index) {
                  final isActive = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 10 : 6,
                    height: isActive ? 10 : 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.white : Colors.white38,
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final assetPath = widget.imageAssetPath ?? '';
    final networkUrl = widget.imageUrl ?? '';

    if (assetPath.isNotEmpty) {
      return Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    if (networkUrl.isNotEmpty) {
      return Image.network(
        networkUrl,
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
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
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