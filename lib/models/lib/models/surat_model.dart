class SuratModel {
  final String id;
  final String tipe;       // masuk / keluar
  final String noSurat;
  final String perihal;
  final String dari;
  final String tanggal;
  final String filePath;
  String status;           // pending / accepted / decline

  SuratModel({
    required this.id,
    required this.tipe,
    required this.noSurat,
    required this.perihal,
    required this.dari,
    required this.tanggal,
    required this.filePath,
    this.status = "pending",
  });
}
