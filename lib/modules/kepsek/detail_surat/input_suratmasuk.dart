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
  final TextEditingController tujuanController = TextEditingController();
  final TextEditingController instruksiController = TextEditingController();
  final TextEditingController koordinasiController = TextEditingController();

  final TextEditingController _multiSelectController = TextEditingController();

  List<String> selectedTujuan = [];

  bool get _isApproved => _selectedStatus == 'terima';
  bool get _isRejected => _selectedStatus == 'tolak';

  List<String> get _attachmentUrls =>
      List<String>.from(widget.surat['lampiran'] ?? []);

  Map<String, dynamic> get suratData => widget.surat['data'] ?? {};

  @override
  void dispose() {
    catatanTerimaController.dispose();
    catatanTolakController.dispose();
    tujuanController.dispose();
    instruksiController.dispose();
    koordinasiController.dispose();
    _multiSelectController.dispose();
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

              /// HEADER
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
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

              /// CHIP
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
                    widget.surat['jenisSurat'] ?? '-',
                    style: TextStyle(
                      color: AppColors.bluePrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// DETAIL
              _detailCard(context),

              const SizedBox(height: 20),

              const Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
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
                        Text("Terima", style: TextStyle(color: Colors.green)),
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
                        Text("Tolak", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _selectedStatus = value),
              ),

              const SizedBox(height: 20),

              if (_isApproved) ...[
                _formDisposisi(),
                const SizedBox(height: 20),
                _formTambahan(),
              ],

              if (_isRejected)
                _sectionCard(
                  title: "Form Disposisi",
                  children: [
                    _textField("Catatan", controller: catatanTolakController),
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
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OutputSuratmasuk(
                            isApproved: _isApproved,
                            catatan: _isApproved
                                ? catatanTerimaController.text
                                : catatanTolakController.text,
                            tujuan: tujuanController.text,
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

  /// ================= DETAIL CARD =================

  Widget _detailCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem(
              Icons.numbers,
              "Nomor Surat",
              suratData['Nomor Surat'] ?? '-',
            ),
            _detailItem(
              Icons.calendar_today,
              "Tanggal",
              widget.surat['tanggal'] ?? '-',
            ),
            _detailItem(Icons.person, "Pengirim", suratData['Dari'] ?? '-'),
            _detailItem(
              Icons.description,
              "Perihal",
              suratData['Perihal'] ?? '-',
            ),

            const SizedBox(height: 10),

            const Text("Lampiran"),

            const SizedBox(height: 8),
            if (_attachmentUrls.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
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
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              )
            else
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
                    Icon(Icons.attach_file, color: Colors.grey, size: 20),
                    const SizedBox(width: 10),
                    const Text("Tidak ada lampiran"),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text("$label : $value")),
        ],
      ),
    );
  }

  /// ================= FORM =================

  Widget _formDisposisi() {
    return _sectionCard(
      title: "Form Disposisi",
      children: [
        _multiSelectField(),
        _textField("Catatan", controller: catatanTerimaController),
      ],
    );
  }

  Widget _formTambahan() {
    return _sectionCard(
      title: "Dengan Hormat Harap",
      children: [
        _textField("Tanggapan", controller: tujuanController),
        _textField("Instruksi", controller: instruksiController),
        _textField("Koordinasi", controller: koordinasiController),
      ],
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _textField(String label, {TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  /// ================= MULTI SELECT =================

  Widget _multiSelectField() {
    return TextField(
      controller: _multiSelectController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: "Di Teruskan Ke",
        border: OutlineInputBorder(),
      ),
      onTap: () async {
        final result = await showDialog<List<String>>(
          context: context,
          builder: (_) {
            final options = [
              "Waka Kurikulum",
              "Waka Kesiswaan",
              "BK",
              "Koordinator",
            ];

            List<String> temp = List.from(selectedTujuan);

            return AlertDialog(
              title: const Text("Pilih Tujuan"),
              content: StatefulBuilder(
                builder: (context, setStateDialog) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.map((e) {
                      return CheckboxListTile(
                        value: temp.contains(e),
                        title: Text(e),
                        onChanged: (v) {
                          setStateDialog(() {
                            v == true ? temp.add(e) : temp.remove(e);
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
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
            _multiSelectController.text = result.join(", ");
          });
        }
      },
    );
  }
}
