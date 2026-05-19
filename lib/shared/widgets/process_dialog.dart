import 'package:flutter/material.dart';

void showProcessDialog(BuildContext context) {
  final w = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0xFFF3F0F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        // Responsif: dialog selalu 75% lebar layar
        insetPadding: EdgeInsets.symmetric(horizontal: w * 0.125),
        child: Padding(
          padding: EdgeInsets.fromLTRB(w * 0.06, w * 0.08, w * 0.06, w * 0.06),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: w * 0.13,
                height: w * 0.13,
                decoration: const BoxDecoration(
                  color: Color(0xFF4A4A4A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: w * 0.065,
                ),
              ),

              SizedBox(height: w * 0.04),

              Text(
                "Surat Dalam Proses",
                style: TextStyle(
                  fontSize: (w * 0.045).clamp(15.0, 18.0),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: w * 0.02),

              // Kontrol baris manual pakai \n
              Text(
                "Surat masih dalam proses\npengajuan.",
                style: TextStyle(
                  fontSize: (w * 0.036).clamp(12.0, 15.0),
                  color: Colors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
                // Pastikan \n dihormati, tidak wrap sendiri
                softWrap: true,
              ),
            ],
          ),
        ),
      );
    },
  );
}