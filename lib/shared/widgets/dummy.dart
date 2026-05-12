class DummySurat {
  static List<Map<String, dynamic>> allSurat = [

    /// ================= SURAT 1 =================
    {
      'id': 1,

      'jenisSurat': 'Surat Masuk',

      'tanggal': '8 Mei 2026',

      'status': 'menunggu',

      /// surat dibuat oleh siapa
      'fromRole': 'tu',

      /// tujuan surat
      'toRole': 'kepsek',

      /// disposisi lanjutan
      'disposisiKe': '',

      'catatan': '',

      'data': {
        'Dari': 'Dinas Pendidikan',
        'Perihal': 'Undangan Rapat',
      },
    },

    /// ================= SURAT 2 =================
    {
      'id': 2,

      'jenisSurat': 'Surat Keluar',

      'tanggal': '9 Mei 2026',

      'status': 'disetujui',

      'fromRole': 'kepsek',

      'toRole': 'tu',

      'disposisiKe': 'waka kurikulum',

      'catatan': 'Segera diproses',

      'data': {
        'Dari': 'SMKN 2 Singosari',
        'Perihal': 'Rapat Pleno',
      },
    },
  ];
}