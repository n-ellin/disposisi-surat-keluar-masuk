import 'package:flutter/material.dart';

class DetailSuratKeluarPage extends StatelessWidget {
  const DetailSuratKeluarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white, // TANPA background hijau
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: size.width * 0.065,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Detail Surat',
                          style: TextStyle(
                            fontSize: size.width * 0.06,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF2A65A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.04),

                /// Subjudul
                Center(
                  child: Text(
                    'Surat Keluar',
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF6C38A),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),

                /// Catatan
                SizedBox(
                  height: size.height * 0.28,
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      labelText: 'Catatan',
                      labelStyle: TextStyle(
                        color: const Color(0xFFF2A65A),
                        fontSize: size.width * 0.045,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFF2A65A),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFF2A65A),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.06),

                /// Tombol OK
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: size.width * 0.26,
                    height: size.height * 0.065,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF28C38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
}
