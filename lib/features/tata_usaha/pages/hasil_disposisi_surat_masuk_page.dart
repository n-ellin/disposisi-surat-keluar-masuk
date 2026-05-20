import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/utils/full-imges-viewer.dart';

class OutputSuratmasuk extends StatelessWidget {
  final bool isApproved;
  final String catatan;
  final String tujuan;
  final String instruksi;
  final String koordinasi;
  final String diteruskanKe;
  final bool isReadOnly;
  final List<String> lampiranUrls;

  const OutputSuratmasuk({
    super.key,
    required this.isApproved,
    required this.catatan,
    required this.tujuan,
    required this.instruksi,
    required this.koordinasi,
    required this.diteruskanKe,
    this.isReadOnly = false,
    this.lampiranUrls = const [],
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final w = size.width;
    final h = size.height;

    double rf(double size) {
      return (w * (size / 375)).clamp(size * 0.9, size * 1.2);
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    w * 0.05,
                    h * 0.025,
                    w * 0.05,
                    0,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.bluePrimary,
                          size: w * 0.05,
                        ),
                      ),

                      SizedBox(width: w * 0.015),

                      Text(
                        "Detail Surat Masuk",
                        style: TextStyle(
                          fontSize: rf(18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.bluePrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.025),

                /// CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// FORM
                        if (isApproved) ...[
                          _sectionCard(
                            w: w,
                            children: [
                              _readOnlyField(
                                label: "Diteruskan Ke",
                                value: diteruskanKe,
                                w: w,
                                h: h,
                                rf: rf,
                              ),
                            ],
                          ),

                          SizedBox(height: h * 0.02),

                          _sectionCard(
                            w: w,
                            children: [
                              _labeledTextArea(
                                label: "Catatan",
                                value: catatan,
                                w: w,
                                h: h,
                                rf: rf,
                              ),
                            ],
                          ),

                          SizedBox(height: h * 0.02),

                          _sectionCard(
                            w: w,
                            children: [
                              _labeledTextArea(
                                label: "Tanggapan dan Saran",
                                value: tujuan,
                                w: w,
                                h: h,
                                rf: rf,
                              ),

                              SizedBox(height: h * 0.015),

                              _labeledTextArea(
                                label: "Proses Lebih Lanjut",
                                value: instruksi,
                                w: w,
                                h: h,
                                rf: rf,
                              ),

                              SizedBox(height: h * 0.015),

                              _labeledTextArea(
                                label: "Koordinasi / Konfirmasikan",
                                value: koordinasi,
                                w: w,
                                h: h,
                                rf: rf,
                              ),
                            ],
                          ),
                        ] else ...[
                          _sectionCard(
                            w: w,
                            children: [
                              _labeledTextArea(
                                label: "Catatan",
                                value: catatan,
                                w: w,
                                h: h,
                                rf: rf,
                              ),
                            ],
                          ),
                        ],

                        SizedBox(height: h * 0.025),

                        /// LAMPIRAN
                        if (isReadOnly && lampiranUrls.isNotEmpty) ...[
                          Text(
                            "Lampiran Surat",
                            style: TextStyle(
                              fontSize: rf(15),
                              fontWeight: FontWeight.bold,
                              color: AppColors.bluePrimary,
                            ),
                          ),

                          SizedBox(height: h * 0.012),

                          _sectionCard(
                            w: w,
                            children: [
                              _AttachmentCarousel(attachmentUrls: lampiranUrls),
                            ],
                          ),

                          SizedBox(height: h * 0.025),
                        ],

                        /// BUTTON
                        Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(0, h * 0.055),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w * 0.05,
                                    vertical: h * 0.014,
                                  ),
                                  side: const BorderSide(
                                    color: AppColors.bluePrimary,
                                    width: 1.2,
                                  ),
                                  foregroundColor: AppColors.bluePrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => FullScreenImageViewer(
                                        imageAssetPath:
                                            'assets/images/undangan.png',
                                        imageUrls: const [
                                          'assets/images/undangan.png',
                                          'assets/images/logo.png',
                                        ],
                                        initialIndex: 0,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  size: w * 0.045,
                                ),
                                label: Text(
                                  "Lihat Surat",
                                  style: TextStyle(
                                    fontSize: rf(14),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              if (!isReadOnly) ...[
                                if (isApproved)
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(0, h * 0.055),
                                      backgroundColor: AppColors.bluePrimary,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.05,
                                        vertical: h * 0.014,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: Icon(Icons.send, size: w * 0.045),
                                    label: Text(
                                      "Teruskan",
                                      style: TextStyle(
                                        fontSize: rf(14),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                else
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(0, h * 0.055),
                                      backgroundColor: AppColors.bluePrimary,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.05,
                                        vertical: h * 0.014,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      "Konfirmasi",
                                      style: TextStyle(
                                        fontSize: rf(14),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: h * 0.03),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required List<Widget> children, required double w}) {
    return Card(
      elevation: 3,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.04),
      ),
      child: Padding(
        padding: EdgeInsets.all(w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _readOnlyField({
    required String label,
    required String value,
    required double w,
    required double h,
    required double Function(double) rf,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: rf(14),
              fontWeight: FontWeight.bold,
              color: AppColors.bluePrimary,
            ),
          ),

          SizedBox(height: h * 0.008),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.03,
              vertical: h * 0.012,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(w * 0.02),
            ),
            child: Text(
              value.isEmpty ? "-" : value,
              style: TextStyle(fontSize: rf(14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labeledTextArea({
    required String label,
    required String value,
    required double w,
    required double h,
    required double Function(double) rf,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: rf(14),
            fontWeight: FontWeight.bold,
            color: AppColors.bluePrimary,
          ),
        ),

        SizedBox(height: h * 0.008),

        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: h * 0.1),
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.03,
            vertical: h * 0.012,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(w * 0.02),
          ),
          child: Text(
            value.isEmpty ? "-" : value,
            style: TextStyle(fontSize: rf(14)),
          ),
        ),
      ],
    );
  }
}

class _AttachmentCarousel extends StatefulWidget {
  const _AttachmentCarousel({required this.attachmentUrls});

  final List<String> attachmentUrls;

  @override
  State<_AttachmentCarousel> createState() => _AttachmentCarouselState();
}

class _AttachmentCarouselState extends State<_AttachmentCarousel> {
  late PageController _pageController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attachmentUrls = widget.attachmentUrls;

    final size = MediaQuery.of(context).size;

    final w = size.width;
    final h = size.height;

    return SizedBox(
      height: w * 0.55,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: attachmentUrls.length,
            onPageChanged: (i) {
              setState(() {
                _currentIndex = i;
              });
            },
            itemBuilder: (context, index) {
              final path = attachmentUrls[index];

              return Padding(
                padding: EdgeInsets.only(right: w * 0.02),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewer(
                          imageAssetPath: path,
                          imageUrls: attachmentUrls,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(w * 0.03),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(w * 0.03),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: Image.asset(
                        path,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: h * 0.04),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: w * 0.12,
                                  color: Colors.grey,
                                ),

                                SizedBox(height: h * 0.01),

                                Text(
                                  "Gagal memuat gambar",
                                  style: TextStyle(fontSize: w * 0.035),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          Positioned(
            bottom: h * 0.015,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(attachmentUrls.length, (index) {
                final isActive = index == _currentIndex;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: w * 0.008),
                  width: isActive ? w * 0.025 : w * 0.015,
                  height: isActive ? w * 0.025 : w * 0.015,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppColors.bluePrimary
                        : Colors.grey.shade400,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
