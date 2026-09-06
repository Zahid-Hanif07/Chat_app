import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';
import 'package:chat_app/core/providers/call_provider.dart';
import 'package:chat_app/core/providers/home_provider.dart';
import 'package:chat_app/user/home_screen/widget/home_search_bar.dart';
import 'package:chat_app/user/call_log_screen/widget/call_log_item.dart';

class CallLogScreen extends StatelessWidget {
  const CallLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final callProvider = context.watch<CallProvider>();
    final homeProvider = context.watch<HomeProvider>();

    final query = homeProvider.searchQuery.toLowerCase();
    final filteredLogs = callProvider.callLogs.where((log) {
      return log.name.toLowerCase().contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header App Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Calls',
                size: 26,
                weight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_ic_call_rounded, color: AppColors.primary, size: 26),
              ),
            ],
          ),
        ),

        // Search Bar
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: HomeSearchBar(hintText: 'Search calls...'),
        ),
        const SizedBox(height: 20),

        // Call log title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: CustomText(
            homeProvider.searchQuery.isNotEmpty ? 'Search Results' : 'Recent Calls',
            size: 15,
            weight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),

        // Logs list
        Expanded(
          child: filteredLogs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_missed_rounded, size: 48, color: AppColors.textMuted.withOpacity(0.4)),
                      const SizedBox(height: 12),
                      CustomText(
                        'No call logs found',
                        size: 15,
                        color: AppColors.textMuted,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: filteredLogs.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: AppColors.border,
                    thickness: 0.8,
                    height: 1,
                    indent: 80,
                    endIndent: 20,
                  ),
                  itemBuilder: (context, index) {
                    return CallLogItem(log: filteredLogs[index]);
                  },
                ),
        ),
      ],
    );
  }
}
