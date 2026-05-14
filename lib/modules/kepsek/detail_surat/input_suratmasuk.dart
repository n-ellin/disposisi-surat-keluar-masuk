import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/full-img-viewer.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/detail_surat/output_suratmasuk.dart';

class InputSuratMasuk extends StatefulWidget {
  final Map<String, dynamic> surat;

  const InputSuratMasuk({super.key, required this.surat});

  @override
  State<InputSuratMasuk> createState() => _InputSuratMasukState();
}

class _InputSuratMasukState extends State<InputSuratMasuk> {
  String? _selectedStatus;

  final TextEditingController catatanTerimaController = TextEditingController();
  final TextEditingController catatanTolakController = TextEditingController();
  final TextEditingController tanggapanController = TextEditingController();
  final TextEditingController instruksiController = TextEditingController();
  final TextEditingController koordinasiController = TextEditingController();
  final TextEditingController multiSelectController = TextEditingController();

  List<String> selectedTujuan = [];

  bool get isApproved => _selectedStatus == 'terima';
  bool get isRejected => _selectedStatus == 'tolak';

  List<String> get attachmentUrls =>
      List<String>.from(widget.surat['lampiran'] ?? []);

  Map<String, dynamic> get suratData => widget.surat['data'] ?? {};

  @override
  void dispose() {
    catatanTerimaController.dispose();
    catatanTolakController.dispose();
    tanggapanController.dispose();
    instruksiController.dispose();
    koordinasiController.dispose();
    multiSelectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),

              // ── HEADER ──────────────────────────────────────────────────
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.bluePrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Text(
                    "Detail Surat Masuk",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bluePrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── DETAIL CARD ─────────────────────────────────────────────
              _detailCard(context),
              const SizedBox(height: 20),

              // ── STATUS DROPDOWN ─────────────────────────────────────────
              const Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    hintText: "Pilih status",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'terima', child: Text("Terima")),
                    DropdownMenuItem(value: 'tolak', child: Text("Tolak")),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedStatus = value);
                  },
                ),
              ),
              const SizedBox(height: 18),

              // ── FORM BERDASARKAN STATUS ─────────────────────────────────
              if (isApproved) ...[
                _formDisposisi(),
                const SizedBox(height: 16),
                _formTambahan(),
              ],

              if (isRejected)
                _sectionCard(
                  title: "Form Disposisi",
                  children: [
                    _buildLabel("Catatan"),
                    _textField(
                      hint: "Masukkan catatan...",
                      controller: catatanTolakController,
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              // ── TOMBOL KIRIM ────────────────────────────────────────────
              if (_selectedStatus != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bluePrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OutputSuratmasuk(
                            isApproved: isApproved,
                            catatan: isApproved
                                ? catatanTerimaController.text
                                : catatanTolakController.text,
                            tujuan: tanggapanController.text,
                            instruksi: instruksiController.text,
                            koordinasi: koordinasiController.text,
                            diteruskanKe: selectedTujuan.join(", "),
                          ),
                        ),
                      );
                    },
                    child: const Text("Kirim"),
                  ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailItem(
            Icons.description_outlined,
            "Nomor Surat",
            suratData['Nomor Surat'] ?? '-',
          ),
          _detailItem(
            Icons.calendar_today_outlined,
            "Tanggal",
            widget.surat['tanggal'] ?? '-',
          ),
          _detailItem(
            Icons.person_outline,
            "Pengirim",
            suratData['Dari'] ?? '-',
          ),
          _detailItem(Icons.notes, "Perihal", suratData['Perihal'] ?? '-'),

          // ── LAMPIRAN: langsung carousel preview ──────────────────────
          if (attachmentUrls.isEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: const Column(
                  children: [
                    Icon(Icons.insert_drive_file, size: 50),
                    SizedBox(height: 10),
                    Text(
                      "Tidak ada lampiran",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            _AttachmentCarousel(attachmentUrls: attachmentUrls),
        ],
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
            child: Icon(icon, color: Colors.grey.shade500, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
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
        _buildLabel("Diteruskan Ke"),
        _multiSelectField(),
        const SizedBox(height: 12),
        _buildLabel("Catatan"),
        _textField(
          hint: "Masukkan catatan tambahan...",
          controller: catatanTerimaController,
        ),
      ],
    );
  }

  Widget _formTambahan() {
    return _sectionCard(
      title: "Dengan Hormat Harap",
      children: [
        _buildLabel("Tanggapan dan Saran"),
        _textField(
          hint: "Masukkan tanggapan dan saran...",
          controller: tanggapanController,
        ),
        const SizedBox(height: 12),
        _buildLabel("Proses Lebih Lanjut"),
        _textField(
          hint: "Masukkan instruksi proses selanjutnya...",
          controller: instruksiController,
        ),
        const SizedBox(height: 12),
        _buildLabel("Koordinasi atau Konfirmasi"),
        _textField(
          hint: "Tulis pihak yang perlu koordinasi",
          controller: koordinasiController,
        ),
      ],
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
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
                  color: AppColors.bluePrimary,
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }

  Widget _textField({
    required String hint,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      maxLines: 2,
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
          borderSide: BorderSide(color: AppColors.bluePrimary, width: 1.5),
        ),
      ),
    );
  }

  // ── MULTI SELECT ───────────────────────────────────────────────────────────

  Widget _multiSelectField() {
    return TextField(
      controller: multiSelectController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: "Pilih penerima",
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
          borderSide: BorderSide(color: AppColors.bluePrimary),
        ),
        suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
      ),
      onTap: () async {
        final result = await showDialog<List<String>>(
          context: context,
          builder: (_) {
            final options = [
              "Waka Kurikulum",
              "Waka Kesiswaan",
              "Waka Humas",
              "Waka Sarpras",
              "Ketua Konsli",
              "Koordinator",
              "BK",
              "BKK",
              "Prakerin",
            ];
            List<String> temp = List.from(selectedTujuan);

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Pilih Tujuan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: StatefulBuilder(
                builder: (context, setStateDialog) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: options.map((e) {
                        return CheckboxListTile(
                          value: temp.contains(e),
                          activeColor: AppColors.bluePrimary,
                          contentPadding: EdgeInsets.zero,
                          title: Text(e),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (v) {
                            setStateDialog(() {
                              v == true ? temp.add(e) : temp.remove(e);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Batal",
                    style: TextStyle(color: AppColors.bluePrimary),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bluePrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context, temp),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );

        if (result != null) {
          setState(() {
            selectedTujuan = result;
            multiSelectController.text = result.join(", ");
          });
        }
      },
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label lampiran
        Row(
          children: [
            Icon(
              Icons.attach_file_rounded,
              size: 18,
              color: AppColors.bluePrimary,
            ),
            const SizedBox(width: 6),
            const Text(
              "Lampiran",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Carousel
        SizedBox(
          height: 230,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: attachmentUrls.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final path = attachmentUrls[index];

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      // ── Tap → full screen viewer ──────────────────────
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

              // Dot indicator
              Positioned(
                bottom: 12,
                child: Row(
                  children: List.generate(
                    attachmentUrls.length,
                    (index) {
                      final isActive = _currentIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 18 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isActive
                              ? AppColors.bluePrimary
                              : Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}