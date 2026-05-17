import 'package:flutter/material.dart';
import 'package:ta_mobile_disposisi_surat/core/constants/app_color.dart';

class SearchBarInput extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final double? fontSize;

  const SearchBarInput({
    super.key,
    this.hintText = 'Cari surat...',
    required this.onChanged,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final fs = fontSize ?? w * 0.036;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.searchBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.searchBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(fontSize: fs),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.hintsearch,
            fontSize: fs,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.searchIcon,
            size: w * 0.052,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: h * 0.014),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}