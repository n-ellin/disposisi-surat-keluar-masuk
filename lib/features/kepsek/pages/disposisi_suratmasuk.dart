import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/utils/full-imges-viewer.dart';

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

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _tujuanKey = GlobalKey();
  final GlobalKey _catatanKey = GlobalKey();

  String? tujuanError;
  String? catatanError;

  List<String> selectedTujuan = [];

  bool get isApproved => _selectedStatus == 'terima';

  bool get isRejected => _selectedStatus == 'tolak';

  List<String> get attachmentUrls =>
      List<String>.from(widget.surat['lampiran'] ?? []);

  Map<String, dynamic> get suratData => widget.surat['data'] ?? {};

  // ── VALIDASI ─────────────────────────────────────────

  bool _validate() {
    tujuanError = null;
    catatanError = null;

    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Pilih status terlebih dahulu."),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return false;
    }

    bool hasError = false;

    if (isApproved) {
      if (selectedTujuan.isEmpty) {
        tujuanError = "Penerima disposisi wajib dipilih.";
        hasError = true;
      }

      if (catatanTerimaController.text.trim().isEmpty) {
        catatanError = "Catatan wajib diisi.";
        hasError = true;
      }

      setState(() {});

      if (hasError) {
        if (selectedTujuan.isEmpty) {
          _scrollToField(_tujuanKey);
        } else {
          _scrollToField(_catatanKey);
        }
      }

      return !hasError;
    }

    if (isRejected) {
      if (catatanTolakController.text.trim().isEmpty) {
        catatanError = "Catatan wajib diisi.";
        hasError = true;

        setState(() {});
        _scrollToField(_catatanKey);

        return false;
      }
    }

    setState(() {});
    return true;
  }

  void _scrollToField(GlobalKey key) {
    final context = key.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.2,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();

    catatanTerimaController.dispose();
    catatanTolakController.dispose();
    tanggapanController.dispose();
    instruksiController.dispose();
    koordinasiController.dispose();

    super.dispose();
  }

  // ── SUBMIT ───────────────────────────────────────────

  void _onKirimPressed() {
    final isValid = _validate();

    if (!isValid) return;

    _showConfirmDialog(context);
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.send_rounded, color: AppColors.bluePrimary),
            SizedBox(width: 8),
            Text("Kirim Disposisi"),
          ],
        ),
        content: const Text("Apakah Anda yakin ingin mengirim disposisi ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bluePrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _submitDisposisi();
            },
            child: const Text("Yakin"),
          ),
        ],
      ),
    );
  }

  void _submitDisposisi() {
    final payload = {
      'status': _selectedStatus,

      if (isApproved) ...{
        'tujuan': selectedTujuan,
        'catatan': catatanTerimaController.text.trim(),
        'tanggapan': tanggapanController.text.trim(),
        'instruksi': instruksiController.text.trim(),
        'koordinasi': koordinasiController.text.trim(),
      },

      if (isRejected) 'catatan': catatanTolakController.text.trim(),
    };

    debugPrint('Payload disposisi: $payload');

    Navigator.pop(context);
  }

  // ── BUILD ────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),

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
                          color: AppColors.bluePrimary,
                          size: 22,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Expanded(
                      child: Text(
                        "Detail Surat Masuk",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.bluePrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // CONTENT
              _detailCard(context),

              const SizedBox(height: 20),

              const Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedStatus = 'terima';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: _selectedStatus == 'terima'
                              ? AppColors.bluePrimary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedStatus == 'terima'
                                ? AppColors.bluePrimary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _selectedStatus == 'terima'
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              size: 16,
                              color: _selectedStatus == 'terima'
                                  ? Colors.white
                                  : Colors.grey.shade400,
                            ),

                            const SizedBox(width: 6),

                            Text(
                              "Terima",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _selectedStatus == 'terima'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedStatus = 'tolak';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedStatus == 'tolak'
                              ? AppColors.bluePrimary.withOpacity(0.75)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedStatus == 'tolak'
                                ? AppColors.bluePrimary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _selectedStatus == 'tolak'
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              size: 16,
                              color: _selectedStatus == 'tolak'
                                  ? Colors.white
                                  : Colors.grey.shade400,
                            ),

                            const SizedBox(width: 6),

                            Text(
                              "Tolak",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _selectedStatus == 'tolak'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // FORM TERIMA
              if (isApproved) ...[
                const SizedBox(height: 20),

                _formDisposisi(),

                const SizedBox(height: 16),

                _formTambahan(),
              ],

              // FORM TOLAK
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
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _onKirimPressed,
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

  // ── DETAIL CARD ─────────────────────────────────────

  Widget _detailCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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

          const SizedBox(height: 4),

          Text(
            "Lampiran",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          if (attachmentUrls.isEmpty)
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
                      imageUrls: attachmentUrls,
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
                    const Icon(
                      Icons.attach_file_rounded,
                      color: AppColors.bluePrimary,
                      size: 20,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      "${attachmentUrls.length} File Lampiran",
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
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade500),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── FORM ─────────────────────────────────────────────

  Widget _formDisposisi() {
    return _sectionCard(
      title: "Form Disposisi",
      children: [
        _buildLabel("Diteruskan Ke *"),

        Container(
          key: _tujuanKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _multiSelectField(),

              if (tujuanError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    tujuanError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        _buildLabel("Catatan *"),

        Container(
          key: _catatanKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textField(
                hint: "Masukkan catatan tambahan...",
                controller: catatanTerimaController,
              ),

              if (catatanError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    catatanError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
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

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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

  Widget _textField({required String hint, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.hinttext, fontSize: 14),
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
          borderSide: const BorderSide(
            color: AppColors.bluePrimary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ── MULTI SELECT ────────────────────────────────────

  static const List<String> _tujuanOptions = [
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

  Widget _multiSelectField() {
    final displayText = selectedTujuan.isEmpty
        ? "Pilih penerima"
        : selectedTujuan.join(", ");

    return GestureDetector(
      onTap: _showTujuanDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 14,
                  color: selectedTujuan.isEmpty
                      ? AppColors.hinttext
                      : Colors.black87,
                ),
              ),
            ),

            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }

  Future<void> _showTujuanDialog() async {
    List<String> temp = List.from(selectedTujuan);

    final result = await showDialog<List<String>>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.72,
                  maxWidth: 420,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // HEADER
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.bluePrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.groups_rounded,
                              color: AppColors.bluePrimary,
                              size: 20,
                            ),
                          ),

                          const SizedBox(width: 12),

                          const Expanded(
                            child: Text(
                              "Pilih Tujuan Disposisi",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(height: 1, color: Colors.grey.shade200),

                    // LIST
                    Flexible(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        itemCount: _tujuanOptions.length,
                        itemBuilder: (_, i) {
                          final opt = _tujuanOptions[i];
                          final isSelected = temp.contains(opt);

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                setStateDialog(() {
                                  isSelected ? temp.remove(opt) : temp.add(opt);
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.bluePrimary.withOpacity(0.08)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.bluePrimary
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // CUSTOM CHECKBOX
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.bluePrimary
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.bluePrimary
                                              : Colors.grey.shade400,
                                          width: 1.6,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check_rounded,
                                              size: 15,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),

                                    const SizedBox(width: 14),

                                    Expanded(
                                      child: Text(
                                        opt,
                                        style: TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Divider(height: 1, color: Colors.grey.shade200),

                    // BUTTONS
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey.shade700,
                                side: BorderSide(color: Colors.grey.shade300),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Batal"),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, temp);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.bluePrimary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Simpan"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedTujuan = result;

        if (selectedTujuan.isNotEmpty) {
          tujuanError = null;
        }
      });
    }
  }
}
