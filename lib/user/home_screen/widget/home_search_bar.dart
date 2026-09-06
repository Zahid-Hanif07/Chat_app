import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/providers/home_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSearchBar extends StatelessWidget {
  final String hintText;
  
  const HomeSearchBar({
    super.key,
    this.hintText = 'Search messages, contacts...',
  });

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: TextField(
        onChanged: homeProvider.setSearchQuery,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textMuted.withOpacity(0.6),
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
          suffixIcon: homeProvider.searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: homeProvider.clearSearch,
                  child: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 20),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}
