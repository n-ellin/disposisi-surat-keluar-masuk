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
  bool? isApproved;

  final TextEditingController catatanTerimaController = TextEditingController();
    final TextEditingController catatanTolakController = TextEditingController();

  final TextEditingController tujuanController = TextEditingController();
  final TextEditingController instruksiController = TextEditingController();
  final TextEditingController koordinasiController =
      TextEditingController(); // null = belum pilih, true = terima, false = tolak
  List<String> selectedTujuan = [];

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

              // BACK + TITLE
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

              // CHIP SURAT MASUK
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

              // CARD DETAIL SURAT
              _detailCard(context),

              const SizedBox(height: 20),

              // FORM DISPOSISI
              // BUTTONS
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            if (isApproved == true) {
                              isApproved = null; // batal
                            } else {
                              isApproved = true;
                            }
                          });
                        },
                        child: const Text("Terima"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            if (isApproved == false) {
                              isApproved = null; // batal
                            } else {
                              isApproved = false;
                            }
                          });
                        },
                        child: const Text("Tolak"),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // FORM DISPOSISI
              if (isApproved == true) ...[
                _formDisposisi(),
                const SizedBox(height: 20),
                _formTambahan(),
              ],

              if (isApproved == false) ...[
                _sectionCard(
                  title: "Form Disposisi",
                  children: [
                    _textField("Catatan", controller: catatanTolakController),
                  ],
                ),
              ],
              if (isApproved != null) ...[
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
                      if (isApproved == true) {
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
                              sifat: '',
                            ),
                          ),
                        );
                      } else if (isApproved == false) {
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
                    }, // ← TAMBAH KOMA DI SINI
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

  Widget _detailCard(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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

            const SizedBox(height: 16),

            Builder(
              builder: (context) {
                const List<String> attachmentUrls = [
                  'assets/images/undangan.png',
                  'assets/images/undangan.png',
                  'assets/images/logo.png',
                ];
                if (attachmentUrls.isEmpty) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: const [
                          Icon(Icons.insert_drive_file, size: 50),
                          SizedBox(height: 10),
                          Text(
                            "Tidak ada lampiran",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return _AttachmentCarousel(attachmentUrls: attachmentUrls);
              },
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
            padding: const EdgeInsets.only(top: 14), // ⬅️ bikin ikon turun
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
        _textField("Koordinasi atau Konfirmasi", controller: koordinasiController),
      ],
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
            primary:
                AppColors.bluePrimary, // ✅ ganti semua warna ungu jadi biru
          ),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.bluePrimary, width: 2),
            ),
            labelStyle: TextStyle(
              color: Colors.grey.shade600,
            ), // ✅ warna label normal
            floatingLabelStyle: TextStyle(
              color: AppColors.bluePrimary,
            ), // ✅ warna label floating
          ),
          items: const [
            DropdownMenuItem(value: "1", child: Text("Sangat Rahasia")),
            DropdownMenuItem(value: "2", child: Text("Segera")),
            DropdownMenuItem(value: "3", child: Text("Rahasia")),
          ],
          onChanged: (String? value) {},
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
                  colorScheme: Theme.of(
                    context,
                  ).colorScheme.copyWith(primary: AppColors.bluePrimary),
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
            controller: TextEditingController(text: selectedTujuan.join(", ")),
          ),
        ),
      ),
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
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) => setState(() => _currentIndex = index),
            itemCount: attachmentUrls.length,
            itemBuilder: (context, index) {
              final path = attachmentUrls[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
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
                  borderRadius: BorderRadius.circular(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: Image.asset(
                        path,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text("Gagal memuat gambar"),
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
            bottom: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(attachmentUrls.length, (index) {
                final isActive = index == _currentIndex;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 10 : 6,
                  height: isActive ? 10 : 6,
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
