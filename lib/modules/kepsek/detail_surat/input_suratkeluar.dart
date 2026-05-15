import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/full-img-viewer.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/detail_surat/output_suratkeluar.dart';

class InputSuratKeluar extends StatefulWidget {
  const InputSuratKeluar({super.key});

  @override
  State<InputSuratKeluar> createState() => _InputSuratKeluarState();
}

class _InputSuratKeluarState extends State<InputSuratKeluar> {
  final TextEditingController catatanController = TextEditingController();

  bool _showLampiran = false;

  static const List<String> _attachmentUrls = [
    'assets/images/undangan.png',
    'assets/images/undangan.png',
    'assets/images/logo.png',
  ];

  @override
  void dispose() {
    catatanController.dispose();
    super.dispose();
  }

  // ── CONFIRM DIALOG ─────────────────────────────────────────────────────────
  void _showConfirmDialog(BuildContext context, {required bool isApproved}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isApproved ? Icons.check_circle_outline : Icons.cancel_outlined,
              color: isApproved ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(isApproved ? "Terima Surat" : "Tolak Surat"),
          ],
        ),
        content: Text(
          isApproved
              ? "Apakah Anda yakin ingin menerima surat ini?"
              : "Apakah Anda yakin ingin menolak surat ini?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isApproved ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Yakin"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ── HEADER ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 10),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.orangePrimary,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Detail Surat Keluar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.orangePrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── DETAIL CARD ──────────────────────────────────────────────
              _detailCard(context),
              const SizedBox(height: 20),

              // ── FORM DISPOSISI ───────────────────────────────────────────
              _formDisposisi(),
              const SizedBox(height: 20),

              // ── BUTTONS ──────────────────────────────────────────────────
              // ── BUTTONS ──────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      label: const Text(
                        "Terima",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      label: const Text(
                        "Tolak",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ── DETAIL CARD ────────────────────────────────────────────────────────────

  Widget _detailCard(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem(
              Icons.numbers,
              "Nomor Surat",
              "421.3/045/SMK-TI/VI/2026",
            ),
            _detailItem(Icons.calendar_today, "Tanggal", "24 Juni 2026"),
            _detailItem(Icons.person, "Pengirim", "SMKN 1 Singosari"),
            _detailItem(
              Icons.description,
              "Perihal",
              "Permohonan Izin Menghadiri Rapat",
            ),
            const SizedBox(height: 8),
            Text(
              "Lampiran",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (_attachmentUrls.isEmpty)
              Text(
                "Tidak ada lampiran",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              )
            else
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImageViewer(
                        imageUrls: _attachmentUrls,
                        initialIndex: 0,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_file_rounded,
                        color: AppColors.orangePrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${_attachmentUrls.length} File Lampiran",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.grey.shade500,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(icon, size: 24, color: Colors.grey.shade500),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── FORM ───────────────────────────────────────────────────────────────────

  Widget _formDisposisi() {
    return _sectionCard(
      title: "Form Disposisi",
      children: [
        _buildLabel("Catatan"),
        _textField(hint: "Masukkan catatan...", controller: catatanController),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.orangePrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _textField({required String hint, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: 2,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.orangePrimary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ── ATTACHMENT CAROUSEL ────────────────────────────────────────────────────

class _AttachmentCarousel extends StatefulWidget {
  const _AttachmentCarousel({required this.attachmentUrls});
  final List<String> attachmentUrls;

  @override
  State<_AttachmentCarousel> createState() => _AttachmentCarouselState();
}

class _AttachmentCarouselState extends State<_AttachmentCarousel> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attachmentUrls = widget.attachmentUrls;

    return SizedBox(
      height: 230,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: attachmentUrls.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final path = attachmentUrls[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewer(
                          imageAssetPath: path,
                          imageUrls: attachmentUrls,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        path,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_rounded,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              Text("Gagal memuat gambar"),
                            ],
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
            bottom: 12,
            child: Row(
              children: List.generate(attachmentUrls.length, (index) {
                final isActive = _currentIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 18 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isActive
                        ? AppColors.orangePrimary
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
