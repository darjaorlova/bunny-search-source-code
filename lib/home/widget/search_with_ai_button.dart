import 'package:bunny_search/home/widget/ai_text_search_insights_page.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:flutter/material.dart';

class SearchWithAIButton extends StatelessWidget {
  const SearchWithAIButton({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openSearchWithAIDialog(context),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 24,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: AppColors.rose,
            ),
            const SizedBox(width: 8),
            Text(
              'Search with AI',
              style: AppTypography.headerMedium.copyWith(
                color: AppColors.rose,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  void _openSearchWithAIDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AITextSearchInsightsPage(searchQuery: searchQuery),
    );
  }
}
