import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/full-img-viewer.dart';
import 'package:ta_mobile_disposisi_surat/modules/tata_usaha/detail_surat/output_suratmasuk.dart';

class InputSuratMasuk extends StatefulWidget {
  const InputSuratMasuk({super.key});

  @override
  State<InputSuratMasuk> createState() => _InputSuratMasukState();
}

class _InputSuratMasukState extends State<InputSuratMasuk> {
  String? _selectedStatus;
  String? selectedSifat;

  final TextEditingController catatanTerimaController = TextEditingController();
  final TextEditingController catatanTolakController = TextEditingController();
  final TextEditingController tujuanController = TextEditingController();
  final TextEditingController instruksiController = TextEditingController();
  final TextEditingController koordinasiController = TextEditingController();
  List<String> selectedTujuan = [];

  bool get _isApproved => _selectedStatus == 'terima';
  bool get _isRejected => _selectedStatus == 'tolak';

  // ✅ dummy lampiran — nanti ganti dari API
  static const List<String> _attachmentUrls = [
    'assets/images/undangan.png',
    'assets/images/undangan.png',
    'assets/images/logo.png',
  ];

  @override
  void dispose() {
    catatanTerimaController.dispose();
    catatanTolakController.dispose();
    tujuanController.dispose();
    instruksiController.dispose();
    koordinasiController.dispose();
    super.dispose();
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
              const SizedBox(height: 20),

              // ── BACK + TITLE ──
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                  Text(
                    "Detail Surat",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bluePrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── CHIP ──
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.bluePrimary),
                  ),
                  child: Text(
                    "Surat Masuk",
                    style: TextStyle(
                      color: AppColors.bluePrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── CARD DETAIL SURAT ──
              _detailCard(context),

              const SizedBox(height: 20),

              // ── DROPDOWN STATUS ──
              const Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  hintText: "Pilih status...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.bluePrimary,
                      width: 2,
                    ),
                  ),
                ),
                iconEnabledColor: _selectedStatus == 'terima'
                    ? Colors.green
                    : _selectedStatus == 'tolak'
                        ? Colors.red
                        : Colors.grey,
                items: const [
                  DropdownMenuItem(
                    value: 'terima',
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Terima',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'tolak',
                    child: Row(
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Tolak',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // ── FORM TERIMA ──
              if (_isApproved) ...[
                _formDisposisi(),
                const SizedBox(height: 20),
                _formTambahan(),
              ],

              // ── FORM TOLAK ──
              if (_isRejected) ...[
                _sectionCard(
                  title: "Form Disposisi",
                  children: [
                    _textField(
                      "Catatan",
                      controller: catatanTolakController,
                    ),
                  ],
                ),
              ],

              // ── TOMBOL KIRIM ──
              if (_selectedStatus != null) ...[
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bluePrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_isApproved) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OutputSuratmasuk(
                              isApproved: true,
                              catatan: catatanTerimaController.text,
                              tujuan: tujuanController.text,
                              instruksi: instruksiController.text,
                              koordinasi: koordinasiController.text,
                              diteruskanKe: selectedTujuan.join(", "),
                              sifat: selectedSifat ?? '',
                            ),
                          ),
                        );
                      } else if (_isRejected) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OutputSuratmasuk(
                              isApproved: false,
                              catatan: catatanTolakController.text,
                              tujuan: '',
                              instruksi: '',
                              koordinasi: '',
                              diteruskanKe: '',
                              sifat: '',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("Kirim"),
                  ),
                ),
              ],

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ── DETAIL CARD ──
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

            // ── LABEL LAMPIRAN ──
            Text(
              "Lampiran",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            // ✅ BUTTON LAMPIRAN
            if (_attachmentUrls.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FullScreenImageViewer(
                        imageAssetPath: _attachmentUrls.first,
                        imageUrls: _attachmentUrls,
                        initialIndex: 0,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_file,
                        color: AppColors.bluePrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "${_attachmentUrls.length} File Lampiran",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),
              )
            else
              // ✅ TIDAK ADA LAMPIRAN
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.attach_file,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Tidak ada lampiran",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Icon(icon, size: 24, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formDisposisi() {
    return _sectionCard(
      title: "Form Disposisi",
      children: [
        _multiSelectField(),
        _dropdownField("Sifat"),
        _textField("Catatan", controller: catatanTerimaController),
      ],
    );
  }

  Widget _formTambahan() {
    return _sectionCard(
      title: "Dengan Hormat Harap",
      children: [
        _textField("Tanggapan dan Saran", controller: tujuanController),
        _textField("Proses Lebih Lanjut", controller: instruksiController),
        _textField(
          "Koordinasi atau Konfirmasi",
          controller: koordinasiController,
        ),
      ],
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.bluePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _dropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppColors.bluePrimary,
          ),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.bluePrimary, width: 2),
            ),
            labelStyle: TextStyle(color: Colors.grey.shade600),
            floatingLabelStyle: TextStyle(color: AppColors.bluePrimary),
          ),
          value: selectedSifat,
          items: const [
            DropdownMenuItem(
              value: "Sangat Rahasia",
              child: Text("Sangat Rahasia"),
            ),
            DropdownMenuItem(value: "Segera", child: Text("Segera")),
            DropdownMenuItem(value: "Rahasia", child: Text("Rahasia")),
          ],
          onChanged: (String? value) {
            setState(() {
              selectedSifat = value;
            });
          },
        ),
      ),
    );
  }

  Widget _textField(
    String label, {
    TextEditingController? controller,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 3,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: hint ?? "Masukkan $label...",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.bluePrimary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _multiSelectField() {
    final List<String> options = [
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () async {
          final List<String>? result = await showDialog(
            context: context,
            builder: (context) {
              List<String> tempSelected = List.from(selectedTujuan);
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: AppColors.bluePrimary,
                  ),
                ),
                child: AlertDialog(
                  title: const Text("Di Teruskan Ke"),
                  content: StatefulBuilder(
                    builder: (context, setStateDialog) {
                      return SingleChildScrollView(
                        child: Column(
                          children: options.map((item) {
                            final isSelected = tempSelected.contains(item);
                            return CheckboxListTile(
                              value: isSelected,
                              title: Text(item),
                              onChanged: (value) {
                                setStateDialog(() {
                                  if (value == true) {
                                    tempSelected.add(item);
                                  } else {
                                    tempSelected.remove(item);
                                  }
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
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, tempSelected),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
          );

          if (result != null) {
            setState(() {
              selectedTujuan = result;
            });
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: "Di Teruskan Ke",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.bluePrimary, width: 2),
              ),
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            controller: TextEditingController(
              text: selectedTujuan.join(", "),
            ),
          ),
        ),
      ),
    );
  }
}