import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

  // Download state
  bool _isDownloading = false;
  double _downloadProgress = 0;

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

  // ─── DOWNLOAD LOGIC ───────────────────────────────────────────────────────

  Future<void> _downloadImage() async {
    final urls = widget.imageUrls ?? [];
    final singleUrl = widget.imageUrl ?? '';

    // Tentukan URL yang aktif saat ini
    final String targetUrl = urls.isNotEmpty
        ? urls[_currentIndex]
        : singleUrl;

    if (targetUrl.isEmpty) {
      _showSnackbar('Tidak ada URL lampiran', isError: true);
      return;
    }

    // Minta izin storage/photos
    final bool granted = await _requestPermission();
    if (!granted) {
      _showSnackbar('Izin ditolak, aktifkan di pengaturan', isError: true);
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      // Temp file path
      final dir = await getTemporaryDirectory();
      final fileName = 'lampiran_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savePath = '${dir.path}/$fileName';

      // Download dengan progress
      await Dio().download(
        targetUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      // Simpan ke galeri
      final result = await ImageGallerySaver.saveFile(savePath);

      // Hapus temp file
      final tempFile = File(savePath);
      if (await tempFile.exists()) await tempFile.delete();

      if (result['isSuccess'] == true) {
        _showSnackbar('Tersimpan ke galeri');
      } else {
        _showSnackbar('Gagal menyimpan ke galeri', isError: true);
      }
    } catch (e) {
      _showSnackbar('Gagal mengunduh, coba lagi', isError: true);
    } finally {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0;
      });
    }
  }

  Future<bool> _requestPermission() async {
    // Android 13+ pakai READ_MEDIA_IMAGES, di bawahnya pakai STORAGE
    if (Platform.isAndroid) {
      final sdkInt = await _getAndroidSdkInt();
      final permission = sdkInt >= 33
          ? Permission.photos
          : Permission.storage;

      if (await permission.isGranted) return true;
      final result = await permission.request();
      return result.isGranted;
    }

    // iOS
    if (await Permission.photos.isGranted) return true;
    final result = await Permission.photos.request();
    return result.isGranted;
  }

  Future<int> _getAndroidSdkInt() async {
    try {
      // Ambil SDK version Android
      final result = await Process.run('getprop', ['ro.build.version.sdk']);
      return int.tryParse(result.stdout.toString().trim()) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? Colors.red.shade300 : Colors.green.shade300,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────

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
                    child: Image.network(
                      multipleImages[index],
                      fit: BoxFit.contain,
                      loadingBuilder: _networkLoadingBuilder,
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

          // ── PAGE COUNTER ──
          if (total > 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / $total',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

          // ── ARROW KIRI ──
          if (total > 1 && _currentIndex > 0)
            Positioned(
              left: 8, top: 0, bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.black38,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ),

          // ── ARROW KANAN ──
          if (total > 1 && _currentIndex < total - 1)
            Positioned(
              right: 8, top: 0, bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.black38,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ),

          // ── DOT INDICATOR ──
          if (total > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 72,
              left: 0, right: 0,
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

          // ── BOTTOM BAR: PROGRESS atau TOMBOL DOWNLOAD ──
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              color: Colors.black54,
              child: _isDownloading
                  ? _buildProgressBar()
                  : _buildDownloadButton(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── WIDGETS ──────────────────────────────────────────────────────────────

  Widget _buildDownloadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bluePrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: _downloadImage,
        icon: const Icon(Icons.download_rounded, size: 20),
        label: const Text(
          'Unduh ke Galeri',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final percent = (_downloadProgress * 100).toStringAsFixed(0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mengunduh...',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              '$percent%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _downloadProgress,
            backgroundColor: Colors.white24,
            color: AppColors.bluePrimary,
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _networkLoadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
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
        loadingBuilder: _networkLoadingBuilder,
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
          'Tidak ada lampiran',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
        ),
      ],
    );
  }
}